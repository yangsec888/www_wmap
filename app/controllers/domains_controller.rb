class DomainsController < ApplicationController
  before_action :authenticate_user!

    def start
      @file = Rails.root.join('uploads', 'domains', current_user.id.to_s)
      @uid = current_user.id
    end

    def show
      @file = Rails.root.join('uploads', 'domains', current_user.id.to_s)
      @uid = current_user.id
    end

    def create
      file_content = params[:file_tag]
      f = Rails.root.join('uploads', 'domains', params[:uid_tag])
      file = File.open(f, 'w+')
      file.write(file_content)
      file.close
      redirect_to domains_start_path, notice: "The domains file is saved!"

    end




end
