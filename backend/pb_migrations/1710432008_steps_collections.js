migrate((db) => {
  // Create steps_logs collection for daily step tracking
  const stepsLogsCollection = new Collection({
    name: "steps_logs",
    type: "base",
    schema: [
      { name: "user", type: "relation", required: true, options: { collectionId: "users", cascadeDelete: true } },
      { name: "date", type: "date", required: true },
      { name: "steps", type: "number", required: true, default: 0 },
      { name: "goal", type: "number", required: true, default: 8000 },
      { name: "distance_km", type: "number" },
      { name: "calories", type: "number" },
      { name: "hourly_data", type: "json" }, // Array of steps per hour [0, 150, 300, ...]
      { name: "source", type: "select", required: true, options: ["pedometer", "manual", "health_connect", "apple_health"], default: "pedometer" },
      { name: "is_synced", type: "bool", required: true, default: false }
    ],
    indexes: [
      { fields: ["user", "date"], unique: true },
      { fields: ["user"], unique: false },
      { fields: ["date"], unique: false }
    ]
  });

  // Create user_steps_settings collection for step preferences
  const stepsSettingsCollection = new Collection({
    name: "user_steps_settings",
    type: "base",
    schema: [
      { name: "user", type: "relation", required: true, options: { collectionId: "users", cascadeDelete: true } },
      { name: "daily_goal", type: "number", required: true, default: 8000 },
      { name: "reminder_enabled", type: "bool", required: true, default: true },
      { name: "reminder_time", type: "text", default: "18:00" }, // Evening reminder
      { name: "cricket_mode", type: "bool", required: true, default: false }, // Fun cricket overs display
      { name: "notifications_enabled", type: "bool", required: true, default: true }
    ],
    indexes: [
      { fields: ["user"], unique: true }
    ]
  });

  // Save collections
  db.saveCollection(stepsLogsCollection);
  db.saveCollection(stepsSettingsCollection);

  // Set API rules for steps_logs (private to user)
  stepsLogsCollection.setRule("list", "@request.auth.id = user");
  stepsLogsCollection.setRule("view", "@request.auth.id = user");
  stepsLogsCollection.setRule("create", "@request.auth.id = user");
  stepsLogsCollection.setRule("update", "@request.auth.id = user");
  stepsLogsCollection.setRule("delete", "@request.auth.id = user");

  // Set API rules for user_steps_settings (private to user)
  stepsSettingsCollection.setRule("list", "@request.auth.id = user");
  stepsSettingsCollection.setRule("view", "@request.auth.id = user");
  stepsSettingsCollection.setRule("create", "@request.auth.id = user");
  stepsSettingsCollection.setRule("update", "@request.auth.id = user");
  stepsSettingsCollection.setRule("delete", "@request.auth.id = user");

  db.saveCollection(stepsLogsCollection);
  db.saveCollection(stepsSettingsCollection);

  console.log("Steps tracking collections created successfully");
}, (db) => {
  // Rollback
  db.deleteCollection("steps_logs");
  db.deleteCollection("user_steps_settings");
});
