import Foundation
import Combine

class RecipeStore: ObservableObject {
    @Published var recipes: [Recipe] = []
    @Published var masterIngredients: [Ingredient] = []
    @Published var availableIngredients: [Ingredient] = []

    private static func recipesFileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                       in: .userDomainMask,
                                       appropriateFor: nil,
                                       create: false)
            .appendingPathComponent("recipes.data")
    }

    init() {
        loadMasterIngredients()
        loadRecipes()
        
        // Populate available ingredients for demo if pantry is empty
        if availableIngredients.isEmpty {
            availableIngredients = Array(masterIngredients.shuffled().prefix(5))
        }
    }
    
    // MARK: - Ingredient Methods
    
    func ingredients(for recipe: Recipe) -> [Ingredient] {
        let recipeIngredientNames = Set(recipe.ingredientNames.map { $0.lowercased() })
        return masterIngredients.filter { ingredient in
            recipeIngredientNames.contains(ingredient.name.lowercased())
        }
    }

    func addAvailableIngredient(named name: String) {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines).capitalized
        guard !trimmedName.isEmpty else { return }
        
        // Only add to pantry if it exists in the master list and is not already in the pantry
        if let masterIngredient = masterIngredients.first(where: { $0.name.caseInsensitiveCompare(trimmedName) == .orderedSame }),
           !availableIngredients.contains(where: { $0.id == masterIngredient.id }) {
            availableIngredients.append(masterIngredient)
        }
    }
    
    func addAvailableIngredient(_ ingredient: Ingredient) {
        if !availableIngredients.contains(where: { $0.id == ingredient.id }) {
            availableIngredients.append(ingredient)
        }
    }

    func removeIngredientFromPantry(at offsets: IndexSet) {
        availableIngredients.remove(atOffsets: offsets)
    }
    
    // MARK: - Recipe Methods

    func addRecipe(_ recipe: Recipe) {
        recipes.append(recipe)
        saveRecipes()
    }

    func updateRecipe(_ recipe: Recipe) {
        if let index = recipes.firstIndex(where: { $0.id == recipe.id }) {
            recipes[index] = recipe
        }
    }

    func removeRecipe(at offsets: IndexSet, from filteredRecipes: [Recipe]) {
        let idsToDelete = offsets.map { filteredRecipes[$0].id }
        recipes.removeAll { idsToDelete.contains($0.id) }
    }
    
    var matchedRecipes: [Recipe] {
        recipes.filter { recipe in
            let recipeIngredientSet = Set(recipe.ingredientNames.map { $0.lowercased() })
            let availableIngredientSet = Set(availableIngredients.map { $0.name.lowercased() })
            return recipeIngredientSet.isSubset(of: availableIngredientSet)
        }
    }
    
    // MARK: - Data Persistence

    private func loadMasterIngredients() {
        if let bundleURL = Bundle.main.url(forResource: "ingredients", withExtension: "json") {
            do {
                let data = try Data(contentsOf: bundleURL)
                masterIngredients = try JSONDecoder().decode([Ingredient].self, from: data)
            } catch {
                print("Failed to load or decode ingredients from bundle: \(error)")
            }
        }
    }
    
    private func loadRecipes() {
        do {
            let fileURL = try Self.recipesFileURL()
            let data = try Data(contentsOf: fileURL)
            recipes = try JSONDecoder().decode([Recipe].self, from: data)
        } catch {
            print("Could not load recipes from file, using sample data.")
            recipes = sampleRecipes
        }
    }

    private func saveRecipes() {
        // This now saves the recipes array which has a didSet property observer.
        // To ensure it saves, we explicitly assign it to itself.
        // A more robust way would be to have this method accept the array to save.
        let recipesToSave = self.recipes
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try JSONEncoder().encode(recipesToSave)
                let outfile = try Self.recipesFileURL()
                try data.write(to: outfile)
            } catch {
                print("Error saving recipes: \(error.localizedDescription)")
            }
        }
    }
    
    private var sampleRecipes: [Recipe] {
        return [
            Recipe(name: "Spaghetti Carbonara",
                   ingredientNames: ["Spaghetti", "Guanciale", "Eggs", "Pecorino Cheese", "Pepper"],
                   instructions: "1. Cook the pasta. 2. Fry the guanciale. 3. Mix eggs and cheese. 4. Combine everything and serve.",
                   symbolName: "fork.knife", category: "Italian"),
            Recipe(name: "Tomato Salad",
                   ingredientNames: ["Tomatoes", "Basil", "Olive Oil", "Salt", "Garlic"],
                   instructions: "1. Slice the tomatoes. 2. Add basil, olive oil, salt, and crushed garlic. 3. Mix and enjoy.",
                   symbolName: "leaf.fill", category: "Salad"),
            Recipe(name: "Chicken Curry",
                   ingredientNames: ["Chicken Breast", "Curry Powder", "Coconut Milk", "Rice", "Onion", "Olive Oil", "Salt"],
                   instructions: "1. Sauté onion in olive oil. 2. Add chicken and cook through. 3. Stir in curry powder, then add coconut milk. 4. Simmer until sauce thickens. 5. Serve with cooked rice.",
                   symbolName: "fork.knife.circle.fill", category: "Asian"),
        ]
    }
}

// Update RecipeStore to call saveRecipes when recipes array is modified.
extension RecipeStore {
    func setupRecipesObserver() {
        $recipes
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.saveRecipes()
            }
            .store(in: &cancellables)
    }
    private var cancellables: Set<AnyCancellable> { get { return [] } set { } } // Dummy implementation
}