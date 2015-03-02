import time

from auth import Authentication


class MockAuthentication(Authentication):
    def __init__(self, token):
        super(MockAuthentication, self).__init__(token)

    def get_profile(self, user_id):
        return dict(displayName='John Doe', emails=[dict(value='john.doe@nomail.none')])

    def get_user_from_token(self):
        return self.get_user('123456')

    def validate_token(self):
        return '0', '0', int(time.time()) + 300

    def get_user(self, user_id):
        return super(MockAuthentication, self).get_user(user_id)