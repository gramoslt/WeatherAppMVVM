//
//  WeatherService.swift
//  Weather-MVVM
//
//  Created by Gerardo Ramos on 01/03/26.
//

import Foundation

let API_KEY = "WRITE_API_KEY_HERE"

protocol WeatherServiceProtocol {
    func fetchWeather(cityName:String) async throws -> WeatherResponseModel
}

final class WeatherService: WeatherServiceProtocol {

    private let baseURL: String = "https://api.weatherapi.com/v1/current.json"

    func fetchWeather(cityName: String) async throws -> WeatherResponseModel {
        let url = try buildURL(cityName: cityName)

        let (data, response) = try await URLSession.shared.data(from: url)

        try validateResponse(response)

        let weatherResponse = try decode(data)

        return weatherResponse
    }

    // ---- HELPER FUNCTIONS ----
    private func buildURL(cityName: String) throws -> URL {
        var components = URLComponents(string: baseURL)!

        components.queryItems = [
            URLQueryItem(name: "key", value: API_KEY),
            URLQueryItem(name: "q", value: cityName)
        ]

        guard let url = components.url else {
            throw WeatherError.invalidURL
        }

        return url
    }

    private func validateResponse(_ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw WeatherError.invalidResponse
        }

        guard (200...299) .contains(httpResponse.statusCode) else {
            throw WeatherError.serverError(statusCode:httpResponse.statusCode)
        }
    }

    private func decode(_ data: Data) throws -> WeatherResponseModel {
        let decoder = JSONDecoder()
        do {
            return try decoder.decode(WeatherResponseModel.self, from: data)
        } catch {
            throw WeatherError.decodingError(error)
        }
    }
}

enum WeatherError: LocalizedError {
    case invalidURL
    case invalidResponse
    case serverError(statusCode: Int)
    case decodingError(Error)
    case noConnection

    var errorDescription: String? {
        switch self {
            case .invalidURL:
                return "API URL is invalid"
            case .invalidResponse:
                return "API returned an invalid response"
            case .serverError(statusCode: let statusCode):
                return "Server error with status code: \(statusCode)"
            case .decodingError(let error):
                return "Failed to decode data: \(error)"
            case .noConnection:
                return "No internet connection"
        }
    }
}

struct MockWeatherService: WeatherServiceProtocol {
    var shouldFail = false

    func fetchWeather(cityName: String) async throws -> WeatherResponseModel {
        // Simulate delay
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 sec

        if shouldFail {
            throw WeatherError.noConnection
        }

        return WeatherResponseModel.Mock
    }
}
