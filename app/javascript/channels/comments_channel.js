import consumer from "./consumer"

consumer.subscriptions.create({channel: 'CommentsChannel', question_id: gon.question_id}, {
  received(data) {
    if (typeof gon.current_user === 'undefined' || (gon.current_user.id !== data.comment.user_id)) {
      let newComment = require('templates/comment.hbs')({comment: data.comment, email: data.email})
      if (data.comment.commentable_type === 'Question') {
        $('.question-comments .comments-list').append(newComment);
      } else {
        $(`#answer-${data.comment.commentable_id} .answer-comments .comments-list`).append(newComment);
      }
    }
  }
});
