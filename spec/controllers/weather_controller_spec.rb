require 'rails_helper'

RSpec.describe WeatherController, type: :controller do
  let(:zip_code) { '600001' }
  let(:forecast_data) { { temperature: 25, high: 30, low: 20, description: 'Clear sky' } }

  describe 'GET #forecast' do
    context 'when zip code is present' do
      before do
        # Mock the WeatherService to return the forecast data
        allow(WeatherService).to receive(:new).with(zip_code).and_return(double(fetch_forecast: [forecast_data, false]))

        get :forecast, params: { address: zip_code }
      end

      it 'assigns the forecast data' do
        expect(assigns(:forecast_data)).to eq(forecast_data)
      end

      it 'renders the forecast view' do
        expect(response).to render_template(:forecast)
      end

      it 'does not render a turbo stream partial' do
        expect(response.body).not_to include('weather/weather_data')
      end
    end

    context 'when zip code is not present' do
      it 'does not fetch the forecast' do
        get :forecast, params: { address: nil }

        expect(assigns(:forecast_data)).to be_nil
        expect(response).to render_template(:forecast)
      end
    end
  end
end
