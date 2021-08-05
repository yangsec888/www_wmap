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
    #@dir = Pathname.new(Gem.loaded_specs['wmap'].full_gem_path).join('data')
    @dir =  Rails.root.join('shared', 'data')
    Dir.mkdir(@dir, 0750) unless Dir.exist?(@dir)
    @file = @dir.join('sites')
    File.new(@file, 'w+') unless File.exist?(@file)
    @uid = current_user.id
  end

  def load_file
    data = ''
    data_dir =  Rails.root.join('shared', 'data')
    @file = data_dir.join('sites')
    file = File.open(@file, 'r')
    file.each_line { |line| data += line }
    file.close
    render plain: data
  end

  def save_file
    if platinum_user_and_above?
      data_dir =  Rails.root.join('shared', 'data')
      @file = data_dir.join('sites')
      file = File.open(@file, 'r')
      @restore = ''
      file.each_line { |line| @restore += line }
      file.close
      file = File.open(@file, 'w+')
      file.write(params[:file_content])
      file.close
      site_table_reload(current_user.id,data_dir.to_s)
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

  # allow user to download site table into Excel file
  def download
    if platinum_user_and_above?
      sites=Site.where("site is not null")
      workbook = RubyXL::Workbook.new
      worksheet = workbook.worksheets[0]
      worksheet.sheet_name = 'Sites'
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
      file = "Discovered_Websites_" + Time.now.strftime('%m%d%Y') + ".xlsx"
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
