migrate((app) => {
    const collections = [
        {
            "name": "weight_logs",
            "type": "base",
            "schema": [
                { "name": "user", "type": "relation", "required": true, "options": { "collectionId": "_pb_users_auth_", "cascadeDelete": true, "maxSelect": 1 } },
                { "name": "weight", "type": "number", "required": true },
                { "name": "date", "type": "date", "required": true },
                { "name": "note", "type": "text" },
                { "name": "photo", "type": "file", "options": { "maxSelect": 1, "maxSize": 5242880 } }
            ]
        },
        {
            "name": "food_items",
            "type": "base",
            "schema": [
                { "name": "name", "type": "text", "required": true },
                { "name": "name_hindi", "type": "text" },
                { "name": "name_tamil", "type": "text" },
                { "name": "category", "type": "select", "options": { "values": ["breakfast", "lunch", "dinner", "snack", "drink", "sweet", "street_food"] } },
                { "name": "cuisine_type", "type": "select", "options": { "values": ["north_indian", "south_indian", "bengali", "gujarati", "punjabi", "other"] } },
                { "name": "serving_size", "type": "text" },
                { "name": "calories", "type": "number" },
                { "name": "protein", "type": "number" },
                { "name": "carbs", "type": "number" },
                { "name": "fats", "type": "number" },
                { "name": "fiber", "type": "number" },
                { "name": "sugar", "type": "number" },
                { "name": "sodium", "type": "number" },
                { "name": "is_vegetarian", "type": "bool" },
                { "name": "is_vegan", "type": "bool" },
                { "name": "tags", "type": "json" },
                { "name": "barcode", "type": "text" },
                { "name": "source", "type": "select", "options": { "values": ["curated", "openfoodfacts", "user"] } },
                { "name": "verified", "type": "bool", "default": false },
                { "name": "added_by", "type": "relation", "options": { "collectionId": "_pb_users_auth_", "maxSelect": 1 } },
                { "name": "image", "type": "file", "options": { "maxSelect": 1 } }
            ]
        },
        {
            "name": "food_logs",
            "type": "base",
            "schema": [
                { "name": "user", "type": "relation", "required": true, "options": { "collectionId": "_pb_users_auth_", "maxSelect": 1 } },
                { "name": "food_item", "type": "relation", "required": true, "options": { "collectionId": "food_items", "maxSelect": 1 } },
                { "name": "meal_type", "type": "select", "options": { "values": ["breakfast", "lunch", "dinner", "snack"] } },
                { "name": "servings", "type": "number", "default": 1 },
                { "name": "date", "type": "date", "required": true },
                { "name": "photo", "type": "file", "options": { "maxSelect": 1 } },
                { "name": "note", "type": "text" }
            ]
        },
        {
            "name": "workouts",
            "type": "base",
            "schema": [
                { "name": "title", "type": "text", "required": true },
                { "name": "title_hindi", "type": "text" },
                { "name": "description", "type": "text" },
                { "name": "category", "type": "select", "options": { "values": ["yoga", "bollywood", "gym", "hiit", "desi", "sports"] } },
                { "name": "difficulty", "type": "select", "options": { "values": ["beginner", "intermediate", "advanced"] } },
                { "name": "duration_mins", "type": "number" },
                { "name": "calories_burned", "type": "number" },
                { "name": "video_url", "type": "url" },
                { "name": "thumbnail", "type": "file", "options": { "maxSelect": 1 } },
                { "name": "instructions", "type": "text" },
                { "name": "equipment_needed", "type": "json" },
                { "name": "is_premium", "type": "bool", "default": false },
                { "name": "karma_cost", "type": "number", "default": 0 }
            ]
        },
        {
            "name": "workout_logs",
            "type": "base",
            "schema": [
                { "name": "user", "type": "relation", "required": true, "options": { "collectionId": "_pb_users_auth_", "maxSelect": 1 } },
                { "name": "workout", "type": "relation", "required": true, "options": { "collectionId": "workouts", "maxSelect": 1 } },
                { "name": "date", "type": "date", "required": true },
                { "name": "duration_mins", "type": "number" },
                { "name": "calories_burned", "type": "number" },
                { "name": "rating", "type": "number" },
                { "name": "note", "type": "text" },
                { "name": "heart_rate_avg", "type": "number" }
            ]
        },
        {
            "name": "steps_logs",
            "type": "base",
            "schema": [
                { "name": "user", "type": "relation", "required": true, "options": { "collectionId": "_pb_users_auth_", "maxSelect": 1 } },
                { "name": "date", "type": "date", "required": true },
                { "name": "steps", "type": "number", "default": 0 },
                { "name": "distance_km", "type": "number", "default": 0 },
                { "name": "calories", "type": "number", "default": 0 },
                { "name": "hourly_data", "type": "json" }
            ]
        },
        {
            "name": "water_logs",
            "type": "base",
            "schema": [
                { "name": "user", "type": "relation", "required": true, "options": { "collectionId": "_pb_users_auth_", "maxSelect": 1 } },
                { "name": "date", "type": "date", "required": true },
                { "name": "glasses", "type": "number", "default": 0 },
                { "name": "ml_total", "type": "number", "default": 0 }
            ]
        },
        {
            "name": "karma_transactions",
            "type": "base",
            "schema": [
                { "name": "user", "type": "relation", "required": true, "options": { "collectionId": "_pb_users_auth_", "maxSelect": 1 } },
                { "name": "amount", "type": "number", "required": true },
                { "name": "action_type", "type": "text" },
                { "name": "description", "type": "text" },
                { "name": "date", "type": "date", "required": true }
            ]
        },
        {
            "name": "posts",
            "type": "base",
            "schema": [
                { "name": "user", "type": "relation", "required": true, "options": { "collectionId": "_pb_users_auth_", "maxSelect": 1 } },
                { "name": "content", "type": "text" },
                { "name": "type", "type": "select", "options": { "values": ["workout", "meal", "progress", "story", "question"] } },
                { "name": "media", "type": "file", "options": { "maxSelect": 5, "maxSize": 10485760 } },
                { "name": "tags", "type": "json" },
                { "name": "likes_count", "type": "number", "default": 0 },
                { "name": "comments_count", "type": "number", "default": 0 },
                { "name": "is_featured", "type": "bool", "default": false }
            ]
        },
        {
            "name": "comments",
            "type": "base",
            "schema": [
                { "name": "post", "type": "relation", "required": true, "options": { "collectionId": "posts", "maxSelect": 1 } },
                { "name": "user", "type": "relation", "required": true, "options": { "collectionId": "_pb_users_auth_", "maxSelect": 1 } },
                { "name": "content", "type": "text", "required": true },
                { "name": "likes_count", "type": "number", "default": 0 }
            ]
        },
        {
            "name": "likes",
            "type": "base",
            "schema": [
                { "name": "user", "type": "relation", "required": true, "options": { "collectionId": "_pb_users_auth_", "maxSelect": 1 } },
                { "name": "post", "type": "relation", "options": { "collectionId": "posts", "maxSelect": 1 } },
                { "name": "comment", "type": "relation", "options": { "collectionId": "comments", "maxSelect": 1 } }
            ]
        },
        {
            "name": "medical_reports",
            "type": "base",
            "schema": [
                { "name": "user", "type": "relation", "required": true, "options": { "collectionId": "_pb_users_auth_", "maxSelect": 1 } },
                { "name": "report_file", "type": "file", "required": true, "options": { "maxSelect": 1 } },
                { "name": "report_date", "type": "date" },
                { "name": "extracted_data", "type": "json" },
                { "name": "verified", "type": "bool", "default": false },
                { "name": "notes", "type": "text" }
            ]
        },
        {
            "name": "challenges",
            "type": "base",
            "schema": [
                { "name": "title", "type": "text", "required": true },
                { "name": "description", "type": "text" },
                { "name": "type", "type": "select", "options": { "values": ["steps", "workouts", "food", "custom"] } },
                { "name": "start_date", "type": "date" },
                { "name": "end_date", "type": "date" },
                { "name": "goal_value", "type": "number" },
                { "name": "karma_reward", "type": "number" },
                { "name": "is_premium", "type": "bool", "default": false },
                { "name": "is_public", "type": "bool", "default": true },
                { "name": "created_by", "type": "relation", "options": { "collectionId": "_pb_users_auth_", "maxSelect": 1 } },
                { "name": "participants", "type": "json" }
            ]
        },
        {
            "name": "challenge_progress",
            "type": "base",
            "schema": [
                { "name": "challenge", "type": "relation", "required": true, "options": { "collectionId": "challenges", "maxSelect": 1 } },
                { "name": "user", "type": "relation", "required": true, "options": { "collectionId": "_pb_users_auth_", "maxSelect": 1 } },
                { "name": "current_value", "type": "number", "default": 0 },
                { "name": "completed", "type": "bool", "default": false },
                { "name": "completion_date", "type": "date" }
            ]
        },
        {
            "name": "diet_plans",
            "type": "base",
            "schema": [
                { "name": "user", "type": "relation", "required": true, "options": { "collectionId": "_pb_users_auth_", "maxSelect": 1 } },
                { "name": "week_start_date", "type": "date", "required": true },
                { "name": "plan_data", "type": "json" },
                { "name": "daily_calories", "type": "number" },
                { "name": "macro_split", "type": "json" },
                { "name": "notes", "type": "text" }
            ]
        },
        {
            "name": "subscriptions",
            "type": "base",
            "schema": [
                { "name": "user", "type": "relation", "required": true, "options": { "collectionId": "_pb_users_auth_", "maxSelect": 1 } },
                { "name": "plan", "type": "select", "options": { "values": ["monthly", "quarterly", "yearly", "family"] } },
                { "name": "start_date", "type": "date", "required": true },
                { "name": "end_date", "type": "date", "required": true },
                { "name": "razorpay_subscription_id", "type": "text" },
                { "name": "status", "type": "select", "options": { "values": ["active", "cancelled", "expired"] } },
                { "name": "auto_renew", "type": "bool", "default": true }
            ]
        }
    ];

    for (const collection of collections) {
        app.save(new Collection(collection));
    }

    // Update users collection with extra fields
    const users = app.findCollectionByNameOrId("users");

    users.fields.add(new TextField({ "name": "full_name" }));
    users.fields.add(new NumberField({ "name": "age" }));
    users.fields.add(new SelectField({ "name": "gender", "values": ["male", "female", "other"] }));
    users.fields.add(new NumberField({ "name": "height" }));
    users.fields.add(new NumberField({ "name": "current_weight" }));
    users.fields.add(new NumberField({ "name": "goal_weight" }));
    users.fields.add(new SelectField({ "name": "activity_level", "values": ["sedentary", "lightly_active", "moderately_active", "very_active", "extra_active"] }));
    users.fields.add(new SelectField({ "name": "goal_type", "values": ["weight_loss", "muscle_gain", "stay_fit", "manage_condition", "wellness"] }));
    users.fields.add(new SelectField({ "name": "dietary_preference", "values": ["veg_satvik", "veg_onion_garlic", "veg_jain", "non_veg", "vegan", "eggetarian"] }));
    users.fields.add(new TextField({ "name": "language" }));
    users.fields.add(new SelectField({ "name": "dosha", "values": ["vata", "pitta", "kapha"] }));
    users.fields.add(new JsonField({ "name": "health_conditions" }));
    users.fields.add(new JsonField({ "name": "workout_preferences" }));
    users.fields.add(new NumberField({ "name": "karma_points", "default": 0 }));
    users.fields.add(new SelectField({ "name": "karma_tier", "values": ["bronze", "silver", "gold", "platinum", "diamond"] }));
    users.fields.add(new NumberField({ "name": "streak_days", "default": 0 }));
    users.fields.add(new DateTimeField({ "name": "last_active_date" }));
    users.fields.add(new SelectField({ "name": "subscription_status", "values": ["free", "premium"], "default": "free" }));
    users.fields.add(new DateTimeField({ "name": "subscription_expires" }));
    users.fields.add(new FileField({ "name": "profile_photo", "maxSelect": 1 }));
    users.fields.add(new BoolField({ "name": "onboarding_completed", "default": false }));

    app.save(users);
}, (app) => {
    // rollback logic: delete collections in reverse order
    const collectionNames = [
        "subscriptions", "diet_plans", "challenge_progress", "challenges",
        "medical_reports", "likes", "comments", "posts", "karma_transactions",
        "water_logs", "steps_logs", "workout_logs", "workouts", "food_logs",
        "food_items", "weight_logs"
    ];
    for (const name of collectionNames) {
        const collection = app.findCollectionByNameOrId(name);
        if (collection) app.delete(collection);
    }
})
