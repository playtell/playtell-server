ActionMailer::Base.smtp_settings = {
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :domain               => "playtell.com",
  :user_name            => "semira@playtell.com",
  :password             => "playtell",
  :authentication       => "plain",
  :enable_starttls_auto => true
}