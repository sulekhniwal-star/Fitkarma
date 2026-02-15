/// <reference path="../pb_data/types.d.ts" />
migrate((app) => {
    const collection = app.findCollectionByNameOrId("karma_tiers_config");

    const tiers = [
        {
            name: "Bronze",
            min_points: 0,
            benefits: ["Basic wellness tips", "Community access"],
        },
        {
            name: "Silver",
            min_points: 1000,
            benefits: ["Personalized routine insights", "Monthly health report"],
        },
        {
            name: "Gold",
            min_points: 5000,
            benefits: ["Priority chat support", "Customized dietary plans"],
        },
        {
            name: "Platinum",
            min_points: 15000,
            benefits: ["One-on-one Ayurvedic consultation", "Exclusive wellness retreats"],
        },
        {
            name: "Diamond",
            min_points: 50000,
            benefits: ["Life-time premium access", "Personal wellness coach", "VIP events"],
        },
    ];

    for (const tier of tiers) {
        const record = new Record(collection, {
            name: tier.name,
            min_points: tier.min_points,
            benefits: tier.benefits,
        });
        app.save(record);
    }
}, (app) => {
    // Add rollback logic if needed
});
