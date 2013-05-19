define ['text!templates/shared/admin/sidebar.html'],
    (template) ->
        SidebarView = Backbone.View.extend
            el: $('#sidebar')
            events:
                'click a': 'update'
            render: ->
                @$el.html template
                hash = window.location.hash
                @$('a[href="' + hash + '"]').parent().addClass('active')
            update: (e) ->
                li = $(e.currentTarget).parent()
                li.addClass('active').siblings().removeClass('active')

