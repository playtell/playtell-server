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

  def contact_invitation(current_user, contact, message)
    @contact = contact
    @message = message
    @app_store_link = APP_STORE_LINK
    @current_user = current_user
    mail(:to => contact.email, :subject => "Keeping in touch")
  end

  def friendship_invitation(current_user, invitee)
    @invitee = invitee
    @current_user = current_user
    mail(:to => invitee.email, :subject => "New friend request")
  end
end