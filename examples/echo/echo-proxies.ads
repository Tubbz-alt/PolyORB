----------------------------------------------------------------------------
----                                                                    ----
----     This in an example which is hand-written                       ----
----     for the echo object                                            ----
----                                                                    ----
----                package echo_proxies                                ----
----                                                                    ----
----                authors : Fabien Azavant, Sebastien Ponce           ----
----                                                                    ----
----------------------------------------------------------------------------

with Corba ;
with Giop_C ;
with Omniproxycalldesc ;

with Adabroker_Debug ;
pragma Elaborate(Adabroker_Debug) ;

package Echo.Proxies is

   Echo_Proxies : constant Boolean := Adabroker_Debug.Is_Active("echo.proxies") ;

   --------------------------------------------------
   ----        function EchoString               ----
   --------------------------------------------------

   type EchoString_Proxy is new OmniProxyCallDesc.Object with private ;

   procedure Init(Self : in out EchoString_Proxy ;
                  Arg : in Corba.String ) ;

   function Operation (Self : in EchoString_Proxy)
                       return CORBA.String ;

   function Align_Size(Self: in EchoString_Proxy ;
                         Size_In: in Corba.Unsigned_Long)
                         return Corba.Unsigned_Long ;

   procedure Marshal_Arguments(Self: in EchoString_Proxy ;
                               Giop_Client: in out Giop_C.Object) ;

   procedure Unmarshal_Returned_Values(Self: in out EchoString_Proxy ;
                                       Giop_Client: in out Giop_C.Object) ;

   function Get_Result (Self : in EchoString_Proxy)
                        return CORBA.String;


private

   type EchoString_Proxy is new OmniProxyCallDesc.Object with record
      Arg_Msg : Corba.String_Ptr := null ;
      Private_Result : Corba.String_Ptr := null ;
   end record ;

   procedure Finalize(Self : in out EchoString_Proxy) ;

end Echo.Proxies ;


