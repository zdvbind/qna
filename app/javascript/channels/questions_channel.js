import consumer from "./consumer"

consumer.subscriptions.create("QuestionsChannel", {
  received(data) {
    if (typeof gon.current_user === 'undefined' || (gon.current_user.id !== data.user_id)) {
      let newQuestionHtml = require('templates/question.hbs')(data)
      $('.questions').children().append(newQuestionHtml);
    }
  }
});
