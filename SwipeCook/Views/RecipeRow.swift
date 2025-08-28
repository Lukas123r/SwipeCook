
import SwiftUI

struct RecipeRow: View {
    let recipe: Recipe

    var body: some View {
        HStack {
            Image(systemName: recipe.symbolName)
                .font(.title2)
                .foregroundColor(Theme.primary)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(recipe.name)
                    .font(.headline)
                    .foregroundColor(Theme.text)
                
                if !recipe.category.isEmpty {
                    Text(recipe.category)
                        .font(.caption)
                        .foregroundColor(Theme.secondaryText)
                }
            }
            
            Spacer()
            
            if recipe.isFavorite {
                Image(systemName: "heart.fill")
                    .foregroundColor(.red)
            }
        }
        .padding()
        .background(Theme.cardBackground)
        .cornerRadius(12)
    }
}
