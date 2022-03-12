//
//  CoinCandleChartRepresentable.swift
//  CryptocurrencyExchange
//
//  Created by Ryan-Son on 2022/03/12.
//

import SwiftUI

import Charts
import ComposableArchitecture

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
