class UserMailer < ActionMailer::Base
  default :from => "Semira@playtell.com"
  
  def earlyuser_welcome(earlyuser)
      @user = earlyuser
      mail(:to => @user.email, :subject => "Hello from PlayTell :)")
  end
  
  def betauser_welcome(betauser)
      @user = betauser
      mail(:to => @user.email, :subject => "PlayTell Alpha - how to get the app")
  end
  
  def betainvitee_welcome(betauser, invitee)
      @invitee = invitee
      @inviter = betauser
      mail(:to => @invitee.email, :subject => betauser.username.capitalize + " got you early access to PlayTell :)")
  end

  def contact_invitation(contact, body)
    @contact = contact
    @current_user = current_user
    @body = body
    mail(:to => contact.email, :subject => "Join #{current_user.first_name} #{current_user.last_name} on PlayTell!")
  end
end
