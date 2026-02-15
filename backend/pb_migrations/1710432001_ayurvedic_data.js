migrate((app) => {
    const collections = [
        {
            "name": "ayurvedic_quiz_questions",
            "type": "base",
            "schema": [
                { "name": "question", "type": "text", "required": true },
                { "name": "options", "type": "json", "required": true }, // {vata: "...", pitta: "...", kapha: "..."}
                { "name": "category", "type": "select", "options": { "values": ["physical", "mental", "lifestyle"] } },
                { "name": "order", "type": "number" }
            ]
        },
        {
            "name": "ayurvedic_recommendations",
            "type": "base",
            "schema": [
                { "name": "dosha", "type": "select", "required": true, "options": { "values": ["vata", "pitta", "kapha"] } },
                { "name": "type", "type": "select", "options": { "values": ["food", "lifestyle", "yoga", "general"] } },
                { "name": "title", "type": "text", "required": true },
                { "name": "content", "type": "text", "required": true },
                { "name": "image", "type": "file", "options": { "maxSelect": 1 } }
            ]
        },
        {
            "name": "daily_routines",
            "type": "base",
            "schema": [
                { "name": "dosha", "type": "select", "required": true, "options": { "values": ["vata", "pitta", "kapha"] } },
                { "name": "time_of_day", "type": "select", "options": { "values": ["early_morning", "morning", "afternoon", "evening", "night"] } },
                { "name": "activity", "type": "text", "required": true },
                { "name": "description", "type": "text" }
            ]
        },
        {
            "name": "karma_tiers_config",
            "type": "base",
            "schema": [
                { "name": "name", "type": "text", "required": true },
                { "name": "min_points", "type": "number", "required": true },
                { "name": "benefits", "type": "json" },
                { "name": "badge_icon", "type": "file", "options": { "maxSelect": 1 } }
            ]
        }
    ];

    for (const collection of collections) {
        app.save(new Collection(collection));
    }

    // Add some initial data for Karma Tiers if possible via migration?
    // Usually we use app.db().insert() or similar in migrations.
}, (app) => {
    const collectionNames = ["karma_tiers_config", "daily_routines", "ayurvedic_recommendations", "ayurvedic_quiz_questions"];
    for (const name of collectionNames) {
        const collection = app.findCollectionByNameOrId(name);
        if (collection) app.delete(collection);
    }
})
