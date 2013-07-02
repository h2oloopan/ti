define [], ->
    utils =
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
