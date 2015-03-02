class User(object):
    def __init__(self, user_name, user_id, email):
        self.user_name = user_name
        self.user_id = user_id
        self.email = email
        self.teams = []

    def get_user_name(self):
        return self.user_name

    def get_user_id(self):
        return self.user_id

    def get_teams(self):
        return self.teams

    # TODO, remove this method and add support for multiple teams for each user.
    def get_org(self):
        return self.teams[0]['name']

    def get_email(self):
        return self.email

    def set_teams(self, teams):
        self.teams = teams