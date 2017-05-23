class SeriesMailer < ApplicationMailer
  default from: 'tvseriesparati@gmail.com'

  def send_invitation(from_user, to_email)
    @user = from_user
    @url = 'http://localhost:3000'
    mail(to: to_email, from: from_user.email, subject: 'TvSeries4u invitation')
  end

  def send_recommendation(from_user, to_email, series)
    @user = from_user
    @url = series_url(series)
    @series = series
    @root_url = root_url
    mail(to: to_email, from: from_user.email,
         subject: 'TvSeries4u recommendation')
  end
end
