require 'rails_helper'
require 'webmock/rspec'

RSpec.describe WeatherService, type: :service do
  let(:zip_code) { '600001' }
  let(:weather_service) { WeatherService.new(zip_code) }

  describe '#fetch_forecast' do
    context 'when data is cached' do
      it 'returns cached weather data' do
        cached_data = { temperature: 25, high: 30, low: 20, description: 'Clear sky' }

        # Mock the cache to return cached data
        allow(Rails.cache).to receive(:read).with("forecast_#{zip_code}").and_return(cached_data)

        forecast_data, from_cache = weather_service.fetch_forecast

        expect(forecast_data).to eq(cached_data)
        expect(from_cache).to be(true)
      end
    end

    context 'when data is not cached and fetches from API' do
      before do
        # Mock the API request using WebMock
        stub_request(:get, "https://api.openweathermap.org/data/2.5/weather?q=#{zip_code}&appid=#{Rails.application.credentials.WEATHER_API_KEY}")
          .to_return(body: { main: { temp: 25, temp_max: 30, temp_min: 20 }, weather: [{ description: 'Clear sky' }] }.to_json, status: 200)
      end

      it 'fetches weather data from the API and caches it' do
        forecast_data = { temperature: 72, high: 75, low: 70, description: 'Sunny' }
        zip_code = '600001'

        # Mock the API response (assuming WebMock is being used)
        stub_request(:get, "https://api.openweathermap.org/data/2.5/weather?q=#{zip_code}&appid=#{Rails.application.credentials.WEATHER_API_KEY}")
          .to_return(body: { main: { temp: 72, temp_max: 75, temp_min: 70 }, weather: [{ description: 'Sunny' }] }.to_json, status: 200)

        # Mock Rails.cache.write
        allow(Rails.cache).to receive(:write)

        # Call the method
        weather_service = WeatherService.new(zip_code)
        weather_service.fetch_forecast

        # Check if write was called with the correct arguments
        expect(Rails.cache).to have_received(:write).with("forecast_#{zip_code}", forecast_data, expires_in: 30.minutes)
      end
    end

    context 'when API request fails' do
      before do
        # Mock the API request to return a failure
        stub_request(:get, "https://api.openweathermap.org/data/2.5/weather?q=#{zip_code}&appid=#{Rails.application.credentials.WEATHER_API_KEY}")
          .to_return(status: 500, body: 'Internal Server Error')
      end

      it 'returns an error message' do
        forecast_data, from_cache = weather_service.fetch_forecast

        expect(forecast_data).to eq(error: 'Failed to retrieve data from weather service.')
        expect(from_cache).to be(false)
      end
    end
  end
end
