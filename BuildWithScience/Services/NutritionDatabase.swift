import Foundation

struct NutritionFacts {
    let name: String
    let calories: Int
    let proteinG: Double
    let carbsG: Double
    let fatG: Double
}

/// Rough, typical-serving nutrition figures for common foods the on-device
/// Vision classifier can recognize. These are approximations for a quick
/// starting estimate, not verified nutrition-label data.
enum NutritionDatabase {
    static let commonFoods: [String: NutritionFacts] = [
        "banana": NutritionFacts(name: "Banana", calories: 105, proteinG: 1.3, carbsG: 27, fatG: 0.4),
        "apple": NutritionFacts(name: "Apple", calories: 95, proteinG: 0.5, carbsG: 25, fatG: 0.3),
        "orange": NutritionFacts(name: "Orange", calories: 62, proteinG: 1.2, carbsG: 15, fatG: 0.2),
        "pizza": NutritionFacts(name: "Pizza (slice)", calories: 285, proteinG: 12, carbsG: 36, fatG: 10),
        "hamburger": NutritionFacts(name: "Hamburger", calories: 550, proteinG: 30, carbsG: 40, fatG: 29),
        "cheeseburger": NutritionFacts(name: "Cheeseburger", calories: 620, proteinG: 33, carbsG: 40, fatG: 34),
        "hot dog": NutritionFacts(name: "Hot Dog", calories: 290, proteinG: 10, carbsG: 22, fatG: 18),
        "french fries": NutritionFacts(name: "French Fries", calories: 365, proteinG: 4, carbsG: 48, fatG: 17),
        "egg": NutritionFacts(name: "Egg", calories: 78, proteinG: 6, carbsG: 0.6, fatG: 5),
        "steak": NutritionFacts(name: "Steak (6oz)", calories: 450, proteinG: 49, carbsG: 0, fatG: 27),
        "chicken": NutritionFacts(name: "Grilled Chicken Breast", calories: 284, proteinG: 53, carbsG: 0, fatG: 6),
        "salad": NutritionFacts(name: "Salad", calories: 150, proteinG: 4, carbsG: 12, fatG: 10),
        "sushi": NutritionFacts(name: "Sushi (6 pieces)", calories: 250, proteinG: 9, carbsG: 45, fatG: 2),
        "pasta": NutritionFacts(name: "Pasta", calories: 400, proteinG: 13, carbsG: 78, fatG: 5),
        "spaghetti": NutritionFacts(name: "Spaghetti", calories: 420, proteinG: 14, carbsG: 80, fatG: 6),
        "rice": NutritionFacts(name: "Rice (1 cup)", calories: 206, proteinG: 4.3, carbsG: 45, fatG: 0.4),
        "bread": NutritionFacts(name: "Bread (slice)", calories: 79, proteinG: 3, carbsG: 14, fatG: 1),
        "sandwich": NutritionFacts(name: "Sandwich", calories: 350, proteinG: 18, carbsG: 35, fatG: 14),
        "burrito": NutritionFacts(name: "Burrito", calories: 480, proteinG: 20, carbsG: 55, fatG: 18),
        "taco": NutritionFacts(name: "Taco", calories: 210, proteinG: 9, carbsG: 20, fatG: 11),
        "pancake": NutritionFacts(name: "Pancake", calories: 175, proteinG: 4, carbsG: 22, fatG: 7),
        "waffle": NutritionFacts(name: "Waffle", calories: 218, proteinG: 6, carbsG: 25, fatG: 11),
        "donut": NutritionFacts(name: "Donut", calories: 260, proteinG: 3, carbsG: 31, fatG: 14),
        "ice cream": NutritionFacts(name: "Ice Cream (1 scoop)", calories: 210, proteinG: 4, carbsG: 24, fatG: 11),
        "cake": NutritionFacts(name: "Cake (slice)", calories: 350, proteinG: 4, carbsG: 50, fatG: 15),
        "cookie": NutritionFacts(name: "Cookie", calories: 148, proteinG: 2, carbsG: 20, fatG: 7),
        "yogurt": NutritionFacts(name: "Yogurt", calories: 150, proteinG: 8, carbsG: 17, fatG: 4),
        "oatmeal": NutritionFacts(name: "Oatmeal", calories: 158, proteinG: 6, carbsG: 27, fatG: 3),
        "soup": NutritionFacts(name: "Soup (1 bowl)", calories: 170, proteinG: 8, carbsG: 20, fatG: 6),
        "avocado": NutritionFacts(name: "Avocado", calories: 234, proteinG: 3, carbsG: 12, fatG: 21),
        "broccoli": NutritionFacts(name: "Broccoli", calories: 55, proteinG: 4, carbsG: 11, fatG: 0.6),
        "salmon": NutritionFacts(name: "Salmon (6oz)", calories: 350, proteinG: 39, carbsG: 0, fatG: 21),
        "shrimp": NutritionFacts(name: "Shrimp", calories: 168, proteinG: 36, carbsG: 0, fatG: 2),
        "guacamole": NutritionFacts(name: "Guacamole", calories: 150, proteinG: 2, carbsG: 8, fatG: 14),
        "french toast": NutritionFacts(name: "French Toast", calories: 250, proteinG: 8, carbsG: 30, fatG: 11),
        "bagel": NutritionFacts(name: "Bagel", calories: 289, proteinG: 11, carbsG: 56, fatG: 2),
        "muffin": NutritionFacts(name: "Muffin", calories: 340, proteinG: 5, carbsG: 46, fatG: 15),
        "protein shake": NutritionFacts(name: "Protein Shake", calories: 160, proteinG: 25, carbsG: 8, fatG: 3),
        "smoothie": NutritionFacts(name: "Smoothie", calories: 220, proteinG: 5, carbsG: 45, fatG: 3),
        "nachos": NutritionFacts(name: "Nachos", calories: 500, proteinG: 14, carbsG: 50, fatG: 27),
        "popcorn": NutritionFacts(name: "Popcorn (1 cup)", calories: 55, proteinG: 1.7, carbsG: 6, fatG: 3)
    ]

    static func lookup(label: String) -> NutritionFacts? {
        let normalized = label.lowercased()
        if let exact = commonFoods[normalized] { return exact }
        return commonFoods.first { normalized.contains($0.key) }?.value
    }
}
