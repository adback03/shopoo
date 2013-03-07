class UsersController < ApplicationController
  before_filter :authenticate, :only => [:edit, :update]
  before_filter :correct_user, :only => [:edit, :update]

  def new
    @title = "Sign Up"
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    @cart = Cart.new

    if @user.save
      @cart.save
      @user.update_attribute :cart_id, @cart.id
      sign_in @user
      flash[:success] = "Welcome to ShopOO!"
      redirect_to @user
    else
      @title = "Sign Up"
      render 'new'
    end
  end

  def show
    @user = User.find(params[:id])
    @title = "#{@user.firstname} #{@user.lastname}"
  end

  def edit
    @title = "Edit Profile"
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated."
      redirect_to @user
    else
      @title = "Edit User"
      render 'edit'
    end
  end

  private

    def authenticate
      deny_access unless signed_in?
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to user_path unless current_user?(@user)
    end
end
