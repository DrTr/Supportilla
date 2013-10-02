ActionMailer::Base.smtp_settings = {
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :domain               => "domain",
  :user_name            => "username",
  :password             => "secret",
  :authentication       => "plain",
  :enable_starttls_auto => true
}

ActionMailer::Base.default_url_options host: "localhost:3000"
ActionMailer::Base.default from: "noreply@supportilla.com"
