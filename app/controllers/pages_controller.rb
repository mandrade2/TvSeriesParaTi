class PagesController < ApplicationController
  def about;
  end

  def contact;
  end

  def help;
  end

  def invite;
  end

  def send_invitation_email
    user = current_user
    to_user = params[:email]
    SeriesMailer.send_invitation(user, to_user).deliver_now
    redirect_to root_path,
                flash: {success: "Se ha enviado la invitacion a #{to_user}"}
  end
end
