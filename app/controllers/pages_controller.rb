class PagesController < ApplicationController




  def search
    if params
      titulo=params[:titulo]
      min1=params[:min1]
      max1=params[:max1]

      @search = Series.search do
        if titulo
          fulltext titulo
        end
        

      end
      @series=@search.results
    end
  end

  def about; end

  def contact; end

  def help; end

  def invite; end

  def send_invitation_email
    user = current_user
    to_user = params[:email]
    SeriesMailer.send_invitation(user, to_user).deliver_now
    redirect_to root_path,
                flash: { success: "Se ha enviado la invitacion a #{to_user}" }
  end
end
