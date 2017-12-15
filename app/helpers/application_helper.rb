#--
# www_wmap
#
# A  Ruby application for enterprise web application asset tracking
#
# Developed by Yang Li, <yang.li@owasp.org>. Creative Common License
#
#++



module ApplicationHelper

 def sortable(column, title = nil)
    title ||= column.titleize
    css_class = if column != sort_column
                    nil
                elsif sort_direction == 'asc'
                    'glyphicon glyphicon-chevron-up'
                else
                    'glyphicon glyphicon-chevron-down'
                end
    direction = column == sort_column && sort_direction == 'asc' ? 'desc' : 'asc'
    link_to "#{title} <span class='#{css_class}'></span>".html_safe, sort: column, direction: direction
 end

 def full_title(page_title)
   base_title = "OWASP Web Mapper Demo" 
	 if page_title.empty?
       base_title
  	 else
       "#{base_title} | #{page_title}"
  	 end
   end

end
