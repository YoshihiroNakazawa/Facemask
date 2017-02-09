class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # before_actionで下で定義したメソッドを実行
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :current_notifications, if: :signed_in?
  before_action :create_search_form, if: :signed_in?

  #変数PERMISSIBLE_ATTRIBUTESに配列[:name]を代入
  PERMISSIBLE_ATTRIBUTES = %i(name avatar avatar_cache)

  def after_sign_out_path_for resource
    new_user_session_path
  end

  protected

    #deviseのストロングパラメーターにカラム追加するメソッドを定義
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: PERMISSIBLE_ATTRIBUTES)
      devise_parameter_sanitizer.permit(:account_update, keys: PERMISSIBLE_ATTRIBUTES)
    end

    def current_notifications
      @notifications_count = Notification.where(user_id: current_user.id).where(read: false).count
    end

    def create_search_form
      if params[:user_find_form].present?
        @form = UserFindForm.new(params.require(:user_find_form))
      else
        @form = UserFindForm.new
      end
    end
end
