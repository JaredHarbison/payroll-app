class PayrollPeriod < ApplicationRecord
  validates :start_date, presence: true 
  validates :end_date, presence: true 
  validate :end_date_after_start_date 
  validate :no_existing_period_overlap 
  validate :no_gap_with_previous_period

  def self.current_period(date = Date.current) 
    where("start_date <= ? AND end_date >= ?", date, date).first
  end

  private 

  def end_date_after_start_date 
    return unless start_date && end_date
    
    if end_date <= start_date 
      errors.add(:end_date, "must be after the start date")
    end
  end

  def no_existing_period_overlap 
    return unless start_date && end_date
  
    overlaps = PayrollPeriod.where(
      "(start_date <= ? AND end_date >= ?) OR (start_date <= ? AND end_date >= ?)", 
      end_date, start_date, end_date, start_date
    ).where.not(id: id)

    if overlaps.exists? 
      errors.add(:base, "this payroll period overlaps with existing periods")
    end
  end

  def no_gap_with_previous_period
    return unless start_date && end_date

    most_recent_period = PayrollPeriod.order(end_date: :desc).first
    return unless most_recent_period

    if most_recent_period.end_date + 1.day != start_date
      errors.add(:start_date, "must be the day after the end date of the most recent payroll period")
    end
  end
  
end
