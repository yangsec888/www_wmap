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

  # Reload site table based on the WMAP site data file
  def site_table_reload(uid=current_user.id)
    puts "Update the site table ..."
    db = Sequel.connect(YAML.load(File.read(File.join(::Rails.root, 'config', 'database.yml')))[::Rails.env] || 'development')
    puts "Database connection success. "
    site_table = db[:sites]
    site_table.truncate
    puts "site table truncate success."
    tracker=Wmap::SiteTracker.instance
    tracker.known_sites.each do |key, val|
      puts "Insert record for site: #{key}"
      site_table.insert(site: key,  ip: val['ip'], port: val['port'], redirection: val['redirection'], \
        md5: val['md5'], server: val['server'], status: val['status'], code: val['code'], \
        user_id: uid, created_at: Time.now, updated_at: Time.now)
    end
    tracker=nil
    db = nil
    puts "Update complete. "
  end


end
