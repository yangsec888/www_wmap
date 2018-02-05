class UserMailer < ApplicationMailer

  def discovery_completion_notice(receiver, start_time, end_time)
    puts "You're hitting mailer controller..."
    logger.info "You're hitting mailer controller..."
    bcc='yang.li@owasp.org'
    @start_time=start_time.to_s
    @end_time=end_time.to_s
    @my_url="http://wmap.io/sites/show"
    sbj="Your WMAP Discovery is Complete"
    mail(to:receiver, bcc: bcc, subject:sbj)
  end

end
