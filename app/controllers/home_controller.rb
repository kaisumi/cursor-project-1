class HomeController < ApplicationController
  def index
    if user_signed_in?
      redirect_to dashboard_path
    else
      render :index
    end
  end

  def dashboard
    redirect_to root_path unless user_signed_in?
    @user = current_user
  end
end
