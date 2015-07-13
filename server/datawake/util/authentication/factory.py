from google import GoogleAuthentication
from mock import MockAuthentication

def get_authentication_object(token,mock):
    if mock:
        return MockAuthentication(token)
    else:
        return GoogleAuthentication(token)
