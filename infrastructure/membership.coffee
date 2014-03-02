auth = require '../helpers/auth'
config = require '../config'
connector = require '../repos/connector'

membership = module.exports =
    userRepo: connector.getRepos().getRepo('user')

    middleware: (req, res, next) ->
        uid = req.signedCookies['U']
        if uid?
            membership.userRepo.getUserById id, (err, user) ->
                if !err? && user?
                    req.user = user
                next()
        else
            next()

    #TODO: may want to make one database call in the future
    #for better performance
    #eu is email or username
    authenticate: (eu, password, cb) ->
        password = auth.encrypt password
        #NOTE: it depends on that username can never contain @
        if eu.indexOf('@') >= 0
            #it's an email
            membership.repo.getUserByEmailPassword eu, password, cb
        else
            #it's a username
            membership.repo.getUserByUsernamePassword eu, password, cb

    login: (user, res) ->
        res.cookie 'U', user.id.toString(), {signed: true}

    logout: (res) ->
        res.clearCookie 'U'

    signup: (user, cb) ->
        if user.password?
            password = user.password
        else
            return cb new Error 'Password is empty'

        membership.userRepo.addUser user, cb
