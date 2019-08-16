#--
# www_wmap
#
# A  Ruby application for enterprise web application asset tracking
#
# Developed by Sam (Yang) Li, <yang.li@owasp.org>.
#
#++

module SitesHelper
  # make table column sortable by user
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

  # write an worksheet row
  def worksheet_write_row(worksheet, index, my_row)
    puts "Writing record into the spreadsheet: #{my_row}"
    (0...my_row.count).map do |col|
      worksheet.add_cell(index, 0, '') if worksheet[index].nil?
      worksheet.add_cell(index,col,'') if worksheet[index][col].nil?
      puts "Write to cell [#{index},#{col}]: #{my_row[col]}"
      worksheet[index][col].change_contents(my_row[col])
    end
  end

end
