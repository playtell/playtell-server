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
    # @current_user = current_user
    @contact = contact
    @message = message
    puts "Message: #{message}"
    mail(:to => contact.email, :subject => "Join #{current_user.firstname} #{current_user.lastname} on PlayTell!")
  end
end