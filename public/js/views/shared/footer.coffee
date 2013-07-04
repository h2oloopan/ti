define ['text!templates/shared/footer.html'], (template) ->
    FooterView = Backbone.View.extend
        el: $('#footer')
        render: ->
            @$el.html _.template(template)