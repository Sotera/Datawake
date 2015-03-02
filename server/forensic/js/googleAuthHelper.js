var authHelper = (function () {
    var authResult = undefined;
    var onLoggedIn = function () {
    };

    return {

        setOnLoggedIn: function (f) {
            onLoggedIn = f
        },


        getToken: function () {
            if (this.authResult && this.authResult['access_token']) {
                return this.authResult['access_token']
            }
            else {
                alert("Bad access token.  Try signing in again.")
                return ''
            }
        },


        /**
         * Hides the sign-in button and connects the server-side app after
         * the user successfully signs in.
         *
         * @param {Object} authResult An Object which contains the access token and
         *   other authentication information.
         */
        onSignInCallback: function (authResult) {
            if (authResult['access_token']) {
                // The user is signed in
                this.authResult = authResult;
                $('#gConnect').hide();
                $('#gDisconnect').show();
                var jsonData = JSON.stringify({token: authResult['access_token']});
                // start a session on the server
                $.ajax({
                    type: 'POST',
                    url: '/datawake/forensic/session',
                    data: {token: authResult['access_token']},
                    success: function (response) {
                        console.log("datawake server login: " + response);
                        onLoggedIn();
                    },
                    error: function (e) {
                        console.log(e);
                    }
                })

            } else if (authResult['error']) {
                // There was an error, which means the user is not signed in.
                // As an example, you can troubleshoot by writing to the console:
                console.log('There was an error: ' + authResult['error']);
                $('#gDisconnect').hide();
                $('#gConnect').show();
                this.authResult = undefined;

                // clear any session on the server
                $.ajax({
                    type: 'DELETE',
                    url: '/datawake/forensic/session',
                    success: function (response) {
                        console.log("datawake server logout: " + response.removeSession);
                        onLoggedIn();
                    },
                    error: function (e) {
                        console.log(e);
                    }
                })

            }
            console.log('authResult', authResult);
        },


        disconnectUser: function () {
            var token = this.getToken();
            if (token != '') {
                var revokeUrl = 'https://accounts.google.com/o/oauth2/revoke?token=' + token;
                $.ajax({
                    type: 'GET',
                    url: revokeUrl,
                    async: false,
                    contentType: "application/json",
                    dataType: 'jsonp',
                    success: function (nullResponse) {
                        gapi.auth.signOut();
                        this.authResult = undefined;
                        console.log("signed out");
                        $('#authOps').hide();
                        $('#gConnect').show();

                        // clear any session on the server
                        $.ajax({
                            type: 'DELETE',
                            url: '/datawake/forensic/session',
                            dataType:'json',
                            success: function (response) {
                                console.log("datawake server logout: " + response.removedSession);
                                onLoggedIn();
                            },
                            error: function (e) {
                                console.log(e);
                            }
                        })

                    },
                    error: function (e) {
                        // Handle the error
                        console.log(e);
                        alert("error signing out. If required you can manually disconnect your account at https://plus.google.com/apps")
                    }
                });

            }

        },


    };
})();