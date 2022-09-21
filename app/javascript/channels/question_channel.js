import consumer from "./consumer"

consumer.subscriptions.create({channel: "QuestionChannel", question_id: gon.question_id}, {
  received(data) {
    if (typeof gon.current_user === 'undefined' || (gon.current_user.id !== data.user_id)) {
      let newAnswerHtml = require('templates/answer.hbs')(data)
      $('.answers').append(newAnswerHtml);
    }
  }
});
