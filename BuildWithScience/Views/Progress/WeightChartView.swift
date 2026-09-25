import SwiftUI
import Charts

struct WeightChartView: View {
    let entries: [BodyMetricEntry]

    var body: some View {
        Chart(entries) { entry in
            LineMark(
                x: .value("Date", entry.date),
                y: .value("Weight", entry.weightKg)
            )
            .foregroundStyle(BWSTheme.primary)
            .interpolationMethod(.catmullRom)

            PointMark(
                x: .value("Date", entry.date),
                y: .value("Weight", entry.weightKg)
            )
            .foregroundStyle(BWSTheme.primary)
        }
        .chartYAxis {
            AxisMarks(position: .leading)
        }
    }
}
