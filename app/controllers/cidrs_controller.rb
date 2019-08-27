#--
# www_wmap
#
# A  Ruby application for enterprise web application asset tracking
#
# Developed by Sam (Yang) Li, <yang.li@owasp.org>.
#
#++

class CidrsController < ApplicationController
  before_action :authenticate_user!
  include CidrsHelper

    def edit
      @dir = Rails.root.join('shared', 'data')
      @file = Rails.root.join('shared', 'data', 'cidrs')
      @uid = current_user.id
    end

    def index
=begin
      @file = Rails.root.join('shared', 'data', 'cidrs')
      File.new(@file, File::CREAT|File::TRUNC|File::RDWR, 0644) unless File.exist?(@file)
      @cidrs = Hash.new
      row=0
      file=File.open(@file,'r')
      file.each_line do |line|
        row += 1
        next if row <= 2
        entry=line.split(',')
        @cidrs[row]=entry
      end
=end
      @cidrs=Cidr.all
    end

    def load_file
      data = ''
      @file = Rails.root.join('shared', 'data', 'cidrs')
      file = File.open(@file, 'r')
      file.each_line { |line| data += line }
      file.close
      render plain: data
    end

    def save_file
      if platinum_user_and_above?
        @file = Rails.root.join('shared', 'data', 'cidrs')
        file = File.open(@file, 'r')
        @restore = ''
        file.each_line { |line| @restore += line }
        file.close
        file = File.open(@file, 'w+')
        file.write(params[:file_content])
        file.close
        cidr_table_reload
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

end
