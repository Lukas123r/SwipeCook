import SwiftUI

struct RecipeCardView: View {
    
    
    let recipe: Recipe

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            // Background Symbol
            Image(systemName: recipe.symbolName)
                .font(.system(size: 150))
                .foregroundColor(Theme.primary.opacity(0.2))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .padding(20)

            // Gradient Overlay
            LinearGradient(gradient: Gradient(colors: [.clear, .black.opacity(0.8)]),
                           startPoint: .center,
                           endPoint: .bottom)

            // Content
            VStack(alignment: .leading, spacing: 8) {
                Text(recipe.name)
                    .font(.system(.largeTitle, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                if !recipe.category.isEmpty {
                    Text(recipe.category)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.white.opacity(0.7))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Theme.primary.opacity(0.8))
                        .cornerRadius(5)
                }

                Text("Ingredients: \(recipe.ingredientNames.joined(separator: ", "))")
                    .font(.body)
                    .foregroundColor(.white.opacity(0.8))
                    .lineLimit(2)
            }
            .padding(20)
        }
        .background(Theme.cardBackground)
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
    }
}
