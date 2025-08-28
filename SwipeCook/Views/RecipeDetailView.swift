
import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe
    @ObservedObject var recipeStore: RecipeStore
    @State private var showingEditRecipeSheet = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Image(systemName: recipe.symbolName)
                    .font(.system(size: 100))
                    .foregroundColor(Theme.primary.opacity(0.6))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.bottom, 10)

                Text(recipe.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Theme.text)

                if !recipe.category.isEmpty {
                    Text(recipe.category)
                        .font(.subheadline)
                        .foregroundColor(Theme.secondaryText)
                }

                Divider()

                Text("Ingredients")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(Theme.text)

                VStack(alignment: .leading, spacing: 10) {
                    ForEach(recipeStore.ingredients(for: recipe)) { ingredient in
                        Text("- \(ingredient.name)")
                            .font(.body)
                            .foregroundColor(Theme.secondaryText)
                    }
                }

                Divider()

                Text("Instructions")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(Theme.text)

                Text(recipe.instructions)
                    .font(.body)
                    .foregroundColor(Theme.secondaryText)
            }
            .padding()
        }
        .navigationTitle(recipe.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    var updatedRecipe = recipe
                    updatedRecipe.isFavorite.toggle()
                    recipeStore.updateRecipe(updatedRecipe)
                } label: {
                    Image(systemName: recipe.isFavorite ? "heart.fill" : "heart")
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Edit") {
                    showingEditRecipeSheet = true
                }
            }
        }
        .sheet(isPresented: $showingEditRecipeSheet) {
            EditRecipeView(recipeStore: recipeStore, recipe: recipe)
        }
        .background(Theme.background.ignoresSafeArea())
    }
}
