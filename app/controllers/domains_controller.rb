#--
# www_wmap
#
# A  Ruby application for enterprise web application asset tracking
#
# Developed by Sam (Yang) Li, <yang.li@owasp.org>.
#
#++

class DomainsController < ApplicationController
  before_action :authenticate_user!
  include DomainsHelper

    # Custom user import error message
    class ImportLimitError < StandardError
      def message
        "Error exceeding import limit 10 entries."
      end
    end

    # for user search function
    def search_list
      if params[:keyword].nil? or params[:keyword].empty?
        redirect_back :fallback_location => root_path, :alert => "Unrecognized user input. "
      else
        keyword = "%" + params[:keyword].strip + "%"
      end
      @domains = Domain.where('name like ?', keyword).limit(10)
    end

    # search for specific domain info
    def search
      if params[:keyword].nil? or params[:keyword].empty?
        redirect_back :fallback_location => root_path, :alert => "Unrecognized user input. "
      else
        keyword =  params[:keyword].downcase.strip
      end
      @domain = Domain.find_by(name: keyword)
      if @domain.present?
        site_header=["Primary Website","Primary IP","Port","Hosting Status","Server","Response Code","MD5 Fingerprint","Detected Redirection","Timestamp"]
        @prime_site = site_header.zip(site_lookup(@domain.name)).to_h
      else
        @prime_site = nil
      end
    end


    def edit
      #@dir = Pathname.new(Gem.loaded_specs['wmap'].full_gem_path).join('data')
      @dir = Rails.root.join('shared','data')
      @file = @dir.join('domains')
      @uid = current_user.id
    end

    def edit_domain
      @domain=Domain.find_by(name: params[:name])
      @divisions=Domain.distinct.pluck(:division)
      respond_to do |format|
        format.js
      end
    end

    # Allow user to import domain to wmap data file and database table
    def import
      dir = Rails.root.join('shared', 'data')
      Dir.mkdir(dir, 0750) unless Dir.exist?(dir)
      file = dir.join('domains')
      File.new(file, 'w+') unless File.exist?(file)
      f = File.open(file, 'r')
      @restore = ''
      f.each_line { |line| @restore += line }
      f.close
    end

    # Save import from user input
    def save_import
      if platinum_user_and_above?
        uid = current_user.id
        existing_domains = Domain.pluck(:name)
        data_dir = Rails.root.join('shared', 'data')
        # save import to cache file
        file = data_dir.join('domains')
        f = File.open(file, 'w+')
        f.write(params[:file_content])
        f.close
        # calculate the domains from import
        my_domains = Array.new
        params[:file_content].split("\n").map do |x|
          next if x =~ /^\#/
          next if ["",nil].include? x
          my_domains.push(x.split(',')[0])
        end
        raise ImportLimitError if my_domains.size>10
        # remove user defined obsolete domains from db
        domains_to_remove = existing_domains - my_domains
        Domain.where(:name => domains_to_remove).delete_all
        # add user defined new domains into system
        domains_to_add = my_domains - existing_domains
        new_domains = Hash.new
        domains_to_add.map {|y| new_domains[y] = true}
        if new_domains.size > 0
          DomainCheckWorker.perform_async(uid,data_dir.to_s,new_domains)
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

    def update
      if platinum_user_and_above?
        logger.debug "Current_user attributes: #{current_user.inspect}"
        @domain=Domain.find_by(name: params[:name])
        @domain.division=params[:division][0] unless params[:division].nil?
        @domain.keep=params[:keep] unless params[:keep].nil?
        @domain.current_redirect=params[:current_redirect] unless params[:current_redirect].nil?
        @domain.new_redirect=params[:new_redirect] unless params[:new_redirect].nil?
        @domain.save
        redirect_back :fallback_location => root_path, :alert => "Record is save!"
      else
        redirect_back :fallback_location => root_path, :alert => "Access denied"
      end
    end

    def destroy
      if platinum_user_and_above?
        @domain=Domain.find_by(name: params[:keyword])
        if @domain.destroy
          redirect_to domains_show_all_path, :alert => "Record is deleted!"
        end
      else
        redirect_back :fallback_location => root_path, :alert => "Access denied"
      end
    end

    # show domain info
    def show
      @domain = Domain.find_by("name = ?", params[:name])
    end

    # show all domains
    def index
      @domains = Domain.all.order(sort_column + " " + sort_direction).page(params[:page]).per_page(25)
      @chart_data = pie_by_keep("all").to_json.html_safe
      respond_to do |format|
        format.html #show.html.erb
        format.json { render json: @chart_data }
      end
    end

    # Ajax call from view to local domains records from wmap data file
    def load_file
      data = ''
      #@file = Pathname.new(Gem.loaded_specs['wmap'].full_gem_path).join('data', 'domains')
      @file = Rails.root.join('shared','data','domains')
      file = File.open(@file, 'r')
      file.each_line { |line| data += line }
      file.close
      render plain: data
    end

    # Ajax call from view to save domain records into both wmap data file and database
    def save_file
      if platinum_user_and_above?
        uid = current_user.id
        data_dir = Rails.root.join('shared','data')
        @file = data_dir.join('domains')
        file = File.open(@file, 'r')
        @restore = ''
        file.each_line { |line| @restore += line }
        file.close
        file = File.open(@file, 'w+')
        file.write(params[:file_content])
        file.close
        domain_table_reload(uid,data_dir.to_s)
        render json: { message: 'Saving successful.' }
      else
        render json: { message: 'Saving failed, please check your file again.' }
      end
    rescue Psych::SyntaxError
      file = File.open(@file, 'w+')
      file.write(@restore)
      file.close
      render json: { message: 'Saving failed, please check your file again.' }
    end

    private

    def sort_column
      Domain.column_names.include?(params[:sort]) ? params[:sort] : "name"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end

end
