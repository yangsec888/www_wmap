#--
# www_wmap
#
# A  Ruby application for enterprise web application asset tracking
#
# Developed by Sam (Yang) Li, <yang.li@owasp.org>.
#
#++

class SitesController < ApplicationController
  before_action :authenticate_user!
  include SitesHelper


  def edit
    @dir = Rails.root.join('shared', 'data')
    Dir.mkdir(@dir, 0750) unless Dir.exist?(@dir)
    @file = @dir.join('sites')
    File.new(@file, 'w+') unless File.exist?(@file)
    @uid = current_user.id
  end

  def load_file
    data = ''
    @file = Rails.root.join('shared', 'data', 'sites')
    file = File.open(@file, 'r')
    file.each_line { |line| data += line }
    file.close
    render plain: data
  end

  def save_file
    if platinum_user_and_above?
      @file = Rails.root.join('shared', 'data', 'sites')
      file = File.open(@file, 'r')
      @restore = ''
      file.each_line { |line| @restore += line }
      file.close
      file = File.open(@file, 'w+')
      file.write(params[:file_content])
      file.close
      site_table_reload
      #YAML.load_file(@file)
      render json: { message: 'Saving successed.' }
    else
      render json: { message: 'Access deined. ' }
    end
  rescue Psych::SyntaxError
    file = File.open(@file, 'w+')
    file.write(@restore)
    file.close
    render json: { message: 'Saving failed, please check your file again.' }
  end

  def index
    @sites=Site.all.order(sort_column + " " + sort_direction).page(params[:page]).per_page(25)
    #@chart_data=Hash.new
  end

  def show
    @site = Site.find(params[:id])
  end

  # for tag site search function
  def search
      if params[:keyword].nil? or params[:keyword].empty?
        redirect_back :fallback_location => root_path, :alert => "Unrecognized user input. "
      else
        keyword = "%" + params[:keyword].strip + "%"
      end
      @sites = Site.where('site like ?', keyword).limit(10)
  end

=begin
  def import
    @dir = Rails.root.join('shared', 'data')
    @file = @dir.join('sites')
    @uid = current_user.id
  end

  def save
    if platinum_user_and_above?
      @file = Rails.root.join('shared', 'data', 'sites')
      file = File.open(@file, 'r')
      @restore = ''
      file.each_line { |line| @restore += line }
      file.close
      site_tracker=Wmap::SiteTracker.instance
      host_tracker=Wmap::HostTracker.instance
      params[:file_content].split("\n").map do |entry|
        logger.debug "Processing entry: #{entry}"
        next unless site_tracker.is_url?(entry)
        my_site=site_tracker.url_2_site(entry)
        my_host=site_tracker.url_2_host(my_site)
        site_tracker.add(my_site)
        host_tracker.add(my_host)
      end
      site_tracker.save!
      host_tracker.save!
      site_tracker=nil
      host_tracker=nil
      render json: { message: 'Saving successed.' }
    else
      render json: { message: 'Access denied. ' }
    end
  rescue Psych::SyntaxError
    file = File.open(@file, 'w+')
    file.write(@restore)
    file.close
    render json: { message: 'Saving failed, please check your file again or contact the site administrator.' }
  end
=end

  def download
    if platinum_user_and_above?
      sites=Site.where("site is not null")
      workbook = RubyXL::Workbook.new
      worksheet = workbook.worksheets[0]
      worksheet.sheet_name = '_Sites'
      header = ["Website","Primary IP","Port","Hosting Status","Server","Response Code","MD5 Finger-print","Redirection","Last Update"]
      index = 0
      worksheet_write_row(worksheet,index,header)
      sites.each do |site|
        next if site.site.nil?
        next if site.site.empty?
        index += 1
        my_row = [site.site, site.ip, site.port, site.status, site.server, site.code, site.md5,site.redirection, site.updated_at]
        worksheet_write_row(worksheet,index, my_row)
      end
      file = "_Websites_" + Time.now.strftime('%m%d%Y') + ".xlsx"
      send_data workbook.stream.string, filename: file, disposition: 'attachment'
    else
      redirect_back :fallback_location => root_path, :alert => "Access denied."
    end
  end


private

  def sort_column
    Site.column_names.include?(params[:sort]) ? params[:sort] : "site"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end


end
