import SwiftUI

struct CreateRecipeView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var recipeStore: RecipeStore

    @State private var recipeName: String = ""
    @State private var selectedIngredients: [String] = []
    @State private var instructionsInput: String = ""
    @State private var symbolName: String = "fork.knife"
    @State private var category: String = ""
    
    @State private var showingIngredientPicker = false

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
                    
                    ForEach(selectedIngredients, id: \.self) {
                        ingredientName in
                        Text(ingredientName)
                    }
                }
                
                Section(header: Text("Instructions")) {
                    TextField("Instructions", text: $instructionsInput, axis: .vertical)
                        .lineLimit(8, reservesSpace: true)
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
                    .disabled(recipeName.isEmpty || selectedIngredients.isEmpty || instructionsInput.isEmpty)
                }
            }
            .sheet(isPresented: $showingIngredientPicker) {
                IngredientPickerView(selectedIngredients: $selectedIngredients, allIngredients: recipeStore.masterIngredients)
            }
        }
    }

    private func saveRecipe() {
        let newRecipe = Recipe(
            name: recipeName,
            ingredientNames: selectedIngredients,
            instructions: instructionsInput,
            symbolName: symbolName,
            isFavorite: false,
            category: category
        )
        recipeStore.addRecipe(newRecipe)
        dismiss()
    }
}