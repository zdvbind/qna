class FullTextSearch
  TYPES_DICTIONARY = {
    'All' => ThinkingSphinx,
    'Questions' => Question,
    'Answers' => Answer,
    'Comments' => Comment,
    'Users' => User
  }.freeze

  def initialize(request_params)
    @request = request_params[:request]
    @request = ThinkingSphinx::Query.escape(@request)
    @type = request_params[:type]
  end

  def call
    return unless valid?

    find_by_request
  end

  private

  attr_reader :request, :type

  def valid?
    request.present? && type.present?
  end

  def find_by_request
    TYPES_DICTIONARY[type].search request
  end
end
