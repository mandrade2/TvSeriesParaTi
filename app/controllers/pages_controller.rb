class PagesController < ApplicationController
  before_action :authenticate_user!, only: %i[myseries]

  def about;
  end

  def contact;
  end

  def help;
  end

  def invite;
  end

  def myseries
    @user = current_user
    if @user.child?
      @series = Series.joins(:user).where(users: {id: @user.father_id})
    else
      @series = Series.where(user_id: @user.id)
    end
  end

  def send_invitation_email
    user = current_user
    to_user = params[:email]
    SeriesMailer.send_invitation(user, to_user).deliver_now
    redirect_to root_path,
                flash: {success: "Se ha enviado la invitacion a #{to_user}"}
  end
end
