import SwiftUI
import PhotosUI
import SwiftData
import UIKit

struct AddFoodEntryView: View {
    let date: Date

    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @State private var photoItem: PhotosPickerItem?
    @State private var image: UIImage?
    @State private var name = ""
    @State private var mealType = "Breakfast"
    @State private var calories = 0
    @State private var protein = 0.0
    @State private var carbs = 0.0
    @State private var fat = 0.0
    @State private var isEstimating = false
    @State private var estimateLabel: String?
    @State private var showCamera = false

    private let mealTypes = ["Breakfast", "Lunch", "Dinner", "Snack"]
    private var isCameraAvailable: Bool { UIImagePickerController.isSourceTypeAvailable(.camera) }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    photoArea
                    HStack {
                        PhotosPicker(selection: $photoItem, matching: .images) {
                            Label("Choose Photo", systemImage: "photo.on.rectangle")
                        }
                        Spacer()
                        Button {
                            showCamera = true
                        } label: {
                            Label("Camera", systemImage: "camera")
                        }
                        .disabled(!isCameraAvailable)
                    }

                    if image != nil {
                        Button {
                            runEstimate()
                        } label: {
                            if isEstimating {
                                ProgressView()
                            } else {
                                Label("Estimate From Photo", systemImage: "sparkles")
                            }
                        }
                        .disabled(isEstimating)
                    }

                    if let estimateLabel {
                        Text("Detected: \(estimateLabel). Review and adjust — this is an approximate, on-device estimate, not a verified nutrition measurement.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                Section("Details") {
                    TextField("Food name", text: $name)
                    Picker("Meal", selection: $mealType) {
                        ForEach(mealTypes, id: \.self) { Text($0) }
                    }
                }

                Section("Nutrition") {
                    Stepper("Calories: \(calories) kcal", value: $calories, in: 0...3000, step: 10)
                    Stepper("Protein: \(Int(protein))g", value: $protein, in: 0...300, step: 1)
                    Stepper("Carbs: \(Int(carbs))g", value: $carbs, in: 0...400, step: 1)
                    Stepper("Fat: \(Int(fat))g", value: $fat, in: 0...200, step: 1)
                }
            }
            .navigationTitle("Log Food")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .onChange(of: photoItem) { _, newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self), let uiImage = UIImage(data: data) {
                        image = uiImage
                    }
                }
            }
            .fullScreenCover(isPresented: $showCamera) {
                CameraCaptureView(image: $image)
                    .ignoresSafeArea()
            }
        }
    }

    private var photoArea: some View {
        Group {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 200)
                    .frame(maxWidth: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .clipped()
            } else {
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color(.tertiarySystemFill))
                    .frame(height: 160)
                    .overlay {
                        VStack(spacing: 8) {
                            Image(systemName: "camera.fill").font(.title)
                            Text("Add a photo of your food")
                                .font(.caption)
                        }
                        .foregroundStyle(.secondary)
                    }
            }
        }
    }

    private func runEstimate() {
        guard let image else { return }
        isEstimating = true
        Task {
            let result = await FoodPhotoEstimator.estimate(from: image)
            isEstimating = false
            guard let result else {
                estimateLabel = "Couldn't identify this photo — enter details manually."
                return
            }
            estimateLabel = "\(result.label.capitalized) (\(Int(result.confidence * 100))% confidence)"
            if let nutrition = result.nutrition {
                name = nutrition.name
                calories = nutrition.calories
                protein = nutrition.proteinG
                carbs = nutrition.carbsG
                fat = nutrition.fatG
            } else if name.isEmpty {
                name = result.label.capitalized
            }
        }
    }

    private func save() {
        let entry = FoodEntry(
            date: date,
            mealType: mealType,
            name: name,
            photoData: image?.jpegData(compressionQuality: 0.7),
            calories: calories,
            proteinG: protein,
            carbsG: carbs,
            fatG: fat,
            isEstimated: estimateLabel != nil
        )
        context.insert(entry)
        try? context.save()
        dismiss()
    }
}
