$.fn.serializeObject = function(trim) {
    if (trim == null) trim = false;
    var o = {}, form;
    if ($(this).is('form')) {
        form = this;
    }
    else {
        form = $('<form></form>').append($(this).clone());
    }
    var a = form.serializeArray();
    $.each(a, function() {
        if (o[this.name] !== undefined) {
            if (!o[this.name].push) {
                o[this.name] = [o[this.name]];
            }
            var value = this.value || '';
            if (trim) value = $.trim(value);
            o[this.name].push(value);
        } else {
            var value = this.value || '';
            if (trim) value = $.trim(value);
            o[this.name] = value;
        }
    });
    return o;
}
