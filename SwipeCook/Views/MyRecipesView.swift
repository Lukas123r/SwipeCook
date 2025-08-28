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
                        RecipeRow(recipe: recipe)
                    }
                    .listRowBackground(Theme.background)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
                }
                .onDelete(perform: deleteRecipe)
            }
            .listStyle(.plain)
            .background(Theme.background)
            .navigationTitle("My Recipes")
            .searchable(text: $searchText)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                        .tint(Theme.primary)
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    private func deleteRecipe(at offsets: IndexSet) {
        recipeStore.removeRecipe(at: offsets, from: filteredRecipes)
    }
}