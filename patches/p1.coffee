User = require '../models/user'
Group = require '../models/group'
UserInfo = require '../models/userInfo'
Goal = require '../models/goal'
#drop all tables
exports.apply = (cb) ->
    #need to chain drops accordingly, for the reason of foreign key constraints
    Goal.drop()
        .success ->
            UserInfo.drop()
                .success ->
                    User.drop()
                        .success ->
                            Group.drop()
                                .success ->
                                    cb null
                                .error (err) ->
                                    cb err
                        .error (err) ->
                            cb err
                .error (err) ->
                    cb err
        .error (err) ->
            cb err