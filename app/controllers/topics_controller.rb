class TopicsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_topic, only: [:show, :edit, :update, :destroy]

=begin
  def index
    @user = User.find(params[:user_id])
    @topics = Topic.where(user_id: @user.id).order(created_at: :desc)
  end
=end

  def show
    @comment = @topic.comments.build
    @comments = @topic.comments
    Notification.find(params[:notification_id]).update(read: true) if params[:notification_id]
  end

  def new
    @user = current_user
    @topic = Topic.new
  end

  def edit
    #@user = current_user
  end

  def create
    @user = User.find(params[:user_id])
    @topics = Topic.where(user_id: @user.id).order(created_at: :desc)
    @topic = Topic.new(topic_params)
    @topic.user_id = current_user.id
    @topic.save
  end

  def update
    #@user = @topic.user
    @topic.update(topic_params)
    @topics = Topic.where(user_id: @topic.user.id).order(created_at: :desc)
  end

  def destroy
    uid = @topic.user.id
    @topic.destroy
    @topics = Topic.where(user_id: uid).order(created_at: :desc)
  end

  private
    def set_topic
      @topic = Topic.find(params[:id])
    end

    def topic_params
      params.require(:topic).permit(:title, :content)
    end
end
