$(document).on('turbolinks:load', function(){
  $('.answers').on('click', '.edit-answer-link', function (e) {
    e.preventDefault();
    $(this).hide();
    let answerId = $(this).data('answerId');
    $(`form#edit-answer-${answerId}`).removeClass('hidden');
  })

  // $('form.new-answer-form').on('ajax:success', function (e) {
  //   let answer = e.detail[0];
  //   $('.answers').append(`<p>${answer.body}</p>`);
  // })
  //   .on('ajax:error', function (e) {
  //     let errors = e.detail[0];
  //
  //     $.each(errors, function (index, value) {
  //       $('.answer-errors').append(`<p>${value}</p>`)
  //     })

    // })
});
