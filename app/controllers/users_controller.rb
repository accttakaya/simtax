class UsersController < ApplicationController

  def edit
  end

  def update
    if current_user.update(user_params)
      redirect_to mypage_path(current_user)
    else
      render :edit
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :acct)
  end
    
end
