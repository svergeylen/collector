class AttachmentsController < ApplicationController

  def download
    attachment = Attachment.find_by(id: params[:attachment_id])
    head(:not_found)    and return if attachment.nil?
    head(:forbidden)    and return unless current_user.can?(:une)
    head(:bad_request)  and return unless File.exist?(attachment.image.path)

    send_file attachment.image.path(params[:style].to_sym), filename: "#{attachment.element.id}#{File.extname(attachment.image.path(params[:style].to_sym))}", disposition: "inline"
  end
end
