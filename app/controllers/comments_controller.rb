class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_comment, only: [:edit, :update, :destroy]

  def index
    @topic = Topic.find(params[:topic_id])
    @comment = @topic.comments.build
    @comments = @topic.comments.order("id")
    respond_to do |format|
      format.js { render :index }
    end
  end

  def create
    @comment = current_user.comments.build(comment_params)
    @topic = @comment.topic
    @notification = @comment.notifications.build(user_id: @topic.user.id )
    respond_to do |format|
      if @comment.save
        unless @comment.topic.user_id == current_user.id
          Pusher.trigger("user_#{@comment.topic.user_id}_channel", 'comment_created', {
            message: 'あなたの作成したトピックにコメントが付きました'
          })
        end
        Pusher.trigger("user_#{@comment.topic.user_id}_channel", 'notification_created', {
          unread_counts: Notification.where(user_id: @comment.topic.user.id, read: false).count
        })
      end
      format.js { render :create }
    end
  end

  def edit
  end

  def update
    @topic = @comment.topic
    @comment_new = @topic.comments.build
    @comment.update(comment_params)
    respond_to do |format|
      format.js { render :update }
    end
  end

  def destroy
    @topic = @comment.topic
    @comment.destroy
    @comments = @topic.comments.order("id")
    respond_to do |format|
      format.js { render :destroy }
    end
  end

  private
    def comment_params
      params.require(:comment).permit(:topic_id, :content)
    end

    def set_comment
      @comment = Comment.find(params[:id])
    end
end
