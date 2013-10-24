ActionMailer::Base.smtp_settings = {
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :domain               => "gmail.com",
  :user_name            => "username",
  :password             => "password",
  :authentication       => "plain",
  :enable_starttls_auto => true
}

ActionMailer::Base.default from: "username@gmail.com"
