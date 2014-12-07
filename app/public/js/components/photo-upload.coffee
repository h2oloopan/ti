define ['ehbs!templates/components/photo-upload', 'jquery.fileupload'], () ->
	return PhotoUploadComponent = Ember.Component.extend
		didInsertElement: ->
			@_super()