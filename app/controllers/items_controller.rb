class ItemsController < ApplicationController
  
  def index
    @items = Item.includes(:user).order("created_at DESC").page(params[:page]).per(5)
  end

  def new
    @item = Item.new
    @item.images.new
  end
  
  def create
    @item = Item.new(item_params)
    if 
      @item.save
      @item.errors.messages
      redirect_to root_path  notice: "出品が完了しました"
    else
      render :new
    end
  end

  def show
    @item = Item.find(params[:id])
    @user = @item.user
    @category = Category.find(@item.category_id)
    # @images = @item.images
  end

  def destroy
    @item = Item.find(params[:id])
    @item.destroy
    redirect_to users_path
  end

  private
      
  def item_params
    params.require(:item).permit(:name,:description,:status,:size,:cost,:days,:price,:category_id, images_attributes: [:image]).merge(user_id: current_user.id)
  end

end