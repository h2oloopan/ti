define(["jquery","me","utils","components/photo-upload","moment","js/MathJax/MathJax.js?config=TeX-AMS-MML_HTMLorMML","bootstrap-tagsinput","ehbs!templates/questions/question.index","ehbs!templates/questions/question.edit","ehbs!templates/questions/questions.index","ehbs!templates/questions/questions.select","ehbs!templates/questions/questions.new"],function(e,t,s,n){var i;return i={setup:function(i){return Ember.Handlebars.registerBoundHelper("display-time",function(e,t){return moment(t).format(e)}),i.Router.map(function(){return this.resource("questions",function(){return this.route("new"),this.route("select")}),this.resource("question",{path:"/question/:question_id"},function(){return this.route("edit")})}),i.PhotoUploadComponent=n,i.QuestionsRoute=Ember.Route.extend({beforeModel:function(){var e;return e=this,t.auth.check().then(function(t){return null==t?e.transitionTo("login"):void 0},function(){return this.fail,e.transitionTo("login")})}}),i.QuestionRoute=Ember.Route.extend({beforeModel:function(){var e;return e=this,t.auth.check().then(function(t){return null==t?e.transitionTo("login"):void 0},function(){return this.fail,e.transitionTo("login")})}}),i.QuestionEditRoute=Ember.Route.extend({model:function(){var e,t;return t=this,e=this.modelFor("question").id,new Ember.RSVP.Promise(function(s,n){return new Ember.RSVP.hash({question_real:t.store.find("question",e),question_fake:t.store.createRecord("question",{}),schools:t.store.find("school")}).then(function(e){return s({question_real:e.question_real,question_fake:e.question_fake,schools:e.schools})},function(e){return n(e)})})},afterModel:function(e){var t,s,n,i,o,r,u,l,c,a,h,d,p;for(i=e.question_real,n=e.question_fake,n.set("school",i.get("school")),r=n.get("school").toJSON(),i.eachAttribute(function(e){return n.set(e,i.get(e))}),n.set("id",i.get("id")),n.set("initialize",{subject:!0,course:!0}),u=r.info.subjects[0],d=r.info.subjects,l=0,a=d.length;a>l;l++)if(o=d[l],o.name===i.get("subject")){u=o;break}for(n.set("subject",u),s=u.courses[0],p=u.courses,c=0,h=p.length;h>c;c++)if(t=p[c],t.number===i.get("course")){s=t;break}return n.set("course",s)}}),i.QuestionEditView=Ember.View.extend({didInsertElement:function(){var t,n,i,o;return this._super(),e("#type-tags").tagsinput(),e("#tags").tagsinput(),n=s.createMathEditor(e("#question-input"),e("#question-preview")),t=s.createMathEditor(e("#hint-input"),e("#hint-preview")),i=s.createMathEditor(e("#solution-input"),e("#solution-preview")),o=s.createMathEditor(e("#summary-input"),e("#summary-preview")),n.update(),t.update(),i.update(),o.update()}}),i.QuestionEditController=Ember.ObjectController.extend({uploadLink:"/api/images/temp",difficulties:[1,2,3,4,5],terms:function(){var e;return e=this.get("question_fake.school"),null==e?[]:(e.toJSON().terms.length>0&&this.set("selectedTerm",e.toJSON().terms[0]),e.toJSON().terms)}.property("question_fake.school"),types:function(){var e;return e=this.get("question_fake.school"),null==e?[]:(e.toJSON().types.length>0&&this.set("selectedType",e.toJSON().types[0]),e.toJSON().types)}.property("question_fake.school"),subjects:function(){var e;return e=this.get("question_fake.school"),null==e?[]:(this.get("question_fake.initialize.subject")?this.set("question_fake.initialize.subject",!1):this.set("question_fake.subject",e.info.subjects[0]),e.toJSON().info.subjects)}.property("question_fake.school"),courses:function(){var e;return e=this.get("question_fake.subject"),null==e?[]:(this.get("question_fake.initialize.course")?this.set("question_fake.initialize.course",!1):this.set("question_fake.course",e.courses[0]),e.courses)}.property("question_fake.subject"),prepare:function(t){var s;return s=t.toJSON(),s.subject=t.get("subject.name"),s.course=t.get("course.number"),s.question=e("#question-input").cleanHtml(),s.hint=e("#hint-input").cleanHtml(),s.solution=e("#solution-input").cleanHtml(),s.summary=e("#summary-input").cleanHtml(),s.typeTags=e("#type-tags").val().replace(/, /g,",").replace(/,/g,", "),s.tags=e("#tags").val().replace(/, /g,",").replace(/,/g,", "),null==t.get("difficulty")&&(s.difficulty=0),s=this.store.createRecord("Question",s),s.set("school",t.get("school"))},actions:{addTypeTag:function(){var t,s,n;return s=this.get("selectedTerm"),n=this.get("selectedType"),t=s+" "+n,e("#type-tags").tagsinput("add",t),!1},save:function(){var e,s,n,i,o,r,u,l;for(r=this,i=this.prepare(this.get("question_fake")),o=i.validate(),this.set("question_fake.errors",i.errors),s=t.keys(i.errors),u=0,l=s.length;l>u;u++)e=s[u],alert(i.errors[e]);return o?(n=this.get("question_real"),n.eachAttribute(function(e){return n.set(e,i.get(e))}),n.save().then(function(){return r.transitionToRoute("questions")},function(e){return n.rollback,console.log(e),alert(e.responseText)}),!1):!1}}}),i.QuestionIndexRoute=Ember.Route.extend({model:function(){var e;return e=this.modelFor("question").id,this.store.find("question",e)}}),i.QuestionIndexView=Ember.View.extend({didInsertElement:function(){var t;return this._super(),t=this.controller.get("model").toJSON(),e("#question-preview").html(t.question),e("#hint-preview").html(t.hint),e("#solution-preview").html(t.solution),e("#summary-preview").html(t.summary),MathJax.Hub.Queue(["Typeset",MathJax.Hub,e(".question-form .right")[0]])}}),i.QuestionIndexController=Ember.ObjectController.extend({actions:{back:function(){return window.history.go(-1),!1}}}),i.QuestionsIndexRoute=Ember.Route.extend({model:function(){return this.store.find("question")}}),i.QuestionsIndexController=Ember.ArrayController.extend({sortProperties:["id"],sortAscending:!1,preview:{},itemController:"questionItem"}),i.QuestionItemController=Ember.ObjectController.extend({isHidden:function(){return this.get("flag")>0?!1:!0}.property("flag"),needs:"questionsIndex",actions:{"delete":function(e){var t,s;return s=e.get("school.name")+" "+e.get("term")+" "+e.get("subject")+" "+e.get("course"),t=confirm("Do you want to delete question "+e.get("id")+" of "+s+"?"),t&&(e.set("flag",0),e.save().then(function(){return!0},function(t){return e.rollback(),alert(t.responseText)})),!1}}}),i.QuestionsSelectRoute=Ember.Route.extend({model:function(){var e;return e=this,new Ember.RSVP.Promise(function(t,s){return new Ember.RSVP.hash({schools:e.store.find("school"),questions:e.store.find("question",{advanced:JSON.stringify(e.controllerFor("questionsSelect").get("advanced"))})}).then(function(e){return t({schools:e.schools,questions:e.questions})},function(e){return s(e)})})}}),i.QuestionsSelectController=Ember.ObjectController.extend({sortProperties:["id"],sortAscending:!1,advanced:{skip:0,limit:10},paging:{pages:{one:1,two:2,three:3,four:4,five:5}},subjects:function(){var e,t;return e=this.get("school"),null==e?[]:(t=e.get("info.subjects"),t.length>0&&this.set("subject",t[0]),t)}.property("school"),courses:function(){var e,t;return t=this.get("subject"),null==t?[]:(e=t.courses,e.length>0&&this.set("course",e[0]),e)}.property("subject"),actions:{update:function(e){return this.set("questions",this.store.find("question",{advanced:JSON.stringify(e)}))},previous:function(){var e;return e=this.get("advanced"),0===e.skip?!1:(e.skip<e.limit?e.skip=0:e.skip-=e.limit,this.set("advanced",e),this.send("update",e),!1)},next:function(){var e;return e=this.get("advanced"),e.skip+=e.limit,this.set("advanced",e),this.send("update",e),!1},jump:function(){return!1}}}),i.QuestionSelectItemView=Ember.View.extend({isHidden:function(){return this.get("flag")>0?!1:!0}.property("flag"),didInsertElement:function(){var e;return this._super(),e=this.get("element"),MathJax.Hub.Queue(["Typeset",MathJax.Hub,e])}}),i.QuestionsNewRoute=Ember.Route.extend({model:function(){var e;return e=this,new Ember.RSVP.Promise(function(t,s){return new Ember.RSVP.hash({question:e.store.createRecord("question",{}),schools:e.store.find("school")}).then(function(e){return t({question:e.question,schools:e.schools})},function(e){return s(e)})})},afterModel:function(){return this.controllerFor("questionsNew").set("initialize",{school:!0})}}),i.QuestionsNewView=Ember.View.extend({didInsertElement:function(){var t,n,i,o;return this._super(),e("#type-tags").tagsinput(),e("#tags").tagsinput(),n=s.createMathEditor(e("#question-input"),e("#question-preview"),{check:!0,url:"/api/search/questions/text",display:e("#question-display")}),t=s.createMathEditor(e("#hint-input"),e("#hint-preview")),i=s.createMathEditor(e("#solution-input"),e("#solution-preview")),o=s.createMathEditor(e("#summary-input"),e("#summary-preview"))}}),i.QuestionsNewController=Ember.ObjectController.extend({initialize:null,needs:"application",difficulties:[1,2,3,4,5],uploadLink:"/api/images/temp",settings:function(){var t,s;return t=e.cookie("settings"),null==t?null:(s=JSON.parse(t),s[this.get("controllers.application.model._id")])}.property("initialize"),terms:function(){var e;return e=this.get("question.school"),null==e?[]:(e.toJSON().terms.length>0&&this.set("selectedTerm",e.toJSON().terms[0]),e.toJSON().terms)}.property("question.school"),types:function(){var e;return e=this.get("question.school"),null==e?[]:(e.toJSON().types.length>0&&this.set("selectedType",e.toJSON().types[0]),e.toJSON().types)}.property("question.school"),subjects:function(){var e,t,s;return t=this.get("question.school"),null==t?(this.set("question.subject",null),[]):(t.toJSON().info.subjects.length>0?this.get("initialize.subject")&&this.get("settings")?(s=this.get("settings"),e=t.toJSON().info.subjects.find(function(e){return e.name===s.subject?!0:!1}),null!=e&&(this.set("question.subject",e),this.set("initialize.course",!0)),this.set("initialize.subject",!1)):this.set("question.subject",t.toJSON().info.subjects[0]):this.set("question.subject",null),t.toJSON().info.subjects)}.property("question.school"),courses:function(){var e,t,s;return s=this.get("question.subject"),null==s?(this.set("question.course",null),[]):(null!=s.courses&&s.courses.length>0?this.get("initialize.course")&&this.get("settings")?(t=this.get("settings"),e=s.courses.find(function(e){return e.number===t.course?!0:!1}),null!=e&&this.set("question.course",e),this.set("initialize.course",!1)):this.set("question.course",s.courses[0]):this.set("question.course",null),s.courses)}.property("question.subject"),schoolsChanged:function(){var e,t;return this.get("initialize.school")&&this.get("settings")?(t=this.get("settings"),e=this.get("schools").find(function(e){return e.get("name")===t.school?!0:!1}),null!=e&&(this.set("question.school",e),this.set("initialize.subject",!0)),this.set("initialize.school",!1)):void 0}.observes("schools"),prepare:function(t){var s;return s=t.toJSON(),s.subject=t.get("subject.name"),s.course=t.get("course.number"),s.question=e("#question-input").cleanHtml(),s.hint=e("#hint-input").cleanHtml(),s.solution=e("#solution-input").cleanHtml(),s.summary=e("#summary-input").cleanHtml(),s.typeTags=e("#type-tags").val().replace(",",", "),s.tags=e("#tags").val().replace(",",", "),null==t.get("difficulty")&&(s.difficulty=0),s=this.store.createRecord("Question",s),s.set("school",t.get("school")),s},saveSettings:function(){var t,s,n;return n=this.get("controllers.application.model._id"),t={school:this.get("question.school.name"),subject:this.get("question.subject.name"),course:this.get("question.course.number")},s=e.cookie("settings"),s=null==s?{}:JSON.parse(s),s[n]=t,e.cookie("settings",JSON.stringify(s),{expires:7})},actions:{addTypeTag:function(){var t,s,n;return s=this.get("selectedTerm"),n=this.get("selectedType"),t=s+" "+n,e("#type-tags").tagsinput("add",t),!1},add:function(){var e,s,n,i,o,r,u;for(o=this,n=this.prepare(this.get("question")),i=n.validate(),this.set("question.errors",n.errors),s=t.keys(n.errors),r=0,u=s.length;u>r;r++)e=s[r],alert(n.errors[e]);return i?(n.save().then(function(){return o.saveSettings(),o.transitionToRoute("questions")},function(e){return n.rollback(),console.log(e),alert(e.responseText)}),!1):!1}}})}}});