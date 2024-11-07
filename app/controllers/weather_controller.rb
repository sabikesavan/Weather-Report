class WeatherController < ApplicationController

  # Action to fetch the weather forecast for a given zip code
  def forecast
    @zip_code = params[:address]
    return unless @zip_code.present?

    @forecast_data, @from_cache = WeatherService.new(@zip_code).fetch_forecast

    respond_to do |format|
      format.html
      format.turbo_stream { render partial: "weather/weather_data" }
    end
  end

end
