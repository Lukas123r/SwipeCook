import SwiftUI

struct FavoriteRecipesView: View {
    @ObservedObject var recipeStore: RecipeStore

    var body: some View {
        NavigationView {
            List {
                ForEach(recipeStore.recipes.filter { $0.isFavorite }) { recipe in
                    NavigationLink(destination: RecipeDetailView(recipe: recipe, recipeStore: recipeStore)) {
                        HStack {
                            Text(recipe.name)
                            Spacer()
                            if !recipe.category.isEmpty {
                                Text(recipe.category)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Favorite Recipes")
        }
    }
}
