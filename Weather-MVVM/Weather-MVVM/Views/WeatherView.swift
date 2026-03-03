//
//  WeatherView.swift
//  Weather-MVVM
//
//  Created by Gerardo Ramos on 02/03/26.
//

import SwiftUI

struct WeatherView: View {
    @Bindable var viewModel: WeatherViewModel

    var body: some View {
        ZStack {
            Color(.systemBackground)

            VStack {
                TextField("city name", text: $viewModel.selectedCity)
                    .textFieldStyle(.roundedBorder)

                mainContent
            }
        }
    }

    @ViewBuilder
    private var mainContent: some View {
        switch viewModel.state {
            case .idle:
                Color.clear

            case .loading:
                ProgressView("Loading Weather...")

            case .success(let weather):
                WeatherSuccessView(
                    weather: weather,
                    onRefresh: {
                        Task { await viewModel.refresh() }
                    }
                )
            case .error(let error):
                ErrorView(
                    errorMessage: error,
                    onRetry: {
                        Task { await viewModel.refresh() }
                    }
                )
        }
    }
}

struct WeatherSuccessView: View {
    let weather: WeatherDisplayModel
    let onRefresh: () -> Void

    var body: some View {
        ScrollView {
            VStack {
                Text(weather.cityName)
                    .font(.title2)
                    .fontWeight(.medium)
                    .foregroundStyle(.black.opacity(0.9))

                Text(weather.currentTemperature)
                    .font(.largeTitle)
                    .fontWeight(.thin)
                    .fontDesign(.rounded)
                    .foregroundStyle(.black)

                Text(weather.weatherCondition)
                    .font(.subheadline)
                    .fontDesign(.rounded)
                    .foregroundStyle(.black)

                Button(action: onRefresh) {
                    Label("Refresh", systemImage: "arrow.clockwise")
                        .font(.subheadline)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(.ultraThinMaterial, in: Capsule())
                        .foregroundStyle(.black)
                }
            }
            .padding()
        }
    }
}

struct ErrorView: View {
    let errorMessage: String
    let onRetry: () -> Void

    var body: some View {
        Text(errorMessage)
            .font(.largeTitle)
            .fontWeight(.thin)
            .fontDesign(.rounded)
            .foregroundStyle(.white)
            .padding()
            .background(Color.black.opacity(0.9))
            .cornerRadius(16)
            .padding()
            .onTapGesture(perform: onRetry)
    }
}

#Preview {
    WeatherView(
        viewModel: WeatherViewModel(
            service: MockWeatherService()
        )
    )
}
