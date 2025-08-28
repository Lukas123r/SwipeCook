
import SwiftUI

struct EditRecipeView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var recipeStore: RecipeStore
    
    @State private var recipe: Recipe
    @State private var showingIngredientPicker = false

    // Separate state for UI to avoid direct mutation of the recipe model in Form
    @State private var recipeName: String
    @State private var selectedIngredients: [String]
    @State private var instructionsInput: String
    @State private var symbolName: String
    @State private var category: String

    init(recipeStore: RecipeStore, recipe: Recipe) {
        self.recipeStore = recipeStore
        self._recipe = State(initialValue: recipe)
        
        // Initialize local state from the recipe
        self._recipeName = State(initialValue: recipe.name)
        self._selectedIngredients = State(initialValue: recipe.ingredientNames)
        self._instructionsInput = State(initialValue: recipe.instructions)
        self._symbolName = State(initialValue: recipe.symbolName)
        self._category = State(initialValue: recipe.category)
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Recipe Details")) {
                    TextField("Recipe Name", text: $recipeName)
                    TextField("Category (e.g., Italian, Breakfast)", text: $category)
                    
                    Picker("Symbol", selection: $symbolName) {
                        Text("Fork & Knife").tag("fork.knife")
                        Text("Leaf").tag("leaf.fill")
                        Text("Flame").tag("flame.fill")
                        Text("Cake").tag("birthday.cake.fill")
                        Text("Carrot").tag("carrot.fill")
                    }
                }
                
                Section(header: Text("Ingredients")) {
                    Button(action: { showingIngredientPicker = true }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Select Ingredients")
                        }
                    }
                    
                    ForEach(selectedIngredients, id: \.self) { ingredientName in
                        Text(ingredientName)
                    }
                }
                
                Section(header: Text("Instructions")) {
                    TextField("Instructions", text: $instructionsInput, axis: .vertical)
                        .lineLimit(8, reservesSpace: true)
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
                    .disabled(recipeName.isEmpty || selectedIngredients.isEmpty || instructionsInput.isEmpty)
                }
            }
            .sheet(isPresented: $showingIngredientPicker) {
                IngredientPickerView(selectedIngredients: $selectedIngredients, allIngredients: recipeStore.masterIngredients)
            }
        }
    }

    private func updateRecipe() {
        let updatedRecipe = Recipe(
            id: recipe.id,
            name: recipeName,
            ingredientNames: selectedIngredients,
            instructions: instructionsInput,
            symbolName: symbolName,
            isFavorite: recipe.isFavorite, // Preserve favorite status
            category: category
        )
        recipeStore.updateRecipe(updatedRecipe)
        dismiss()
    }
}
