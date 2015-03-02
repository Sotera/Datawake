import json

import tangelo

from datawake.conf import datawakeconfig


@tangelo.restful
def get():
    return json.dumps(dict(version=datawakeconfig.VERSION_NUMBER))