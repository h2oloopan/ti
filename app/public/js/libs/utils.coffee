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
						minimum = @options.minimum || 30
						step = @options.step || 10
						#do the work
						counter = 0
						match = false
						checking = false
						next = minimum
						thiz = @
						$(@input).keydown (e) ->
							if counter < next then return counter++
							if e.which == 8 then match = false
							if match then return
							if checking then return
							text = $(thiz.input).cleanHtml().trim()
							if text.length < minimum then return $(display).hide()
							address = url + '?text=' + text
							checking = true
							$.get(address).done (ids) ->
								#done
								if ids.length == 0
									match = true
								else
									#there is a match
									message = 'Possible duplication(s): '
									for id in ids
										#display
										message += '<a target="_blank" href="/#/question/' + id + '/edit">' + id + '</a> '
									$(display).html message
									$(display).show()
								if ids.length == 1
									match = true
								checking = false
								next += step
								return true
							.fail (errors) ->
								#fail
								#suppress
								checking = false
								next += step
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