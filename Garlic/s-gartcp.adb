------------------------------------------------------------------------------
--                                                                          --
--                           GARLIC COMPONENTS                              --
--                                                                          --
--                   S Y S T E M . G A R L I C . T C P                      --
--                                                                          --
--                                 B o d y                                  --
--                                                                          --
--                            1.34                             --
--                                                                          --
--           Copyright (C) 1996 Free Software Foundation, Inc.              --
--                                                                          --
-- GARLIC is free software;  you can redistribute it and/or modify it under --
-- terms of the  GNU General Public License  as published by the Free Soft- --
-- ware Foundation;  either version 2,  or (at your option)  any later ver- --
-- sion.  GARLIC is distributed  in the hope that  it will be  useful,  but --
-- WITHOUT ANY WARRANTY;  without even the implied warranty of MERCHANTABI- --
-- LITY or  FITNESS FOR A PARTICULAR PURPOSE.  See the  GNU General Public  --
-- License  for more details.  You should have received  a copy of the GNU  --
-- General Public License  distributed with GARLIC;  see file COPYING.  If  --
-- not, write to the Free Software Foundation, 59 Temple Place - Suite 330, --
-- Boston, MA 02111-1307, USA.                                              --
--                                                                          --
-- As a special exception,  if other files  instantiate  generics from this --
-- unit, or you link  this unit with other files  to produce an executable, --
-- this  unit  does not  by itself cause  the resulting  executable  to  be --
-- covered  by the  GNU  General  Public  License.  This exception does not --
-- however invalidate  any other reasons why  the executable file  might be --
-- covered by the  GNU Public License.                                      --
--                                                                          --
--               GARLIC is maintained by ACT Europe.                        --
--            (email:distribution@act-europe.gnat.com).                     --
--                                                                          --
------------------------------------------------------------------------------

with Ada.Unchecked_Conversion;
with Ada.Unchecked_Deallocation;
with Interfaces.C.Strings;
with System.Garlic.Constants; use System.Garlic.Constants;
with System.Garlic.Debug; use System.Garlic.Debug;
with System.Garlic.Heart;  use System.Garlic.Heart;
with System.Garlic.Naming; use System.Garlic.Naming;
with System.Garlic.Options;
with System.Garlic.Physical_Location; use System.Garlic.Physical_Location;
with System.Garlic.Priorities;
with System.Garlic.Termination; use System.Garlic.Termination;
with System.Garlic.Thin;   use System.Garlic.Thin;
with System.Garlic.TCP.Platform_Specific;
with System.Garlic.Utils; use System.Garlic.Utils;

package body System.Garlic.TCP is

   --  This system implements TCP communication. The connection is established
   --  as follow: (C = caller, R = receiver)
   --    - If the partition_ID is not known:
   --      C->R : Null_Partition_ID
   --      R->C : <new caller Partition_ID>
   --    - After this, in any case: (C & R may be reversed)
   --      C->R : <Length (Stream_Element_Count)> <Packet>

   Private_Debug_Key : constant Debug_Key :=
     Debug_Initialize ("TCP", "(s-gartcp): ");
   procedure D
     (Level   : in Debug_Levels;
      Message : in String;
      Key     : in Debug_Key := Private_Debug_Key)
     renames Print_Debug_Info;

   use Ada.Streams, System.Garlic.Protocols, System.RPC;
   package C renames Interfaces.C;
   package Strings renames C.Strings;
   use type C.int;
   use type C.unsigned_short;
   --  Shortcuts.

   package Net renames Platform_Specific.Net;

   In_Address_Any : constant Naming.Address := Any_Address;

   type Host_Location is record
      Addr : Naming.Address   := In_Address_Any;
      Port : C.Unsigned_short := 0;
   end record;

   function Split_Data (Data : String) return Host_Location;
   --  Split a data given as <machine> or <machine>:<port>

   type Host_Data is record
      Location  : Host_Location;
      FD        : C.int;
      Connected : Boolean := False;
      Known     : Boolean := False;
      Queried   : Boolean := False;
      Locked    : Boolean := False;
   end record;

   Self_Host : Host_Data;

   type Partition_Array is array (Partition_ID) of Host_Data;

   protected type Partition_Map_Type is
      procedure Set_Locked
        (Partition : in Partition_ID; Data : in Host_Data);
      entry Get (Partition_ID) (Data : out Host_Data);
      entry Lock (Partition_ID);
      procedure Unlock (Partition : in Partition_ID);
      function Get_Immediate (Partition : Partition_ID) return Host_Data;
   private
      Partitions  : Partition_Array;
   end Partition_Map_Type;
   --  Get returns immediately if Known is True or else Queried is False,
   --  and sets Queried to True, meaning that the calling task should ask
   --  for the coordinates.

   type Partition_Map_Access is access Partition_Map_Type;
   procedure Free is
      new Ada.Unchecked_Deallocation (Partition_Map_Type,
                                      Partition_Map_Access);

   Partition_Map : Partition_Map_Access :=
     new Partition_Map_Type;

   function Establish_Connection (Location : Host_Location) return C.int;
   --  Establish a socket to a remote location and return the file descriptor.

   procedure Establish_Listening_Socket;
   --  Establish a socket according to the information in Self_Host (and
   --  complete it if needed).

   function To_Sockaddr_Access is
      new Ada.Unchecked_Conversion (Sockaddr_In_Access, Sockaddr_Access);

   procedure Free is
     new Ada.Unchecked_Deallocation (Sockaddr_In, Sockaddr_In_Access);

   function Ask_For_Partition_ID (FD : C.int) return Partition_ID;
   --  Ask for a partition ID on the given file descriptor (which is
   --  of course bound to the server, since we cannot contact other
   --  partitions if we haven't our partition ID).

   procedure Physical_Receive
     (FD : in C.int; Data : out Stream_Element_Array);
   pragma Inline (Physical_Receive);
   procedure Physical_Send (FD : in C.int; Data : in Stream_Element_Array);
   pragma Inline (Physical_Send);
   --  Receive and send data. Physical_Receive loops as long as Data has
   --  not been filled and Physical_Send as long as everything has not been
   --  sent.

   procedure Send_My_Partition_ID (FD : in C.int);
   --  Transmit my partition ID to the remote end.

   Partition_ID_Length_Cache : Stream_Element_Count := 0;
   function Partition_ID_Length return Stream_Element_Count;
   pragma Inline (Partition_ID_Length);
   --  Return the length in stream elements needed to store a Partition_ID.

   Stream_Element_Count_Length_Cache : Stream_Element_Count := 0;
   function Stream_Element_Count_Length return Stream_Element_Count;
   pragma Inline (Stream_Element_Count_Length);
   --  Idem for a stream element count.

   task Accept_Handler is
      pragma Storage_Size (150_000);
      pragma Priority (Priorities.RPC_Priority);
      entry Start;
   end Accept_Handler;
   --  The task which will accept new connections.

   task type Incoming_Connection_Handler (FD        : C.Int;
                                          Receiving : Boolean;
                                          Remote    : Partition_ID) is
      pragma Storage_Size (150_000);
      pragma Priority (Priorities.RPC_Priority);
   end Incoming_Connection_Handler;
   type Incoming_Connection_Handler_Access is
      access Incoming_Connection_Handler;
   --  Handler for an incoming connection.

   --------------------
   -- Accept_Handler --
   --------------------

   task body Accept_Handler is
   begin

      --  Wait for start or terminate.

      select
         accept Start;
      or
         terminate;
      end select;

      --  Infinite loop on C_Accept.

      select
         Shutdown_Keeper.Wait;
         D (D_Debug,
            "Accept_Handler exiting because of Shutdown_Keeper");
         raise Communication_Error;
      then abort
         loop
            declare
               Sin    : Sockaddr_In_Access := new Sockaddr_In;
               Length : aliased C.int := Sin.all'Size / 8;
               FD     : C.int;
               NT     : Incoming_Connection_Handler_Access;
            begin
               Add_Non_Terminating_Task;
               FD := Net.C_Accept (Self_Host.FD, To_Sockaddr_Access (Sin),
                                   Length'Access);
               Sub_Non_Terminating_Task;
               if FD = Failure then
                  raise Communication_Error;
               end if;
               NT :=
                new Incoming_Connection_Handler (FD,
                                                 Receiving => True,
                                                 Remote => Null_Partition_ID);
            end;
         end loop;
      end select;
   end Accept_Handler;

   --------------------------
   -- Ask_For_Partition_ID --
   --------------------------

   function Ask_For_Partition_ID (FD : C.int) return Partition_ID is
      Params    : aliased Params_Stream_Type (Partition_ID_Length);
      Result    : aliased Params_Stream_Type (Partition_ID_Length);
      Result_P  : Stream_Element_Array (1 .. Partition_ID_Length);
      Partition : Partition_ID;
   begin
      D (D_Garlic, "Asking for a Partition_ID");
      Partition_ID'Write (Params'Access, Null_Partition_ID);
      Physical_Send (FD, To_Stream_Element_Array (Params'Access));
      Physical_Receive (FD, Result_P);
      To_Params_Stream_Type (Result_P, Result'Access);
      Partition_ID'Read (Result'Access, Partition);
      if not Partition'Valid then
         D (D_Garlic, "Invalid partition ID");
         raise Constraint_Error;
      end if;
      D (D_Garlic, "My Partition_ID is" & Partition_ID'Image (Partition));
      return Partition;
   end Ask_For_Partition_ID;

   ------------
   -- Create --
   ------------

   function Create return Protocol_Access is
      Self : Protocol_Access := new TCP_Protocol;
   begin
      Register_Protocol (Self);
      return Self;
   end Create;

   --------------------------
   -- Establish_Connection --
   --------------------------

   function Establish_Connection (Location : Host_Location)
     return C.int is
      FD   : C.int;
      Sin  : Sockaddr_In_Access := new Sockaddr_In;
      Code : C.int;
   begin
      FD := C_Socket (Af_Inet, Sock_Stream, 0);
      if FD = Failure then
         Free (Sin);
         raise Communication_Error;
      end if;
      Sin.Sin_Addr := To_In_Addr (Location.Addr);
      Sin.Sin_Port := Location.Port;
      Code := Net.C_Connect (FD,
                             To_Sockaddr_Access (Sin), Sin.all'Size / 8);
      if Code = Failure then
         Code := C_Close (FD);
         Free (Sin);
         raise Communication_Error;
      end if;
      return FD;
   end Establish_Connection;

   --------------------------------
   -- Establish_Listening_Socket --
   --------------------------------

   procedure Establish_Listening_Socket is
      Addr  : Naming.Address renames Self_Host.Location.Addr;
      Port  : C.unsigned_short renames Self_Host.Location.Port;
      FD    : C.int renames Self_Host.FD;
      Sin   : Sockaddr_In_Access := new Sockaddr_In;
      Check : Sockaddr_In_Access := new Sockaddr_In;
      Dummy : aliased C.int := Check.all'Size / 8;
   begin
      FD := C_Socket (Af_Inet, Sock_Stream, 0);
      if FD = Failure then
         Free (Sin);
         Free (Check);
         raise Communication_Error;
      end if;
      declare
         One   : aliased C.int := 1;
         Dummy : C.int;
         function To_Chars_Ptr is
            new Ada.Unchecked_Conversion (Int_Access, Strings.chars_ptr);
      begin
         Dummy := C_Setsockopt (FD, Sol_Socket,
                                So_Reuseaddr,
                                One'Address,
                                One'Size / 8);
      end;
      Sin.Sin_Port := Port;
      if C_Bind (FD,
                 To_Sockaddr_Access (Sin),
                 Sin.all'Size / 8) = Failure then
         Free (Sin);
         Free (Check);
         raise Communication_Error;
      end if;
      if C_Listen (FD, 15) = Failure then
         raise Communication_Error;
      end if;
      if Port = 0 then
         if C_Getsockname (FD,
                           To_Sockaddr_Access (Check),
                           Dummy'Access) =  Failure then
            Free (Sin);
            Free (Check);
            raise Communication_Error;
         end if;
         Port := Check.Sin_Port;
      end if;
      Free (Check);
      Self_Host.Connected := True;
      D (D_Communication,
         "Listening on port" & C.unsigned_short'Image (Port));
   end Establish_Listening_Socket;

   --------------
   -- Get_Info --
   --------------

   function Get_Info (P : access TCP_Protocol) return String is
      Port : constant String :=
        C.unsigned_short'Image (Self_Host.Location.Port);
   begin
      return Name_Of (Image (Self_Host.Location.Addr)) &
        ":" & Port (2 .. Port'Last);
   end Get_Info;

   --------------
   -- Get_Name --
   --------------

   function Get_Name (P : access TCP_Protocol) return String is
   begin
      return "tcp";
   end Get_Name;

   ---------------------------------
   -- Incoming_Connection_Handler --
   ---------------------------------

   task body Incoming_Connection_Handler is
      Data      : Host_Data;
      Partition : Partition_ID := Null_Partition_ID;
   begin

      select
         Shutdown_Keeper.Wait;
         raise Communication_Error;
      then abort

         if Receiving then

            --  The first thing we will receive is the Partition_ID. As an
            --  exception, Null_Partition_ID means that the remote side hasn't
            --  got a Partition_ID.

            declare
               Stream_P  : Stream_Element_Array (1 .. Partition_ID_Length);
               Stream    : aliased Params_Stream_Type (Partition_ID_Length);
            begin
               D (D_Communication, "New communication task started");

               --  We do not call Add_Non_Terminating_Task since we want to
               --  receive the whole partition ID. Moreover, we will signal
               --  that data has arrived.

               Activity_Detected;
               Physical_Receive (FD, Stream_P);
               To_Params_Stream_Type (Stream_P, Stream'Access);
               Partition_ID'Read (Stream'Access, Partition);
               if not Partition'Valid then
                  D (D_Debug, "Invalid partition ID");
                  raise Constraint_Error;
               end if;
               if Partition = Null_Partition_ID then
                  declare
                     Result : aliased Params_Stream_Type (Partition_ID_Length);
                  begin
                     Partition := Allocate_Partition_ID;
                     Partition_ID'Write (Result'Access, Partition);
                     Add_Non_Terminating_Task;
                     begin
                        Physical_Send
                          (FD, To_Stream_Element_Array (Result'Access));
                     exception
                        when Communication_Error =>
                           Sub_Non_Terminating_Task;
                           raise Communication_Error;
                     end;
                     Sub_Non_Terminating_Task;
                  end;
               end if;
               D (D_Communication,
                  "This task is in charge of partition" &
                  Partition_ID'Image (Partition));
               Partition_Map.Lock (Partition);
               Data           := Partition_Map.Get_Immediate (Partition);
               Data.FD        := FD;
               Data.Connected := True;
               Partition_Map.Set_Locked (Partition, Data);
               Partition_Map.Unlock (Partition);
            end;

         else

            Partition := Remote;
            D (D_Communication,
               "New task to handle partition" &
               Partition_ID'Image (Partition));

         end if;

         --  Then we have an (almost) infinite loop to get requests or
         --  answers.

         loop
            declare
               Header_P : Stream_Element_Array
                 (1 .. Stream_Element_Count_Length);
               Header   : aliased Params_Stream_Type
                 (Stream_Element_Count_Length);
               Length   : Stream_Element_Count;
            begin
               Add_Non_Terminating_Task;
               begin
                  Physical_Receive (FD, Header_P);
               exception
                  when Communication_Error =>
                     Sub_Non_Terminating_Task;
                     raise Communication_Error;
               end;
               Sub_Non_Terminating_Task;
               To_Params_Stream_Type (Header_P, Header'Access);
               Stream_Element_Count'Read (Header'Access, Length);
               if not Length'Valid then
                  D (D_Debug, "Invalid Length");
                  raise Constraint_Error;
               end if;
               D (D_Debug,
                  "Will receive a packet of length" &
                  Stream_Element_Count'Image (Length));

               declare
                  Request_P : Stream_Element_Array (1 .. Length);
               begin

                  --  No Add_Non_Terminating_Task either (see above).

                  Physical_Receive (FD, Request_P);
                  Has_Arrived (Partition, Request_P);
               end;
            end;
         end loop;
      end select;

   exception

      when Communication_Error =>

         --  The remote end has closed the socket or a communication error
         --  occurred.

         Partition_Map.Lock (Partition);
         Data := Partition_Map.Get_Immediate (Partition);
         Data.Connected := False;
         Partition_Map.Set_Locked (Partition, Data);
         Partition_Map.Unlock (Partition);
         declare
            Dummy : C.int;
         begin
            Dummy := C_Close (FD);
         end;

         --  Signal to the heart that we got an error on this partition.

         if Partition = Null_Partition_ID then
            D (D_Garlic, "Task dying before determining remote Partition_ID");
         else
            D (D_Garlic,
               "Signaling that partition" & Partition_ID'Image (Partition) &
               " is now unavailable");
            Remote_Partition_Error (Partition);
         end if;

      when others =>
         D (D_Garlic, "Fatal error in connection handler");
         declare
            Dummy : C.int;
         begin
            Dummy := C_Close (FD);
         end;

   end Incoming_Connection_Handler;

   -------------------------
   -- Partition_ID_Length --
   -------------------------

   function Partition_ID_Length return Stream_Element_Count is
   begin
      if Partition_ID_Length_Cache = 0 then
         declare
            Stream : aliased Params_Stream_Type (0);
         begin
            Partition_ID'Write (Stream'Access, Null_Partition_ID);
            Partition_ID_Length_Cache :=
              To_Stream_Element_Array (Stream'Access) 'Length;
         end;
      end if;
      return Partition_ID_Length_Cache;
   end Partition_ID_Length;

   ------------------------
   -- Partition_Map_Type --
   ------------------------

   protected body Partition_Map_Type is

      ---------
      -- Get --
      ---------

      entry Get (for Partition in Partition_ID) (Data : out Host_Data)
      when Partitions (Partition).Known or else
        not Partitions (Partition).Queried is
      begin
         if Partitions (Partition).Known then
            Data := Partitions (Partition);
         else
            Partitions (Partition).Queried := True;
            Data := Partitions (Partition);
         end if;
      end Get;

      -------------------
      -- Get_Immediate --
      -------------------

      function Get_Immediate (Partition : Partition_ID) return Host_Data is
      begin
         return Partitions (Partition);
      end Get_Immediate;

      ----------
      -- Lock --
      ----------

      entry Lock (for P in Partition_ID)
      when not Partitions (P).Locked is
      begin
         Partitions (P).Locked := True;
      end Lock;

      ----------------
      -- Set_Locked --
      ----------------

      procedure Set_Locked
        (Partition : in Partition_ID; Data : in Host_Data)
      is
      begin
         Partitions (Partition) := Data;
      end Set_Locked;

      ------------
      -- Unlock --
      ------------

      procedure Unlock (Partition : in Partition_ID) is
      begin
         Partitions (Partition).Locked := False;
      end Unlock;

   end Partition_Map_Type;

   ----------------------
   -- Physical_Receive --
   ----------------------

   procedure Physical_Receive
     (FD : in C.int; Data : out Stream_Element_Array)
   is
      function To_Chars_Ptr is
         new Ada.Unchecked_Conversion (C.int, Strings.chars_ptr);
      function To_Int is
         new Ada.Unchecked_Conversion (System.Address, C.int);
      Current : C.int := To_Int (Data (Data'First) 'Address);
      Rest    : C.int := Data'Length;
      Code    : C.int;
   begin
      while Rest > 0 loop
         Code := Net.C_Read (FD, To_Chars_Ptr (Current), Rest);
         if Code <= 0 then
            raise Communication_Error;
         end if;
         Current := Current + Code;
         Rest := Rest - Code;
      end loop;
   end Physical_Receive;

   -------------------
   -- Physical_Send --
   -------------------

   procedure Physical_Send (FD : in C.int; Data : in Stream_Element_Array)
   is
      function To_Chars_Ptr is
         new Ada.Unchecked_Conversion (C.int, Strings.chars_ptr);
      function To_Int is
         new Ada.Unchecked_Conversion (System.Address, C.int);
      Current : C.int := To_Int (Data (Data'First) 'Address);
      Rest    : C.int := Data'Length;
      Code    : C.int;
   begin
      while Rest > 0 loop
         Code := Net.C_Write (FD, To_Chars_Ptr (Current), Rest);
         if Code <= 0 then
            raise Communication_Error;
         end if;
         Current := Current + Code;
         Rest := Rest - Code;
      end loop;
   end Physical_Send;

   ----------
   -- Send --
   ----------

   procedure Send
     (Protocol  : access TCP_Protocol;
      Partition : in Partition_ID;
      Data      : access Stream_Element_Array) is
      Remote_Data : Host_Data;
      Header_Length : constant Stream_Element_Count :=
        Stream_Element_Count_Length;
      Header        : aliased Params_Stream_Type (Header_Length);
   begin
      select
         Shutdown_Keeper.Wait;
         raise Communication_Error;
      then abort
         Partition_Map.Lock (Partition);
         Partition_Map.Get (Partition) (Remote_Data);
         if Remote_Data.Queried and then not Remote_Data.Known then
            Partition_Map.Unlock (Partition);
            declare
               Temp : Host_Location;
            begin
               Temp := Split_Data
                 (Get_Data (Get_Partition_Location (Partition)));
               Partition_Map.Lock (Partition);
               Remote_Data := Partition_Map.Get_Immediate (Partition);
               Remote_Data.Location := Temp;
               Remote_Data.Known := True;
               Remote_Data.Queried := False;
               Partition_Map.Set_Locked (Partition, Remote_Data);
            end;
         end if;
         begin
            if not Remote_Data.Connected then

               D (D_Communication,
                  "Willing to connect to " &
                  Image (Remote_Data.Location.Addr) & " port" &
                  C.unsigned_short'Image (Remote_Data.Location.Port));

               declare
                  Retries : Natural := 1;
               begin
                  if Partition = Get_Boot_Server then
                     Retries := Options.Get_Connection_Hits;
                  end if;
                  for I in 1 .. Retries loop
                     begin
                        D (D_Communication,
                           "Trying to connect to partition" &
                           Partition_ID'Image (Partition));
                        Remote_Data.FD :=
                          Establish_Connection (Remote_Data.Location);
                        Remote_Data.Connected := True;
                        exit;
                     exception
                        when Communication_Error =>
                           if I = Retries then
                              D (D_Communication,
                                 "Cannot connect to partition" &
                                 Partition_ID'Image (Partition));
                              raise Communication_Error;
                           else
                              delay 2.0;
                           end if;
                     end;
                  end loop;
                  D (D_Communication,
                     "Connected to partition" &
                     Partition_ID'Image (Partition));
               end;

               Partition_Map.Set_Locked (Partition, Remote_Data);
               if Get_My_Partition_ID_Immediately = Null_Partition_ID then
                  Set_My_Partition_ID (Ask_For_Partition_ID (Remote_Data.FD));
               else
                  Send_My_Partition_ID (Remote_Data.FD);
               end if;

               --  Now create a task to get data on this connection.

               declare
                  NT : Incoming_Connection_Handler_Access;
               begin
                  NT := new Incoming_Connection_Handler
                    (Remote_Data.FD, Receiving => False, Remote => Partition);
               end;

            end if;
            declare
               Offset : constant Stream_Element_Offset :=
                 Data'First + Unused_Space - Header_Length;
            begin
               Stream_Element_Count'Write (Header'Access,
                                           Data'Length - Unused_Space);
               Data (Offset .. Offset + Header_Length - 1) :=
                 To_Stream_Element_Array (Header'Access);
               D (D_Debug,
                  "Sending packet of length" &
                  Stream_Element_Count'Image (Data'Last - Offset + 1) &
                  " (content of" &
                  Stream_Element_Count'Image (Data'Length - Unused_Space) &
                  ")");
               Physical_Send (Remote_Data.FD, Data (Offset .. Data'Last));
            end;
            Partition_Map.Unlock (Partition);
         exception
            when Communication_Error =>
               D (D_Debug, "Error detected in Send");
               Partition_Map.Unlock (Partition);
               raise Communication_Error;
         end;
      end select;
   end Send;

   --------------------------
   -- Send_My_Partition_ID --
   --------------------------

   procedure Send_My_Partition_ID (FD : in C.int) is
      Stream : aliased Params_Stream_Type (Partition_ID_Length);
   begin
      Partition_ID'Write (Stream'Access, Get_My_Partition_ID);
      Physical_Send (FD, To_Stream_Element_Array (Stream'Access));
   end Send_My_Partition_ID;

   -------------------
   -- Set_Boot_Data --
   -------------------

   procedure Set_Boot_Data
     (Protocol         : access TCP_Protocol;
      Is_Boot_Protocol : in Boolean := False;
      Boot_Data        : in String := "";
      Is_Master        : in Boolean := False)
   is
      Boot_Host : Host_Data;
   begin
      Self_Host.Location := Split_Data (Host_Name);
      if Is_Boot_Protocol then
         Boot_Host.Location := Split_Data (Boot_Data);
         Boot_Host.Known    := True;
         Partition_Map.Lock (Get_Boot_Server);
         Partition_Map.Set_Locked (Get_Boot_Server, Boot_Host);
         Partition_Map.Unlock (Get_Boot_Server);
         if Is_Master then
            Self_Host.Location.Port := Boot_Host.Location.Port;
         end if;
      end if;
      Establish_Listening_Socket;
      Accept_Handler.Start;
   end Set_Boot_Data;

   --------------
   -- Shutdown --
   --------------

   procedure Shutdown (Protocol : access TCP_Protocol) is
   begin
      Free (Partition_Map);
   end Shutdown;

   ----------------
   -- Split_Data --
   ----------------

   function Split_Data (Data : String) return Host_Location is
      Result : Host_Location;
   begin
      if Data = "" then
         return Result;
      end if;
      for I in Data'Range loop
         if Data (I) = ':' then
            Result.Addr := Address_Of (Data (Data'First .. I - 1));
            Result.Port := C.unsigned_short'Value (Data (I + 1 .. Data'Last));
            return Result;
         end if;
      end loop;
      Result.Addr := Address_Of (Data);
      return Result;
   end Split_Data;

   ---------------------------------
   -- Stream_Element_Count_Length --
   ---------------------------------

   function Stream_Element_Count_Length return Stream_Element_Count is
   begin
      if Stream_Element_Count_Length_Cache = 0 then
         declare
            Stream : aliased Params_Stream_Type (0);
         begin
            Stream_Element_Count'Write (Stream'Access, 0);
            Stream_Element_Count_Length_Cache :=
              To_Stream_Element_Array (Stream'Access) 'Length;
            pragma Assert (Stream_Element_Count_Length_Cache <= Unused_Space);
         end;
      end if;
      return Stream_Element_Count_Length_Cache;
   end Stream_Element_Count_Length;

end System.Garlic.TCP;
