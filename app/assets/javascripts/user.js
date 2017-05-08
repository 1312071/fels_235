$(document).ready(function(){
  $('#btn-search').on('click',function(){
     $.ajax({
      type: 'GET',
      url: '/admin/users',
      dataType: 'json',
      data: {search: $('#search').val()},
      success: function(result){
        $('#result').html(result.html_user);
      },
      error: function(){
        alert(I18n.t('admin.users.error.get_data'));
      }
    });
  })
})
