
from test_utils import *
import sys

if not client_server(r'../examples/corba/rtcorba/dhb/rtcorba_iiop_client', r'',
                     r'../examples/corba/rtcorba/dhb/rtcorba_iiop_server', r''):
    fail()

