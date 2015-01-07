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
				@set 'insertLink', url.substr(url.lastIndexOf('/') + 1)
				@$('.modal-photo-preview').modal()
				return false
			delete: (url) ->
				photos = @get 'question.photos'
				photos.removeObject url
				@set 'question.photos', photos
				if @get('edit') then return false
				#call to remove the photo from server's temp folder, it doesn't matter if it succeed or not
				$.ajax
					url: '/api/images/location?url=' + url
					type: 'DELETE'
				.done (result) ->
					return false
				.fail (reponse) ->
					return false
				return false
