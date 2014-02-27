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
      @user.promote_to_admin
      @user.save

      if params[:user].present? and params[:user].has_key? :attachment
        @user.import_character(params[:user]).to_yaml
      end
      redirect_to current_user
    else
      redirect_to new_user_session_path
    end
  end
end
