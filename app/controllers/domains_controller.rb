class DomainsController < ApplicationController
  before_action :authenticate_user!

    def start
      @dir = Rails.root.join('uploads', current_user.id.to_s)
      @file = Rails.root.join('uploads', current_user.id.to_s, 'domains')
      @uid = current_user.id
    end

    def show
      @dir = Rails.root.join('uploads', current_user.id.to_s)
      @file = Rails.root.join('uploads', current_user.id.to_s, 'domains')
      @uid = current_user.id
    end

    def create
      file_content = params[:file_tag]
      f = Rails.root.join('uploads', params[:uid_tag], 'domains')
      file = File.open(f, 'w+')
      file.write(file_content)
      file.close
      redirect_to domains_start_path, notice: "The domains file is saved!"

    end




end
