define ['jquery'], ($) ->
	return utils = 
		createMathEditor: (input, preview) ->

			class MathEditor
				constructor: (@input, @preview) ->
				delay: 300
				timeout: null
				running: false
				update: ->
					thiz = @
					if @timeout then clearTimeout @timeout
					@timeout = setTimeout ->
						if thiz.running then return
						text = $(thiz.input).val()
						$(thiz.preview).html text
						thiz.running = true
						MathJax.Hub.Queue ['Typeset', MathJax.Hub, $(thiz.dummy)[0]], ['done', thiz]
					, @delay
				done: ->
					@running = false

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