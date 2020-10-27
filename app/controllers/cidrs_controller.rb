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

    class ImportLimitError < StandardError
      def message
        "Error exceeding import limit between 1 - 10 entries."
      end
    end

    def edit
      #@dir = Pathname.new(Gem.loaded_specs['wmap'].full_gem_path).join('data')
      @dir = Rails.root.join('shared','data')
      Dir.mkdir(@dir, 0750) unless Dir.exist?(@dir)
      @file = @dir.join('cidrs')
      File.new(@file, 'w+') unless File.exist?(@file)
      @uid = current_user.id
    end

    def index
      @cidrs=Cidr.all
    end

    def load_file
      data = ''
      #@file = Pathname.new(Gem.loaded_specs['wmap'].full_gem_path).join('data', 'cidrs')
      @file = Rails.root.join('shared','data','cidrs')
      file = File.open(@file, 'r')
      file.each_line { |line| data += line }
      file.close
      render plain: data
    end

    def save_file
      if platinum_user_and_above?
        uid = current_user.id
        data_dir = Rails.root.join('shared','data')
        @file = data_dir.join('cidrs')
        file = File.open(@file, 'r')
        @restore = ''
        file.each_line { |line| @restore += line }
        file.close
        f = File.open(@file, 'w+')
        f.write(params[:file_content])
        f.close
        cidr_table_reload(uid,data_dir.to_s)
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

    def import
      @dir = Rails.root.join('shared','data')
      Dir.mkdir(@dir, 0750) unless Dir.exist?(@dir)
      @file = @dir.join('cidrs')
      File.new(@file, 'w+') unless File.exist?(@file)
      file = File.open(@file, 'r')
      @restore = ''
      file.each_line { |line| @restore += line }
      file.close
    end

    def save_import
      if platinum_user_and_above?
        uid = current_user.id
        data_dir = Rails.root.join('shared', 'data')
        my_cidrs=params[:file_content].split("\n")
        raise ImportLimitError if my_cidrs.size>10 || my_cidrs.size<1
        new_cidrs = Hash.new
        my_cidrs.map do |entry|
          cur_entry = entry.downcase.strip
          next if ["",nil].include? cur_entry
          cidr = Cidr.find_by(owed_cidr: cur_entry)
          if cidr
            #cidr.update(name: cur_entry, user_id: uid)
          else
            new_cidrs[cur_entry] = true
          end
        end
        if new_cidrs.size > 0
          CidrCheckWorker.perform_async(uid,data_dir.to_s,new_cidrs)
        end
        render json: { message: 'Saving successed.' }
      else
        render json: { message: 'Access Denied.' }
      end
    rescue ImportLimitError => e
      render json: { message: e.message }
    rescue Psych::SyntaxError
      file = File.open(params[:file_path], 'w+')
      file.write(@restore)
      file.close
      render json: { message: 'Saving failed, please check your file again or contact the site administrator.' }
    end

end
