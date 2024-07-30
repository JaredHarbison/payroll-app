class CreatePayrollPeriods < ActiveRecord::Migration[7.1]
  def change
    create_table :payroll_periods do |t|
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
