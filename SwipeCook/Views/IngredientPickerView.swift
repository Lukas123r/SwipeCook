
import SwiftUI

struct IngredientPickerView: View {
    @Binding var selectedIngredients: [String]
    @Environment(\.dismiss) var dismiss
    
    let allIngredients: [Ingredient]
    @State private var searchText = ""

    var filteredIngredients: [Ingredient] {
        if searchText.isEmpty {
            return allIngredients
        } else {
            return allIngredients.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }

    var body: some View {
        NavigationView {
            List(filteredIngredients) { ingredient in
                Button(action: { toggleSelection(for: ingredient) }) {
                    HStack {
                        Text(ingredient.name)
                        Spacer()
                        if selectedIngredients.contains(ingredient.name) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(Theme.primary)
                        }
                    }
                }
                .foregroundColor(Theme.text)
            }
            .searchable(text: $searchText)
            .navigationTitle("Select Ingredients")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }

    private func toggleSelection(for ingredient: Ingredient) {
        if let index = selectedIngredients.firstIndex(of: ingredient.name) {
            selectedIngredients.remove(at: index)
        } else {
            selectedIngredients.append(ingredient.name)
        }
    }
}
