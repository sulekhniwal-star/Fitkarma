migrate((app) => {
    const quizQuestions = [
        {
            "question": "How would you describe your physical build?",
            "options": {
                "vata": "Thin, prominent joints, difficult to gain weight",
                "pitta": "Medium build, good muscle tone, stable weight",
                "kapha": "Large build, thick skin, gains weight easily"
            },
            "category": "physical",
            "order": 1
        },
        {
            "question": "How is your digestion and appetite?",
            "options": {
                "vata": "Irregular, variable appetite, frequent gas/bloating",
                "pitta": "Strong, intense hunger if meals are skipped",
                "kapha": "Slow but steady, can skip meals easily"
            },
            "category": "lifestyle",
            "order": 2
        },
        {
            "question": "How do you react to stress?",
            "options": {
                "vata": "Anxious, worried, or fearful",
                "pitta": "Irritable, angry, or impatient",
                "kapha": "Withdrawn, calm, or avoidant"
            },
            "category": "mental",
            "order": 3
        }
    ];

    const recommendations = [
        {
            "dosha": "vata",
            "type": "food",
            "title": "Warm and Grounding Meals",
            "content": "Focus on warm, cooked foods like soups, stews, and grains. Use warming spices like ginger and cinnamon."
        },
        {
            "dosha": "pitta",
            "type": "food",
            "title": "Cooling and Hydrating",
            "content": "Favor cooling foods like cucumbers, melons, and leafy greens. Avoid spicy and fried foods."
        },
        {
            "dosha": "kapha",
            "type": "food",
            "title": "Light and Stimulating",
            "content": "Choose light, spicy, and bitter foods. Favor legumes and steamed vegetables. Reduce dairy and sweets."
        }
    ];

    for (const q of quizQuestions) {
        app.save(new Record(app.findCollectionByNameOrId("ayurvedic_quiz_questions"), q));
    }

    for (const r of recommendations) {
        app.save(new Record(app.findCollectionByNameOrId("ayurvedic_recommendations"), r));
    }
}, (app) => {
    // Rollback not strictly necessary for data seeding but good practice
})
