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
							question_real: thiz.store.find 'question', qid
							question_fake: thiz.store.createRecord 'question', {}
							schools: thiz.store.find 'school'
						.then (result) ->
							resolve
								question_real: result.question_real
								question_fake: result.question_fake
								schools: result.schools
						, (errors) ->
							reject errors
				afterModel: (model, transition) ->
					real = model.question_real
					fake = model.question_fake
					fake.set 'school', real.get 'school'
					school = fake.get('school').toJSON()
					
					real.eachAttribute (name, meta) ->
						fake.set name, real.get name

					fake.set 'id', real.get 'id'

					fake.set 'initialize', 
						subject: true
						term: true
						course: true

					#term
					term = school.info.terms[0]
					for t in school.info.terms
						if t.name == real.get 'term'
							term = t
							break
					fake.set 'term', term

					#subject
					subject = term.subjects[0]
					for s in term.subjects
						if s.name == real.get 'subject'
							subject = s
							break
					fake.set 'subject', subject

					#course
					course = subject.courses[0]
					for c in subject.courses
						if c.number == real.get 'course'
							course = c
							break
					fake.set 'course', course

			App.QuestionEditView = Ember.View.extend
				didInsertElement: ->
					@_super()

					questionEditor = utils.createMathEditor($('#question-input'), $('#question-preview'))
					hintEditor = utils.createMathEditor($('#hint-input'), $('#hint-preview'))
					solutionEditor = utils.createMathEditor($('#solution-input'), $('#solution-preview'))
					summaryEditor = utils.createMathEditor($('#summary-input'), $('#summary-preview'))

					questionEditor.update()
					hintEditor.update()
					solutionEditor.update()
					summaryEditor.update()
					
			App.QuestionEditController = Ember.ObjectController.extend
				types: ['other', 'assignment', 'midterm', 'final', 'textbook']
				difficulties: [1, 2, 3, 4, 5]
				terms: ( ->
					school = @get 'question_fake.school'
					if !school? then return []
					if @get 'question_fake.initialize.term'
						@set 'question_fake.initialize.term', false
					else
						@set 'question_fake.term', school.toJSON().info.terms[0]
					return school.toJSON().info.terms
				).property 'question_fake.school'
				subjects: ( ->
					term = @get 'question_fake.term'
					if !term? then return []
					if @get 'question_fake.initialize.subject'
						@set 'question_fake.initialize.subject', false
					else
						@set 'question_fake.subject', term.subjects[0]
					return term.subjects
				).property 'question_fake.term'
				courses: ( ->
					subject = @get 'question_fake.subject'
					if !subject? then return []
					if @get 'question_fake.initialize.course'
						@set 'question_fake.initialize.course', false
					else
						@set 'question_fake.course', subject.courses[0]
					return subject.courses
				).property 'question_fake.subject'
				prepare: (question) ->
					another = question.toJSON()
					another.subject = question.get('subject.name')
					another.term = question.get('term.name')
					another.course = question.get('course.number')
					another.question = $('#question-input').html()
					another.hint = $('#hint-input').html()
					another.solution = $('#solution-input').html()
					another.summary = $('#summary-input').html()
					if !question.get('difficulty')? then another.difficulty = 0
					another = @store.createRecord 'Question', another
					another.set 'school', question.get('school')
				actions:
					save: ->
						thiz = @
						question_fake = @prepare(@get 'question_fake')
						result = question_fake.validate()
						@set 'question_fake.errors', question_fake.errors
						if !result then return false

						question = @get 'question_real'
						#copy fake to real
						question.eachAttribute (name, meta) ->
							question.set name, question_fake.get name

						question.save().then ->
							#done
							thiz.transitionToRoute 'questions'
						, (errors) ->
							#fail
							question.rollback
							console.log errors
							alert errors
						return false

#questions
			App.QuestionsIndexRoute = Ember.Route.extend
				model: ->
					return @store.find 'question'

			App.QuestionsIndexController = Ember.ArrayController.extend
				sortProperties: ['id']
				sortAscending: false
				preview: {}
				itemController: 'questionItem'

			App.QuestionItemController = Ember.ObjectController.extend
				isHidden: ( ->
					if @get('flag') > 0 then return false
					return true
				).property 'flag'
				needs: 'questionsIndex'
				actions:
					delete: (question) ->
						#this is not a real delete
						name = question.get('school.name') + ' ' + question.get('term') + ' ' + question.get('subject') + ' ' + question.get('course')
						ans = confirm 'Do you want to delete question ' + question.get('id') + ' of ' + name + '?'
						if ans
							question.set 'flag', 0
							question.save().then ->
								#done
								return true
							, (errors) ->
								question.rollback()
								alert errors.responseText
						return false
					view: (question) ->
						@set 'controllers.questionsIndex.preview', question
						question = question.toJSON()
						questionView = $('#question-view').html question.question
						hintView = $('#hint-view').html question.hint
						solutionView = $('#solution-view').html question.solution
						summaryView = $('#summary-view').html question.summary
						MathJax.Hub.Queue ['Typeset', MathJax.Hub, $('#modal-math')[0]]
						$('.modal').modal()
						return false

#questions new
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
				initialize: true
				needs: 'application'
				types: ['other', 'assignment', 'midterm', 'final', 'textbook']
				difficulties: [1, 2, 3, 4, 5]
				terms: ( ->
					school = @get 'question.school'
					if !school? then return []
					if @get('initialize')
						
						@set 'initialize', false
					else
						@set 'question.term', school.toJSON().info.terms[0]
					return school.toJSON().info.terms
				).property 'question.school'
				subjects: ( ->
					term = @get 'question.term'
					if !term? then return []
					@set 'question.subject', term.subjects[0]
					return term.subjects
				).property 'question.term'
				courses: ( ->
					subject = @get 'question.subject'
					if !subject? then return []
					@set 'question.course', subject.courses[0]
					return subject.courses
				).property 'question.subject'
				prepare: (question) ->
					another = question.toJSON()
					another.term = question.get('term.name')
					another.subject = question.get('subject.name')
					another.course = question.get('course.number')
					another.question = $('#question-input').html()
					another.hint = $('#hint-input').html()
					another.solution = $('#solution-input').html()
					another.summary = $('#summary-input').html()
					if !question.get('difficulty')? then another.difficulty = 0
					another = @store.createRecord 'Question', another
					another.set 'school', question.get('school')
					return another
				saveSettings: ->
					settings = 
						uid: @get 'controllers.application.model._id'
						school: @get 'question.school.name'
						term: @get 'question.term.name'
						subject: @get 'question.subject.name'
						course: @get 'question.course.number'
						type: @get 'question.type'
					$.cookie 'settings', JSON.stringify(settings), { expires: 7 }
				actions:
					add: ->
						thiz = @
						question = @prepare(@get 'question')
						result = question.validate()
						@set 'question.errors', question.errors
						if !result then return false
						question.save().then ->
							#done
							#record setting
							thiz.saveSettings()
							thiz.transitionToRoute 'questions'
						, (errors) ->
							#fail
							question.rollback()
							console.log errors
							alert errors
						return false
						

    		


	return QuestionsRoute