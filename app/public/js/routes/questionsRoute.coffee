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

					#subject
					subject = school.info.subjects[0]
					for s in school.info.subjects
						if s.code == real.get 'subject'
							subject = s
							break
					fake.set 'subject', subject

					#term
					term = subject.terms[0]
					for t in subject.terms
						if t.name == real.get 'term'
							term = t
							break
					fake.set 'term', term

					#course
					course = term.courses[0]
					for c in term.courses
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
				subjects: ( ->
					school = @get 'question_fake.school'
					if !school? then return []
					if @get 'question_fake.initialize.subject'
						@set 'question_fake.initialize.subject', false
					else
						@set 'question_fake.subject', school.toJSON().info.subjects[0]
					return school.toJSON().info.subjects
				).property 'question_fake.school'
				terms: ( ->
					subject = @get 'question_fake.subject'
					if !subject? then return []
					if @get 'question_fake.initialize.term'
						@set 'question_fake.initialize.term', false
					else
						@set 'question_fake.term', subject.terms[0]
					return subject.terms
				).property 'question_fake.subject'
				courses: ( ->
					term = @get 'question_fake.term'
					if !term? then return []
					if @get 'question_fake.initialize.course'
						@set 'question_fake.initialize.course', false
					else
						@set 'question_fake.course', term.courses[0]
					return term.courses
				).property 'question_fake.term'
				prepare: (question) ->
					another = question.toJSON()
					another.subject = question.get('subject.code')
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
				types: ['other', 'assignment', 'midterm', 'final', 'textbook']
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
					if !question.get('difficulty')? then another.difficulty = 0
					another = @store.createRecord 'Question', another
					another.set 'school', question.get('school')
					return another
				actions:
					add: ->
						thiz = @
						question = @prepare(@get 'question')
						result = question.validate()
						@set 'question.errors', question.errors
						if !result then return false
						question.save().then ->
							#done
							thiz.transitionToRoute 'questions'
						, (errors) ->
							#fail
							question.rollback()
							console.log errors
							alert errors
						return false
						

    		


	return QuestionsRoute