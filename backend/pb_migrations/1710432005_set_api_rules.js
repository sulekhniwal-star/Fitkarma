migrate((app) => {
    // 1. Set public read for curated content
    const publicCollections = [
        "food_items",
        "workouts",
        "challenges",
        "ayurvedic_quiz_questions",
        "ayurvedic_recommendations",
        "daily_routines",
        "karma_tiers_config"
    ];

    for (const name of publicCollections) {
        try {
            const collection = app.findCollectionByNameOrId(name);
            if (collection) {
                collection.listRule = "";
                collection.viewRule = "";
                app.save(collection);
            }
        } catch (e) { }
    }

    // 2. Set restricted access for all other base collections that have a 'user' field
    const allCollections = app.findAllCollections("base");
    for (const collection of allCollections) {
        // Skip public ones we already set
        if (publicCollections.includes(collection.name)) continue;

        // Check if collection has a 'user' field or 'created_by'
        let fieldName = "";
        try {
            // In some versions of PB JS VM, collection.fields is accessible
            const fields = collection.fields;
            if (fields) {
                for (const f of fields) {
                    if (f.name === "user" || f.name === "created_by") {
                        fieldName = f.name;
                        break;
                    }
                }
            }
        } catch (e) {
            // Fallback: try to just set it and see if PB validates it
            fieldName = "user";
        }

        if (fieldName) {
            try {
                collection.listRule = `@request.auth.id != "" && ${fieldName} = @request.auth.id`;
                collection.viewRule = `@request.auth.id != "" && ${fieldName} = @request.auth.id`;
                collection.createRule = `@request.auth.id != "" && @request.body.${fieldName} = @request.auth.id`;
                collection.updateRule = `@request.auth.id != "" && ${fieldName} = @request.auth.id`;
                collection.deleteRule = `@request.auth.id != "" && ${fieldName} = @request.auth.id`;
                app.save(collection);
            } catch (e) {
                // If it fails (e.g. field doesn't exist), set a general auth-only rule
                collection.listRule = "@request.auth.id != \"\"";
                collection.viewRule = "@request.auth.id != \"\"";
                collection.createRule = "@request.auth.id != \"\"";
                collection.updateRule = "@request.auth.id != \"\"";
                collection.deleteRule = "@request.auth.id != \"\"";
                app.save(collection);
            }
        }
    }
}, (app) => {
    // rollback
})
