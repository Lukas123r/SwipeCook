
import SwiftUI

struct IngredientView: View {
    @ObservedObject var recipeStore: RecipeStore
    @State private var newIngredientName: String = ""
    @State private var suggestions: [Ingredient] = []
    @FocusState private var isTextFieldFocused: Bool

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // --- Input Section ---
                VStack(alignment: .leading) {
                    HStack {
                        TextField("Add an ingredient...", text: $newIngredientName)
                            .textFieldStyle(.plain)
                            .padding(12)
                            .background(Theme.cardBackground)
                            .cornerRadius(10)
                            .focused($isTextFieldFocused)
                            .onChange(of: newIngredientName) { _, newValue in
                                updateSuggestions(for: newValue)
                            }
                        
                        Button(action: addManually) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title2)
                                .foregroundColor(Theme.primary)
                        }
                    }
                    
                    // --- Suggestions List (Dynamically sized) ---
                    if !suggestions.isEmpty {
                        LazyVStack(spacing: 4) {
                            ForEach(suggestions) { suggestion in
                                Button(action: { addSuggestion(suggestion) }) {
                                    Text(suggestion.name)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(10)
                                        .background(Color.gray.opacity(0.1))
                                        .cornerRadius(8)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .background(Theme.cardBackground)
                        .cornerRadius(10)
                        .transition(.opacity.animation(.easeInOut))
                    }
                }
                .padding()
                .background(Theme.background)

                // --- Pantry List ---
                if recipeStore.availableIngredients.isEmpty {
                    Spacer()
                    VStack {
                        Image(systemName: "basket.fill")
                            .font(.system(size: 50))
                            .foregroundColor(Theme.secondaryText)
                        Text("Your pantry is empty.")
                            .font(.headline)
                            .foregroundColor(Theme.text)
                        Text("Add ingredients using the field above to find matching recipes.")
                            .font(.subheadline)
                            .foregroundColor(Theme.secondaryText)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    Spacer()
                } else {
                    List {
                        ForEach(recipeStore.availableIngredients) { ingredient in
                            IngredientRow(ingredient: ingredient) {
                                if let index = recipeStore.availableIngredients.firstIndex(where: { $0.id == ingredient.id }) {
                                    recipeStore.removeIngredientFromPantry(at: IndexSet(integer: index))
                                }
                            }
                        }
                        .listRowBackground(Theme.background)
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
                    }
                    .listStyle(.plain)
                    .background(Theme.background)
                }
            }
            .navigationTitle("My Pantry")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                        .tint(Theme.primary)
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onTapGesture {
             isTextFieldFocused = false
        }
    }
    
    private func updateSuggestions(for input: String) {
        if input.isEmpty {
            suggestions = []
            return
        }
        
        let availableIngredientNames = Set(recipeStore.availableIngredients.map { $0.name.lowercased() })
        
        let filtered = recipeStore.masterIngredients.filter { ingredient in
            let isAlreadyAvailable = availableIngredientNames.contains(ingredient.name.lowercased())
            let matchesInput = ingredient.name.lowercased().contains(input.lowercased())
            return !isAlreadyAvailable && matchesInput
        }
        suggestions = Array(filtered.prefix(5))
    }
    
    private func addSuggestion(_ ingredient: Ingredient) {
        recipeStore.addAvailableIngredient(ingredient)
        newIngredientName = ""
        suggestions = []
        isTextFieldFocused = false
    }
    
    private func addManually() {
        guard !newIngredientName.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        recipeStore.addAvailableIngredient(named: newIngredientName)
        newIngredientName = ""
        isTextFieldFocused = false
    }
}

// --- Ingredient Row Subview ---
struct IngredientRow: View {
    let ingredient: Ingredient
    let deleteAction: () -> Void
    
    var body: some View {
        HStack {
            Image(systemName: "leaf.fill")
                .foregroundColor(Theme.primary)
            Text(ingredient.name)
                .foregroundColor(Theme.text)
            Spacer()
            Button(action: deleteAction) {
                Image(systemName: "trash.circle.fill")
                    .font(.title2)
                    .foregroundColor(.red.opacity(0.7))
            }
            .buttonStyle(.plain)
        }
        .padding()
        .background(Theme.cardBackground)
        .cornerRadius(12)
    }
}
