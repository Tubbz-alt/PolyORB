///////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////
////                                                               ////
////                         AdaBroker                             ////
////                                                               ////
////                 class OmniObject_C2Ada                        ////
////                                                               ////
////                                                               ////
////   Copyright (C) 1999 ENST                                     ////
////                                                               ////
////   This file is part of the AdaBroker library                  ////
////                                                               ////
////   The AdaBroker library is free software; you can             ////
////   redistribute it and/or modify it under the terms of the     ////
////   GNU Library General Public License as published by the      ////
////   Free Software Foundation; either version 2 of the License,  ////
////   or (at your option) any later version.                      ////
////                                                               ////
////   This library is distributed in the hope that it will be     ////
////   useful, but WITHOUT ANY WARRANTY; without even the implied  ////
////   warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR     ////
////   PURPOSE.  See the GNU Library General Public License for    ////
////   more details.                                               ////
////                                                               ////
////   You should have received a copy of the GNU Library General  ////
////   Public License along with this library; if not, write to    ////
////   the Free Software Foundation, Inc., 59 Temple Place -       ////
////   Suite 330, Boston, MA 02111-1307, USA                       ////
////                                                               ////
////                                                               ////
////                                                               ////
////   Description                                                 ////
////   -----------                                                 ////
////     This class is a descendant of the omniObject              ////
////     class. It provides the sames functions plus a pointer     ////
////     on a Ada_OmniObject.                                      ////
////                                                               ////
////     Furthermore, the function dipatch is implemented and      ////
////     simply calls the Ada one. It allows the C code of         ////
////     omniORB to call the Ada objects.                          ////
////                                                               ////
////                                                               ////
////   authors : Sebastien Ponce, Fabien Azavant                   ////
////   date    : 02/28/99                                          ////
////                                                               ////
///////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////


#include "omniObject_C2Ada.hh"

// Constructor
//------------
omniObject_C2Ada::omniObject_C2Ada (Ada_OmniObject *Ada_Ptr) : omniObject ()
{
  // calls the omniObject constructor and initialise the pointer
  // on the Ada_OmniObject Ada_OmniObject_Pointer ;
  Ada_OmniObject_Pointer = Ada_Ptr;
};


// Constructor
//------------
omniObject_C2Ada::omniObject_C2Ada(const char *repoId,
				   Rope *r,
				   _CORBA_Octet *key,
				   size_t keysize,
				   IOP::TaggedProfileList *profiles,
				   _CORBA_Boolean release,
				   Ada_OmniObject *Ada_Ptr) : omniObject (repoId,
									  r,
									  key,
									  keysize,
									  profiles,
									  release)
{
  // calls the omniObject constructor and initialise the pointer
  // on the Ada_OmniObject Ada_OmniObject_Pointer ;
  Ada_OmniObject_Pointer = Ada_Ptr;
};


// get_omniObject_C2Ada
//---------------------
omniObject_C2Ada *
omniObject_C2Ada::get_omniObject_C2Ada (omniObject *omniobj)
{
  // creates a omniObject_C2Ada object (and its associated Ada_Omniobject)
  // out of an omniObject
  
  Ada_OmniObject *ada_omniobj = new Ada_OmniObject ();
  // makes a new empty Ada_Omniobject
  
  omniObject_C2Ada *result = (omniObject_C2Ada *) omniobj;
  // cast the omniobj object into an omniObject_C2Ada object
  
  ada_omniobj->Init (result);
  // initialize the Ada_Omniobject object with this new omniObject_C2Ada object
  
  result->Ada_OmniObject_Pointer = ada_omniobj;
  // and makes the new omniObject_C2Ada object point on ada_omniobj 
  
  return result;
};


// dispatch
//---------
_CORBA_Boolean
omniObject_C2Ada::dispatch(GIOP_S &giop,
			   const char *operation,
			   _CORBA_Boolean response_expected)
{
  return Ada_OmniObject_Pointer->dispatch(giop,
					  operation,
					  response_expected);
  // calls dispatch on the Ada_OmniObject pointed by Ada_OmniObject_Pointer
  // This function allows the C code to call the Ada function dispatch
};


// _widenFromTheMostDerivedIntf
//-----------------------------
void*
omniObject_C2Ada::_widenFromTheMostDerivedIntf(const char* repoId,
					       _CORBA_Boolean is_cxx_type_id=0) {
  if (Ada_OmniObject_Pointer->Ada_Is_A(repoId) ) {
    return (void*) this ;
  } else {
    return 0 ;
  }
}


// get_Ada_OmniObject
//-------------------
Ada_OmniObject *
omniObject_C2Ada::get_Ada_OmniObject ()
{
  return Ada_OmniObject_Pointer;
}

