class ApplicationMailer < ActionMailer::Base
  default from: "Enwords<#{ENV['GMAIL_USERNAME']}>"
  layout 'mailer'

  def test_email(email)
    mail(to: email, subject: 'Welcome to My Awesome Site', body: 'Хорошего дня')
  end

  def feedback_mail(email)
    mail(to: email, subject: 'Нам нужен твой отзыв')
  end
end
