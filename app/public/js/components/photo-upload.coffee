define ['ehbs!templates/components/photo-upload', 'jquery.fileupload'], () ->
	return PhotoUploadComponent = Ember.Component.extend
		didInsertElement: ->
			@_super()
			thiz = @
			@$('a.btn').click ->
				thiz.$('input').click()
			@$('input').fileupload
				dataType: 'json'
				done: (e, data) ->
					return thiz.send 'done', data
				fail: (e, data) ->
					return thiz.send 'fail', data
		actions:
			done: (data) ->
				url = data.response().result.files[0].url
				photos = @get 'question.photos'
				if !photos? then photos = []
				photos.pushObject url
				@set 'question.photos', photos
				return false
			fail: (data) ->
				alert 'Something was wrong: ' + data.errorThrown
				return false
			preview: (url) ->
				@set 'previewLink', url
				@$('.modal-photo-preview').modal()
				return false
			delete: (url) ->
				photos = @get 'question.photos'
				photos.removeObject url
				@set 'question.photos', photos
				return false
