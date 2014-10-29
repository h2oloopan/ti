Ember.TEMPLATES["questions/index"]=Ember.Handlebars.template(function(s,e,t,n,a){function h(s,e){e.buffer.push("Add New")}function u(s,e){var n,a,h,u="";return e.buffer.push("\n			"),a={},h={},n=t.unless.call(s,"question.isNew",{hash:{},inverse:T.noop,fn:T.program(4,i,e),contexts:[s],types:["ID"],hashContexts:h,hashTypes:a,data:e}),(n||0===n)&&e.buffer.push(n),e.buffer.push("\n			"),u}function i(s,e){var n,a,h,u="";return e.buffer.push("\n			"),a={},h={},n=t.unless.call(s,"question.isHidden",{hash:{},inverse:T.noop,fn:T.program(5,o,e),contexts:[s],types:["ID"],hashContexts:h,hashTypes:a,data:e}),(n||0===n)&&e.buffer.push(n),e.buffer.push("\n			"),u}function o(s,e){var n,a,h,u,i,o="";return e.buffer.push("\n			<tr>\n				<td>\n					"),h={},u={},e.buffer.push(m(t._triageMustache.call(s,"question.school.name",{hash:{},contexts:[s],types:["ID"],hashContexts:u,hashTypes:h,data:e}))),e.buffer.push("\n				</td>\n				<td>\n					"),h={},u={},e.buffer.push(m(t._triageMustache.call(s,"question.term",{hash:{},contexts:[s],types:["ID"],hashContexts:u,hashTypes:h,data:e}))),e.buffer.push("\n				</td>\n				<td>\n					"),h={},u={},e.buffer.push(m(t._triageMustache.call(s,"question.subject",{hash:{},contexts:[s],types:["ID"],hashContexts:u,hashTypes:h,data:e}))),e.buffer.push("\n				</td>\n				<td>\n					"),h={},u={},e.buffer.push(m(t._triageMustache.call(s,"question.course",{hash:{},contexts:[s],types:["ID"],hashContexts:u,hashTypes:h,data:e}))),e.buffer.push("\n				</td>\n				<td>\n					"),h={},u={},e.buffer.push(m(t._triageMustache.call(s,"question.note",{hash:{},contexts:[s],types:["ID"],hashContexts:u,hashTypes:h,data:e}))),e.buffer.push("\n				</td>\n				<td>\n					"),h={},u={},n=t["if"].call(s,"question.flag",{hash:{},inverse:T.program(8,r,e),fn:T.program(6,p,e),contexts:[s],types:["ID"],hashContexts:u,hashTypes:h,data:e}),(n||0===n)&&e.buffer.push(n),e.buffer.push('\n				</td>\n				<td>\n					\n					<a title="View Question" href="" '),h={},u={},e.buffer.push(m(t.action.call(s,"view","question",{hash:{},contexts:[s,s],types:["STRING","ID"],hashContexts:u,hashTypes:h,data:e}))),e.buffer.push('><span class="glyphicon glyphicon-search"></span></a>\n					'),u={title:s},h={title:"STRING"},i={hash:{title:"Edit Question"},inverse:T.noop,fn:T.program(10,l,e),contexts:[s,s],types:["STRING","ID"],hashContexts:u,hashTypes:h,data:e},n=t["link-to"]||s&&s["link-to"],a=n?n.call(s,"question.edit","question",i):I.call(s,"link-to","question.edit","question",i),(a||0===a)&&e.buffer.push(a),e.buffer.push('\n					<!-- This is not a real delete, it only changes the flag of question, the question will still persist in the database -->\n					<a title="Delete Question" href="" '),h={},u={},e.buffer.push(m(t.action.call(s,"delete","question",{hash:{},contexts:[s,s],types:["STRING","ID"],hashContexts:u,hashTypes:h,data:e}))),e.buffer.push('>\n						<span class="glyphicon glyphicon-remove"></span>\n					</a>\n					\n				</td>\n			</tr>\n			'),o}function p(s,e){e.buffer.push('\n					<a title="OK"><span class="glyphicon glyphicon-ok"></span></a>\n					')}function r(s,e){e.buffer.push('\n					<a title="To Be Removed"><span class="glyphicon glyphicon-remove"></span></a>\n					')}function l(s,e){e.buffer.push('<span class="glyphicon glyphicon-pencil"></span>')}function f(s,e){var n,a,h="";return e.buffer.push("\n					"),n={},a={},e.buffer.push(m(t._triageMustache.call(s,"preview.difficulty",{hash:{},contexts:[s],types:["ID"],hashContexts:a,hashTypes:n,data:e}))),e.buffer.push("\n					"),h}function c(s,e){e.buffer.push("\n					TBD\n					")}this.compilerInfo=[4,">= 1.0.0"],t=this.merge(t,Ember.Handlebars.helpers),a=a||{};var d,b,y,v,x,g="",m=this.escapeExpression,T=this,I=t.helperMissing;return a.buffer.push('<div class="jumbotron">\n	<div class="container">\n		<h2>Questions</h2>\n		<h6>View and manage questions</h6>\n	</div>\n</div>\n<div class="container">\n	<!--\n	'),y={"class":e},v={"class":"STRING"},x={hash:{"class":"btn btn-success"},inverse:T.noop,fn:T.program(1,h,a),contexts:[e],types:["STRING"],hashContexts:y,hashTypes:v,data:a},d=t["link-to"]||e&&e["link-to"],b=d?d.call(e,"questions.new",x):I.call(e,"link-to","questions.new",x),(b||0===b)&&a.buffer.push(b),a.buffer.push('\n	-->\n	<table class="table table-bordered question-list">\n		<thead>\n			<tr>\n				<th style="width:200px;">School</th>\n				<th style="width:100px;">Term</th>\n				<th style="width:100px;">Subject</th>\n				<th style="width:100px;">Course</th>\n				<th style="width:250px;">Note</th>\n				<th style="width:60px;">Status</th>\n				<th>Actions</th>\n			</tr>\n		</thead>\n		<tbody>\n			'),v={},y={},b=t.each.call(e,"question","in","controller",{hash:{},inverse:T.noop,fn:T.program(3,u,a),contexts:[e,e,e],types:["ID","ID","ID"],hashContexts:y,hashTypes:v,data:a}),(b||0===b)&&a.buffer.push(b),a.buffer.push("\n		</tbody>\n	</table>\n	"),y={"class":e},v={"class":"STRING"},x={hash:{"class":"btn btn-success"},inverse:T.noop,fn:T.program(1,h,a),contexts:[e],types:["STRING"],hashContexts:y,hashTypes:v,data:a},d=t["link-to"]||e&&e["link-to"],b=d?d.call(e,"questions.new",x):I.call(e,"link-to","questions.new",x),(b||0===b)&&a.buffer.push(b),a.buffer.push('\n	<br/>\n	<br/>\n</div>\n<div class="modal fade">\n	<div class="modal-dialog">\n		<div class="modal-content">\n			<div class="modal-header">\n				<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>\n				<h6>'),v={},y={},a.buffer.push(m(t._triageMustache.call(e,"preview.school.name",{hash:{},contexts:[e],types:["ID"],hashContexts:y,hashTypes:v,data:a}))),a.buffer.push(", "),v={},y={},a.buffer.push(m(t._triageMustache.call(e,"preview.term",{hash:{},contexts:[e],types:["ID"],hashContexts:y,hashTypes:v,data:a}))),a.buffer.push(", "),v={},y={},a.buffer.push(m(t._triageMustache.call(e,"preview.subject",{hash:{},contexts:[e],types:["ID"],hashContexts:y,hashTypes:v,data:a}))),a.buffer.push(" "),v={},y={},a.buffer.push(m(t._triageMustache.call(e,"preview.course",{hash:{},contexts:[e],types:["ID"],hashContexts:y,hashTypes:v,data:a}))),a.buffer.push('</h6>\n				<h4 class="modal-title">Question ID: '),v={},y={},a.buffer.push(m(t._triageMustache.call(e,"preview.id",{hash:{},contexts:[e],types:["ID"],hashContexts:y,hashTypes:v,data:a}))),a.buffer.push('</h4>\n			</div>\n			<div class="modal-body">\n				<div class="well">\n					Type: '),v={},y={},a.buffer.push(m(t._triageMustache.call(e,"preview.type",{hash:{},contexts:[e],types:["ID"],hashContexts:y,hashTypes:v,data:a}))),a.buffer.push("\n					<br/>\n					Difficulty:\n					"),v={},y={},b=t["if"].call(e,"preview.difficulty",{hash:{},inverse:T.program(14,c,a),fn:T.program(12,f,a),contexts:[e],types:["ID"],hashContexts:y,hashTypes:v,data:a}),(b||0===b)&&a.buffer.push(b),a.buffer.push("\n					<br/>\n					Tags: "),v={},y={},a.buffer.push(m(t._triageMustache.call(e,"preview.tags",{hash:{},contexts:[e],types:["ID"],hashContexts:y,hashTypes:v,data:a}))),a.buffer.push("\n					<br/>\n					Note: "),v={},y={},a.buffer.push(m(t._triageMustache.call(e,"preview.note",{hash:{},contexts:[e],types:["ID"],hashContexts:y,hashTypes:v,data:a}))),a.buffer.push('\n				</div>\n				<div id="modal-math">\n					<h5 class="page-header">Question</h5>\n					<div id="question-view"></div>\n					<h5 class="page-header">Hint</h5>\n					<div id="hint-view"></div>\n					<h5 class="page-header">Solution</h5>\n					<div id="solution-view"></div>\n					<h5 class="page-header">Summary</h5>\n					<div id="summary-view"></div>\n				</div>\n			</div>\n			<div class="modal-footer">\n				<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>\n			</div>\n			</div><!-- /.modal-content -->\n			</div><!-- /.modal-dialog -->\n			</div><!-- /.modal -->'),g});