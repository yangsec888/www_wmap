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

    class ImportLimitError < StandardError
      def message
        "Error exceeding import limit of 10 entries."
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

=begin
    def index
      domains=Hash.new
      @file = Rails.root.join('shared', 'data', 'domains')
      row = 0
      file = File.open(@file,'r')
      file.each_line do |line|
        row += 1
        next if row <= 2
        entry = line.split(",")
        domains[row]=entry
      end
      @domains = domains
    end
=end

    def edit
      @dir = Rails.root.join('shared', 'data')
      @file = Rails.root.join('shared', 'data', 'domains')
      @uid = current_user.id
    end

    def edit_domain
      @domain=Domain.find_by(name: params[:name])
      @divisions=Domain.distinct.pluck(:division)
      respond_to do |format|
        format.js
      end
    end

    def update
      if platinum_user_and_above?
        logger.debug "Current_user attributes: #{current_user.inspect}"
        @domain=Domain.find_by(name: params[:name])
        @domain.imprint=params[:imprint] unless params[:imprint].nil?
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
    #def show_all
    def index
      @domains = Domain.all.order(sort_column + " " + sort_direction).page(params[:page]).per_page(25)
      @chart_data = pie_by_keep("all").to_json.html_safe
      respond_to do |format|
        format.html #show.html.erb
        format.json { render json: @chart_data }
      end
    end

    def load_file
      data = ''
      @file = Rails.root.join('shared', 'data', 'domains')
      file = File.open(@file, 'r')
      file.each_line { |line| data += line }
      file.close
      render plain: data
    end

    # Ajax call from view to save domain records into both wmap data file and database
    def save_file
      if platinum_user_and_above?
        @file = Rails.root.join('shared', 'data', 'domains')
        file = File.open(@file, 'r')
        @restore = ''
        file.each_line { |line| @restore += line }
        file.close
        file = File.open(@file, 'w+')
        file.write(params[:file_content])
        file.close
        domain_table_reload
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

=begin
    def import
      @dir = Rails.root.join('shared', 'data')
      @file = @dir.join('domains')
      @uid = current_user.id
    end

    def save_import
      if platinum_user_and_above?
        file = File.open(Rails.root.join('shared', 'data', 'domains'), 'r')
        @restore = ''
        file.each_line { |line| @restore += line }
        file.close
        site_tracker=Wmap::SiteTracker.new
        domain_tracker=Wmap::DomainTracker.new
        my_domains=params[:file_content].split("\n")
        raise ImportLimitError if my_domains.size>10
        my_sites=[]
        my_domains.map do |entry|
          next unless site_tracker.is_domain_root?(entry)
          my_site=domain_2_site(entry)
          unless my_site.nil?
            my_sites.push(my_site)
          end
        end
        logger.debug "Processing sites: #{my_sites}"
        site_tracker.adds(my_sites)
        site_tracker.save!
        logger.debug "Processing domains: #{my_domains}"
        domain_tracker.adds(my_domains)
        domain_tracker.save!
        site_tracker=nil
        domain_tracker=nil
        render json: { message: 'Saving successed.' }
      else
        render json: { message: 'Saving failed, please check your file again.' }
      end
    rescue ImportLimitError => e
      render json: { message: e.message }
    rescue Psych::SyntaxError
      file = File.open(params[:file_path], 'w+')
      file.write(@restore)
      file.close
      render json: { message: 'Saving failed, please check your file again or contact the site administrator.' }
    end
=end

    private

    def sort_column
      Domain.column_names.include?(params[:sort]) ? params[:sort] : "name"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end

end
