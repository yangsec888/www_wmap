#--
# www_wmap
#
# A  Ruby application for enterprise web application asset tracking
#
# Developed by Yang Li, <yang.li@owasp.org>. Creative Common License
#
#++

class SeedController < ApplicationController
  before_action :authenticate_user!

  def start
    @file = Rails.root.join('uploads', 'seed', current_user.id.to_s)
    @uid = current_user.id
  end

  def show
    @file = Rails.root.join('uploads', 'seed', current_user.id.to_s)
    @uid = current_user.id
  end

  def create
    file_content = params[:file_tag]
    f = Rails.root.join('uploads', 'seed', params[:uid_tag])
    file = File.open(f, 'w+')
    file.write(file_content)
    file.close
    redirect_to seed_start_path, notice: "The seed file is saved!"

  end

end
