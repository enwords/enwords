class ApplicationMailer < ActionMailer::Base
  default from: 'support@enwords.tk'
  layout 'mailer'

  def test_email(email)
    mail(to: email, subject: 'Welcome to My Awesome Site', body: 'Хорошего дня')
  end
end
