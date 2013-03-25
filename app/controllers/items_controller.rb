class ItemsController < ApplicationController

  def new
    @title = "Add Item"
    @item = Item.new
  end

  def create
    @item = Item.create(params[:item])
    if @item.save
      redirect_to :action => :browse
    else
      redirect_to :action => :browse
    end
  end

  def browse
    @title = "Browse"
    @items = Item.all
  end

  def cart
    if not signed_in?
      flash[:error] = "Please sign in or register to view your cart."
      redirect_to '/signin'
    else
      @title = "Cart"
      @user = current_user
      @cart = @user.cart
      @items = @cart.items.order("id").all
    end
  end

  def edit
    @title = "Edit"
    @item = Item.find(params[:id])
  end

  def update
    @item = Item.find(params[:id])
    if @item.update_attributes(params[:item])
      redirect_to :action => :browse
    else
      render 'edit'
    end
  end

  def update_quantity
    @quantity = Quantity.find_by_id(params[:quantity][:id])
    if @quantity.update_attributes(params[:quantity])
      flash[:success] = "#{@quantity.item.name} updated."
    else
      flash[:error] = "Editing failed."
    end
    redirect_to "/cart"
  end

  def view
    @item = Item.find(params[:id])
  end
end
