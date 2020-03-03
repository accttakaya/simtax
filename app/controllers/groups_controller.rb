class GroupsController < ApplicationController

  def index
  end
  
  def new
    @group = Group.new
    @group.users << current_user
  end

  def create
    
    @group = Group.new(group_params)
    
    if @group.save
      redirect_to mypage_path(current_user), notice: 'グループを作成しました'
    else
      render :new
    end
  end

  def edit
    @group = Group.find(params[:id])
  end

  def update
    @group = Group.find(params[:id])
    if @group.update(group_params)
      redirect_to root_path, notice: 'グループを更新しました'
    else
      render :edit
    end
  end

  def destroy
    group = Group.find(params[:id])
    group.destroy
  end


  private
  def group_params
    group_params1 = params.require(:group).permit(:name, user_ids:[])
    group_params1["user_ids"].push(current_user.id)
    return group_params1
  end

end
