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
    let isDay: Int
    let condition: ConditionModel
    let windKph: Double
    let feelsLikeC: Double
    let feelsLikeF: Double

    enum CodingKeys: String, CodingKey {
        case tempC = "temp_c"
        case tempF = "temp_f"
        case isDay = "is_day"
        case condition
        case windKph = "wind_kph"
        case feelsLikeC = "feelslike_c"
        case feelsLikeF = "feelslike_f"
    }
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
        self.feelsLike = "\(weatherResponse.current.feelsLikeC) ºC"
        self.windSpeed = "\(weatherResponse.current.windKph) KPH"
        self.weatherCondition = weatherResponse.current.condition.text
        self.weatherIcon = "\(weatherResponse.current.condition.icon)"
    }
}
