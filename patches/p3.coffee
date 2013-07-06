mysql = require('../infrastructure/db').mysql


#add all foreign keys
#TODO: maybe we can do it in recursive way to improve readability
fk1 = 'ALTER TABLE goals ADD CONSTRAINT fk_goals_users FOREIGN KEY (user_id) REFERENCES users (id);'
fk2 = 'ALTER TABLE users ADD CONSTRAINT fk_users_groups FOREIGN KEY (group_id) REFERENCES groups (id);'
fk3 = 'ALTER TABLE user_infos ADD CONSTRAINT fk_user_infos_users FOREIGN KEY (user_id) REFERENCES users (id);'

exports.apply = (cb) ->
    mysql.query(fk1)
        .success ->
            mysql.query(fk2)
                .success ->
                    mysql.query(fk3)
                        .success ->
                            cb null
                        .error (err) ->
                            cb err
                .error (err) ->
                    cb err
        .error (err) ->
            cb err