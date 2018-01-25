class UserMailer < ApplicationMailer

  def discovery_completion_notice(receiver, start_time, end_time)
    @start_time=start_time.to_s
    @end_time=end_time.to_s
    sbj="Your Discovery Is Complete"
    mail(to:receiver, subject:sbj)
  end

end
