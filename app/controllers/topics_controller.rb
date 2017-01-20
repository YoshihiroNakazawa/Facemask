class TopicsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_topic, only: [:show, :edit, :update, :destroy]

  def index
    @user = User.find(params[:user_id])
    @topics = Topic.where(user_id: @user.id).order(created_at: :desc)
  end

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
    @user = current_user
  end

  def create
    @user = User.find(params[:user_id])
    @topics = Topic.where(user_id: @user.id).order(created_at: :desc)
    @topic = Topic.new(topic_params)
    @topic.user_id = current_user.id
    @topic.save
=begin
    respond_to do |format|
      if @topic.save
        format.html { redirect_to @topic, notice: 'Topic was successfully created.' }
      else
        format.html { render :new }
        #format.html { redirect_to new_topic_url }
      end
    end
=end
  end

  def update
    @user = @topic.user
    @topic.update(topic_params)
    @topics = Topic.where(user_id: @user.id).order(created_at: :desc)
=begin
    respond_to do |format|
      if @topic.update(topic_params)
        format.html { redirect_to @topic, notice: 'Topic was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
=end
  end

  def destroy
    @user = User.find(params[:user_id])
    @topic.destroy
    redirect_to user_topics_url(@user)
=begin
    respond_to do |format|
      format.html { redirect_to topics_url, notice: 'Topic was successfully destroyed.' }
    end
=end
  end

  private
    def set_topic
      @topic = Topic.find(params[:id])
    end

    def topic_params
      params.require(:topic).permit(:title, :content)
    end
end
