//
//  WeatherViewModel.swift
//  Weather-MVVM
//
//  Created by Gerardo Ramos on 02/03/26.
//

import Foundation
import Observation

// loading state
enum ViewState {
    case idle
    case loading
    case success(WeatherDisplayModel)
    case error(String)
}

@Observable
@MainActor
final class WeatherViewModel {

    var selectedCity: String = "Mexico City"
    var state: ViewState = .idle
    private let service: WeatherServiceProtocol

    init(service: WeatherServiceProtocol = WeatherService()) {
        self.service = service
    }

    func loadWeather() async {
        state = .loading

        do {
            let response: WeatherResponseModel = try await service.fetchWeather(cityName: selectedCity)

            let displayModel = WeatherDisplayModel(weatherResponse: response)

            state = .success(displayModel)
        } catch {
            let errorMessage: String = (error as? WeatherError)?.errorDescription ?? error.localizedDescription
            state = .error(errorMessage)
        }
    }

    func refresh() async {
        await loadWeather()
    }
}
