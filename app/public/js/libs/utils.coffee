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