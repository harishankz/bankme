class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :intialize_customer_api
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :fetch_all_roles, only: [:new, :edit]

  # GET /users
  # GET /users.json
  def index
    response = @customer_api.find_all
    @users = response[:users]
    if response[:status].to_i == 403
      redirect_to home_index_path
      flash[:alert] = "You are not allowed to access this page"
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    response = @customer_api.find(params[:id])
    @user = response[:user]
    @role = RubyBank::RoleApi.new(session[:token]).find(@user.role_id)[:role]
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    response = @customer_api.create(params)

    respond_to do |format|
      if response[:status] == 201
        format.html { redirect_to users_path , notice: 'User successfully created.' }
        format.json { render :show, status: :created, location: user_path(response[:body]) }
      else
        format.html { redirect_to new_user_path, alert: formatted_error_message(response).join("<br/>").html_safe }
        format.json { render json: response[:body], status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    response = @customer_api.update(params)
    respond_to do |format|
      if response[:status] == 200
        format.html { redirect_to users_path , notice: 'User successfully updated.' }
        format.json { render :show, status: :created, location: user_path(response[:body]) }
      else
        format.html { redirect_to edit_user_path(params[:id]), alert: formatted_error_message(response).join("<br/>").html_safe }
        format.json { render json: response[:body], status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    response = @customer_api.destroy(params[:id])
    respond_to do |format|
      if response[:status] == 200
        format.html { redirect_to users_url, notice: 'Account was successfully destroyed.' }
        format.json { head :no_content }
      else
        format.html { redirect_to users_url, alert: formatted_error_message(response).join("<br/>").html_safe }
        format.json { render json: response[:body], status: :unprocessable_entity }
      end
    end
  end

  private

  def intialize_customer_api
    @customer_api = RubyBank::CustomerApi.new(session[:token])
  end
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    response = @customer_api.find(params[:id])
    @user = response[:user]
  end

  def fetch_all_roles
    @roles = RubyBank::RoleApi.new(session[:token]).find_all[:roles]
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.fetch(:user, {})
  end
end
