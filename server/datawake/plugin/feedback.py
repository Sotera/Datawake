import json
import tangelo
import datawake.util.db.datawake_mysql as db
import datawake.util.session.helper as session_helper
from datawake.util.validate.parameters import required_parameters



@session_helper.is_in_session
@session_helper.has_team
@session_helper.has_trail
@required_parameters([ 'feature_type', 'feature_value'])
@tangelo.types(team_id=int,domain_id=int,trail_id=int)
def invalid_extraction(team_id,domain_id,trail_id,feature_type, feature_value):
    user = session_helper.get_user()
    db.mark_invalid_feature(trail_id,user.get_email(), feature_type, feature_value)
    return json.dumps(dict(success=True))



@session_helper.is_in_session
@session_helper.has_team
@session_helper.has_trail
@required_parameters(['raw_text', 'feature_type', 'feature_value', 'url'])
@tangelo.types(team_id=int,domain_id=int,trail_id=int)
def add_manual_feature(team_id,domain_id,trail_id,url,raw_text,feature_type,feature_value):
    user = session_helper.get_user()
    db.add_manual_feature(trail_id, user.get_email(),url,raw_text, feature_type, feature_value)
    return json.dumps(dict(success=True))



@session_helper.is_in_session
@session_helper.has_team
@session_helper.has_trail
@required_parameters(['url'])
@tangelo.types(team_id=int,domain_id=int,trail_id=int)
def get_manual_features(team_id,domain_id,trail_id, url):
    features = db.get_manual_features(trail_id,url)
    return json.dumps(features)



@session_helper.is_in_session
@session_helper.has_team
@session_helper.has_trail
@tangelo.types(team_id=int,domain_id=int,trail_id=int)
def get_marked_features(team_id,domain_id,trail_id):
    user = session_helper.get_user()
    marked_features_list = db.get_marked_features(trail_id)
    return json.dumps(marked_features_list)


post_actions = {
    "get_invalid_features": get_marked_features,
    "invalid_feature": invalid_extraction,
    "add_manual_feature": add_manual_feature,
    "manual_features": get_manual_features
}


@tangelo.restful
def post(action, *arg, **kwargs):
    post_data = json.loads(tangelo.request_body().read())

    def unknown(*args):
        return tangelo.HTTPStatusCode(400, "invalid service call")

    return post_actions.get(action, unknown)(**post_data)
