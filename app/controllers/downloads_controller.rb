class DownloadsController < ApplicationController
  def show
    file_path = Rails.root.join('tmp', params[:file_name])
    send_file file_path, filename: params[:file_name], type: "application/octet-stream", disposition: "attachment"
  end
end