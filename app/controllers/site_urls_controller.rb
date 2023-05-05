#--
# www_wmap
#
# A  Ruby application for enterprise web application asset tracking
#
# Developed by Sam (Yang) Li, <yang.li@owasp.org>.
#
#++

class SiteUrlsController < ApplicationController
  before_action :set_site_url, only: %i[ show edit update destroy display]
  before_action :authenticate_user!
  include SiteUrlsHelper

  # GET /site_urls or /site_urls.json
  def index
    @site_urls = SiteUrl.all.order(sort_column + " " + sort_direction).page(params[:page]).per_page(25)
  end

  # Render the site urls in the tree structure
  def display
    urls = SiteUrl.where(:site => params[:site]).map(&:url) - [nil,""]
    #render plain: urls
    @tree = urls.count>0? urls_2_tree(params[:site],urls) : []
    @site = params[:site]
    #@tree=[{"id"=>"https://www.google.com/", "text"=>"https://www.google.com/", "children"=>[{"id"=>"images", "text"=>"images", "children"=>[{"id"=>"icon.png", "text"=>"icon.png", "children"=>[], "icon"=>"glyphicon glyphicon-list", "state"=>{"opened"=>true}}], "icon"=>"glyphicon glyphicon-list", "state"=>{"opened"=>true}}], "icon"=>"glyphicon glyphicon-list", "state"=>{"opened"=>true}}]
    logger.debug("tree: #{@tree}")
    respond_to do |format|
      format.html
      format.json { render json: @tree }
    end
  end

  # GET /site_urls/1 or /site_urls/1.json
  def show
  end

  # GET /site_urls/new
  def new
    @site_url = SiteUrl.new
  end

  # GET /site_urls/1/edit
  def edit
  end

  # POST /site_urls or /site_urls.json
  def create
    @site_url = SiteUrl.new(site_url_params)

    respond_to do |format|
      if @site_url.save
        format.html { redirect_to @site_url, notice: "Site url was successfully created." }
        format.json { render :show, status: :created, location: @site_url }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @site_url.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /site_urls/1 or /site_urls/1.json
  def update
    respond_to do |format|
      if @site_url.update(site_url_params)
        format.html { redirect_to @site_url, notice: "Site url was successfully updated." }
        format.json { render :show, status: :ok, location: @site_url }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @site_url.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /site_urls/1 or /site_urls/1.json
  def destroy
    @site_url.destroy
    respond_to do |format|
      format.html { redirect_to site_urls_url, notice: "Site url was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # allow user to download url table into Excel file
  def download
    if platinum_user_and_above?
      urls=SiteUrl.where("site is not null")
      workbook = RubyXL::Workbook.new
      worksheet = workbook.worksheets[0]
      worksheet.sheet_name = 'urls'
      header = ["Site","Url","Last Update"]
      index = 0
      worksheet_write_row(worksheet,index,header)
      urls.each do |url|
        next if url.site.nil?
        next if url.site.empty?
        index += 1
        my_row = [url.site, url.url, url.updated_at]
        worksheet_write_row(worksheet,index, my_row)
      end
      file = "Discovered_Urls_" + Time.now.strftime('%m%d%Y') + ".xlsx"
      send_data workbook.stream.string, filename: file, disposition: 'attachment'
    else
      redirect_back :fallback_location => root_path, :alert => "Access denied."
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_site_url
      @site_url = SiteUrl.find(params[:id]) if params[:id]
    end

    # Only allow a list of trusted parameters through.
    def site_url_params
      params.require(:site_url).permit(:site, :url, :req_method, :code)
    end

    def sort_column
      SiteUrl.column_names.include?(params[:sort]) ? params[:sort] : "site"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end

end
