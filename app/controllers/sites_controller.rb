class SitesController < ApplicationController
  before_action :authenticate_user!

  def show
    @dir = Rails.root.join('uploads', current_user.id.to_s)
    @file = @dir.join('sites')
    @uid = current_user.id
  end

  def download
    send_file params[:file_path]
  end


end
