# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  before_action :configure_sign_in_params, only: [:create]
  skip_before_action :verify_signed_out_user, only: [:destroy]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create
    response = RubyBank.sign_in( { email: params[:user][:email], password: params[:user][:password] })
    if response[:code] == 200
      session[:user_id] = response[:body][:user][:user_id]
      session[:token] = response[:body][:user][:token]
      redirect_to root_path
    else
      error_message = []
      response[:body][:errors].each do |field, errors|
        errors.each do |error|
          error_message << field.to_s + " " + error
        end
      end
      flash[:alert] = error_message.join(",")
      redirect_to user_session_path
    end
  end

  # DELETE /resource/sign_out
  def destroy
    reset_session
    redirect_to new_user_session_path
  end

  protected

  #If you have extra params to permit, append them to the sanitizer.
  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  end
end
