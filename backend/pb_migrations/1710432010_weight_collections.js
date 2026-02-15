migrate((db) => {
  // Create weight_logs collection for weight tracking
  const weightLogsCollection = new Collection({
    name: "weight_logs",
    type: "base",
    schema: [
      { name: "user", type: "relation", required: true, options: { collectionId: "users", cascadeDelete: true } },
      { name: "date", type: "date", required: true },
      { name: "weight", type: "number", required: true }, // in kg
      { name: "note", type: "text" },
      { name: "photo", type: "file" },
      { name: "body_fat_percentage", type: "number" },
      { name: "muscle_mass", type: "number" },
      { name: "measurements", type: "json" }, // {chest, waist, hips, arms, thighs} in cm
      { name: "mood", type: "select", options: ["happy", "neutral", "sad", "motivated", "frustrated"] },
      { name: "is_synced", type: "bool", required: true, default: false }
    ],
    indexes: [
      { fields: ["user", "date"], unique: false },
      { fields: ["user"], unique: false },
      { fields: ["date"], unique: false }
    ]
  });

  // Create user_weight_goals collection for weight goals and settings
  const weightGoalsCollection = new Collection({
    name: "user_weight_goals",
    type: "base",
    schema: [
      { name: "user", type: "relation", required: true, options: { collectionId: "users", cascadeDelete: true } },
      { name: "start_weight", type: "number" },
      { name: "current_weight", type: "number" },
      { name: "goal_weight", type: "number" },
      { name: "goal_type", type: "select", options: ["lose", "maintain", "gain"], default: "maintain" },
      { name: "weekly_goal_kg", type: "number", default: 0.5 }, // 0.5 kg per week
      { name: "reminder_enabled", type: "bool", required: true, default: true },
      { name: "reminder_day", type: "select", options: ["daily", "weekly"], default: "weekly" },
      { name: "reminder_time", type: "text", default: "08:00" },
      { name: "photo_reminders", type: "bool", required: true, default: true }, // Remind for progress photos
      { name: "notifications_enabled", type: "bool", required: true, default: true }
    ],
    indexes: [
      { fields: ["user"], unique: true }
    ]
  });

  // Save collections
  db.saveCollection(weightLogsCollection);
  db.saveCollection(weightGoalsCollection);

  // Set API rules for weight_logs (private to user)
  weightLogsCollection.setRule("list", "@request.auth.id = user");
  weightLogsCollection.setRule("view", "@request.auth.id = user");
  weightLogsCollection.setRule("create", "@request.auth.id = user");
  weightLogsCollection.setRule("update", "@request.auth.id = user");
  weightLogsCollection.setRule("delete", "@request.auth.id = user");

  // Set API rules for user_weight_goals (private to user)
  weightGoalsCollection.setRule("list", "@request.auth.id = user");
  weightGoalsCollection.setRule("view", "@request.auth.id = user");
  weightGoalsCollection.setRule("create", "@request.auth.id = user");
  weightGoalsCollection.setRule("update", "@request.auth.id = user");
  weightGoalsCollection.setRule("delete", "@request.auth.id = user");

  db.saveCollection(weightLogsCollection);
  db.saveCollection(weightGoalsCollection);

  console.log("Weight tracking collections created successfully");
}, (db) => {
  // Rollback
  db.deleteCollection("weight_logs");
  db.deleteCollection("user_weight_goals");
});
