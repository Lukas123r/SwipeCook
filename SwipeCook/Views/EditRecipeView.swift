import SwiftUI

struct EditRecipeView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var recipeStore: RecipeStore
    @State var recipe: Recipe

    @State private var recipeName: String
    @State private var ingredientsInput: String
    @State private var instructionsInput: String
    @State private var symbolName: String
    @State private var category: String

    init(recipeStore: RecipeStore, recipe: Recipe) {
        self.recipeStore = recipeStore
        self._recipe = State(initialValue: recipe)
        self._recipeName = State(initialValue: recipe.name)
        self._ingredientsInput = State(initialValue: recipe.ingredients.map { $0.name }.joined(separator: ", "))
        self._instructionsInput = State(initialValue: recipe.instructions)
        self._symbolName = State(initialValue: recipe.symbolName)
        self._category = State(initialValue: recipe.category)
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Recipe Details")) {
                    TextField("Recipe Name", text: $recipeName)
                    TextField("Ingredients (comma separated)", text: $ingredientsInput)
                    TextField("Instructions", text: $instructionsInput, axis: .vertical)
                        .lineLimit(5, reservesSpace: true)
                    TextField("Category (e.g., Italian, Breakfast)", text: $category)
                    
                    Picker("Symbol", selection: $symbolName) {
                        Text("Fork & Knife").tag("fork.knife")
                        Text("Leaf").tag("leaf.fill")
                        Text("Flame").tag("flame.fill")
                        Text("Cake").tag("birthday.cake.fill")
                        Text("Carrot").tag("carrot.fill")
                    }
                }
            }
            .navigationTitle("Edit Recipe")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        updateRecipe()
                    }
                    .disabled(recipeName.isEmpty || ingredientsInput.isEmpty || instructionsInput.isEmpty)
                }
            }
        }
    }

    private func updateRecipe() {
        let ingredientNames = ingredientsInput.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        let ingredients = ingredientNames.map { Ingredient(name: $0) }

        let updatedRecipe = Recipe(
            id: recipe.id, // Keep the original ID
            name: recipeName,
            ingredients: ingredients,
            instructions: instructionsInput,
            symbolName: symbolName,
            isFavorite: recipe.isFavorite,
            category: category
        )
        recipeStore.updateRecipe(updatedRecipe)
        dismiss()
    }
}
