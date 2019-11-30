class ApplicationMailer < ActionMailer::Base
  default from: "Enwords<#{ENV['GMAIL_USERNAME']}>"
  layout 'mailer'

  def test_email(email)
    mail(to: email, subject: 'Welcome to My Awesome Site', body: 'Хорошего дня')
  end

  def feedback_email(email)
    mail(to: email, subject: 'Нам нужен твой отзыв')
  end

  def telegram_bot_email(email)
    mail(to: email, subject: 'Попробуй бота для изучения английского')
  end
end
