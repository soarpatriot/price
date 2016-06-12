class ErrorsController < ApplicationController
  
  skip_before_action  :authorized!
  
  layout false
  def show
    render status_code.to_s, status: status_code
  end
 
protected
 
  def status_code
    params[:code] || 500
  end
 
end
