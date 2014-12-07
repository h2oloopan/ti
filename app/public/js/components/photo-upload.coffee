define ['ehbs!templates/components/photo-upload', 'jquery.fileupload'], () ->
	return PhotoUploadComponent = Ember.Component.extend
		width: 128
		height: 96
		didInsertElement: ->
			@_super()
			thiz = @
			@$('input').fileupload
				dataType: 'json'
				done: (e, data) ->
					#display photos
					thiz.sendAction 'uploadDone', data
				fail: (e, data) ->
					thiz.sendAction 'uploadFail', data