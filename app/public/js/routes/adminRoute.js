define(["jquery","me","utils","ehbs!templates/admin/admin","ehbs!templates/admin/users","ehbs!templates/admin/users.new","ehbs!templates/admin/users.edit","ehbs!templates/admin/schools","ehbs!templates/admin/school.edit"],function(e,t){var r;return r={setup:function(r){return r.Router.map(function(){return this.route("admin")}),r.AdminRoute=Ember.Route.extend({beforeModel:function(){var e;return e=this,t.auth.power(999).then(function(){return!0},function(){return e.transitionTo("error",{type:"401"})})},model:function(){var e;return e=this,new Ember.RSVP.Promise(function(t,r){return new Ember.RSVP.hash({users:e.store.find("user"),schools:e.store.find("school")}).then(function(e){return t({users:e.users,schools:e.schools})},function(e){return r(e)})})}}),r.AdminView=Ember.View.extend({didInsertElement:function(){var t;return this._super(),e(".nav-tabs a").each(function(){return e(this).click(function(t){var r,s,n;return n=t.currentTarget,s=e(n).attr("href").substr(1),r=window.location.href,r.indexOf("?")>=0&&(r=r.substr(0,r.indexOf("?"))),window.location.href=r+"?"+s})}),t=window.location.href,t=t.indexOf("?")>=0?"#"+t.substr(t.indexOf("?")+1):null,null!=t?e('.nav-tabs a[href="'+t+'"]').click():e(".nav-tabs a:first").click()}}),r.UsersController=Ember.ArrayController.extend({sortProperties:["power"],sortAscending:!1,itemController:"user",actions:{add:function(){return e(".modal-admin-user").modal()}}}),r.UserController=Ember.ObjectController.extend({needs:"usersEdit",isAdmin:function(){return this.get("model.power")>=999?!0:!1}.property("power"),type:function(){}.property("power"),actions:{edit:function(t){var r;return r=this,t.set("password",null),this.store.find("school").then(function(s){return r.set("controllers.usersEdit.model",{user:t,schools:s}),e(".modal-admin-user-edit").modal(),!0},function(){return!1}),!1},"delete":function(e){var t;return t=confirm("Do you want to delete user "+e.get("username")+"?"),t&&e.destroyRecord().then(function(){return!0},function(t){return e.rollback(),alert(t.responseText)}),!1}}}),r.UsersEditController=Ember.ObjectController.extend({roles:["editor","instructor"],errors:{},isAddingPrivilege:!1,cleanPrivilege:function(){return this.set("term",null),this.set("subject",null),this.set("course",null)},actions:{addPrivilege:function(){return this.set("isAddingPrivilege",!0),!1},savePrivilege:function(){var e,r;return null==this.get("school")&&t.isEmptyString(this.get("term"))&&t.isEmptyString(this.get("subject"))&&t.isEmptyString(this.get("course"))?(alert("Cannot enter an empty row of privilege"),!1):t.isEmptyString(this.get("subject"))&&!t.isEmptyString(this.get("course"))?(alert("Course must be coupled with subject"),!1):(r=this.get("user"),e=r.get("privileges"),e.pushObject({school:this.get("school"),term:this.get("term"),subject:this.get("subject"),course:this.get("course")}),r.set("privileges",e),this.cleanPrivilege(),this.set("isAddingPrivilege",!1),!1)},cancelPrivilege:function(){return this.cleanPrivilege(),this.set("isAddingPrivilege",!1),!1},deletePrivilege:function(e){var t;return t=this.get("user.privileges"),t.removeObject(e),this.set("user.privileges",t),!1},save:function(r){var s,n,i,o,u;for(i=r.validate(),n=t.keys(r.errors),o=0,u=n.length;u>o;o++)if(s=n[o],"password"!==s)return this.set("errors."+s,errors[s]),!1;return r.save().then(function(){return e(".modal-admin-user-edit").modal("hide")},function(e){return r.rollback(),alert(e.responseText)}),!1}}}),r.UsersNewController=Ember.ObjectController.extend({user:{role:{}},roles:["editor","instructor"],prepare:function(e){return e},actions:{add:function(){var t,r;return this.set("user.errors",null),r=this.store.createRecord("user",this.get("user")),(t=r.validate())?(r.save().then(function(){return e(".modal-admin-user").modal("hide")},function(e){return r.rollback(),alert(e.responseText)}),!1):(this.set("user.errors",r.errors),!1)}}}),r.SchoolsController=Ember.ArrayController.extend({school:{},itemController:"school",actions:{add:function(){return this.set("school.errors",null),this.set("isAdding",!0),!1},save:function(e){var t,r;return r=this,e=this.store.createRecord("school",e),(t=e.validate())?(e.save().then(function(){return r.set("school.name",null),r.set("isAdding",!1)},function(t){return e.rollback(),alert(t.responseText)}),!1):(this.set("school.errors",e.errors),!1)},cancel:function(){return this.set("school.name",null),this.set("isAdding",!1),!1}}}),r.SchoolController=Ember.ObjectController.extend({needs:"schools",needs:"schoolEdit",schoolEdit:Ember.computed.alias("controllers.schoolEdit"),actions:{select:function(t){var r;return r=t.get("id"),e(".nav-sidebar li").removeClass("active"),e('.nav-sidebar li[data-id="'+r+'"]').addClass("active"),this.get("schoolEdit").send("update",t)}}}),r.SchoolEditController=Ember.ObjectController.extend({selectedTermChange:function(){return this.get("isReset")?(this.set("isReset",!1),!1):null!=this.get("selectedTerm.subjects")&&this.get("selectedTerm.subjects").length>0?this.set("selectedSubject",this.get("selectedTerm.subjects")[0]):this.set("selectedSubject",null)}.observes("selectedTerm"),actions:{update:function(e){return this.set("model",e),this.set("isEditing",!0),this.get("info.terms").length>0&&(this.set("selectedTerm",this.get("info.terms")[0]),this.get("selectedTerm.subjects").length>0)?this.set("selectedSubject",this.get("selectedTerm.subjects")[0]):void 0},deleteSchool:function(){return alert("We are not allowed to delete school at the moment"),!1},addCourse:function(){return this.set("isAddingCourse",!0),!1},cancelCourse:function(){return this.set("course",null),this.set("isAddingCourse",!1),!1},saveCourse:function(e){var t,r,s,n,i;return i=this,n=this.get("selectedTerm"),s=this.get("selectedSubject"),t=function(t){return t.number.toLowerCase()===e.toLowerCase()?!0:!1},s.courses.any(t)?(alert("You cannot add course with same name/number"),!1):(s.courses.pushObject({number:e,name:""}),this.set("course",null),this.set("isAddingCourse",!1),r=this.get("model"),r.save().then(function(){var e;return e=r.get("info.terms").find(function(e){return e.name===n.name?!0:!1}),null==e?!1:(i.set("isReset",!0),i.set("selectedTerm",e),e=e.subjects.find(function(e){return e.name===s.name?!0:!1}),null==e?!1:(i.set("selectedSubject",e),!0))},function(e){return r.rollback(),alert(e.responseText)}),!1)},deleteCourse:function(e){var t,r,s,n,i;return i=this,(t=confirm("Are you sure you want to delete course "+e.number+"?"))?(n=this.get("selectedTerm"),s=this.get("selectedSubject"),s.courses.removeObject(e),r=this.get("model"),r.save().then(function(){var e;return e=r.get("info.terms").find(function(e){return e.name===n.name?!0:!1}),null==e?!1:(e=e.subjects.find(function(e){return e.name===s.name?!0:!1}),null==e?!1:(i.set("selectedSubject",e),!0))},function(e){return r.rollback(),alert(e.responseText)}),!1):!1},addSubject:function(){return this.set("isAddingSubject",!0),!1},cancelSubject:function(){return this.set("subject",null),this.set("isAddingSubject",!1),!1},saveSubject:function(e){var t,r,s,n;return n=this,s=this.get("selectedTerm"),t=function(t){return t.name.toLowerCase()===e.toLowerCase()?!0:!1},s.subjects.any(t)?(alert("You cannot add subject with same name"),!1):(s.subjects.pushObject({name:e,courses:[]}),this.set("subject",null),this.set("isAddingSubject",!1),r=this.get("model"),r.save().then(function(){var e;return e=r.get("info.terms").find(function(e){return e.name===s.name?!0:!1}),null==e?!1:(n.set("isReset",!0),n.set("selectedTerm",e),n.set("selectedSubject",e.subjects[e.subjects.length-1]),!0)},function(e){return r.rollback(),alert(e.responseText)}),!1)},deleteSubject:function(e){var t,r,s;return(t=confirm("Are you sure you want to delete subject "+e.name+"?"))?(s=this.get("selectedTerm"),s.subjects.removeObject(e),r=this.get("model"),r.save().then(function(){var e;return e=r.get("info.terms").find(function(e){return e.name===s.name?!0:!1}),null==e?!1:(thiz.set("selectedTerm",e),!0)},function(e){return r.rollback(),alert(e.responseText)}),!1):!1},addTerm:function(){return this.set("isAddingTerm",!0),!1},cancelTerm:function(){return this.set("term",null),this.set("isAddingTerm",!1),!1},saveTerm:function(e){var t,r,s,n;return n=this,t=this.get("info"),r=function(t){return t.name.toLowerCase()===e.toLowerCase()?!0:!1},t.terms.any(r)?(alert("You cannot add term with same name"),!1):(t.terms.pushObject({name:e,subjects:[]}),this.set("term",null),this.set("isAddingTerm",!1),s=this.get("model"),s.save().then(function(){return n.set("selectedTerm",n.get("info.terms")[n.get("info.terms").length-1]),!0},function(e){return s.rollback(),alert(e.responseText)}),!1)},deleteTerm:function(e){var t,r,s,n;return n=this,(t=confirm("Are you sure you want to delete term "+e.name+"?"))?(r=this.get("info"),r.terms.removeObject(e),this.set("selectedTerm",null),s=this.get("model"),s.save().then(function(){return!0},function(e){return s.rollback(),alert(e.responseText)}),!1):!1}}})}}});