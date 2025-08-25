import SwiftUI

struct MyRecipesView: View {
    @ObservedObject var recipeStore: RecipeStore
    @State private var searchText = ""

    var filteredRecipes: [Recipe] {
        if searchText.isEmpty {
            return recipeStore.recipes
        } else {
            return recipeStore.recipes.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.category.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(filteredRecipes) { recipe in
                    NavigationLink(destination: RecipeDetailView(recipe: recipe, recipeStore: recipeStore)) {
                        HStack {
                            Text(recipe.name)
                            Spacer()
                            if !recipe.category.isEmpty {
                                Text(recipe.category)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            if recipe.isFavorite {
                                Image(systemName: "heart.fill")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                }
                .onDelete(perform: deleteRecipe)
            }
            .navigationTitle("My Recipes")
            .searchable(text: $searchText)
            .toolbar {
                EditButton()
            }
        }
    }

    private func deleteRecipe(at offsets: IndexSet) {
        recipeStore.recipes.remove(atOffsets: offsets)
    }
}
