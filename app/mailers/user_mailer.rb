class UserMailer < ActionMailer::Base
  default :from => "semira@playtell.com"
  
  def earlyuser_welcome(earlyuser)
      @user = earlyuser
      mail(:to => @user.email, :subject => "Hello from PlayTell :)")
  end
  
  def betauser_welcome(betauser)
      @user = betauser
      mail(:to => @user.email, :subject => "PlayTell Beta - quick iPad setup")
  end
  
  def betainvitee_welcome(betauser, invitee)
      @invitee = invitee
      @inviter = betauser
      mail(:to => @user.email, :subject => betauser.username + " got you early access to PlayTell :)")
  end
end
