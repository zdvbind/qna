class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @attach = ActiveStorage::Attachment.find(params[:id])
    @attach&.purge if current_user.author?(@attach.record)
  end
end
