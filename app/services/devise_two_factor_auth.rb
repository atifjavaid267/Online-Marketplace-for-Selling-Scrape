# frozen_string_literal: true

# devise two factor authentication
class DeviseTwoFactorAuth
  def initialize(user)
    @user = user
  end

  def send_message
    code = User.generate_otp(@user.otp_secret)
    CodeMailer.send_code(@user).deliver_later

    twilio_number = '+14345108668'
    client = Twilio::REST::Client.new(ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN'])

    client.messages.create(
      from: twilio_number,
      to: '+923081186267',
      body: "Your OTP is #{code}"
    )
  end
end
