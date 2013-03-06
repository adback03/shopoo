class UsersController < ApplicationController
  def new
    @title = "Sign Up"
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
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
end