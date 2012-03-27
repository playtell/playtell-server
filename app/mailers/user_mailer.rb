class UserMailer < ActionMailer::Base
  default :from => "semira@playtell.com"
  
  def earlyuser_confirmation(earlyuser)
      mail(:to => earlyuser.email, :subject => "Hello from PlayTell :)")
  end
end
