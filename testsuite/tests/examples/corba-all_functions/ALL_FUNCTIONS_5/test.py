
from test_utils import *
import sys

if not client_server(r'../examples/corba/all_functions/client', r'giop_1_1.conf',
                     r'../examples/corba/all_functions/server', r'giop_1_1.conf'):
    fail()

