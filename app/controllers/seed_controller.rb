#--
# www_wmap
#
# A  Ruby application for enterprise web application asset tracking
#
# Developed by Sam (Yang) Li, <yang.li@owasp.org>.
#
#++

class SeedController < ApplicationController
  before_action :authenticate_user!

  def start
    #@dir = Pathname.new(Gem.loaded_specs['wmap'].full_gem_path).join('data')
    @dir = Rails.root.join('shared','data')
    Dir.mkdir(@dir, 0750) unless Dir.exist?(@dir)
    @file = @dir.join('seed')
    File.new(@file, 'w+') unless File.exist?(@file)
    @uid = current_user.id
  end

  def show
    #@dir = Pathname.new(Gem.loaded_specs['wmap'].full_gem_path).join('data')
    @dir = Rails.root.join('shared','data')
    Dir.mkdir(@dir, 0750) unless Dir.exist?(@dir)
    @file = @dir.join('seed')
    File.new(@file, 'w+') unless File.exist?(@file)
    @uid = current_user.id
  end

  def load_file
    data = ''
    #@file = Pathname.new(Gem.loaded_specs['wmap'].full_gem_path).join('data', 'seed')
    @file = Rails.root.join('shared','data','seed')
    file = File.open(@file, 'r')
    file.each_line { |line| data += line }
    file.close
    render plain: data
  end

  def save_file
    if platinum_user_and_above?
      #@file = Pathname.new(Gem.loaded_specs['wmap'].full_gem_path).join('data', 'seed')
      @file = Rails.root.join('shared','data','seed')
      file = File.open(@file, 'r')
      @restore = ''
      file.each_line { |line| @restore += line }
      file.close
      file = File.open(@file, 'w+')
      file.write(params[:file_content])
      file.close
      YAML.load_file(@file)
      render json: { message: 'Saving successed.' }
    else
      render json: { message: 'Access denied.' }
    end
  rescue Psych::SyntaxError
    file = File.open(@file, 'w+')
    file.write(@restore)
    file.close
    render json: { message: 'Saving failed, please check your file again.' }
  end

  def discovery
    #UserMailer.discovery_completion_notice("yli8@yahoo.com", "yesterday", "today").deliver_later
    @user= User.find(current_user.id)
    if platinum_user_and_above?
      flash[:notice] = "Discovery is kicked-off in the background ... "
      logger.info "starting the sidekiq worker for the discovery job"
      uid = current_user.id
      DiscoveryWorker.perform_async(uid)
    else
      redirect_back :fallback_location => root_path, :alert => "Access denied."
    end
  end

  def distest
    @user= User.find(current_user.id)
    puts "You're hitting distest controller"
  end



end
