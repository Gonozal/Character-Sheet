class UsersController < ApplicationController
  def index
    if user_signed_in?
      redirect_to current_user
    else
      redirect_to new_user_session_path
    end
  end

  def show
    if user_signed_in?
      @user = current_user
    else
      redirect_to new_user_session_path
    end
  end

  def update
    if user_signed_in?
      @user = current_user

      if params[:user].present? and params[:user].has_key? :attachment
        begin
          @user.import_character(params[:user]).to_yaml
        rescue => e
          logger.warn e
          flash[:error] = "There was an error importing your character"
        end
      end

      redirect_to current_user
    else
      redirect_to new_user_session_path
    end
  end
end
