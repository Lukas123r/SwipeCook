
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

    // Custom decoder to handle JSON with only a 'name' field
    enum CodingKeys: String, CodingKey {
        case name
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        
        // Assign default values to other properties
        self.id = UUID()
        self.quantity = 1.0
        self.unit = ""
    }
}

struct Recipe: Identifiable, Codable {
    let id: UUID
    let name: String
    let ingredientNames: [String]
    let instructions: String
    let symbolName: String // Using SF Symbols
    var isFavorite: Bool
    var category: String

    init(id: UUID = UUID(), name: String, ingredientNames: [String], instructions: String, symbolName: String, isFavorite: Bool = false, category: String = "") {
        self.id = id
        self.name = name
        self.ingredientNames = ingredientNames
        self.instructions = instructions
        self.symbolName = symbolName
        self.isFavorite = isFavorite
        self.category = category
    }
}
