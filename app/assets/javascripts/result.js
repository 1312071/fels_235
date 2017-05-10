$(document).ready(function(){
  $('#btn_answer').on('click', function(){
    var answer = [];
    var lesson_id = location.pathname.split('/')[2];
    var id = $('#result_id').val();
    if ($('input:radio').length > 0) {
      $.each($('input:radio[name=\'answer[]\']:checked'), function(){
        answer.push($(this).val());
      });
    } else {
      $.each($('input:checkbox[name=\'answer[]\']:checked'), function(){
        answer.push($(this).val());
      });
    };
    $.ajax({
      type: 'PUT',
      url: '/lessons/' + lesson_id + '/results/' + id,
      dataType: 'json',
      data: {answer: answer},
      success: function(result){
        if(result) {
          $('#answer').html(result.question);
        } else {
          location.pathname = '/lessons/' + location.pathname.split('/')[2] +
            '/results'
        }
      },
      error: function(){
        alert(I18n.t("lessons.alert.choose_answer"));
        location.pathname = url;
      }
    });
  })
});
