module.exports = class User
    constructor: (@id, @username, @password, @email) ->

    validations:
        id:
            required: true
        username:
            required: true
            regex: /^([a-zA-Z0-9_]{4,32})$/g
        password:
            required: true
        email:
            required: true

