////////////////////////////////////////////////////////////////////////////
////                                                                    ////
////     This package deals with the raising of C exceptions in         ////
////   Ada and ada ones in C.                                           ////
////     It is both a C and a Ada class (see exceptions.ads)            ////
////   and provides 2 mains methods : raise_C_Exception and             ////
////   raise_Ada_Exception. The first one is called by Ada code         ////
////   and implemented in C. The second is called by C code and         ////
////   implemented in Ada. Both translate exceptions in the other       ////
////   language.                                                        ////
////                                                                    ////
////                Date : 03/04/99                                     ////
////                                                                    ////
////                authors : Sebastien Ponce                           ////
////                                                                    ////
////////////////////////////////////////////////////////////////////////////


#include "Ada_exceptions.hh"

//#define DEF_EXCEPTION(name)
void Raise_Corba_Exception (CORBA::UNKNOWN e)
{
  CORBA::ULong pd_minor = e.minor () ;
  CORBA::CompletionStatus pd_status = e.completed () ;
  Raise_Ada_UNKNOWN_Exception (pd_minor, pd_status) ;
};

void Raise_C_UNKNOWN_Exception (CORBA::ULong pd_minor,
				CORBA::CompletionStatus pd_status)
{
  CORBA::UNKNOWN *e = new CORBA::UNKNOWN (pd_minor, pd_status);
  Raise_Ada_UNKNOWN_Exception (pd_minor, pd_status) ;
  //  e->_raise ();
};

/*

DEF_EXCEPTION (UNKNOWN);
DEF_EXCEPTION (BAD_PARAM);
DEF_EXCEPTION (NO_MEMORY);
DEF_EXCEPTION (IMP_LIMIT);
DEF_EXCEPTION (COMM_FAILURE);
DEF_EXCEPTION (INV_OBJREF);
DEF_EXCEPTION (OBJECT_NOT_EXIST);
DEF_EXCEPTION (NO_PERMISSION);
DEF_EXCEPTION (INTERNAL);
DEF_EXCEPTION (MARSHAL);
DEF_EXCEPTION (INITIALIZE);
DEF_EXCEPTION (NO_IMPLEMENT);
DEF_EXCEPTION (BAD_TYPECODE);
DEF_EXCEPTION (BAD_OPERATION);
DEF_EXCEPTION (NO_RESOURCES);
DEF_EXCEPTION (NO_RESPONSE);
DEF_EXCEPTION (PERSIST_STORE);
DEF_EXCEPTION (BAD_INV_ORDER);
DEF_EXCEPTION (TRANSIENT);
DEF_EXCEPTION (FREE_MEM);
DEF_EXCEPTION (INV_IDENT);
DEF_EXCEPTION (INV_FLAG);
DEF_EXCEPTION (INTF_REPOS);
DEF_EXCEPTION (BAD_CONTEXT);
DEF_EXCEPTION (OBJ_ADAPTER);
DEF_EXCEPTION (DATA_CONVERSION);
DEF_EXCEPTION (TRANSACTION_REQUIRED);
DEF_EXCEPTION (TRANSACTION_ROLLEDBACK);
DEF_EXCEPTION (INVALID_TRANSACTION);
DEF_EXCEPTION (WRONG_TRANSACTION);


#undef DEF_EXCEPTION
*/
