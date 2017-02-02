class ConversationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = User.all
    #@conversations = Conversation.where("conversations.sender_id=? OR conversations.recipient_id=?",current_user.id,current_user.id)
    @conversations = Conversation.find_by_sql(
      ["SELECT A.*,COALESCE(B.send_count,0) AS send_count,B.last_send_time,COALESCE(C.recieve_count,0) AS recieve_count,C.last_recieve_time,COALESCE(D.unread_count,0) AS unread_count FROM conversations AS A
      LEFT OUTER JOIN (SELECT conversation_id,COUNT(*) AS send_count,MAX(created_at) AS last_send_time FROM messages WHERE user_id=? GROUP BY conversation_id) AS B ON(B.conversation_id=A.id)
      LEFT OUTER JOIN (SELECT conversation_id,COUNT(*) AS recieve_count,MAX(created_at) AS last_recieve_time FROM messages WHERE user_id<>? GROUP BY conversation_id) AS C ON(C.conversation_id=A.id)
      LEFT OUTER JOIN (SELECT conversation_id,COUNT(*) AS unread_count FROM messages WHERE user_id<>? AND read=false GROUP BY conversation_id) AS D ON(D.conversation_id=A.id)
      WHERE (A.sender_id=? OR A.recipient_id=?) AND (B.send_count>0 OR C.recieve_count>0 OR 0=0)
      ORDER BY CASE WHEN COALESCE(D.unread_count,0)<>0 THEN 0 ELSE 1 END,
      CASE WHEN C.last_recieve_time IS NULL THEN '-infinity' ELSE C.last_recieve_time END DESC,
      CASE WHEN B.last_send_time IS NULL THEN '-infinity' ELSE B.last_send_time END DESC",
      current_user.id,current_user.id,current_user.id,current_user.id,current_user.id]
    )
  end

  def create
    if Conversation.between(params[:sender_id], params[:recipient_id]).present?
      @conversation = Conversation.between(params[:sender_id], params[:recipient_id]).first
    else
      @conversation = Conversation.create!(conversation_params)
    end
    #redirect_to conversation_messages_path(@conversation)
    redirect_to conversation_path(@conversation)
  end

  def show
    @conversation = Conversation.find(params[:id])
    @messages = @conversation.messages.last(10)
    @message = @conversation.messages.build
    @target_user = @conversation.target_user(current_user)
    @readonly = false
  end

  private
    def conversation_params
      params.permit(:sender_id, :recipient_id)
    end
end
