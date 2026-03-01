//
//  WeatherModel.swift
//  Weather-MVVM
//
//  Created by Gerardo Ramos on 28/02/26.
//

// Models for API Response
struct Location: Decodable {
    let name: String
    let country: String
    let lat: Double
    let lon: Double
    let tz_id: String
}

struct ConditionModel: Decodable {
    let text: String
    let icon: String
    let code: Int
}

struct CurrentWeatherModel: Decodable {
    let tempC: Double
    let tempF: Double
    let isDay: Bool
    let condition: ConditionModel
    let wind_kph: Double
    let feelslikeC: Double
    let feelsLikeF: Double
}

struct WeatherResponseModel: Decodable {
    let location: Location
    let current: CurrentWeatherModel
}

// Model for for Display (ViewModel → View)
struct WeatherDisplayModel: Decodable {
    let cityName: String
    let country: String
    let currentTemperature: String
    let feelsLike: String
    let windSpeed: String
    let weatherCondition: String
    let weatherIcon: String

    init(weatherResponse: WeatherResponseModel) {
        self.cityName = weatherResponse.location.name
        self.country = weatherResponse.location.country
        self.currentTemperature = "\(weatherResponse.current.tempC) ºC"
        self.feelsLike = "\(weatherResponse.current.feelslikeC) ºC"
        self.windSpeed = "\(weatherResponse.current.wind_kph) KPH"
        self.weatherCondition = weatherResponse.current.condition.text
        self.weatherIcon = "\(weatherResponse.current.condition.icon)"
    }
}
