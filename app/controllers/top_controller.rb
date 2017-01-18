class TopController < ApplicationController
  before_action :authenticate_user!

  def index
    @user = current_user;
    redirect_to user_topics_path( @user )
  end
end
