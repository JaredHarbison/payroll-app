require 'rails_helper'

RSpec.describe PayrollPeriodsController, type: :controller do 
  describe 'GET #index' do 
    it 'returns a success response' do 
      get :index 
      expect(response).to be_successful 
    end
  end

  describe 'GET #new' do 
    it 'returns a success response' do
      get :new 
      expect(response).to be_successful 
    end
  end

  describe 'POST #create' do 
    context 'with valid params' do 
      it 'creates a new PayrollPeriod' do 
        expect {
          post :create, params: { payroll_period: { start_date: Date.current, end_date: Date.current + 1.month } }
        }.to change(PayrollPeriod, :count).by(1)
      end

      it 'redirects to payroll_periods list' do 
        post :create, params: { payroll_period: { start_date: Date.current, end_date: Date.current + 1.month } }
        expect(response).to redirect_to(payroll_periods_path)
      end
    end

    context 'with invalid params' do 
      it 'returns a success response (directs to the new page)' do 
        post :create, params: { payroll_period: { start_date: nil, end_date: Date.current + 1.month } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'GET #edit' do 
    it 'returns a success response' do 
      payroll_period = PayrollPeriod.create(start_date: Date.current, end_date: Date.current + 1.month)
      get :edit, params: { id: payroll_period.to_param }
      expect(response).to be_successful
    end
  end

  describe 'PUT #update' do 
    let(:payroll_period) { PayrollPeriod.create(start_date: Date.current, end_date: Date.current + 1.month) }

    context 'with valid params' do 
      let(:new_attributes) { 
        {
          start_date: payroll_period.end_date + 1.day,
          end_date: payroll_period.end_date + 1.day + 1.month
        }
      }

      it 'updates the payroll period' do 
        put :update, params: { id: payroll_period.to_param, payroll_period: new_attributes }
        payroll_period.reload 
        expect(payroll_period.start_date).to eq(new_attributes[:start_date])
        expect(payroll_period.end_date).to eq(new_attributes[:end_date])
      end

      it 'redirects to payroll_periods list' do 
        put :update, params: { id: payroll_period.to_param, payroll_period: new_attributes }
        expect(response).to redirect_to(payroll_periods_path)
      end 
    end

    context 'with invalid params' do 
      it 'returns unprocessable entity response' do 
        put :update, params: { id: payroll_period.to_param, payroll_period: { start_date: nil } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE #destroy' do 
    it 'destroys the payroll_period' do 
      payroll_period = PayrollPeriod.create(start_date: Date.current, end_date: Date.current + 1.month) 
      expect {
        delete :destroy, params: { id: payroll_period.to_param }
      }.to change(PayrollPeriod, :count).by(-1)
    end 

    it 'redirects to the payroll_periods list' do 
      payroll_period = PayrollPeriod.create(start_date: Date.current, end_date: Date.current + 1.month)
      delete :destroy, params: { id: payroll_period.to_param } 
      expect(response).to redirect_to(payroll_periods_path)
    end
  end

end