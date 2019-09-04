class UserMailer < ApplicationMailer

  def discovery_completion_notice(receiver, start_time, end_time)
    puts "You're hitting mailer controller..."
    logger.info "You're hitting mailer controller..."
    bcc='yang.li@owasp.org'
    @start_time=start_time.to_s
    @end_time=end_time.to_s
    @my_url="https://wmap.io/sites/index"
    sbj="Your WMAP Discovery is Complete"
    mail(to:receiver, bcc: bcc, subject:sbj)
  end

  def portfolio_update_completion_notice(file_type, receiver, start_time, end_time)
    puts "You're hitting mailer controller..."
    logger.info "You're hitting mailer controller..."
    bcc='yang.li@owasp.org'
    @division = file_type
    @start_time=start_time.to_s
    @end_time=end_time.to_s
    @my_url="https://wmap.io/reports/division"
    sbj="Divisional Domain Portfolio Update Job Is Complete"
    mail(to:receiver, bcc: bcc, subject:sbj)
  end

end
