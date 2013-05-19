auth = require '../helpers/auth'
config = require '../config'
userRepo = require '../repos/userRepo'

membership = module.exports =
    repo: userRepo

    initialize: (repo) ->
        membership.repo = repo

    middleware: (req, res, next) ->
        privilege = req.signedCookies['P']
        if privilege?
            req.privilege = parseInt privilege
        else
            req.privilege = config.system.privileges.guest

        uid = req.signedCookies['U']
        if uid?
            membership.repo.getUser
                id: uid
            , (err, user) ->
                if !err? && user?
                    req.user = user
                next()
        else
            next()

    authorize: (privilege, handler) ->
        func = (req, res) ->
            if req.privilege < privilege
                res.send 401
            else
                handler req, res


    #TODO: may want to make one database call in the future
    #for better performance
    authenticate: (eu, password, cb) ->
        password = auth.encrypt password
        #NOTE: it depends on that username can never contain @
        if eu.indexOf('@') >= 0
            #it's an email
            membership.repo.getUserWithGroup
                email: eu
                password: password
            , cb
        else
            #it's a username
            membership.repo.getUserWithGroup
                username: eu
                password: password
            , cb

    login: (user, res) ->
        res.cookie 'U', user.id.toString(), {signed: true}
        if user.group?
            res.cookie 'P', user.group.privilege.toString(), {signed: true}
        else
            res.cookie 'P', "0", {signed: true}

    logout: (res) ->
        res.clearCookie 'U'
        res.clearCookie 'P'

    signup: (user, cb) ->
        if user.password?
            password = user.password
            if password.length < config.system.password.min || password.length > config.system.password.max
                return cb new Error 'Password must be between ' + config.system.password.min + ' and ' + config.system.password.max + ' characters'
            user.password = auth.encrypt password
        else
            return cb new Error 'Password is empty'
        membership.repo.createUser user, cb
