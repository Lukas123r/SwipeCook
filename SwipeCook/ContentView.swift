
import SwiftUI

struct ContentView: View {
    @StateObject private var recipeStore = RecipeStore()

    var body: some View {
        TabView {
            MatchedRecipesView(recipeStore: recipeStore)
                .tabItem {
                    Image(systemName: "flame")
                    Text("Recipes")
                }

            IngredientView(recipeStore: recipeStore)
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Ingredients")
                }

            MyRecipesView(recipeStore: recipeStore)
                .tabItem {
                    Image(systemName: "book.closed.fill")
                    Text("My Recipes")
                }

            FavoriteRecipesView(recipeStore: recipeStore)
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("Favorites")
                }
        }
    }
}
