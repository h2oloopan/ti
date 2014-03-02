
exports.bind = (app) ->
    #should expose user info rather than basic data
    #remember we need to impose authentication and authorization here
    app.get '/api/users/self', (req, res) ->
        if req.user?
            user_id = req.user.id
            repo.getUserInfo
                user_id: user_id
            , (err, info) ->
                if err?
                    res.send 500, err.message
                else
                    user =
                        id: user_id
                        userInfo: info

                    res.send 200, user



