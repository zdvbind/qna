class SearchesController < ApplicationController
  skip_authorization_check

  def show
    @result = FullTextSearch.new(request_params).call
  end

  private

  def request_params
    params.permit(:request, :type)
  end
end
