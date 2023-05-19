class CodeMailer < ApplicationMailer
  def send_code(user)
    @greeting = 'Hi'
    @code = User.generate_otp(user.otp_secret)
    mail(to: user.email, subject: 'OTP Code')
  end
end
