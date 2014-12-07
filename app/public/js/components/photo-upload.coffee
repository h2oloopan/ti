define ['ehbs!templates/components/photo-upload', 'jquery.fileupload'], () ->
	return PhotoUploadComponent = Ember.Component.extend
		didInsertElement: ->
			@_super()
			thiz = @
			@$('input').fileupload
				dataType: 'json'
				done: (e, data) ->
					thiz.sendAction 'uploadDone', data
				fail: (e, data) ->
					thiz.sendAction 'uploadFail', data