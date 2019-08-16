#--
# www_wmap
#
# A  Ruby application for enterprise web application asset tracking
#
# Developed by Sam (Yang) Li, <yang.li@owasp.org>.
#
#++

module DomainsHelper
  # make view sortable
  def sortable_domain(column, title = nil, div)
    title ||= column.titleize
    css_class = if column != sort_column
                    nil
                elsif sort_direction == 'asc'
                    'glyphicon glyphicon-chevron-up'
                else
                    'glyphicon glyphicon-chevron-down'
                end
    direction = column == sort_column && sort_direction == 'asc' ? 'desc' : 'asc'
    link_to "#{title} <span class='#{css_class}'></span>".html_safe, division: div, sort: column, direction: direction
  end

  # make view sortable
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

  # domain to site conversion
  def domain_2_site (domain,port=80)
    puts "Perform simple http(s) service detection on domain #{domain}, port #{port}" if @verbose
    begin
      domain=domain.strip
      if port.to_i == 80
        url_1 = "http://www." + domain + "/"
      elsif port.to_i ==443
        url_1 = "https://www" + domain + "/"
      else
        url_1 = "http://www" + domain + ":" + port.to_s + "/"
        url_2 = "https://www" + domain + ":" + port.to_s + "/"
      end
      puts "Please ensure your internet connection is active before running this method: #{__method__}" if @verbose
      checker=Wmap::UrlChecker.new
      if checker.response_code(url_1) != 10000
        puts "Found URL: #{url_1}" if @verbose
        return url_1
      elsif checker.response_code(url_2) != 10000
        puts "Found URL: #{url_2}" if @verbose
        return url_2
      else
        puts "No http(s) service found on: #{domain}:#{port}" if @verbose
        return nil
      end
    rescue => ee
      puts "Exception on method #{__method__}: #{ee}" if @verbose
      return nil
    end
  end

  # generate pie chart data by 'keep' column
  def pie_by_keep(division)
    chart_data = []
    chart_data.push(["Keep, Redirect or Release?", "Count"])
    if division == "all"
      domains = Domain.select("id,keep, COUNT(*) AS total").group("id, keep")
    else
      domains = Domain.where(division: division).select("id,keep, COUNT(*) AS total").group("id, keep")
    end
    domains.group_by(&:keep).each do |k,v|
       chart_data << [k,v.size]
    end
    return chart_data
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
