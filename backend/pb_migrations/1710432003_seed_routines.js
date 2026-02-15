migrate((app) => {
    const routines = [
        // Vata Routines
        {
            "dosha": "vata",
            "time_of_day": "early_morning",
            "activity": "Oil Massage (Abhyanga)",
            "description": "Gently massage warm sesame oil over your body to ground your energy and soothe the nervous system."
        },
        {
            "dosha": "vata",
            "time_of_day": "morning",
            "activity": "Warm Breakfast",
            "description": "Favor cooked grains like oatmeal or cream of rice. Avoid cold cereals and smoothies."
        },
        {
            "dosha": "vata",
            "time_of_day": "night",
            "activity": "Early Sleep",
            "description": "Try to be in bed by 10:00 PM. Vata needs plenty of rest to stay balanced."
        },

        // Pitta Routines
        {
            "dosha": "pitta",
            "time_of_day": "morning",
            "activity": "Cool Shower",
            "description": "Start your day with a lukewarm or cool shower to keep your internal heat in check."
        },
        {
            "dosha": "pitta",
            "time_of_day": "afternoon",
            "activity": "Largest Meal",
            "description": "Eat your main meal between 12:00 PM and 1:00 PM when your digestive fire (Agni) is strongest."
        },
        {
            "dosha": "pitta",
            "time_of_day": "evening",
            "activity": "Moonlight Walk",
            "description": "A calm walk in the cool evening air helps soothe Pitta's intensity."
        },

        // Kapha Routines
        {
            "dosha": "kapha",
            "time_of_day": "early_morning",
            "activity": "Vigorous Exercise",
            "description": "Engage in stimulating activity like Sun Salutations or a brisk walk before 7:00 AM."
        },
        {
            "dosha": "kapha",
            "time_of_day": "morning",
            "activity": "Light Breakfast",
            "description": "A simple fruit or warm spiced tea is often enough to kickstart your metabolism."
        },
        {
            "dosha": "kapha",
            "time_of_day": "afternoon",
            "activity": "Dry Massage",
            "description": "Use a silk glove or dry brush to stimulate lymphatic flow and reduce congestion."
        }
    ];

    for (const r of routines) {
        app.save(new Record(app.findCollectionByNameOrId("daily_routines"), r));
    }
}, (app) => {
    // rollback
})
