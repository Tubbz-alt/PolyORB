
from test_utils import *
import sys

if not client_server(r'../examples/corba/random/client', r'soap.conf',
                     r'../examples/corba/random/server', r'soap.conf'):
    fail()

