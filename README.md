# Weather Forecast App

A Ruby on Rails application that allows users to fetch the weather forecast based on their zip code. The application fetches real-time weather data from the OpenWeather API and caches the results for efficiency.

# Features
Users can input a zip code to get the current weather forecast.
Displays temperature, high, low, and weather conditions.
Weather data is cached to reduce API calls and improve response time.
Built with Ruby on Rails, leveraging the OpenWeather API for weather data.

# Technologies Used
Ruby on Rails – Framework for building web applications.
OpenWeather API – Provides weather data for a given location.
Rails Caching – Used to store weather data temporarily.
RSpec – Testing framework for Ruby applications.
WebMock – Library to simulate HTTP requests in tests.

## Setup
1. Clone the repository.
2. Run 'bundle install' to install dependencies.
3. Configure your environment variables in '.env.
4. Run 'rails server' to start the application.

## Usage
Access the weather forecast via '/weather/forecast?address=ZIP_CODE.

## Testing
Run tests using 'rspec'.
