#--
# www_wmap
#
# A  Ruby application for enterprise web application asset tracking
#
# Developed by Sam (Yang) Li, <yang.li@owasp.org>.
#
#++


module ApplicationHelper


  def full_title(page_title)
    base_title = " Web Mapper Online"
    if page_title.empty?
       base_title
    else
       "#{base_title} | #{page_title}"
    end
  end

private
  def sort_column
    User.column_names.include?(params[:sort]) ? params[:sort] : "username"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

end
