//
//  CoinCandleStickChartView.swift
//  CryptocurrencyExchange
//
//  Created by Ryan-Son on 2022/03/09.
//

import SwiftUI

import Charts
import ComposableArchitecture

struct CoinCandleChartState: Equatable {
    var symbol: String
    var dataEntries: [BithumbCandleStickDataSingle]?
}

enum CoinCandleChartAction {
    case onAppear
    case onDisappear
    case coinCandleResponse(Result<BithumbCandleStickSingle, Error>)
    case showToast(message: String)
}

struct CoinCandleChartEnvironment {
    var useCase: CoinCandleChartUseCaseProtocol
    var toastClient: ToastClient
}

let coinCandleChartReducer = Reducer<
    CoinCandleChartState, CoinCandleChartAction, CoinCandleChartEnvironment
> { state, action, environment in
    struct CancelId: Hashable { }
    switch action {
    case .onAppear:
//        let useCase = environment.useCase()
        return environment.useCase
            .getCandleStickSinglePublisher(symbol: state.symbol)
            .receive(on: DispatchQueue.main)
            .catchToEffect(CoinCandleChartAction.coinCandleResponse)
            .cancellable(id: CancelId())
    case let .coinCandleResponse(.success(candleStickSingle)):
//        state.dataEntries = candleStickSingle.data.map { $0.toDataEntry() }
        state.dataEntries = candleStickSingle.data
        return .none
    case let .coinCandleResponse(.failure(error)):
        return Effect.merge(
            Effect(value: .onAppear),
            Effect(value: .showToast(message: "\(error.localizedDescription)"))
        )
    case .onDisappear:
        return .cancel(id: CancelId())
    case let .showToast(message):
        let model = ToastModel(duration: 3, message: message)
        return environment.toastClient.show(model)
            .fireAndForget()
    }
}

struct CoinCandleChartView: View {
    let store: Store<CoinCandleChartState, CoinCandleChartAction>

    var body: some View {
        WithViewStore(self.store) { viewStore in
            IfLetStore(
                self.store.scope(state: \.dataEntries),
                then: { store in
                    CoinCandleChartRepresentable(viewStore: ViewStore(store))
                        .padding()
                },
                else: ProgressView.init
            )
                .onAppear {
                    viewStore.send(.onAppear)
                }
        }
    }
}

struct CoinCandleChartRepresentable: UIViewRepresentable {
    let viewStore: ViewStore<[BithumbCandleStickDataSingle], CoinCandleChartAction>

    func makeUIView(context: Context) -> CandleStickChartView {
        let chartView = CandleStickChartView()
        chartView.backgroundColor = .systemBackground
        chartView.rightAxis.enabled = false
        chartView.leftAxis.enabled = true
        chartView.autoScaleMinMaxEnabled = true
        chartView.doubleTapToZoomEnabled = false
        chartView.highlightPerTapEnabled = true
        chartView.scaleYEnabled = false
        chartView.dragYEnabled = false
        chartView.xAxis.setLabelCount(4, force: false)
        chartView.xAxis.labelPosition = .bottom
        chartView.dragDecelerationEnabled = false
        return chartView
    }
    
    func updateUIView(_ uiView: CandleStickChartView, context: Context) {
        let entries = viewStore.state
        let dataEntries = dataEntries(from: entries)
        let axisValues = axisValues(from: entries)
        let dataSet = CandleChartDataSet(entries: dataEntries)
        dataSet.shadowColorSameAsCandle = true
        dataSet.drawValuesEnabled = false
        dataSet.increasingFilled = true
        dataSet.decreasingFilled = true
        dataSet.increasingColor = .red
        dataSet.decreasingColor = .blue
        dataSet.label = nil
        dataSet.form = .none

        let chartData = CandleChartData(dataSet: dataSet)
        uiView.data = chartData
        uiView.xAxis.valueFormatter = IndexAxisValueFormatter(values: axisValues)
        uiView.setVisibleXRange(minXRange: 20, maxXRange: 200)
        uiView.zoom(scaleX: 10, scaleY: 1, x: 0, y: 0)
        uiView.moveViewToX(uiView.chartXMax)
        uiView.drawMarkers = true
    }

    func dataEntries(from entries: [BithumbCandleStickDataSingle]) -> [CandleChartDataEntry] {
        return entries.enumerated().map {
            return CandleChartDataEntry(
                x: Double($0),
                shadowH: $1.highPrice,
                shadowL: $1.lowPrice,
                open: $1.openPrice,
                close: $1.closePrice
            )
        }
    }

    func axisValues(from entries: [BithumbCandleStickDataSingle]) -> [String] {
        return entries.map(\.asDateString)
    }
}

extension BithumbCandleStickDataSingle {
    var asDateString: String {
        let dateFormatter = DateFormatter()
        let date = Date(timeIntervalSince1970: date / 1000)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
}


struct CoinCandleStickChartView_Previews: PreviewProvider {
    static var previews: some View {
        CoinCandleChartView(
            store: Store(
                initialState: CoinCandleChartState(
                    symbol: "BTC_KRW"
                ),
                reducer: coinCandleChartReducer,
                environment: CoinCandleChartEnvironment(
                    useCase: CoinCandleChartUseCase(),
                    toastClient: .live
                )
            )
        )
            .preferredColorScheme(.dark)
    }
}
