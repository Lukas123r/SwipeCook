import SwiftUI

struct IngredientView: View {
    @ObservedObject var recipeStore: RecipeStore
    @State private var newIngredientName: String = ""
    @State private var showingCreateRecipeSheet = false

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Input Section
                VStack {
                    HStack {
                        TextField("Add an ingredient...", text: $newIngredientName)
                            .textFieldStyle(.plain)
                            .padding(12)
                            .background(Theme.cardBackground)
                            .cornerRadius(10)
                        
                        Button(action: addIngredient) {
                            Image(systemName: "plus")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(12)
                                .background(Theme.primary)
                                .cornerRadius(10)
                        }
                    }
                }
                .padding()
                .background(Theme.background)

                // List Section
                List {
                    ForEach(recipeStore.availableIngredients) { ingredient in
                        Text(ingredient.name)
                            .listRowBackground(Theme.cardBackground)
                    }
                    .onDelete(perform: recipeStore.removeIngredient)
                }
                .listStyle(.insetGrouped)
            }
            .background(Theme.background)
            .navigationTitle("My Pantry")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) { // Wrapped EditButton in ToolbarItem
                    EditButton()
                        .tint(Theme.primary)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingCreateRecipeSheet = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .tint(Theme.primary)
                    }
                }
            }
            .sheet(isPresented: $showingCreateRecipeSheet) {
                CreateRecipeView(recipeStore: recipeStore)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func addIngredient() {
        guard !newIngredientName.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        recipeStore.addIngredient(name: newIngredientName)
        newIngredientName = ""
    }
}