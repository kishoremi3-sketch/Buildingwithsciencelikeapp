import SwiftUI
import PhotosUI
import SwiftData
import UIKit

struct AddProgressPhotoView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @State private var photoItem: PhotosPickerItem?
    @State private var image: UIImage?
    @State private var category = "Front"
    @State private var note = ""

    private let categories = ["Front", "Side", "Back"]

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    if let image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 260)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    PhotosPicker(selection: $photoItem, matching: .images) {
                        Label(image == nil ? "Choose Photo" : "Change Photo", systemImage: "photo.on.rectangle")
                    }
                }

                Picker("Angle", selection: $category) {
                    ForEach(categories, id: \.self) { Text($0) }
                }

                TextField("Note", text: $note, axis: .vertical)
            }
            .navigationTitle("Add Progress Photo")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .disabled(image == nil)
                }
            }
            .onChange(of: photoItem) { _, newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self), let uiImage = UIImage(data: data) {
                        image = uiImage
                    }
                }
            }
        }
    }

    private func save() {
        guard let image, let data = image.jpegData(compressionQuality: 0.8) else { return }
        let photo = ProgressPhoto(imageData: data, category: category, note: note)
        context.insert(photo)
        try? context.save()
        dismiss()
    }
}
