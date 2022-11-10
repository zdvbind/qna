class Api::V1::BaseController < ApplicationController # rubocop:disable Style/ClassAndModuleChildren
  before_action :doorkeeper_authorize!

  private

  def current_resource_owner
    @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end

  def doorkeeper_unauthorized_render_options(**)
    { json: { error: 'Not authorized' } }
  end

  protected

  def current_ability
    @current_ability ||= Ability.new(current_resource_owner)
  end
end
