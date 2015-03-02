define(['../rest/authorization','./events'], function(authModule,events) {

    var authResult;
    var onLoggedIn = function () {
    };
    var onLoggedOut = function() {
    };

    return {

        setOnLoggedIn: function (f) {
            onLoggedIn = f;
        },

        setOnLoggedOut : function(f) {
            onLoggedOut = f;
        },

        getToken: function () {
            if (authResult && authResult['access_token']) {
                return authResult['access_token'];
            }
            else {
                alert('Bad access token.  Try signing in again.');
                return '';
            }
        },


        /**
         * Hides the sign-in button and connects the server-side app after
         * the user successfully signs in.
         *
         * @param {Object} _authResult An Object which contains the access token and
         *   other authentication information.
         */
        onSignInCallback: function (_authResult) {
            if (_authResult['access_token']) {
                // The user is signed in
                authResult = _authResult;

                // Let server know of authorization
                authModule.post(_authResult)
                .then(
                    function(response) {
                        console.log("datawake server login: " + response);
                        onLoggedIn();
                    }
                );

            } else if (_authResult['error']) {
                // There was an error, which means the user is not signed in.
                // As an example, you can troubleshoot by writing to the console:
                console.log('There was an error: ' + _authResult['error']);
                authResult = undefined;
                authModule.del()
                .then(
                    function() {
                        onLoggedOut();
                    }
                );

            }
            console.log('authResult', _authResult);
        },

        disconnectUser: function () {
            authModule.del()
            .then(
                function() {
                    // TODO:   on logout success
                },
                function() {
                    // TODO:   on logout fail
                }
            );
        }
    };
});