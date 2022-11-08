class Api::V1::ProfilesController < Api::V1::BaseController
  def me
    render json: current_resource_owner
  end

  def all_except_me
    @users = User.where.not(id: current_resource_owner.id)
    render json: @users
  end
end
