define(["ehbs!templates/components/photo-upload","jquery.fileupload"],function(){var n;return n=Ember.Component.extend({didInsertElement:function(){var n;return this._super(),n=this,this.$("input").fileupload({dataType:"json",done:function(e,t){return n.sendAction("uploadDone",t)},fail:function(e,t){return n.sendAction("uploadFail",t)}})}})});