class LogsController < ApplicationController
  before_action :authenticate_user!

  def list
    dir = Rails.root.join('uploads', current_user.id.to_s, 'logs')
    @log_files = Dir.glob("#{dir}/*.log").select{|f| File.file?(f)}
  end


  def download
    send_file params[:file_path]
  end


end
