class PayrollPeriodsController < ApplicationController 
  before_action :set_payroll_period, only: [:edit, :update, :show, :destroy]

  def index 
    @payroll_periods = PayrollPeriod.order(start_date: :desc)
  end

  def new 
    @payroll_period = PayrollPeriod.new
  end

  def create 
    @payroll_period = PayrollPeriod.new(payroll_period_params) 

    if @payroll_period.save 
      redirect_to payroll_periods_path, notice: 'Payroll period was successfully created.'
    else 
      render :new, status: :unprocessable_entity
    end
  end

  def edit 
  end 

  def show
  end

  def update 
    if @payroll_period.update(payroll_period_params) 
      redirect_to payroll_periods_path, notice: 'Payroll period was successfully updated.'
    else 
      render :edit, status: :unprocessable_entity
    end
  end 

  def destroy 
    @payroll_period.destroy 
    respond_to do |format|
      format.html { redirect_to payroll_periods_url, notice: 'Payroll period was successfully deleted.' }
      format.json { head :no_content }
    end
  end 

  private 

  def set_payroll_period 
    @payroll_period = PayrollPeriod.find(params[:id])
  end

  def payroll_period_params  
    params.require(:payroll_period).permit(:start_date, :end_date)
  end 

end