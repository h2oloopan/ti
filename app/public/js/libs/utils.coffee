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
					display = @options.display || null
					if check and url? and display?
						#check
						#get some setting properties
						interval = @options.interval || 5000
						minimum = @options.minimum || 50
						recurrence = @options.recurrence || 3
						#do the work
						counter = 0
						match = true
						checking = false
						thiz = @
						$(@input).keydown (e) ->
							if counter < minimum then return counter++
							if !match then return
							if checking then return
							text = $(thiz.input).cleanHtml()
							address = url + '?text=' + text
							$.get(address).done (data) ->
								#done
								
								return true
							.fail (errors) ->
								#fail
								#suppress
								return false



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