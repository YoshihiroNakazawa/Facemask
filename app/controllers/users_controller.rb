class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = User.all
    @users = @users.where( "name LIKE ?", "%#{params[:user_find_form][:name]}%" ) if params[:user_find_form][:name].present?
  end

  def show
    @user = User.find(params[:id])
  end
end
