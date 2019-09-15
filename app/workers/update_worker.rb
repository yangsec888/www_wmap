#--
# www_wmap
#
# A  Ruby application for enterprise web application asset tracking
#
# Developed by Sam (Yang) Li, <yang.li@owasp.org>.
#
#++

class UpdateWorker
  include Wmap::Utils
  include Sidekiq::Worker
  sidekiq_options retry: false

  def on_complete(status,params)
    puts "Sending out email notice to: #{receiver}"
    end_time=Time.now.to_s
    receiver=User.find(uid).email
    UserMailer.portfolio_update_completion_notice(receiver, end_time).deliver_later
  end

  def perform(file,file_type,uid)
    start_time = Time.now.to_s
    portfolio = parse_domain_portfolio_workbook(file)
    puts "Porfolio data structure: #{portfolio.inspect}"
    db_update_domain(portfolio,file_type,uid)  #update db
    wmap_update(portfolio)          #sync up with wmap gem data file
    db_update_zone_transferable(portfolio) #update transferable field in the domain table
    rpt=generate_report(file,file_type, portfolio)           #generate the Excel report based on what wmap know-how
    if rpt
      db_update_report(file,file_type)
    end
    end_time = Time.now.to_s
    receiver = User.find(uid).email
    mail = UserMailer.portfolio_update_completion_notice(file_type, receiver, start_time, end_time)
    mail.deliver_later
  end

  # Parsing the domain portfolio workbook from upload
	def parse_domain_portfolio_workbook (file)
		#begin
			puts "Start parsing Excel workbook file: #{file}"
			portfolio=Hash.new
			workbook = RubyXL::Parser.parse(file)
			worksheet=workbook.worksheets.first
			row_cnt=0
			header=Array.new
			user_index=0
			worksheet.count.times  do |row|
				row_cnt+=1
        break if row_cnt > 5000   # Max read upto 5000 rows in the spreadsheet
				puts "Parsing workbook row: #{row_cnt}"
				entry=Array.new
				# Processing Header Row
        col_max_size = (worksheet[row].size > 9)? 9 : worksheet[row].size   # Max read upto 7 columns in the spreadsheet
				if row_cnt==1
					0.upto(col_max_size) do |col|
						if worksheet[row][col].nil?
							header.push(nil)
						else
							header.push(worksheet[row][col].value.to_s.strip)
						end
					end
					next
				else
					0.upto(col_max_size) do |col|
						if worksheet[row][col].nil?
							entry.push(nil)
						else
							entry.push(worksheet[row][col].value.to_s.strip)
						end
					end
					user_index += 1
				end
				record = header.zip(entry).to_h.reject {|k,v| k.nil? or k.empty?}
				puts "User record: #{record}" if @verbose
				portfolio[user_index] = record unless portfolio.key?(user_index)
			end
			workbook=nil
			return portfolio
	#	rescue => ee
	#		puts "Exception on method #{__method__}: #{ee}"
	#	end
	end

  # update domain table based on the upload
  def db_update_domain(portfolio,file_type,uid)
    puts "Update domain table ..."
    db = Sequel.connect(ENV['DATABASE_URL'])
    domains = db[:domains]
    portfolio.each do |index, record|
      my_domain = record["Domain Name"]
      next if my_domain.nil?
      next if my_domain.empty?
      next if my_domain.strip.empty?
      puts "Update domain record: #{record.values}"
      if domains.where(:name => my_domain).count == 0
        domains.insert(name: my_domain, division: file_type, user_id: uid, keep: record['Keep, Redirect or Release?'], \
          imprint: record['Imprint'], current_redirect: record['Current Redirect'], new_redirect: record['New Redirect'], \
          created_at: Time.now, updated_at: Time.now)
      else
        domains.where(:name => my_domain).update(division: file_type, user_id: uid, keep: record["Keep, Redirect or Release?"], \
          imprint: record["Imprint"], current_redirect: record["Current Redirect"], new_redirect: record["New Redirect"], updated_at: Time.now)
      end
      puts "Domain update complete with: #{my_domain}"
    end
    db.disconnect
  end

  # update wmap gem data file
  def wmap_update(portfolio)
    tracker=Wmap::DomainTracker.instance
    portfolio.each do |index, record|
      tracker.add(record["Domain Name"]) unless (record["Domain Name"].nil? or record["Domain Name"].empty?)
    end
    tracker.save!
    tracker=nil
  end

  # update domain zone file transferable value into db
  def db_update_zone_transferable(portfolio)
    puts "Upate the zone transferable flag in the domain table. "
    db = Sequel.connect(ENV['DATABASE_URL'])
    domains = db[:domains]
    tracker=Wmap::DomainTracker.instance
    portfolio.each do |index, record|
      my_domain = record["Domain Name"]
      next if my_domain.nil?
      next if my_domain.empty?
      next if my_domain.strip.empty?
      zone_transfer = tracker.known_internet_domains[my_domain]
      if zone_transfer
        puts "#{my_domain} is transferable"
      else
        puts "#{my_domain} is not transferable"
      end
      puts "Update the transferable flag: #{zone_transfer}"
      domains.where(name: my_domain).update(transferable: zone_transfer)
    end
    tracker=nil
    db.disconnect
  end

  # update domain report download file name into db
  def db_update_report(file,file_type)
    puts "Upate the report table: #{file}, #{file_type} "
    db = Sequel.connect(ENV['DATABASE_URL'])
    reports = db[:reports]
    my_title = "Domain Portfolio - " + file_type
    desc = "Divisional workbooks - " + file_type + " Domain Portfolio. "
    file_name = file.split("/")[-1].split(".")[0] + "-output.xlsx"
    if reports.where(:division => file_type).count == 0
      reports.insert(title: my_title, division: file_type, department: "IT", created_at: Time.now, updated_at: Time.now, \
        attachment_url: file_name, description: desc, published: true)
    else
      reports.where(:division => file_type).update(updated_at: Time.now, attachment_url: file_name, description: desc, \
        published: true)
    end
    db.disconnect
  end

  # generate divisional report
  def generate_report(file, file_type, portfolio)
    puts "Generating divisional domain portfolio report: #{portfolio}"
    file_name = file.split("/")[-1].split(".")[0]
    report = Rails.root.join('downloads',file_name + "-output.xlsx")
    workbook = RubyXL::Parser.parse(file)
    worksheet=workbook.worksheets.first
    worksheet.sheet_name = file_type
    if portfolio.size >= 1
      header_row = portfolio[1].keys + ["Website","Primary IP","Port","Hosting Status","Server","Response Code","MD5 Fingerprint","Detected Redirection","Timestamp", "WordPress", "WordPress Version"]
      worksheet_write_row(worksheet,0,header_row)
    end
    portfolio.each do |index, record|
      puts "Processing row: #{index}, #{record}"
      my_row=Array.new
      my_domain = record.values[0]
      puts "Processing domain: #{my_domain}"
      if is_domain?(my_domain)
        my_row = record.values + site_lookup(my_domain) + wp_site_lookup(my_domain)
      else
        my_row = record.values + [nil]*10
      end
      # write my_row into worksheet[row]
      worksheet_write_row(worksheet, index, my_row)
    end
    workbook.write(report)
    workbook = nil
    return true
  rescue => err
    puts "Exception on method #{__method__}: #{err}"
    return false
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

  # Lookup the site store for a domain; then return the fingger print info of the site
  def site_lookup(domain)
    tracker=Wmap::SiteTracker.instance
    tracker.verbose=false
    #first order search
    tracker.known_sites.each do |key,val|
      if key.include?(domain.strip.downcase) && key.include?("https")
        tracker=nil
        return [key] + val.values
      end
    end
    #second order search
    tracker.known_sites.each do |key,val|
      if key.include?(domain.strip.downcase)
        tracker=nil
        return [key] + val.values
      end
    end
    tracker=nil
    return [nil]*9
  end

  # look up the wp site data store for a domain; then return the wp finger print info: [is_wp?,wp_ver]
  def wp_site_lookup(domain)
    tracker=Wmap::WpTracker.new(:verbose=>false)
  	# first order
  	tracker.known_wp_sites.each do |key,val|
  		if key.include?(domain.strip.downcase) && val
  			ver=tracker.wp_ver(key)
  			tracker=nil
  			return [val,ver]
  		end
  	end
    # second order
    tracker.known_wp_sites.each do |key,val|
      if key.include?(domain.strip.downcase) && key.include?("https") && val
        tracker=nil
        return [val,nil]
      end
    end
    # third order
    tracker.known_wp_sites.each do |key,val|
      if key.include?(domain.strip.downcase)
        tracker=nil
        return [val,nil]
      end
    end
    tracker=nil
    return [nil,nil]
  end

end
