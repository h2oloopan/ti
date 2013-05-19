mysql = require('../infrastructure/db').mysql

exports.apply = (cb) ->
    query = 'ALTER TABLE users ADD CONSTRAINT fk_users_groups FOREIGN KEY (group_id) REFERENCES groups (id);'

    mysql.query(query)
        .success ->
            cb null
        .error (err) ->
            cb err

