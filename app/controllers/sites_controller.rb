class SitesController < ApplicationController
  before_action :authenticate_user!

  def show
    @dir = Rails.root.join('uploads', current_user.id.to_s)
    @file = @dir.join('sites')
    @uid = current_user.id
  end



end
