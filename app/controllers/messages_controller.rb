class MessagesController < ApplicationController
  before_action do
    @conversation = Conversation.find(params[:conversation_id])
  end
  before_action :set_message, only: [:edit, :update, :destroy]

  def index
    @messages = @conversation.messages
    @conversation.messages.where("user_id <> ? AND read = false", current_user.id).update_all(read: :true)
=begin
    if @messages.length > 10
      @over_ten = true
      @messages = @messages[-10..-1]
    end

    if params[:m]
      @over_ten = false
      @messages = @conversation.messages
    end

    if @messages.last
      if @messages.last.user_id != current_user.id
       @messages.last.read = true
      end
    end

    @message = @conversation.messages.build
=end
  end

  def create
    @message = @conversation.messages.build(message_params)
    respond_to do |format|
      if @message.save
        #format.html { redirect_to conversation_path(@conversation), notice: 'メッセージを送信しました。' }
        format.js { render :index }
        unless @message.user_id == current_user.id
          Pusher.trigger("user_#{@message.user_id}_channel", 'message_created', {
            message: @message
          })
        end
      else
        format.html { render :index }
      end
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
