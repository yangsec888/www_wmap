#--
# www_wmap
#
# A  Ruby application for enterprise web application asset tracking
#
# Developed by Yang Li, <yang.li@owasp.org>. Creative Common License
#
#++

class ReporterController < ApplicationController

  before_action :authenticate_user!, except: [:create]
  before_action :init_reporter_env
  helper_method :sort_column, :sort_direction

  def init_reporter_env
    # @candidate_list = YAML.load_file(Rails.root.join('config','candidate_list.yml'))
    candidate_array = Candidate.all.order(:name).map { |c| [c['name'], [c['email'], c['status']]] }
    @candidate_list = {}
    candidate_array.each do |key, value|
      @candidate_list.merge!({key => value})
    end
  	@event = YAML.load_file(Rails.root.join('config','event.yml'))
  end

  def index
    if params[:category].nil?
      @records = Reporter.search(params[:name], '').paginate(page: params[:page], per_page: 15).order(sort_column + ' ' + sort_direction)
    else
      @records = Reporter.search(params[:name], params[:category][0]).paginate(page: params[:page], per_page: 15).order(sort_column + ' ' + sort_direction)
    end
  end

  def create
    @record = Reporter.new
    @record.candidate = params[:name][0]
    @record.candidate_email = @candidate_list[params[:name][0]][0]
    @record.quiz_eventid = @event
    @record.quiz_category = params[:quiz_category]
    @record.quiz_score = params[:score]
    @record.save
    redirect_to root_url, notice: 'Record saved!'
  end

  def check
    category = params[:category][0]
    eventid = params[:eventid][0]
    @recorded_candidates = Reporter.where(quiz_category: category, quiz_eventid: eventid).distinct.pluck(:candidate)
    @recorded_candidates.each do |name|
      @candidate_list.delete(name)
    end
  end

  def save
    file_content = params[:file_tag]
    @file = Rails.root.join('config', 'candidate_list.yml')
    file = File.open(@file, 'w+')
    file.write(file_content)
    file.close
    redirect_to reporter_list_path, notice: 'The list file has been saved.'
  end

  def list
    @list_file = Rails.root.join('config', 'candidate_list.yml')
  end

  private

  def sort_column
    Reporter.column_names.include?(params[:sort]) ? params[:sort] : 'candidate'
  end

  def sort_direction
    %w(asc desc).include?(params[:direction]) ? params[:direction] : 'asc'
  end

end
