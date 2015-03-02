from datawake.util.authentication.user import User


class Authentication(object):

    def __init__(self, token):
        self.token = token

    def get_user_from_token(self):
        NotImplementedError("Class %s doesn't implement getUser()" % self.__class__.__name__)

    def validate_token(self):
        NotImplementedError("Class %s doesn't implement validate_token()" % self.__class__.__name__)

    def get_profile(self, user_id):
        NotImplementedError("Class %s doesn't implement get_profile()" % self.__class__.__name__)

    def get_user(self, user_id):
        profile = self.get_profile(user_id)
        emails = profile.get("emails")
        email = emails[0]['value']
        user = User(profile.get("displayName"), user_id, email)
        return user