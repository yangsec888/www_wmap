class CidrsController < ApplicationController
  before_action :authenticate_user!

    def start
      @file = Rails.root.join('uploads', 'cidrs', current_user.id.to_s)
      @uid = current_user.id
    end

    def show
      @file = Rails.root.join('uploads', 'cidrs', current_user.id.to_s)
      @uid = current_user.id
    end

    def create
      file_content = params[:file_tag]
      f = Rails.root.join('uploads', 'cidrs', params[:uid_tag])
      file = File.open(f, 'w+')
      file.write(file_content)
      file.close
      redirect_to cidrs_start_path, notice: "The cidrs file is saved!"

    end

end
