User = require '../../models/user'
userRepo = module.exports =
    convert: (row) ->
        user = new User()
        user.id = row.id
        user.username = row.username
        user.password = row.password
        user.email = row.email
        return user

    getUserById: (id, cb) ->
        sql = 'SELECT * FROM users WHERE id = $id'
        db.get sql,
            id: id
        , (err, row) ->
            if err
                cb err
            else
                #create the User object
                console.log row
                user = userRepo.convert row
                cb err, user

    getUserByEmailPassword: (email, password, cb) ->
        sql = 'SELECT * FROM users WHERE email = $email AND password = $password'
        db.get sql,
            email: email
            password: password
        , (err, row) ->
            if err
                cb err
            else
                #create the User object
                user = userRepo.convert row
                cb err, user



