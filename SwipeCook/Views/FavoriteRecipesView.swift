import SwiftUI

struct FavoriteRecipesView: View {
    @ObservedObject var recipeStore: RecipeStore

    var favoriteRecipes: [Recipe] {
        recipeStore.recipes.filter { $0.isFavorite }
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(favoriteRecipes) { recipe in
                    NavigationLink(destination: RecipeDetailView(recipe: recipe, recipeStore: recipeStore)) {
                        RecipeRow(recipe: recipe)
                    }
                    .listRowBackground(Theme.background)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
                }
            }
            .listStyle(.plain)
            .background(Theme.background)
            .navigationTitle("Favorite Recipes")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}