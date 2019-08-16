#--
# www_wmap
#
# A  Ruby application for enterprise web application asset tracking
#
# Developed by Sam (Yang) Li, <yang.li@owasp.org>.
#
#++

module ReportsHelper
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

  # Determine download file name based on division
  def output(division)
    return "DomainPortfolio-" + division.strip + "-output.xlsx"
  end

end
