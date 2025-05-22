class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:offline]
  
  def offline
    render layout: 'minimal'
  end
end
