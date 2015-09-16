class CommissionsController < ApplicationController
  before_action :set_commission, only: [:show, :edit, :update, :destroy]

  # GET /commissions
  def index
    @commissions = Commission.all
  end

  # GET /commissions/1
  def show
  end

  # GET /commissions/new
  def new
    @commission = Commission.new
  end

  # GET /commissions/1/edit
  def edit
  end

  # POST /commissions
  def create
    @commission = Commission.new(commission_params)

    if @commission.save
      redirect_to @commission, notice: '提成区域创建成功。'
    else
      render :new
    end
  end

  # PATCH/PUT /commissions/1
  def update
    if @commission.update(commission_params)
      redirect_to @commission, notice: '提成区域更新成功！'
    else
      render :edit
    end
  end

  # DELETE /commissions/1
  def destroy
    @commission.destroy
    redirect_to commissions_url, notice: '提成区域删除成功！'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_commission
      @commission = Commission.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def commission_params
      params.require(:commission).permit(:name, :price)
    end
end
