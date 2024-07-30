require 'rails_helper'

RSpec.describe PayrollPeriod, type: :model do
  describe 'validations' do 
    it 'is has valid attributes' do 
      payroll_period = PayrollPeriod.new(start_date: Date.current, end_date: Date.current + 1.month)
      expect(payroll_period).to be_valid 
    end 

    it 'is invalid without start date' do 
      payroll_period = PayrollPeriod.new(end_date: Date.current + 1.month)
      expect(payroll_period).to_not be_valid 
    end 

    it 'is invalid without an end date' do 
      payroll_period = PayrollPeriod.new(start_date: Date.current) 
      expect(payroll_period).to_not be_valid 
    end 

    it 'is invalid if end date is before start date' do 
      payroll_period = PayrollPeriod.create(start_date: Date.current, end_date: Date.current - 1.day)
      expect(payroll_period).to_not be_valid 
    end

    it 'is invalid if it overlaps with another period' do 
      PayrollPeriod.create(start_date: '2024-01-01', end_date: '2024-01-31')
      invalid_period = PayrollPeriod.new(start_date: '2024-01-07', end_date: '2024-01-14')
      expect(invalid_period).to_not be_valid 
    end
    
    it 'is valid when there is no gap between payroll periods' do
      PayrollPeriod.create(start_date: '2023-07-01', end_date: '2023-07-15')
      new_period = PayrollPeriod.new(start_date: '2023-07-16', end_date: '2023-07-31')

      expect(new_period).to be_valid
    end

    it 'is invalid when there is a gap between payroll periods' do
      PayrollPeriod.create(start_date: '2023-07-01', end_date: '2023-07-15')
      new_period = PayrollPeriod.new(start_date: '2023-07-17', end_date: '2023-07-31')

      expect(new_period).not_to be_valid
      expect(new_period.errors[:start_date]).to include('must be the day after the end date of the most recent payroll period')
    end

    it 'is valid when there is no previous payroll period' do
      new_period = PayrollPeriod.new(start_date: '2023-07-01', end_date: '2023-07-15')

      expect(new_period).to be_valid
    end
  end

  describe 'current_period' do 
    it 'returns the current period' do 
      PayrollPeriod.create(start_date: 1.month.ago.beginning_of_month, end_date: 1.month.ago.end_of_month)
      current_period = PayrollPeriod.create(start_date: Date.current.beginning_of_month, end_date: Date.current.end_of_month)
      PayrollPeriod.create(start_date: 1.month.from_now.beginning_of_month, end_date: 1.month.from_now.end_of_month)

      result = PayrollPeriod.current_period
      expect(result.start_date).to eq(current_period.start_date)
      expect(result.end_date).to eq(current_period.end_date)
    end

    it 'returns nil if no current period' do 
      PayrollPeriod.create(start_date: 2.months.ago.beginning_of_month, end_date:2.months.ago.end_of_month)
      PayrollPeriod.create(start_date: 2.months.from_now.beginning_of_month, end_date:2.months.from_now.end_of_month)
      expect(PayrollPeriod.current_period).to be_nil
    end
  end
end
