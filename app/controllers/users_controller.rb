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
      if params[:user].present? and params[:user].has_key? :attachment
        f = params[:user][:attachment]

        puts f
        c = Import.import_file(f.read)
        c.user_id = current_user.id
        c.save
      end
      redirect_to current_user
    else
      redirect_to new_user_session_path
    end
  end
end
