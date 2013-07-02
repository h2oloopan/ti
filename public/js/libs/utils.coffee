define ['jquery'], ($) ->
    utils =
        serialize: (element, trim) ->
            if !trim?
                trim = false

            o = {}
            if $(element).is 'form'
                form = element
            else
                form = $('<form></form>').append $(element).clone()

            a = form.serializeArray()
            $.each a, ->
                if o[@name] != undefined
                    if !o[@name].push
                        o[@name] = [o[@name]]
                    value = @value || ''
                    if trim
                        value = $.trim value
                    o[@name].push value
                else
                    value = @value || ''
                    if trim
                        value = $.trim value
                    o[@name] = value

            return o


        auth: (cb) ->
            $.get('/api/account/auth')
                .done ->
                    cb true
                .fail ->
                    cb false
        logout: (cb) ->
            $.post('/api/account/logout')
                .always ->
                    window.location.reload()
                    cb null
        login: (user, cb) ->
            $.post('/api/account/login', user)
                .done ->
                    window.location.href = '/'
                    cb null
                .fail (result) ->
                    cb result.responseText
