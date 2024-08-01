# Payroll App
Create customizable payroll periods that do not overlap or create date coverage gaps and view or edit the current payroll period. 

## Features
- Access the dashboard at localhost:3000
- Click "Create New" to create your first payroll period
- If the current date falls within a payroll period, the "Edit Current" button will appear
- From the dashboard you will see a list of app payroll periods with "Edit" and "Delete"

- The app validates that each payroll period has a start date and end date. 
- The app also validates that the end date falls after the start date, the period does not overlap existing periods, and there is no gap with the previous period. 

## Installation
- git clone https://github.com/JaredHarbison/payroll-app.git
- cd payroll-app
- bundle install
- rails db:migrate
- rails s
