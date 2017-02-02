class MessagesController < ApplicationController
  before_action only: [:index, :create] do
    @conversation = Conversation.find(params[:conversation_id])
  end
  before_action :set_message, only: [:edit, :update, :destroy]

  def index
    @messages = @conversation.messages
    @target_user = @conversation.target_user(current_user)
    @readonly = true
  end

  def create
    @messages = @conversation.messages.last(10)
    @message = @conversation.messages.build(message_params)
    respond_to do |format|
      @message.save
      if @message.user_id == current_user.id
        @target_user = @conversation.target_user(current_user)
        @text = render_to_string(partial:'messages/index', locals: { messages: @messages, conversation: @conversation, read_user: @target_user, readonly: false }, layout: false )
        Pusher.trigger("user_#{@target_user.id}_channel", 'message_user', {
          message: @message.user_id
        })
        Pusher.trigger("user_#{@target_user.id}_channel", 'render_string', {
          message: @text
        })
      end
      format.js { render :index }
    end
  end

  def update
    @conversation = @message.conversation
    @readonly = ActiveRecord::Type::Boolean.new.type_cast_from_user(params[:readonly])
    @target_user = @conversation.target_user(current_user)
    @message.read = true;
    respond_to do |format|
      @message.save
      if @readonly
        @messages = @conversation.messages
      else
        @messages = @conversation.messages.last(10)
      end
      format.js { render :index }
    end
  end

  private
    def message_params
      params.require(:message).permit(:body, :user_id)
    end

    def set_message
      @message = Message.find(params[:id])
    end
end
