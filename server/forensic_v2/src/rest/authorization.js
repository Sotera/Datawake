define([], function() {
    return {

        /**
         * Authorize this session on the datawake server
         */
        post : function(authResult) {
            // start a session on the server
            return $.ajax({
                type: 'POST',
                url: '/datawake/forensic/session',
                data: {token: authResult['access_token']}
            });
        },

        /**
         * Delete session on datawake server
         * @returns {*}
         */
        del : function() {
            return $.ajax({
                type: 'DELETE',
                url: '/datawake/forensic/session',
                dataType:'json'
            });
        }
    };
});