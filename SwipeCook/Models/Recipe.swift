import Foundation

struct Ingredient: Identifiable, Hashable, Codable {
    let id: UUID
    let name: String
    var quantity: Double
    var unit: String

    init(id: UUID = UUID(), name: String, quantity: Double = 1.0, unit: String = "") {
        self.id = id
        self.name = name
        self.quantity = quantity
        self.unit = unit
    }
}

struct Recipe: Identifiable, Codable {
    let id: UUID
    let name: String
    let ingredients: [Ingredient]
    let instructions: String
    let symbolName: String // Using SF Symbols
    var isFavorite: Bool
    var category: String

    init(id: UUID = UUID(), name: String, ingredients: [Ingredient], instructions: String, symbolName: String, isFavorite: Bool = false, category: String = "") {
        self.id = id
        self.name = name
        self.ingredients = ingredients
        self.instructions = instructions
        self.symbolName = symbolName
        self.isFavorite = isFavorite
        self.category = category
    }
}