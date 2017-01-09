class UsersController < ApplicationController
  
  #before_action :authenticate_user!
  #before_action :admin_only
  #helper_method :sort_column, :sort_direction

  def index
    @users = User.order(sort_column + " " + sort_direction)
    filtering_params(params).each do |key, value|
      next if value.nil?
      @users = @users.public_send(key, value) if value.present?
    end
  end

  def show
    @user = User.find(params[:id])
    unless current_user.admin?
      unless @user == current_user
        redirect_to :back, :alert => "Access denied."
      end
    end
  end

  def update
    @user = User.find(params[:id])
    # add the following line to bypass password validations in Rails 4.2
    @user.password = "!@#$%^&*----"
    #render plain: secure_params.inspect
#=begin
    if @user.update!(secure_params)
      redirect_to users_path, :notice => "User updated successfully."
    else
      redirect_to users_path, :alert => "Unable to update user."
    end
#=end
  end

  def report
    # Respond to the Download request
      index
      wb = RubyXL::Workbook.new
      download = wb.worksheets[0]
      download.sheet_name = 'IDM User Report'
      # set the header row
      download.add_cell(0,0, "Name")
      download.add_cell(0,1, "Email")
      download.add_cell(0,2, "Department")
      download.add_cell(0,3, "Role")
      # fill the rest of the rows
      my_row=0
      @users.each do |aa|
          my_row += 1
          next if aa.nil?
          download.add_cell(my_row,0, aa['username'].titleize)
          download.add_cell(my_row,1, aa['email'])
          download.add_cell(my_row,2, aa['department'])
          download.add_cell(my_row,3, aa['role'])
          unless aa['equinix_id'].nil?
            download.add_cell(my_row,5, "Yes")
          end
      end
      send_data wb.stream.string, filename: "IDM_User.xlsx", disposition: 'attachment'
      wb = nil

  end

  private


  def destroy
    user = User.find(params[:id])
    user.destroy
    redirect_to users_path, :notice => "User deleted."
  end

  def filtering_params(params)
    params.slice(:department)
  end

  def secure_params
    params.require(:user).permit(:role)
    #['role', 'admin']
  end

  def sort_column
    User.column_names.include?(params[:sort]) ? params[:sort] : "username"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

end
