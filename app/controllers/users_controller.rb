class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    if params[:page].present?
      page_index = params[:page]
    else
      page_index = 1
    end
    if params[:user_find_form].present?
      @users = User.where("name LIKE ?","%#{params[:user_find_form][:name]}%").order("id").page(page_index)
    else
      @users = User.all.order("id").page(page_index)
    end
=begin
    if params[:user_find_form].present?
      @users = User.find_by_sql(["SELECT users.*,
        CASE WHEN A.id IS NULL THEN FALSE ELSE TRUE END AS follower,
        CASE WHEN B.id IS NULL THEN FALSE ELSE TRUE END AS followed
        FROM users
        LEFT OUTER JOIN relationships AS A ON (A.follower_id=users.id AND A.followed_id=?)
        LEFT OUTER JOIN relationships AS B ON (B.followed_id=users.id AND B.follower_id=?)
        WHERE users.id<>? AND name LIKE ?",current_user.id,current_user.id,current_user.id,"%#{params[:user_find_form][:name]}%"])
    else
      @users = User.find_by_sql(["SELECT users.*,
        CASE WHEN A.id IS NULL THEN FALSE ELSE TRUE END AS follower,
        CASE WHEN B.id IS NULL THEN FALSE ELSE TRUE END AS followed
        FROM users
        LEFT OUTER JOIN relationships AS A ON (A.follower_id=users.id AND A.followed_id=?)
        LEFT OUTER JOIN relationships AS B ON (B.followed_id=users.id AND B.follower_id=?)
        WHERE users.id<>?",current_user.id,current_user.id,current_user.id])
    end
=end
  end

  def show
    @user = User.find(params[:id])
  end
end
