
import SwiftUI

struct CreateRecipeView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var recipeStore: RecipeStore

    @State private var recipeName: String = ""
    @State private var ingredientsInput: String = ""
    @State private var instructionsInput: String = ""
    @State private var symbolName: String = "fork.knife"
    @State private var category: String = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Recipe Details")) {
                    TextField("Recipe Name", text: $recipeName)
                    TextField("Ingredients (comma separated)", text: $ingredientsInput)
                    TextField("Instructions", text: $instructionsInput, axis: .vertical)
                        .lineLimit(5, reservesSpace: true)
                    TextField("Category (e.g., Italian, Breakfast)", text: $category)
                    
                    // Simple SF Symbol picker for now
                    Picker("Symbol", selection: $symbolName) {
                        Text("Fork & Knife").tag("fork.knife")
                        Text("Leaf").tag("leaf.fill")
                        Text("Flame").tag("flame.fill")
                        Text("Cake").tag("birthday.cake.fill")
                        Text("Carrot").tag("carrot.fill")
                    }
                }
            }
            .navigationTitle("Create New Recipe")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveRecipe()
                    }
                    .disabled(recipeName.isEmpty || ingredientsInput.isEmpty || instructionsInput.isEmpty)
                }
            }
        }
    }

    private func saveRecipe() {
        let ingredientNames = ingredientsInput.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        let ingredients = ingredientNames.map { Ingredient(name: $0) }

        let newRecipe = Recipe(
            // id: UUID(), // FIX 1: Removed explicit id initialization as Recipe struct handles it
            name: recipeName,
            ingredients: ingredients,
            instructions: instructionsInput,
            symbolName: symbolName,
            isFavorite: false,
            category: category
        )
        recipeStore.addRecipe(newRecipe)
        dismiss()
    }
}
