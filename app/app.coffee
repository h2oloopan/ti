if Meteor.isClient
	Template.hello.greeting = ->
		return 'Welcome to app.'

	Template.hello.events
		'click input': ->
			if typeof console != 'undefined'
				console.log 'You pressed the button'

if Meteor.isServer
	Meteor.startup ->
		#do nothing