class AccountsController < ApplicationController
  before_action :authenticate_user!
  before_action :initialize_account_api
  before_action :set_account, only: [:show, :edit, :update, :destroy]
  before_action :fetch_all_users, only: [:new, :edit]

  # GET /accounts
  # GET /accounts.json
  def index
    response = @account_api.find_all
    if response[:status].to_i == 403
      redirect_to home_index_path
      flash[:alert] = "You are not allowed to access this page"
    end

    @accounts = response[:accounts]
  end

  # GET /accounts/1
  # GET /accounts/1.json
  def show
    response = @account_api.find(params[:id])
    @account = response[:account]
    # @user = RubyBank::CustomerApi.new(session[:token]).find(@account.customer_id)[:user]
  end

  # GET /accounts/new
  def new
    @account = Account.new
  end

  # GET /accounts/1/edit
  def edit
  end

  # POST /accounts
  # POST /accounts.json
  def create
    response = @account_api.create(params)

    respond_to do |format|
      if response[:status] == 201
        format.html { redirect_to accounts_path , notice: 'Account successfully created.' }
        format.json { render :show, status: :created, location: user_path(response[:body]) }
      else
        format.html { redirect_to new_account_path, alert: formatted_error_message(response).join("<br/>").html_safe }
        format.json { render json: response[:body], status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /accounts/1
  # PATCH/PUT /accounts/1.json
  def update
    response = @account_api.update(params)

    respond_to do |format|
      if response[:status] == 200
        format.html { redirect_to accounts_path , notice: 'Account successfully updated.' }
        format.json { render :show, status: :created, location: user_path(response[:body]) }
      else
        format.html { redirect_to edit_account_path(params[:id]), alert: formatted_error_message(response).join("<br/>").html_safe }
        format.json { render json: response[:body], status: :unprocessable_entity }
      end
    end
  end

  # DELETE /accounts/1
  # DELETE /accounts/1.json
  def destroy
    response = @account_api.destroy(params[:id])
    respond_to do |format|
      if response[:status] == 200
        format.html { redirect_to accounts_url, notice: 'Account was successfully destroyed.' }
        format.json { head :no_content }
      else
        format.html { redirect_to accounts_url, alert: formatted_error_message(response).join("<br/>").html_safe }
        format.json { render json: response[:body], status: :unprocessable_entity }
      end
    end
  end

  private
  def initialize_account_api
    @account_api ||= RubyBank::AccountApi.new(session[:token])
  end
  # Use callbacks to share common setup or constraints between actions.
  def set_account
    response = @account_api.find(params[:id])
    @account = response[:account]
  end

  #
  # fetch_all_users
  #
  def fetch_all_users
    @users = RubyBank::CustomerApi.new(session[:token]).find_all[:users]
  end
  # Only allow a list of trusted parameters through.
  def account_params
    params.fetch(:account, {})
  end
end
