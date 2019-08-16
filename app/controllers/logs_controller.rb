#--
# www_wmap
#
# A  Ruby application for enterprise web application asset tracking
#
# Developed by Sam (Yang) Li, <yang.li@owasp.org>.
#
#++

class LogsController < ApplicationController
  before_action :authenticate_user!

  def list
    dir = Rails.root.join('shared', 'log', 'wmap_logs')
    @log_files = Dir.glob("#{dir}/*.log").select{|f| File.file?(f)}
  end

  def show
    @file = Rails.root.join('shared', 'log', 'wmap_logs', params[:id])
    @file_name = params[:id]
    f = File.open(@file, 'r')
    @file_contents = Array.new
    f.each_line do |line|
      @file_contents << line
    end
  end

  def download
    if current_user.admin?
      send_file Rails.root.join('shared', 'log', 'wmap_logs', params[:file_name])
    else
      logger.debug "Current_user attributes: #{current_user.inspect}"
      redirect_back :fallback_location => root_path, :alert => "Access denied."
    end
  end


end
