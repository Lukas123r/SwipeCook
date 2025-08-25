import Foundation
import Combine

class RecipeStore: ObservableObject {
    @Published var recipes: [Recipe] {
        didSet {
            saveRecipes()
        }
    }
    @Published var availableIngredients: [Ingredient] = []

    private var cancellables = Set<AnyCancellable>()

    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                       in: .userDomainMask,
                                       appropriateFor: nil,
                                       create: false)
            .appendingPathComponent("recipes.data")
    }

    init() {
        // Populate with sample data
        let salt = Ingredient(name: "Salt")
        let pepper = Ingredient(name: "Pepper")
        let oliveOil = Ingredient(name: "Olive Oil")
        let spaghetti = Ingredient(name: "Spaghetti")
        let guanciale = Ingredient(name: "Guanciale")
        let eggs = Ingredient(name: "Eggs")
        let pecorino = Ingredient(name: "Pecorino Cheese")
        let garlic = Ingredient(name: "Garlic")
        let tomatoes = Ingredient(name: "Tomatoes")
        let basil = Ingredient(name: "Basil")
        let chicken = Ingredient(name: "Chicken Breast")
        let curryPowder = Ingredient(name: "Curry Powder")
        let coconutMilk = Ingredient(name: "Coconut Milk")
        let rice = Ingredient(name: "Rice")
        let onion = Ingredient(name: "Onion")
        let flour = Ingredient(name: "Flour")
        let milk = Ingredient(name: "Milk")
        let sugar = Ingredient(name: "Sugar")
        let butter = Ingredient(name: "Butter")
        let avocado = Ingredient(name: "Avocado")
        let lime = Ingredient(name: "Lime")
        let cilantro = Ingredient(name: "Cilantro")
        let romaineLettuce = Ingredient(name: "Romaine Lettuce")
        let croutons = Ingredient(name: "Croutons")
        let parmesan = Ingredient(name: "Parmesan Cheese")
        let caesarDressing = Ingredient(name: "Caesar Dressing")

        // Load recipes from file
        if let loadedRecipes = try? RecipeStore.loadRecipes() {
            self.recipes = loadedRecipes
        } else {
            self.recipes = [
                Recipe(name: "Spaghetti Carbonara",
                       ingredients: [spaghetti, guanciale, eggs, pecorino, pepper],
                       instructions: "1. Cook the pasta. 2. Fry the guanciale. 3. Mix eggs and cheese. 4. Combine everything and serve.",
                       symbolName: "fork.knife", isFavorite: false, category: "Italian"),
                Recipe(name: "Tomato Salad",
                       ingredients: [tomatoes, basil, oliveOil, salt, garlic],
                       instructions: "1. Slice the tomatoes. 2. Add basil, olive oil, salt, and crushed garlic. 3. Mix and enjoy.",
                       symbolName: "leaf.fill", isFavorite: false, category: "Salad"),
                Recipe(name: "Aglio e Olio",
                    ingredients: [spaghetti, garlic, oliveOil, pepper],
                    instructions: "1. Cook the pasta. 2. Sauté garlic in olive oil. 3. Add the pasta and season with pepper.",
                    symbolName: "flame.fill", isFavorite: false, category: "Italian"),
                Recipe(name: "Chicken Curry",
                       ingredients: [chicken, curryPowder, coconutMilk, rice, onion, oliveOil, salt],
                       instructions: "1. Sauté onion in olive oil. 2. Add chicken and cook through. 3. Stir in curry powder, then add coconut milk. 4. Simmer until sauce thickens. 5. Serve with cooked rice.",
                       symbolName: "fork.knife.circle.fill", isFavorite: false, category: "Asian"),
                Recipe(name: "Pancakes",
                       ingredients: [flour, milk, eggs, sugar, butter, salt],
                       instructions: "1. Whisk together flour, sugar, and salt. 2. In a separate bowl, mix egg and milk. 3. Combine wet and dry ingredients. 4. Melt butter in a pan and cook pancakes until golden brown.",
                       symbolName: "birthday.cake.fill", isFavorite: false, category: "Breakfast"),
                Recipe(name: "Guacamole",
                       ingredients: [avocado, lime, onion, cilantro, salt, pepper],
                       instructions: "1. Mash the avocados in a bowl. 2. Finely chop onion and cilantro. 3. Mix all ingredients together. 4. Season with salt and pepper to taste.",
                       symbolName: "person.fill.and.arrow.left.and.arrow.right", isFavorite: false, category: "Mexican"),
                Recipe(name: "Caesar Salad",
                       ingredients: [romaineLettuce, croutons, parmesan, chicken, caesarDressing],
                       instructions: "1. Wash and chop the lettuce. 2. Cook chicken and slice. 3. Combine lettuce, chicken, croutons, and parmesan in a large bowl. 4. Drizzle with Caesar dressing and toss to combine.",
                       symbolName: "carrot.fill", isFavorite: false, category: "Salad")
            ]
        }

        // Start with some ingredients
        availableIngredients = [spaghetti, salt, pepper, oliveOil, garlic, flour, milk, eggs, sugar]
    }

    func addIngredient(name: String) {
        if !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            availableIngredients.append(Ingredient(name: name))
        }
    }

    func removeIngredient(at offsets: IndexSet) {
        availableIngredients.remove(atOffsets: offsets)
    }

    func addRecipe(_ recipe: Recipe) {
        recipes.append(recipe)
    }

    func updateRecipe(_ recipe: Recipe) {
        if let index = recipes.firstIndex(where: { $0.id == recipe.id }) {
            recipes[index] = recipe
        }
    }

    private func saveRecipes() {
        do {
            let data = try JSONEncoder().encode(recipes)
            let outfile = try RecipeStore.fileURL()
            try data.write(to: outfile)
        } catch {
            print("Error saving recipes: \(error.localizedDescription)")
        }
    }

    private static func loadRecipes() throws -> [Recipe] {
        let infile = try fileURL()
        let data = try Data(contentsOf: infile)
        let decodedRecipes = try JSONDecoder().decode([Recipe].self, from: data)
        return decodedRecipes
    }

    var matchedRecipes: [Recipe] {
        recipes.filter { recipe in
            let recipeIngredientSet = Set(recipe.ingredients.map { $0.name.lowercased() })
            let availableIngredientSet = Set(availableIngredients.map { $0.name.lowercased() })
            return recipeIngredientSet.isSubset(of: availableIngredientSet)
        }
    }
}