migrate((db) => {
  // Create food_items collection
  const foodItemsCollection = new Collection({
    name: "food_items",
    type: "base",
    schema: [
      { name: "name", type: "text", required: true },
      { name: "name_hindi", type: "text" },
      { name: "name_tamil", type: "text" },
      { name: "name_telugu", type: "text" },
      { name: "name_bengali", type: "text" },
      { name: "name_marathi", type: "text" },
      { name: "name_gujarati", type: "text" },
      { name: "name_kannada", type: "text" },
      { name: "name_malayalam", type: "text" },
      { name: "name_punjabi", type: "text" },
      { name: "category", type: "select", required: true, options: ["breakfast", "lunch", "dinner", "snack", "street_food", "sweets", "beverages"] },
      { name: "cuisine_type", type: "select", options: ["north_indian", "south_indian", "east_indian", "west_indian", "central_indian"] },
      { name: "serving_size", type: "text", required: true },
      { name: "calories", type: "number", required: true },
      { name: "protein", type: "number", required: true },
      { name: "carbs", type: "number", required: true },
      { name: "fats", type: "number", required: true },
      { name: "fiber", type: "number" },
      { name: "sugar", type: "number" },
      { name: "sodium", type: "number" },
      { name: "is_vegetarian", type: "bool", required: true },
      { name: "is_vegan", type: "bool", required: true },
      { name: "tags", type: "json" },
      { name: "barcode", type: "text" },
      { name: "source", type: "select", required: true, options: ["curated", "openfoodfacts", "user"] },
      { name: "verified", type: "bool", required: true },
      { name: "added_by", type: "relation", options: { collectionId: "users" } },
      { name: "image", type: "file" }
    ],
    indexes: [
      { fields: ["name"], unique: false },
      { fields: ["barcode"], unique: true, sparse: true },
      { fields: ["category"], unique: false },
      { fields: ["cuisine_type"], unique: false }
    ]
  });

  // Create food_logs collection
  const foodLogsCollection = new Collection({
    name: "food_logs",
    type: "base",
    schema: [
      { name: "user", type: "relation", required: true, options: { collectionId: "users", cascadeDelete: true } },
      { name: "food_item", type: "relation", required: true, options: { collectionId: "food_items" } },
      { name: "meal_type", type: "select", required: true, options: ["breakfast", "lunch", "dinner", "snack"] },
      { name: "servings", type: "number", required: true },
      { name: "date", type: "date", required: true },
      { name: "photo", type: "file" },
      { name: "note", type: "text" },
      { name: "calories", type: "number" },
      { name: "protein", type: "number" },
      { name: "carbs", type: "number" },
      { name: "fats", type: "number" },
      { name: "fiber", type: "number" },
      { name: "sugar", type: "number" },
      { name: "sodium", type: "number" }
    ],
    indexes: [
      { fields: ["user", "date"], unique: false },
      { fields: ["meal_type"], unique: false }
    ]
  });

  // Create sample Indian food items
  const sampleFoods = [
    {
      name: "Whole Wheat Roti",
      name_hindi: "गेहूं की रोटी",
      category: "lunch",
      cuisine_type: "north_indian",
      serving_size: "1 medium (40g)",
      calories: 70,
      protein: 3,
      carbs: 15,
      fats: 0.5,
      fiber: 2,
      is_vegetarian: true,
      is_vegan: true,
      verified: true,
      source: "curated",
      tags: ["staple", "low-fat"]
    },
    {
      name: "Plain Rice (Steamed)",
      name_hindi: "चावल",
      category: "lunch",
      cuisine_type: "all",
      serving_size: "1 cup (150g)",
      calories: 200,
      protein: 4,
      carbs: 45,
      fats: 0.5,
      fiber: 1,
      is_vegetarian: true,
      is_vegan: true,
      verified: true,
      source: "curated",
      tags: ["staple", "gluten-free"]
    },
    {
      name: "Dal (Toor/Arhar)",
      name_hindi: "तूर दाल",
      category: "lunch",
      cuisine_type: "north_indian",
      serving_size: "1 katori (150g)",
      calories: 120,
      protein: 8,
      carbs: 20,
      fats: 2,
      fiber: 5,
      is_vegetarian: true,
      is_vegan: true,
      verified: true,
      source: "curated",
      tags: ["high-protein", "fiber-rich"]
    },
    {
      name: "Idli",
      name_hindi: "इडली",
      name_tamil: "இட்லி",
      category: "breakfast",
      cuisine_type: "south_indian",
      serving_size: "2 pieces",
      calories: 80,
      protein: 2,
      carbs: 16,
      fats: 0.5,
      fiber: 1,
      is_vegetarian: true,
      is_vegan: true,
      verified: true,
      source: "curated",
      tags: ["fermented", "light"]
    },
    {
      name: "Dosa (Plain)",
      name_hindi: "डोसा",
      name_tamil: "தோசை",
      category: "breakfast",
      cuisine_type: "south_indian",
      serving_size: "1 medium",
      calories: 120,
      protein: 3,
      carbs: 22,
      fats: 2,
      fiber: 1,
      is_vegetarian: true,
      is_vegan: true,
      verified: true,
      source: "curated",
      tags: ["fermented", "crispy"]
    },
    {
      name: "Poha",
      name_hindi: "पोहा",
      name_marathi: "पोहे",
      category: "breakfast",
      cuisine_type: "west_indian",
      serving_size: "1 plate (200g)",
      calories: 250,
      protein: 4,
      carbs: 45,
      fats: 6,
      fiber: 2,
      is_vegetarian: true,
      is_vegan: true,
      verified: true,
      source: "curated",
      tags: ["light", "quick"]
    },
    {
      name: "Upma",
      name_hindi: "उपमा",
      name_tamil: "உப்புமா",
      category: "breakfast",
      cuisine_type: "south_indian",
      serving_size: "1 cup (200g)",
      calories: 200,
      protein: 5,
      carbs: 35,
      fats: 5,
      fiber: 3,
      is_vegetarian: true,
      is_vegan: true,
      verified: true,
      source: "curated",
      tags: ["savory", "filling"]
    },
    {
      name: "Paratha (Plain)",
      name_hindi: "पराठा",
      category: "breakfast",
      cuisine_type: "north_indian",
      serving_size: "1 medium",
      calories: 120,
      protein: 3,
      carbs: 18,
      fats: 4,
      fiber: 2,
      is_vegetarian: true,
      is_vegan: false,
      verified: true,
      source: "curated",
      tags: ["fried", "heavy"]
    },
    {
      name: "Aloo Paratha",
      name_hindi: "आलू पराठा",
      category: "breakfast",
      cuisine_type: "north_indian",
      serving_size: "1 medium",
      calories: 180,
      protein: 4,
      carbs: 28,
      fats: 6,
      fiber: 3,
      is_vegetarian: true,
      is_vegan: false,
      verified: true,
      source: "curated",
      tags: ["stuffed", "popular"]
    },
    {
      name: "Samosa",
      name_hindi: "समोसा",
      category: "snack",
      cuisine_type: "north_indian",
      serving_size: "1 piece",
      calories: 150,
      protein: 3,
      carbs: 18,
      fats: 8,
      fiber: 2,
      is_vegetarian: true,
      is_vegan: true,
      verified: true,
      source: "curated",
      tags: ["fried", "street_food"]
    },
    {
      name: "Chai (Tea with Milk)",
      name_hindi: "चाय",
      category: "beverages",
      cuisine_type: "all",
      serving_size: "1 cup (150ml)",
      calories: 80,
      protein: 2,
      carbs: 12,
      fats: 3,
      is_vegetarian: true,
      is_vegan: false,
      verified: true,
      source: "curated",
      tags: ["beverage", "caffeine"]
    },
    {
      name: "Filter Coffee",
      name_tamil: "காபி",
      category: "beverages",
      cuisine_type: "south_indian",
      serving_size: "1 cup (150ml)",
      calories: 70,
      protein: 1,
      carbs: 10,
      fats: 3,
      is_vegetarian: true,
      is_vegan: false,
      verified: true,
      source: "curated",
      tags: ["beverage", "caffeine"]
    },
    {
      name: "Rajma (Kidney Beans)",
      name_hindi: "राजमा",
      category: "lunch",
      cuisine_type: "north_indian",
      serving_size: "1 katori (150g)",
      calories: 140,
      protein: 9,
      carbs: 22,
      fats: 2,
      fiber: 6,
      is_vegetarian: true,
      is_vegan: true,
      verified: true,
      source: "curated",
      tags: ["high-protein", "fiber-rich"]
    },
    {
      name: "Chole (Chickpeas)",
      name_hindi: "छोले",
      category: "lunch",
      cuisine_type: "north_indian",
      serving_size: "1 katori (150g)",
      calories: 160,
      protein: 7,
      carbs: 24,
      fats: 4,
      fiber: 7,
      is_vegetarian: true,
      is_vegan: true,
      verified: true,
      source: "curated",
      tags: ["high-protein", "fiber-rich"]
    },
    {
      name: "Paneer Tikka",
      name_hindi: "पनीर टिक्का",
      category: "dinner",
      cuisine_type: "north_indian",
      serving_size: "100g",
      calories: 280,
      protein: 18,
      carbs: 6,
      fats: 20,
      fiber: 1,
      is_vegetarian: true,
      is_vegan: false,
      verified: true,
      source: "curated",
      tags: ["high-protein", "grilled"]
    },
    {
      name: "Chicken Curry",
      name_hindi: "चिकन करी",
      category: "lunch",
      cuisine_type: "north_indian",
      serving_size: "1 katori (150g)",
      calories: 220,
      protein: 20,
      carbs: 8,
      fats: 12,
      fiber: 1,
      is_vegetarian: false,
      is_vegan: false,
      verified: true,
      source: "curated",
      tags: ["high-protein", "non-veg"]
    },
    {
      name: "Fish Curry",
      name_bengali: "মাছের ঝোল",
      category: "lunch",
      cuisine_type: "east_indian",
      serving_size: "1 katori (150g)",
      calories: 180,
      protein: 22,
      carbs: 5,
      fats: 8,
      fiber: 0,
      is_vegetarian: false,
      is_vegan: false,
      verified: true,
      source: "curated",
      tags: ["high-protein", "omega-3"]
    },
    {
      name: "Egg Curry",
      name_hindi: "अंडा करी",
      category: "lunch",
      cuisine_type: "all",
      serving_size: "2 eggs with gravy",
      calories: 200,
      protein: 14,
      carbs: 6,
      fats: 14,
      fiber: 1,
      is_vegetarian: false,
      is_vegan: false,
      verified: true,
      source: "curated",
      tags: ["high-protein", "eggetarian"]
    },
    {
      name: "Boiled Egg",
      name_hindi: "उबला अंडा",
      category: "snack",
      cuisine_type: "all",
      serving_size: "1 large egg",
      calories: 70,
      protein: 6,
      carbs: 0.5,
      fats: 5,
      fiber: 0,
      is_vegetarian: false,
      is_vegan: false,
      verified: true,
      source: "curated",
      tags: ["quick", "protein"]
    },
    {
      name: "Banana",
      name_hindi: "केला",
      category: "snack",
      cuisine_type: "all",
      serving_size: "1 medium",
      calories: 105,
      protein: 1,
      carbs: 27,
      fats: 0.3,
      fiber: 3,
      is_vegetarian: true,
      is_vegan: true,
      verified: true,
      source: "curated",
      tags: ["fruit", "potassium"]
    }
  ];

  // Save collections
  db.saveCollection(foodItemsCollection);
  db.saveCollection(foodLogsCollection);

  // Insert sample foods
  for (const food of sampleFoods) {
    try {
      db.saveRecord("food_items", new Record(food));
    } catch (e) {
      console.log(`Failed to insert ${food.name}: ${e.message}`);
    }
  }

  // Set API rules for food_items (public read, authenticated write)
  foodItemsCollection.setRule("list", "@request.auth.id != '' || 1=1");
  foodItemsCollection.setRule("view", "@request.auth.id != '' || 1=1");
  foodItemsCollection.setRule("create", "@request.auth.id != ''");
  foodItemsCollection.setRule("update", "@request.auth.id != '' && (source = 'user' || @request.auth.id = added_by)");
  foodItemsCollection.setRule("delete", "@request.auth.id != '' && source = 'user' && @request.auth.id = added_by");

  // Set API rules for food_logs (private to user)
  foodLogsCollection.setRule("list", "@request.auth.id = user");
  foodLogsCollection.setRule("view", "@request.auth.id = user");
  foodLogsCollection.setRule("create", "@request.auth.id = user");
  foodLogsCollection.setRule("update", "@request.auth.id = user");
  foodLogsCollection.setRule("delete", "@request.auth.id = user");

  db.saveCollection(foodItemsCollection);
  db.saveCollection(foodLogsCollection);
}, (db) => {
  // Rollback
  db.deleteCollection("food_items");
  db.deleteCollection("food_logs");
});
