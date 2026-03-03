//
//  ContentView.swift
//  Weather-MVVM
//
//  Created by Gerardo Ramos on 28/02/26.
//

import SwiftUI

struct ContentView: View {
    @State var viewModel: WeatherViewModel = WeatherViewModel()

    var body: some View {
        WeatherView(viewModel: viewModel)
        .task {
            await viewModel.loadWeather()
        }
    }
}

#Preview {
    ContentView(viewModel: WeatherViewModel(service: MockWeatherService()))
}
