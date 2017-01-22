class TopController < ApplicationController
  before_action :authenticate_user!

  def index
    @user = current_user;
    @topics = Topic.where(user_id: @user.id).order(created_at: :desc)
  end
end
