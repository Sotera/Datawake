import time
import json

import httplib2

from auth import Authentication
from datawake.conf import datawakeconfig as constants


"""
 Authenticates a user with google

 the auth request must come form a valid client ID registed with the google devopment console

 https://console.developers.google.com/project/apps~elevated-epoch-574/apiui/credential?authuser=0


"""

VALIDATE_TOKEN_URL = 'https://www.googleapis.com/oauth2/v1/tokeninfo?access_token=%s'
GET_PROFILE_URL = 'https://www.googleapis.com/plus/v1/people/%s?access_token=%s'
CLIENT_IDS = constants.CLIENT_IDS


class GoogleAuthentication(Authentication):
    def __init__(self, token):
        super(GoogleAuthentication, self).__init__(token)

    def get_profile(self, user_id):
        url = (GET_PROFILE_URL % (user_id, self.token))
        h = httplib2.Http()
        result = json.loads(h.request(url, 'GET')[1])

        if "error" in result:
            raise ValueError("Invalid access token or userId %s" % result.get("error"))
        return result

    def get_user(self, user_id):
        return super(GoogleAuthentication, self).get_user(user_id)

    def get_user_from_token(self):
        (user_id, client_id, expires) = self.validate_token()
        return self.get_user(user_id)

    def validate_token(self):
        url = (VALIDATE_TOKEN_URL % self.token)
        h = httplib2.Http()
        result = json.loads(h.request(url, 'GET')[1])

        if result.get('error') is not None:
            raise ValueError("Invalid access token")

        client_id = result.get('audience')
        if client_id not in CLIENT_IDS:
            raise ValueError("Token granted to unknown client: " + client_id)

        user_id = result.get('user_id')
        if user_id is None:
            raise ValueError("userId not returned by token validation. Ensure the profile scope was present in the request to create the access token")

        expires = int(result.get('expires_in')) + int(time.time())
        return user_id, client_id, expires