User = require '../models/user'
Goal = require '../models/goal'
mysql = require('../infrastructure/db').mysql

exports.apply = (cb) ->
    Goal.sync
        force: true
    .success ->
        User.sync
            force: true
        .success ->
            query = 'ALTER TABLE goals ADD CONSTRAINT fk_goals_users FOREIGN KEY (user_id) REFERENCES users (id);'
            mysql.query(query)
                .success ->
                    cb null
                .error (err) ->
                    cb err
        .error (err) ->
            cb err
    .error (err) ->
        cb err

