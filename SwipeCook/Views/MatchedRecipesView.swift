import SwiftUI

struct MatchedRecipesView: View {
    @ObservedObject var recipeStore: RecipeStore
    @State private var matchedRecipes: [Recipe] = []
    @State private var showingCreateRecipeSheet = false

    var body: some View {
        NavigationView {
            VStack {
                if matchedRecipes.isEmpty {
                    VStack {
                        Image(systemName: "fork.knife.circle")
                            .font(.system(size: 60))
                            .foregroundColor(Theme.secondaryText)
                        Text("No matching recipes found.")
                            .font(.headline)
                            .foregroundColor(Theme.text)
                        Text("Try adding more ingredients to your pantry.")
                            .font(.subheadline)
                            .foregroundColor(Theme.secondaryText)
                    }
                    .multilineTextAlignment(.center)
                    .padding()
                } else {
                    ZStack {
                        ForEach(matchedRecipes) { recipe in
                            NavigationLink(destination: RecipeDetailView(recipe: recipe, recipeStore: recipeStore)) {
                                RecipeCardWrapper(recipe: recipe, onRemove: {
                                    withAnimation {
                                        self.matchedRecipes.removeAll { $0.id == recipe.id }
                                    }
                                })
                            }
                            .zIndex(Double(self.matchedRecipes.count - (self.matchedRecipes.firstIndex(where: { $0.id == recipe.id }) ?? 0)))
                        }
                    }
                    .padding(.vertical)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Theme.background)
            .navigationTitle("Recipes for You")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingCreateRecipeSheet = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                }
            }
            .sheet(isPresented: $showingCreateRecipeSheet) {
                CreateRecipeView(recipeStore: recipeStore)
            }
            .onReceive(recipeStore.$availableIngredients) { _ in
                self.matchedRecipes = recipeStore.matchedRecipes
            }
        }
    }
}

struct RecipeCardWrapper: View {
    let recipe: Recipe
    let onRemove: () -> Void
    
    @State private var translation: CGSize = .zero
    @State private var isLiked: Bool? = nil

    private var rotationAngle: Angle {
        .degrees(Double(translation.width / UIScreen.main.bounds.width * 25))
    }

    private var scale: CGFloat {
        let progress = 1 - min(abs(translation.width) / UIScreen.main.bounds.width / 2, 0.1)
        return max(progress, 0.9)
    }

    private var overlayColor: Color {
        if let liked = isLiked {
            return liked ? Color.green : Color.red
        }
        return .clear
    }

    private var overlayOpacity: Double {
        let progress = min(abs(translation.width) / 100, 1)
        return Double(progress)
    }

    var body: some View {
        GeometryReader { geometry in
            RecipeCardView(recipe: recipe)
                .rotationEffect(rotationAngle)
                .scaleEffect(scale)
                .offset(x: self.translation.width, y: 0)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            self.translation = value.translation
                            if value.translation.width > 50 {
                                self.isLiked = true
                            } else if value.translation.width < -50 {
                                self.isLiked = false
                            } else {
                                self.isLiked = nil
                            }
                        }
                        .onEnded { value in
                            if abs(value.translation.width) > 150 {
                                self.onRemove()
                            } else {
                                withAnimation(.spring()) {
                                    self.translation = .zero
                                    self.isLiked = nil
                                }
                            }
                        }
                )
                .overlay(
                    ZStack {
                        if let liked = isLiked {
                            Image(systemName: liked ? "heart.fill" : "xmark.circle.fill")
                                .font(.system(size: 80))
                                .foregroundColor(.white)
                                .padding()
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(overlayColor.opacity(overlayOpacity))
                    .cornerRadius(20)
                )
        }
        .padding(.horizontal)
    }
}