import SwiftUI
import SwiftData

struct ProgressTrackerView: View {
    @Query(sort: \BodyMetricEntry.date) private var weightEntries: [BodyMetricEntry]
    @Query(sort: \ProgressPhoto.date, order: .reverse) private var photos: [ProgressPhoto]

    @State private var showAddWeight = false
    @State private var showAddPhoto = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Weight Trend").font(.headline)
                        Spacer()
                        Button {
                            showAddWeight = true
                        } label: {
                            Image(systemName: "plus.circle.fill")
                        }
                    }
                    if weightEntries.isEmpty {
                        EmptyStateView(icon: "scalemass", title: "No Entries Yet", message: "Log your weight to start tracking trends.")
                    } else {
                        WeightChartView(entries: weightEntries)
                            .frame(height: 220)
                    }
                }
                .padding()
                .background(BWSTheme.cardBackground)
                .clipShape(RoundedRectangle(cornerRadius: 20))

                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Progress Photos").font(.headline)
                        Spacer()
                        Button {
                            showAddPhoto = true
                        } label: {
                            Image(systemName: "plus.circle.fill")
                        }
                    }
                    ProgressPhotosGridView(photos: photos)
                }
                .padding()
                .background(BWSTheme.cardBackground)
                .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            .padding()
        }
        .background(BWSTheme.screenBackground)
        .navigationTitle("Progress")
        .sheet(isPresented: $showAddWeight) {
            AddWeightEntryView()
        }
        .sheet(isPresented: $showAddPhoto) {
            AddProgressPhotoView()
        }
    }
}
