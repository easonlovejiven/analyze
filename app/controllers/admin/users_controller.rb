# coding: utf-8
class Admin::UsersController < Admin::BaseController

  before_action :find_user, only: [:edit, :update, :password, :change_password, :destroy]

  def index
  end

  def more_user
    @search = params[:search][:value] ? params[:search][:value] : ""
    @per_page = params[:per_page] ? params[:per_page] : 10
    page = params[:page] || 1
    start = params[:start].to_i || 0
    length = params[:length] ? params[:length].to_i : 10
    page = (start / length) + 1;
    @per_page = length;
    users = User.where(["username like ? and state = ?", "%%#{@search}%%", true]).paginate(page: page , per_page: @per_page).order("id DESC")
    data = users.collect { |item| {:id => item.id, :username => item.username, :email => item.email, :phone => item.phone, :genre => item.show_genre} }
    has_more = (users.length == 0 ? false : true)
    all_count = users.count
    draw = params[:draw].to_i + 1
    render :json => {:draw => draw, :has_more => has_more, :start => start, :recordsTotal => all_count, :recordsFiltered => all_count, :data => data }
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to admin_users_url, notice: '新建成功！'
    else
      render :new
    end
  end

  def update
    get_user_params = user_params
    get_user_params.except!(:password, :password_confirmation) if user_params[:password].blank? && user_params[:password_confirmation].blank?
    if @user.update(get_user_params)
      redirect_to admin_users_url, notice: '更新成功！'
    else
      render :edit
    end
  end

  def password
    render json: @user
  end

  def change_password
    if @user.update(user_params)
      redirect_to "/admin/users"
    else
      redirect_to "/admin/users"
    end
  end

  def destroy
    @user.state? ? @user.update(state: false) : @user.update(state: true)
    redirect_to admin_users_url
  end

  private

  def find_user
    @user = User.find(params[:id])
  end
  
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :remember_me, :username, :user_pic , :genre, :description, :phone, :phone_verify, :private_token, :weibo_uid, :qq_uid, :wechat_uid, :twitter_uid, :message_count ,:background_image_pic , :source , :_alias , :comments_push_switch , :praises_push_switch , :letter_push_switch , :letter_count, :address, :status)
  end
end
