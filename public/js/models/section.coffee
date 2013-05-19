define [], ->
    Section = Backbone.Model.extend
        urlRoot: '/api/sections'
        validate: (attrs, options) ->
            if !attrs.name?
                return 'Section name cannot be empty'
            else
                if attrs.name.length == 0
                    return 'Section name cannot be empty'
                else if attrs.name.length > 255
                    return 'Section name cannot exceed 255 characters'

            if !attrs.order? || (/\D/gi).test(attrs.order)
                return 'Section order must be a positive integer'
