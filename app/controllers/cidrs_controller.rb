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

    # Save import from user input
    def save_import
      if platinum_user_and_above?
        uid = current_user.id
        existing_cidrs = Cidr.pluck(:owed_cidr)
        data_dir = Rails.root.join('shared', 'data')
        file = data_dir.join('cidrs')
        # Save user import to cache file
        f = File.open(file, 'w+')
        f.write(params[:file_content])
        f.close
        # calculate the cidrs from import
        my_cidrs=Array.new
        params[:file_content].split("\n").map do |x|
          next if x =~ /^\#/
          next if ["",nil].include? x
          my_cidrs.push(x.split(',')[0])
        end
        raise ImportLimitError if my_cidrs.size>10 || my_cidrs.size<1
        # remove user defined obsolete cidrs from db
        cidrs_to_remove = existing_cidrs - my_cidrs
        Cidr.where(:owed_cidr => cidrs_to_remove).delete_all
        # add user defined new cidrs into system
        cidrs_to_add = my_cidrs - existing_cidrs
        new_cidrs = Hash.new
        cidrs_to_add.map {|y| new_cidrs[y] = true }
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
      file = File.open(@file, 'w+')
      file.write(@restore)
      file.close
      render json: { message: 'Saving failed, please check your file again or contact the site administrator.' }
    end

end
