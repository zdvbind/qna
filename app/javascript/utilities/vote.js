$(document).on('turbolinks:load', function (){
  $('.vote').on('ajax:success', function (e) {
    let rating = e.detail[0].rating;
    let resource_id = e.detail[0].resource_id;
    let resource_name = e.detail[0].resource_name;
    $(`#rating-${resource_name}-${resource_id}`).html(rating);
  })
    .on('ajax:error', function (e) {
      let error = e.detail[0].message;
      let parent = $(this).closest('.vote')
      $('.vote-error').html('');

      parent.find('.vote-error').html(error);
    })
});
