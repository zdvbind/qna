module Api
  module V1
    class QuestionsController < Api::V1::BaseController
      before_action :load_question, only: %i[show update destroy]

      authorize_resource

      def index
        @questions = Question.all
        render json: @questions
      end

      def show
        render json: @question, serializer: QuestionAdvancedSerializer
      end

      def create
        @question = current_resource_owner.questions.new(question_params)

        if @question.save
          render json: @question, serializer: QuestionAdvancedSerializer, status: :created
        else
          render json: { errors: @question.errors }, status: :unprocessable_entity
        end
      end

      def update
        if @question.update(question_params)
          render json: @question, serializer: QuestionAdvancedSerializer, status: :created
        else
          render json: { errors: @question.errors }, status: :unprocessable_entity
        end
      end

      def destroy
        @question.best_answer&.unmark_as_best
        @question.destroy
        render json: { messages: 'Your question was destroyed' }
      end

      private

      def load_question
        @question = Question.find(params[:id])
      end

      def question_params
        params.require(:question).permit(:title, :body)
      end
    end
  end
end
