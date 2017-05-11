function add_fields(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp('new_' + association, 'g')
  if($('.answer_field:visible').length < 4)
    $(link).parent().before(content.replace(regexp, new_id));
  else {
    alert(I18n.t('admin.words.error.answer_not_more_4'))
  }
}

function remove_fields(link) {
  if($('.answer_field:visible').length > 2){
    $(link).prev('input[type=hidden]').val(true) ;
    $(link).closest('.form-group').hide();
  }
  else{
    alert(I18n.t('admin.words.error.answer_not_less_2'))
  }
}
