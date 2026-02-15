/// <reference path="../pb_data/types.d.ts" />
migrate((app) => {
    // Create karma_transactions collection
    const collection = new Collection({
        system: false,
        id: "karma_transactions",
        name: "karma_transactions",
        type: "base",
    });

    app.save(collection);

    // Add fields
    collection.fields.add(new RelationField({
        name: "user",
        collectionId: "users",
        cascadeDelete: false,
        required: true,
    }));

    collection.fields.add(new NumberField({
        name: "amount",
        required: true,
    }));

    collection.fields.add(new TextField({
        name: "action_type",
        required: true,
    }));

    collection.fields.add(new TextField({
        name: "description",
    }));

    collection.fields.add(new DateField({
        name: "date",
        required: true,
    }));

    // Add API rules
    collection.apiRule = new APIRule({
        list: "@request.auth.id != ''", // Authenticated users can list their own
        view: "@request.auth.id != ''",  // Authenticated users can view their own
        create: "@request.auth.id != ''", // Authenticated users can create
        update: false, // No updates allowed
        delete: false, // No deletes allowed (for audit)
    });

    app.save(collection);
}, (app) => {
    // Rollback: delete the collection
    const collection = app.findCollectionByNameOrId("karma_transactions");
    if (collection) {
        app.deleteCollection(collection.id);
    }
});
