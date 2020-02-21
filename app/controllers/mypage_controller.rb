class MypageController < ApplicationController

  def show
    @number = params[:id]
  end
end
