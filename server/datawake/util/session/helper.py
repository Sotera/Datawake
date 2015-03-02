import cherrypy
from datawake.util.exceptions import datawakeexception
from datawake.util.db import datawake_mysql
import tangelo

def is_in_session(callback):
    def has_session(**kwargs):
        if 'user' in cherrypy.session:
            return callback(**kwargs)
        tangelo.http_status(401)
        tangelo.log("401 Unauthorized No user in session")
        return "No User in the current session"
    return has_session



def has_team(callback):
    """
    Decorator for tangelo web services.
    Requires a team_id and checks that the current user has permissions for that team
    :param callback:
    :return:
    """
    def verifyTeamId(**kwargs):
        if 'team_id' not in kwargs:
            tangelo.http_status(500)
            tangelo.log("team_id required.")
            return "team id required for this call."

        user = get_user()

        # verify the user can access the team
        if not datawake_mysql.hasTeamAccess(user.get_email(),kwargs['team_id']):
            tangelo.content_type()
            tangelo.http_status(401)
            tangelo.log("401 Unauthorized. User has no access to requested team.")
            return "401 Unauthorized"

        return callback(**kwargs)
    return verifyTeamId


def has_domain(callback):
    """
    Decorator for tangelo web servcies
    Requires a team_id and domain_id, checks that the team can access the domain
    :param callback:
    :return:
    """
    def verifyDomainId(**kwargs):

        if 'team_id' not in kwargs or 'domain_id' not in kwargs:
            tangelo.http_status(500)
            tangelo.log("team_id and domain_id required.")
            return "team id and domain id required for this call."

        team_id = int(kwargs['team_id'])
        domain_id = int(kwargs['domain_id'])
        if not datawake_mysql.hasDomains(team_id,domain_id):
            tangelo.http_status(401)
            tangelo.log("401 Unauthorized. Team has no access to requested domain")
            return "401 Unauthorized"
        return callback(**kwargs)
    return verifyDomainId



def has_trail(callback):
    """
    Decorator for tangelo web servcies
    Requires a team_id and trail_id, checks that the team can access to the trail
    :param callback:
    :return:
    """
    def verifyTrailId(**kwargs):

        if 'team_id' not in kwargs or 'trail_id' not in kwargs or 'domain_id' not in kwargs:
            tangelo.http_status(500)
            tangelo.log("team_id, domain id, and trail_id required.")
            tangelo.log(kwargs)
            return "team id, domain id, and trail id required for this call."

        team_id = int(kwargs['team_id'])
        domain_id = int(kwargs['domain_id'])
        trail_id = int(kwargs['trail_id'])

        if not datawake_mysql.hasTrail(team_id,domain_id,trail_id):
            tangelo.http_status(401)
            tangelo.log("401 Unauthorized. Team has no access to requested domain")
            return "401 Unauthorized"
        return callback(**kwargs)
    return verifyTrailId


def get_user():
    user = cherrypy.session.get('user')
    return user


def get_org():
    user = get_user()
    if user is not None:
        return user.get_org()

    return None


def get_token():
    return cherrypy.session.get('token')


def is_token_in_session():
    return 'token' in cherrypy.session


def expire_user():
    if 'user' in cherrypy.session:
        del cherrypy.session['user']
    if 'token' in cherrypy.session:
        del cherrypy.session['token']
    cherrypy.lib.sessions.expire()
    return True


def set_user(user):
    teams = datawake_mysql.getTeams(email=user.get_email())
    if len(teams) == 0:
        # create a team with just this user
        teams = [ datawake_mysql.createTeam(user.get_email(),'Auto generated private team.',emails=[user.get_email()]) ]
    user.set_teams(teams)
    cherrypy.session['user'] = user
    return True


def set_token(token):
    cherrypy.session['token'] = token
    return True
