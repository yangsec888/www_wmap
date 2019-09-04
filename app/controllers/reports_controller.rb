#--
# www_wmap
#
# A  Ruby application for enterprise web application asset tracking
#
# Developed by Sam (Yang) Li, <yang.li@owasp.org>.
#
#++


class ReportsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_report, only: [:show, :edit, :update, :destroy]
  include ReportsHelper

  # Divisional domain portfolio report
  def division
    @reports = Report.where.not(division: [nil,""]).
                      where(category: "domain").
                      order(division: :ASC)
  end

  # Divisional Adware tag report
  def tag
    @reports = Report.where.not(division: [nil,""]).
                      where(category: "adware").
                      order(division: :ASC)
  end

  # GET /reports
  # GET /reports.json
  def index
    @reports = Report.all
  end

  # GET /reports/1
  # GET /reports/1.json
  def show
    report=Report.find(params[:id])
    if report.division.nil? or report.division.empty?
      case report.title
      when "All Domains"
        redirect_to domains_index_path
      when "All Networks"
        redirect_to cidrs_index_path
      when "All Hosts"
        redirect_to hosts_index_path
      when "All Websites"
        redirect_to sites_index_path
      when "All Adware Tags"
        redirect_to tags_index_path
      else
      end
    elsif report.category == "domain"
      redirect_to domains_show_path(division: report.division)
    elsif report.category == "adware"
      redirect_to tags_report_path(division: report.division)
    end
  end

  # GET /reports/new
  def new
    redirect_back :fallback_location => root_path, :alert => "Access denied." unless current_user.admin?
    @report = Report.new
  end

  # GET /reports/1/edit
  def edit
  end

  # provide pre-created divisional domain report in Excel workbook download
  def download
    if platinum_user_and_above?
      file_name = output(params[:division])
      file = Rails.root.join("downloads", file_name)
      if File.exist?(file)
        send_file(
          file,
          filename: file_name,
          type: "application/xlsx",
          disposition: "attachment"
        )
      else
        redirect_to reports_division_path, :flash => {:error => "File not found!"}
      end
    else
      redirect_back :fallback_location => root_path, :alert => "Access denied."
    end
  end

  # provide all domains report in Excel workbook download
  def download_all
    if platinum_user_and_above?
      @domains=Domain.where("name is not null")
      template = Rails.root.join("app","views","reports", "DomainPortfolio-template.xlsx")
      workbook = RubyXL::Parser.parse(template)
      worksheet = workbook.worksheets[0]
      worksheet.sheet_name = 'All'
      index = 0
      @domains.each do |domain|
        next if domain.name.nil?
        next if domain.name.empty?
        index += 1
        if domain.transferable
          my_row = [domain.name, "yes"]
        else
          my_row = [domain.name, "no"]
        end
        worksheet_write_row(worksheet,index, my_row)
      end
      file = "DomainPortfolio-All-" + Time.now.strftime('%m%d%Y') + ".xlsx"
      send_data workbook.stream.string, filename: file, disposition: 'attachment'
    else
      redirect_back :fallback_location => root_path, :alert => "Access denied."
    end
  end

  # provide all adware tag report in Excel workbook download
  def download_tags

  end

  # POST /reports
  # POST /reports.json
  def create
    if current_user.admin?
      @report = Report.new(report_params)
      respond_to do |format|
        if @report.save
          format.html { redirect_to @report, notice: 'Report was successfully created.' }
          format.json { render :show, status: :created, location: @report }
        else
          format.html { render :new }
          format.json { render json: @report.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_back :fallback_location => root_path, :alert => "Access denied."
    end
  end

  # PATCH/PUT /reports/1
  # PATCH/PUT /reports/1.json
  def update
    if  platinum_user_and_above?
      respond_to do |format|
        if @report.update(report_params)
          format.html { redirect_to @report, notice: 'Report was successfully updated.' }
          format.json { render :show, status: :ok, location: @report }
        else
          format.html { render :edit }
          format.json { render json: @report.errors, status: :unprocessable_entity }
        end
      end
    else
      respond_to do |format|
        format.html {
          redirect_back :fallback_location => root_path, :alert => "Access denied."
        }
        format.json {
          render json: { message: 'Access denied.' }
        }
      end

    end
  end

  # DELETE /reports/1
  # DELETE /reports/1.json
  def destroy
    if platinum_user_and_above?
      @report = Report.find(params[:id])
      file_name = output(@report.division)
      file = Rails.root.join("downloads", file_name)
      respond_to do |format|
        format.html {
          if File.exist?(file)
            File.unlink(file)
          end
          @report.destroy
          redirect_to reports_division_path, notice: 'Report '+ file_name + ' was successfully destroyed.'
        }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html {
          redirect_back :fallback_location => root_path, :alert => "Access denied."
        }
        format.json {
          render json: { message: 'Access denied.' }
        }
      end
    end

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_report
      @report = Report.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def report_params
      params.require(:report).permit(:title, :description, :published)
    end
end
