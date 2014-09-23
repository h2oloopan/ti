define ['jquery', 'me', 'utils', 'js/MathJax/MathJax.js?config=TeX-AMS-MML_HTMLorMML',
'ehbs!templates/questions/question.edit',
'ehbs!templates/questions/questions.index',
'ehbs!templates/questions/questions.new'], 
($, me, utils) ->
	QuestionsRoute = 
		setup: (App) ->
			#route
			App.Router.map ->
				@resource 'questions', ->
					@route 'new'
				@resource 'question', {path: '/question/:question_id'}, ->
					@route 'edit'

			App.QuestionsRoute = Ember.Route.extend
				beforeModel: ->
					thiz = @
					me.auth.check().then (user) ->
						#done
						if !user?
							thiz.transitionTo 'login'
					, (errors) ->
						@fail
						thiz.transitionTo 'login'

			App.QuestionRoute = Ember.Route.extend
				beforeModel: ->
					thiz = @
					me.auth.check().then (user) ->
						#done
						if !user?
							thiz.transitionTo 'login'
					, (errors) ->
						@fail
						thiz.transitionTo 'login'
	
#question 
#edit
			App.QuestionEditRoute = Ember.Route.extend
				model: ->
					thiz = @
					qid = @modelFor('question').id
					return new Ember.RSVP.Promise (resolve, reject) ->
						new Ember.RSVP.hash
							question: thiz.store.find 'question', qid
							schools: thiz.store.find 'school'
						.then (result) ->
							resolve
								question: result.question
								schools: result.schools
						, (errors) ->
							reject errors

			App.QuestionEditView = Ember.View.extend
				didInsertElement: ->
					@_super()


			App.QuestionEditController = Ember.ObjectController.extend
				difficulties: [1, 2, 3, 4, 5]
				subjects: ( ->
					school = @get 'question.school'
					if !school? then return []
					@set 'question.subject', school.toJSON().info.subjects[0]
					return school.toJSON().info.subjects
				).property 'question.school'
				terms: ( ->
					subject = @get 'question.subject'
					if !subject? then return []
					@set 'question.term', subject.terms[0]
					return subject.terms
				).property 'question.subject'
				courses: ( ->
					term = @get 'question.term'
					if !term? then return []
					@set 'question.course', term.courses[0]
					return term.courses
				).property 'question.term'
				actions:
					save: ->
						thiz = @
						question = @get 'question'
						result = question.validate()
						if !result then return false
						question.save().then ->
							#done
							thiz.transitionToRoute 'questions'
						, (errors) ->
							#fail
							console.log errors
							alert errors
						return false

#questions
			App.QuestionsIndexRoute = Ember.Route.extend
				model: ->
					return @store.find 'question'

			App.QuestionsIndexController = Ember.ArrayController.extend
				preview: {}
				itemController: 'questionItem'

			App.QuestionItemController = Ember.ObjectController.extend
				needs: 'questionsIndex'
				actions:
					delete: (question) ->
						ans = confirm 'Do you want to delete question ' + question.id + '?'
						if ans
							question.destroyRecord().then ->
								#done
								return true
							, (errors) ->
								#fail
								question.rollback()
								alert errors.responseText
						return false
					view: (question) ->
						@set 'controllers.questionsIndex.preview', question
						math = document.getElementById 'modal-math'
						math.innerHTML = question.get 'question'
						
						MathJax.Hub.Queue ['Typeset', MathJax.Hub, math]

						$('.modal').modal()
						return false

			#m
			App.QuestionsNewRoute = Ember.Route.extend
				model: ->
					thiz = @
					return new Ember.RSVP.Promise (resolve, reject) ->
						new Ember.RSVP.hash
							question: thiz.store.createRecord 'question', {}
							schools: thiz.store.find 'school'
						.then (result) ->
							resolve
								question: result.question
								schools: result.schools
						, (errors) ->
							reject errors
			
			#v
			App.QuestionsNewView = Ember.View.extend
				didInsertElement: ->
					@_super()
					
					questionEditor = utils.createMathEditor($('#question-input'), $('#question-preview'))
					hintEditor = utils.createMathEditor($('#hint-input'), $('#hint-preview'))
					solutionEditor = utils.createMathEditor($('#solution-input'), $('#solution-preview'))
					summaryEditor = utils.createMathEditor($('#summary-input'), $('#summary-preview'))

			#c
			App.QuestionsNewController = Ember.ObjectController.extend
				difficulties: [1, 2, 3, 4, 5]
				subjects: ( ->
					school = @get 'question.school'
					if !school? then return []
					@set 'question.subject', school.toJSON().info.subjects[0]
					return school.toJSON().info.subjects
				).property 'question.school'
				terms: ( ->
					subject = @get 'question.subject'
					if !subject? then return []
					@set 'question.term', subject.terms[0]
					return subject.terms
				).property 'question.subject'
				courses: ( ->
					term = @get 'question.term'
					if !term? then return []
					@set 'question.course', term.courses[0]
					return term.courses
				).property 'question.term'
				prepare: (question) ->
					another = question.toJSON()
					another.subject = question.get('subject.code')
					another.term = question.get('term.name')
					another.course = question.get('course.number')
					another.question = $('#question-input').html()
					another.hint = $('#hint-input').html()
					another.solution = $('#solution-input').html()
					another.summary = $('#summary-input').html()
					another = @store.createRecord 'Question', another
					another.set 'school', question.get('school')
					return another
				actions:
					add: ->
						thiz = @
						question = @prepare(@get 'question')
						console.log question
						result = question.validate()
						@set 'question.errors', question.errors
						if !result then return false
						question.save().then ->
							#done
							thiz.transitionToRoute 'questions'
						, (errors) ->
							#fail
							console.log errors
							alert errors
						return false
						

    		


	return QuestionsRoute