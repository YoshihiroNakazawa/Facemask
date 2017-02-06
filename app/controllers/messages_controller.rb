class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action only: [:index, :create] do
    @conversation = Conversation.find(params[:conversation_id])
  end
  before_action :set_message, only: [:edit, :update, :destroy]

  def index
    if params[:page].present?
      page_index = params[:page]
    else
      page_index = 1
    end
    @messages = @conversation.messages.order(id: :desc).page(page_index)
    @target_user = @conversation.target_user(current_user)
    if @target_user == nil
      redirect_to root_path
    end
    @readonly = true
  end

  def create
    @message = @conversation.messages.build(message_params)
    respond_to do |format|
      if @message.save
        if @message.user_id == current_user.id
          @target_user = @conversation.target_user(current_user)
          @text = render_to_string(partial:'messages/message', locals: { message: @message, conversation: @conversation, read_user: @target_user, readonly: false }, layout: false )
          Pusher.trigger("user_#{@target_user.id}_channel", 'message_user', {
            message: @message.user_id
          })
          Pusher.trigger("user_#{@target_user.id}_channel", 'render_string', {
            message: @text
          })
        end
      end
      @messages = @conversation.messages.order("id").last(10)
      format.js { render :create }
    end
  end

  def update
    @read_user = current_user
    @readonly = ActiveRecord::Type::Boolean.new.type_cast_from_user(params[:readonly])
    @message.read = true
    @message.save
  end

  private
    def message_params
      params.require(:message).permit(:body, :user_id)
    end

    def set_message
      @message = Message.find(params[:id])
    end
end
