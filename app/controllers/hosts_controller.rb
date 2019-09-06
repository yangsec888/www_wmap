#--
# www_wmap
#
# A  Ruby application for enterprise web application asset tracking
#
# Developed by Sam (Yang) Li, <yang.li@owasp.org>.
#
#++

class HostsController < ApplicationController
  before_action :authenticate_user!
  include HostsHelper

=begin
    def index
      file = Rails.root.join('shared', 'data', 'hosts')
      File.new(file, File::CREAT|File::TRUNC|File::RDWR, 0644) unless File.exist?(file)
      logger.debug "Reading hosts file: #{file}"
      @hosts = Hash.new
      row = 0
      File.open(file,'r').each_line do |line|
        row += 1
        next if row <= 1
        entry = line.split(' ')
        @hosts[row]=entry
      end
      @uid = current_user.id
    end
=end

    def index
      @hosts=Host.all.order(sort_column + " " + sort_direction).page(params[:page]).per_page(25)
      #@chart_data=Hash.new
    end

    def edit
      #@dir =  Rails.root.join('shared', 'data')
      @dir = Pathname.new(Gem.loaded_specs['wmap'].full_gem_path).join('data')
      Dir.mkdir(@dir, 0750) unless Dir.exist?(@dir)
      logger.debug "My data dir: #{@dir}"
      #@file = Rails.root.join('shared', 'data', 'hosts')
      @file = @dir.join('hosts')
      File.new(@file, 'w+') unless File.exist?(@file)
      @uid = current_user.id
    end

    def load_file
      data = ''
      #@file = Rails.root.join('shared', 'data', 'hosts')
      @file = Pathname.new(Gem.loaded_specs['wmap'].full_gem_path).join('data', 'hosts')
      file = File.open(@file, 'r')
      file.each_line { |line| data += line }
      file.close
      render plain: data
    end

    def save_file
      unless platinum_user_and_above?
        logger.debug "Current_user attributes: #{current_user.inspect}"
        render json: { message: 'Access Denied.' }
        return false
      end
      #@file = Rails.root.join('shared', 'data', 'hosts')
      @file = Pathname.new(Gem.loaded_specs['wmap'].full_gem_path).join('data', 'hosts')
      file = File.open(@file, 'r')
      @restore = ''
      file.each_line { |line| @restore += line }
      file.close
      file = File.open(@file, 'w+')
      file.write(params[:file_content])
      file.close
      host_table_reload
      #YAML.load_file(@file)
      render json: { message: 'Saving successed.' }
    rescue Psych::SyntaxError
      file = File.open(@file, 'w+')
      file.write(@restore)
      file.close
      render json: { message: 'Saving failed, please check your file again.' }
    end

    private

    def sort_column
      Host.column_names.include?(params[:sort]) ? params[:sort] : "host_name"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end

end
