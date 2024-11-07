# WeatherService fetches and caches weather data for a given zip code.

class WeatherService
  def initialize(zip_code)
    @zip_code = zip_code
    @api_key = Rails.application.credentials.WEATHER_API_KEY
  end

  def fetch_forecast
    cached_data = Rails.cache.read(cache_key)
    return [cached_data, true] if cached_data

    forecast_data = fetch_weather_data
    Rails.cache.write(cache_key, forecast_data, expires_in: 30.minutes) if forecast_data[:error].nil?

    [forecast_data, false]
  end

  private

  def cache_key
    "forecast_#{@zip_code}"
  end

  # Fetches weather data from the OpenWeather API
  def fetch_weather_data
    url = URI("https://api.openweathermap.org/data/2.5/weather?q=#{@zip_code}&appid=#{@api_key}")
    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true
    request = Net::HTTP::Get.new(url)
    response = https.request(request)

    return parse_response(response) if response.is_a?(Net::HTTPSuccess)

    { error: 'Failed to retrieve data from weather service.' }
  end

  def parse_response(response)
    data = JSON.parse(response.body)
    {
      temperature: data['main']['temp'],
      high: data['main']['temp_max'],
      low: data['main']['temp_min'],
      description: data['weather'][0]['description']
    }
  end
end
