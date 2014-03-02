validator = module.exports =
    validate: (item, cb) ->
        errs = []
        for key, value of item
            if item.hasOwnProperty key
                #check required
                required = Object.getPrototypeOf(item).validations[key].required
                if value == null && required
                    errs.push new Error('Missing required property ' + key)
                #check the regex
                regex = Object.getPrototypeOf(item).validations[key].regex
                if regex
                    result = regex.test value
                    if !result
                        errs.push new Error('Incorrect value for property ' + key)

        if errs.length == 0
            errs = null
        cb errs
