define ['jquery'], ($) ->
	return utils = 
		createMathEditor: (input, preview) ->

			MathEditor = (input, preview) ->
				@input = input
				@preview = preview
			
				#private
				delay = 150

			MathEditor.prototype.update = ->


			return new MathEditor input, preview
###			
			oldText: null
			init: (input, preview) ->
				@preview = preview
			swapBuffers: ->
				buffer = @preview
				preview = @buffer
				buffer.style.visibility = 'hidden'
				buffer.style.position = 'absolute'
				preview.style.position = ''
				preview.style.visibility = ''
			update: ->
				if @timeout then clearTimeout @timeout
				@timeout = setTimeout @callback, @delay
			createPreview: ->
				@timeout = null
				if @mjRunning then return
				text = document.getElementById('math-input').value
				if text == @oldtext then return
				@buffer.innerHTML = @oldtext = text
				@mjRunning = true
				MathJax.Hub.Queue ['Typeset', MathJax.Hub, @buffer], ['previewDone', @]
			previewDone: ->
				@mjRunning = false
				@swapBuffers()
###