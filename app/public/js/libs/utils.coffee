define ['jquery', 'bootstrap-wysiwyg'], ($) ->
	return utils = 
		createMathEditor: (input, preview, options) ->
			class MathEditor
				constructor: (@input, @preview, @options) ->
					@init()
				delay: 300
				timeout: null
				running: false
				checking: false
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

					#string matching test for duplication
					@options = @options || {}
					check = @options.check || false
					url = @options.url || null
					if check and url?
						#check
						#get some setting properties
						interval = @options.interval || 5000
						minimum = @options.minimum || 50
						recurrence = @options.recurrence || 3
						#do the work
						timer = null
						counter = 0
						poll = (counter) ->
							if checking then return
							if counter > recurrence then return clearInterval timer

							

							counter++

						timer = setInterval () ->
							poll()
						, interval


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

			return new MathEditor input, preview, options