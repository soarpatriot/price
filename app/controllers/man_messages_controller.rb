class ManMessagesController < ApplicationController
  before_action :set_man_message, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @man_messages = ManMessage.all
    respond_with(@man_messages)
  end

  def show
    respond_with(@man_message)
  end

  def new
    @man_message = ManMessage.new
    respond_with(@man_message)
  end

  def edit
  end

  def create
    @man_message = ManMessage.new(man_message_params)
    @man_message.save
    respond_with(@man_message)
  end

  def update
    @man_message.update(man_message_params)
    respond_with(@man_message)
  end

  def destroy
    @man_message.destroy
    respond_with(@man_message)
  end

  private
    def set_man_message
      @man_message = ManMessage.find(params[:id])
    end

    def man_message_params
      params.require(:man_message).permit(:is_success, :status_message, :courier_name, :courier_mobile, :account_id, :employee_no)
    end
end
