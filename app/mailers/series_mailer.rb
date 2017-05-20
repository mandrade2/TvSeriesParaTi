class SeriesMailer < ApplicationMailer
  default from: 'tvseriesparati@gmail.com'

  def send_invitation(from_user, to_email)
    @user = from_user
    @url = 'http://localhost:3000'
    mail(to: to_email, from: from_user.email, subject: 'TvSeries4u invitation')
  end
end
