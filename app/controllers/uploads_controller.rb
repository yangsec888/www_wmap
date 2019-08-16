#--
# www_wmap
#
# A  Ruby application for enterprise web application asset tracking
#
# Developed by Sam (Yang) Li, <yang.li@owasp.org>.
#
#++

require 'sequel'
require 'yaml'
require 'rubyXL'
include ActionView::Helpers::NumberHelper

class UploadsController < ApplicationController
  before_action :authenticate_user!
  before_action :platinum_user_and_above, except: :new

  def show
    @upload = Upload.new
    @file_type = params[:id]
  rescue
    redirect_to uploads_alert_uploads_path(error_path: request.url, error_time: DateTime.now)
  end

  def new
    @upload = Upload.new
  rescue
    redirect_to uploads_alert_uploads_path(error_path: request.url, error_time: DateTime.now)
  end

  def division_1
    @upload = Upload.new
    @file_type = "division_1"
    @file_name = params.key?(:file_name)? params[:file_name] : "DomainPortfolio-division_1.xlsx"
  rescue
    redirect_to uploads_alert_uploads_path(error_path: request.url, error_time: DateTime.now)
  end

  def division_2
    @upload = Upload.new
    @file_type = "division_2"
    @file_name = params.key?(:file_name)? params[:file_name] : "DomainPortfolio-division_2.xlsx"
  rescue
    redirect_to uploads_alert_uploads_path(error_path: request.url, error_time: DateTime.now)
  end

  def division_3
    @upload = Upload.new
    @file_type = "division_3"
    @file_name = params.key?(:file_name)? params[:file_name] : "DomainPortfolio-division_3.xlsx"
  rescue
    redirect_to uploads_alert_uploads_path(error_path: request.url, error_time: DateTime.now)
  end

  def create
    @upload = Upload.new(upload_params)
    #@upload.attachment = params[:attachment]
    if @upload.save
      case @upload.file_type
      when "division_1"
        redirect_to uploads_division_1_path(:file_name => @upload.attachment.current_path.to_s), notice: "The file #{@upload.name} has been uploaded successfully."
      when "division_2"
        redirect_to uploads_division_2_path(:file_name => @upload.attachment.current_path.to_s), notice: "The file #{@upload.name} has been uploaded successfully."
      when "division_3"
        redirect_to uploads_division_3_path(:file_name => @upload.attachment.current_path.to_s), notice: "The file #{@upload.name} has been uploaded successfully."
      else
        redirect_back :fallback_location => root_path, :alert => "Division unknown."
      end
    end
  rescue => e
    redirect_to uploads_alert_uploads_path(error_path: request.url, error_time: DateTime.now, error: e.to_s)
  end

  def update
    if current_user.admin?
      puts "Sidekiq on the domain portfolio update job ... "
      UpdateWorker.perform_async(params[:file],params[:file_type],current_user.id)
    else
      logger.debug "Current_user attributes: #{current_user.inspect}"
      redirect_back :fallback_location => root_path, :alert => "Access denied."
    end
  rescue
    redirect_to uploads_alert_uploads_path(error_path: request.url, error_time: DateTime.now)
  end

  def alert_uploads
    @time = params[:error_time]
    @path = params[:error_path]
    @error = params[:error]
  end


private

  def upload_params
    params.require(:upload).permit(:name, :file_type, :switch_tag, :attachment)
  end


end
