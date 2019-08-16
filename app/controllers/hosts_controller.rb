#--
# www_wmap
#
# A  Ruby application for enterprise web application asset tracking
#
# Developed by Sam Li, <sli@penguinrandomhouse.com>. 2018-2020
#
#++

class HostsController < ApplicationController
  before_action :authenticate_user!

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

    def edit
      @dir =  Rails.root.join('shared', 'data')
      logger.debug "My data dir: #{@dir}"
      @file = Rails.root.join('shared', 'data', 'hosts')
      @uid = current_user.id
    end

    def load_file
      data = ''
      @file = Rails.root.join('shared', 'data', 'hosts')
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
      @file = Rails.root.join('shared', 'data', 'hosts')
      file = File.open(@file, 'r')
      @restore = ''
      file.each_line { |line| @restore += line }
      file.close
      file = File.open(@file, 'w+')
      file.write(params[:file_content])
      file.close
      YAML.load_file(@file)
      render json: { message: 'Saving successed.' }
    rescue Psych::SyntaxError
      file = File.open(@file, 'w+')
      file.write(@restore)
      file.close
      render json: { message: 'Saving failed, please check your file again.' }
    end


end
