define ['jquery', 'bootstrap-wysiwyg'], ($) ->
	return utils = 
		createMathEditor: (input, preview) ->

			class MathEditor
				constructor: (@input, @preview) ->
					@init()
				delay: 300
				timeout: null
				running: false
				init: ->
					thiz = @
					$(@input).wysiwyg()
					$(@input).on 'keypress', ->
						thiz.update()
					$(@input).on 'paste', (e) ->
						e.preventDefault()
						if e.originalEvent.clipboardData
							content = (e.originalEvent || e).clipboardData.getData 'text/plain'
							document.execCommand 'insertText', false, content
						else if window.clipboardData
							content = window.clipboardData.getData 'Text'
							document.selection.createRange().pasteHTML content

				update: ->
					thiz = @
					if @timeout then clearTimeout @timeout
					@timeout = setTimeout ->
						if thiz.running then return
						content = $(thiz.input).html()
						$(thiz.preview).html content
						thiz.running = true
						MathJax.Hub.Queue ['Typeset', MathJax.Hub, $(thiz.preview)[0]], ['done', thiz]
					, @delay
				done: ->
					@running = false

			return new MathEditor input, preview