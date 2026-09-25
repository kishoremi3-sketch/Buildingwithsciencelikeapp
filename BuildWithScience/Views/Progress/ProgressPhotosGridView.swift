import SwiftUI
import UIKit

struct ProgressPhotosGridView: View {
    let photos: [ProgressPhoto]

    private let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        if photos.isEmpty {
            EmptyStateView(icon: "photo.on.rectangle.angled", title: "No Photos Yet", message: "Add progress photos to visually track changes over time.")
        } else {
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(photos) { photo in
                    NavigationLink {
                        ProgressPhotoDetailView(photo: photo)
                    } label: {
                        if let uiImage = UIImage(data: photo.imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(height: 110)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .clipped()
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

struct ProgressPhotoDetailView: View {
    let photo: ProgressPhoto

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                if let uiImage = UIImage(data: photo.imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                Text(photo.date.formatted(date: .long, time: .omitted))
                    .foregroundStyle(.secondary)
                if !photo.note.isEmpty {
                    Text(photo.note)
                }
            }
            .padding()
        }
        .navigationTitle(photo.category)
        .navigationBarTitleDisplayMode(.inline)
    }
}
