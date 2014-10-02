Ember.TEMPLATES.signup=Ember.Handlebars.template(function(s,a,e,t,r){function l(s,a){a.buffer.push("Home")}this.compilerInfo=[4,">= 1.0.0"],e=this.merge(e,Ember.Handlebars.helpers),r=r||{};var n,h,p,o,u,c="",f=this.escapeExpression,i=e.helperMissing,d=this;return r.buffer.push('<div class="jumbotron">\n	<div class="container">\n		<div class="row">\n			<div class="col-md-4 col-md-offset-4">\n				<div class="login-form">\n					<h4>New Account Signup</h4>\n					<hr />\n					<form role="form">\n						<div '),p={"class":a},o={"class":"STRING"},r.buffer.push(f(e["bind-attr"].call(a,{hash:{"class":":form-group errors.username:has-error"},contexts:[],types:[],hashContexts:p,hashTypes:o,data:r}))),r.buffer.push('>\n							<label>Username</label>\n							<p class="text-danger">'),o={},p={},r.buffer.push(f(e._triageMustache.call(a,"errors.username",{hash:{},contexts:[a],types:["ID"],hashContexts:p,hashTypes:o,data:r}))),r.buffer.push("</p>\n							"),p={"class":a,name:a,value:a,placeholder:a},o={"class":"STRING",name:"STRING",value:"ID",placeholder:"STRING"},u={hash:{"class":"form-control",name:"username",value:"username",placeholder:"Username"},contexts:[],types:[],hashContexts:p,hashTypes:o,data:r},r.buffer.push(f((n=e.input||a&&a.input,n?n.call(a,u):i.call(a,"input",u)))),r.buffer.push("\n						</div>\n						<div "),p={"class":a},o={"class":"STRING"},r.buffer.push(f(e["bind-attr"].call(a,{hash:{"class":":form-group errors.email:has-error"},contexts:[],types:[],hashContexts:p,hashTypes:o,data:r}))),r.buffer.push('>\n							<label>Email</label>\n							<p class="text-danger">'),o={},p={},r.buffer.push(f(e._triageMustache.call(a,"errors.email",{hash:{},contexts:[a],types:["ID"],hashContexts:p,hashTypes:o,data:r}))),r.buffer.push("</p>\n							"),p={"class":a,name:a,value:a,placeholder:a},o={"class":"STRING",name:"STRING",value:"ID",placeholder:"STRING"},u={hash:{"class":"form-control",name:"email",value:"email",placeholder:"Email"},contexts:[],types:[],hashContexts:p,hashTypes:o,data:r},r.buffer.push(f((n=e.input||a&&a.input,n?n.call(a,u):i.call(a,"input",u)))),r.buffer.push("\n						</div>\n						<div "),p={"class":a},o={"class":"STRING"},r.buffer.push(f(e["bind-attr"].call(a,{hash:{"class":":form-group errors.password:has-error"},contexts:[],types:[],hashContexts:p,hashTypes:o,data:r}))),r.buffer.push('>\n							<label>Password</label>\n							<p class="text-danger">'),o={},p={},r.buffer.push(f(e._triageMustache.call(a,"errors.password",{hash:{},contexts:[a],types:["ID"],hashContexts:p,hashTypes:o,data:r}))),r.buffer.push("</p>\n							"),p={"class":a,name:a,type:a,value:a,placeholder:a},o={"class":"STRING",name:"STRING",type:"STRING",value:"ID",placeholder:"STRING"},u={hash:{"class":"form-control",name:"password",type:"password",value:"password",placeholder:"Password"},contexts:[],types:[],hashContexts:p,hashTypes:o,data:r},r.buffer.push(f((n=e.input||a&&a.input,n?n.call(a,u):i.call(a,"input",u)))),r.buffer.push("\n						</div>\n						<div "),p={"class":a},o={"class":"STRING"},r.buffer.push(f(e["bind-attr"].call(a,{hash:{"class":":form-group errors.confirm:has-error"},contexts:[],types:[],hashContexts:p,hashTypes:o,data:r}))),r.buffer.push('>\n							<label>Confirm Password</label>\n							<p class="text-danger">'),o={},p={},r.buffer.push(f(e._triageMustache.call(a,"errors.confirm",{hash:{},contexts:[a],types:["ID"],hashContexts:p,hashTypes:o,data:r}))),r.buffer.push("</p>\n							"),p={"class":a,name:a,type:a,value:a,placeholder:a},o={"class":"STRING",name:"STRING",type:"STRING",value:"ID",placeholder:"STRING"},u={hash:{"class":"form-control",name:"confirm",type:"password",value:"confirm",placeholder:"Confirm Password"},contexts:[],types:[],hashContexts:p,hashTypes:o,data:r},r.buffer.push(f((n=e.input||a&&a.input,n?n.call(a,u):i.call(a,"input",u)))),r.buffer.push('\n						</div>\n						<button class="btn btn-primary" '),o={},p={},r.buffer.push(f(e.action.call(a,"signup",{hash:{},contexts:[a],types:["STRING"],hashContexts:p,hashTypes:o,data:r}))),r.buffer.push(">Signup</button>\n						"),p={"class":a},o={"class":"STRING"},u={hash:{"class":"btn btn-default"},inverse:d.noop,fn:d.program(1,l,r),contexts:[a],types:["STRING"],hashContexts:p,hashTypes:o,data:r},n=e["link-to"]||a&&a["link-to"],h=n?n.call(a,"index",u):i.call(a,"link-to","index",u),(h||0===h)&&r.buffer.push(h),r.buffer.push("\n					</form>\n				</div>\n			</div>\n		</div>\n	</div>\n</div>"),c});