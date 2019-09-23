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
    #dir = Pathname.new(Gem.loaded_specs['wmap'].full_gem_path).join('logs')
    dir = Rails.root.join('shared', 'data', 'logs')
    @log_files = Dir.glob("#{dir}/*.log").select{|f| File.file?(f)}
  end

  def show
    # Restrict log access to admin users only
    redirect_back :fallback_location => root_path, :alert => "Access denied." unless current_user.admin?
    dir = Rails.root.join('shared', 'data', 'logs')
    white_list = Dir.glob(dir + '*.log')
    logger.debug "White list: #{white_list}"
    @file = dir.join(params[:id]).to_s
    @file_name = params[:id]
    if white_list.include?(@file)
      f = File.open(@file, 'r')
      @file_contents = Array.new
      f.each_line do |line|
        @file_contents << line
      end
    else
      logger.debug "Unauthorized access: #{current_user.inspect}, #{@file}"
      redirect_to destroy_user_session_path, :method => :delete
    end

  end

  def download
    dir = Rails.root.join('shared', 'data', 'logs')
    white_list = Dir.glob(dir + '*.log')
    file = dir.join(params[:file_name]).to_s
    if current_user.admin?
      if white_list.include?(file)
        send_file file
      else
        logger.debug "Unauthorized access: #{current_user.inspect}, #{params[:file_name]}"
        redirect_to destroy_user_session_path, :method => :delete
      end
    else
      logger.debug "Current_user attributes: #{current_user.inspect}"
      redirect_back :fallback_location => root_path, :alert => "Access denied."
    end
  end


end
