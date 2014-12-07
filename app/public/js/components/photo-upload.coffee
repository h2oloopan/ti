define ['ehbs!templates/components/photo-upload', 'jquery.fileupload'], () ->
	return PhotoUploadComponent = Ember.Component.extend
		didInsertElement: ->
			@_super()
			thiz = @
			@$('button').click ->
				thiz.$('input').click()
			@$('input').fileupload
				dataType: 'json'
				done: (e, data) ->
					return thiz.send 'done', data
				fail: (e, data) ->
					return thiz.sendAction 'fail', data
		actions:
			done: (data) ->
				url = data.response().result.files[0].url
				photos = @get 'photos'
				if !photos? then photos = []
				photos.push url
				@set 'photos', photos
				return false
			fail: (data) ->
				alert 'fail'
				return false