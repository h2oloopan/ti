define ['text!templates/admin/forums.html', 'models/section', 'models/sectionCollection'],
    (template, Section, SectionCollection) ->
        ForumsView = Backbone.View.extend
            el: $('#content')
            events:
                'click .btn-addsection': 'btnClickAddSection'
                'click .btn-savesection': 'btnClickSaveSection'
                'click .btn-cancelsection': 'btnClickCancelSection'
                'click .btn-deletesection': 'btnClickDeleteSection'
                'click .btn-editsection': 'btnClickEditSection'
            initialize: ->
                @collection = new SectionCollection()
            render: ->
                @collection.on 'reset', @updateTable, @
                @collection.on 'remove', @updateTable, @
                @collection.fetch()
            updateTable: ->
                @$el.html _.template(template, {sections: @collection.toJSON()})
            btnClickAddSection: (e) ->
                @cleanUp()
                clone = @$('table.table-holder tr.row-editsection').clone().addClass 'row-newsection'
                if @$('table.table tbody tr.row-newsection').length <= 0
                    @$('table.table tbody').append clone
                return false
            btnClickEditSection: (e) ->
                target = $ e.currentTarget
                section = @collection.get target.data('id')
                row = target.parent().parent()
                @cleanUp()
                clone = @$('table.table-holder tr.row-editsection').clone()
                #inject section to clone
                clone.find('input[name="order"]').val section.get('order')
                clone.find('input[name="name"]').val section.get('name')
                clone.find('a.btn-savesection').data 'id', section.get('id')
                row.addClass('temp-hidden').hide().after clone
                return false
            btnClickSaveSection: (e) ->
                target = $ e.currentTarget
                row = target.parent().parent()
                obj = row.serializeObject
                    trim: true

                if target.data('id')?
                    section = @collection.get target.data('id')
                else
                    section = new Section()

                section.set obj
                #now add it to collection and sync to server
                view = @
                result = section.save null,
                    success: (model, res) ->
                        view.collection.fetch
                            reset: true
                    error: (model, res) ->
                        alert res.responseText
                        return false

                if !result
                    alert section.validationError

                return false
            btnClickDeleteSection: (e) ->
                target = $ e.currentTarget
                section = @collection.get target.data('id')

                result = confirm 'Are you sure to delete section ' + section.get('name') + '?'
                if !result
                    return false

                section.destroy
                    wait: true
                    error: (model, res) ->
                        alert res.responseText
                        return false
                return false
            btnClickCancelSection: (e) ->
                target = $ e.currentTarget
                row = target.parent().parent()
                prev = row.prev 'tr.temp-hidden'
                row.remove()
                prev.show().removeClass 'temp-hidden'
                return false
            cleanUp: ->
                @$('table.table tr.row-editsection').remove()
                @$('table.table tr.temp-hidden').show().removeClass 'temp-hidden'
                return false
