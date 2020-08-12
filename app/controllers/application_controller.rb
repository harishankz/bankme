class ApplicationController < ActionController::Base

  def formatted_error_message(response)
    error_message = []
    if response[:body][:exception].present?
      error_message << "Something went Wrong!!!"
    elsif response[:body][:message].present?
      error_message << response[:body][:message]
    elsif response[:body].is_a?(Hash)
      response[:body].each do |field, errors|
        errors.each do |error|
          error_message << field.to_s.capitalize + " " + error
        end
      end
    else
      error_message << 'Something went Wrong!!!'
    end

    error_message
  end

  private

  #
  # authenticate_user!
  #
  def authenticate_user!(options = {})
    redirect_to new_user_session_path unless signed_in?
  end

  #
  # current_user
  #
  def current_user
    @customer_api = RubyBank::CustomerApi.new(session[:token])
    response = @customer_api.find(session[:user_id])

    @current_user ||= response[:user]
  end

  #
  # signed_in?
  #
  def signed_in?
    session[:user_id].present?
  end

end
