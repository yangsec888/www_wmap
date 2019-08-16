#--
# www_wmap
#
# A  Ruby application for enterprise web application asset tracking
#
# Developed by Sam (Yang) Li, <yang.li@owasp.org>.
#
#++

class DomainMapController < ApplicationController
  before_action :authenticate_user!
  include DomainMapHelper

  def show
    redirect_back :fallback_location => root_path, :alert => "Unknown domain: #{params[:keyword]}" unless params[:keyword]
    @sites = Site.where('site like ?', "%" + params[:keyword] + "%")
    @tree = []
    @tree << { 'id' => params[:keyword], 'text' => params[:keyword],
               'children' => [], 'icon' => 'glyphicon glyphicon-home',
               'state' => { 'opened' => true } }
    #get_site_info(params[:keyword])
    @sites.each do |site|
      @tree[0]['children'] << { 'id' => site['id'],
                                'text' => site['site'],
                                'icon' => 'glyphicon glyphicon-picture' }
    end
    #render json: @tree
    respond_to do |format|
      format.html
      format.json { render json: @tree }
    end
  end

=begin
  def load_file
    data = ''
    file = File.open(params[:path], 'r')
    file.each_line { |line| data += line }
    file.close
    #render data.inspect
    render plain: data
  end

  def save_file
    file = File.open(params[:file_path], 'r')
    @restore = ''
    file.each_line { |line| @restore += line }
    file.close
    file = File.open(params[:file_path], 'w+')
    file.write(params[:file_content])
    file.close
    YAML.load_file(params[:file_path])
    render json: { message: 'Saving successed.' }
  rescue Psych::SyntaxError
    file = File.open(params[:file_path], 'w+')
    file.write(@restore)
    file.close
    render json: { message: 'Saving failed, please check YAML file format again.' }
  end

=end

end
