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
    @dir =  Rails.root.join('uploads', current_user.id.to_s)
    @file = Rails.root.join('uploads', current_user.id.to_s, 'seed')
    @uid = current_user.id
  end

  def show
    @dir =  Rails.root.join('uploads', current_user.id.to_s)
    @file = Rails.root.join('uploads', current_user.id.to_s, 'seed')
    @uid = current_user.id
  end

  def create
    file_content = params[:file_tag]
    f = Rails.root.join('uploads', params[:uid_tag], 'seed')
    file = File.open(f, 'w+')
    file.write(file_content)
    file.write("\n")
    file.close
    redirect_to domains_start_url, notice: "The seed file is saved!"
  end

  def discovery
    @uid = current_user.id.to_s
    dir = Rails.root.join('uploads', current_user.id.to_s)
    s_dir = dir.to_s + "/"
    file = Rails.root.join('uploads', current_user.id.to_s, 'seed')
    cmd = "wmap" + " " + file.to_s + " " + s_dir
    puts "Execute command in the background: #{cmd}"
    Spawnling.new do
      if system(cmd)
        puts "Discovery successful!"
      else
        puts "Discovery failed!"
      end
    end
  end

  def distest
    @uid = current_user.id.to_s
    puts "You're hitting distest controller"
  end



end
