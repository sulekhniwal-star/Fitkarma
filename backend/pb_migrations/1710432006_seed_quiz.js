migrate((app) => {
    const questions = [
        {
            "question": "How would you describe your body frame?",
            "category": "physical",
            "order": 1,
            "options": {
                "vata": "Slender, thin, or bony; difficult to gain weight.",
                "pitta": "Medium build; muscular; easy to maintain weight.",
                "kapha": "Broad, sturdy, or heavy; tendency to gain weight easily."
            }
        },
        {
            "question": "What is your typical skin type?",
            "category": "physical",
            "order": 2,
            "options": {
                "vata": "Dry, rough, or often cold.",
                "pitta": "Fair, oily, or prone to redness and freckles.",
                "kapha": "Thick, smooth, and cool; tends to be pale."
            }
        },
        {
            "question": "How do you usually react to stress?",
            "category": "mental",
            "order": 3,
            "options": {
                "vata": "I feel anxious, worried, or fearful.",
                "pitta": "I feel irritable, angry, or impatient.",
                "kapha": "I remain calm, but can become withdrawn or stubborn."
            }
        },
        {
            "question": "Which climate do you prefer least?",
            "category": "lifestyle",
            "order": 4,
            "options": {
                "vata": "Cold and windy weather.",
                "pitta": "Hot and humid weather.",
                "kapha": "Damp and cold weather."
            }
        },
        {
            "question": "How is your memory?",
            "category": "mental",
            "order": 5,
            "options": {
                "vata": "Quick to learn, but quick to forget.",
                "pitta": "Sharp and focused; remembers what is useful.",
                "kapha": "Slow to learn, but has an excellent long-term memory."
            }
        }
    ];

    for (const q of questions) {
        app.save(new Record(app.findCollectionByNameOrId("ayurvedic_quiz_questions"), q));
    }
}, (app) => {
    // rollback
})
