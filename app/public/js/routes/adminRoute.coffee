define ['jquery', 'me', 'utils',
'ehbs!templates/admin/admin.index'
], ($, me, utils) ->
	AdminRoute = 
		setup: (App) ->
			App.Router.map ->
				@resource 'admin', ->
					@route 'users'


			App.AdminUsersRoute = Ember.Route.extend
				model: ->
					return @store.find 'user'



	return AdminRoute