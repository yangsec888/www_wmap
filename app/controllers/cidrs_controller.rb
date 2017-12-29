class CidrsController < ApplicationController
  before_action :authenticate_user!

    def start
      @dir = Rails.root.join('uploads', current_user.id.to_s)
      @file = Rails.root.join('uploads', current_user.id.to_s, 'cidrs')
      @uid = current_user.id
    end

    def show
      @dir = Rails.root.join('uploads', current_user.id.to_s)
      @file = Rails.root.join('uploads', current_user.id.to_s, 'cidrs')
      @uid = current_user.id
    end

    def create
      file_content = params[:file_tag]
      f = Rails.root.join('uploads',  params[:uid_tag], 'cidrs')
      file = File.open(f, 'w+')
      file.write(file_content)
      file.close
      redirect_to cidrs_start_path, notice: "The cidrs file is saved!"

    end

end
