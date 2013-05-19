define [], ->
    User = Backbone.Model.extend
        urlRoot: '/api/users'
        validate: (attrs, options) ->
            if attrs.email?
                if attrs.email.indexOf('@') >= 0
                    #email
                    pattern = /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,6}$/ig
                    result = pattern.test attrs.email
                    if !result
                        return 'Invalid email address'
                else if attrs.email.length < 4
                    #NOTE: this is just a safeguard, the real logic is imposed at server
                    return 'Username must be no less than 4 characters'
            else
                return 'Email / Username cannot be empty'


            if attrs.password?
                if attrs.password.length < 6
                    #NOTE: this is just a safeguard, the real logic is imposed at server
                    return 'Password must be no less than 6 characters'
            else
                return 'Password is empty'
