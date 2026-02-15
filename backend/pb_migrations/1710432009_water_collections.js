migrate((db) => {
  // Create water_logs collection for daily water intake tracking
  const waterLogsCollection = new Collection({
    name: "water_logs",
    type: "base",
    schema: [
      { name: "user", type: "relation", required: true, options: { collectionId: "users", cascadeDelete: true } },
      { name: "date", type: "date", required: true },
      { name: "glasses", type: "number", required: true, default: 0 },
      { name: "goal", type: "number", required: true, default: 8 },
      { name: "ml_total", type: "number", default: 0 },
      { name: "entries", type: "json" }, // Array of {time, amount_ml, type: "glass"|"bottle"|"chai"}
      { name: "streak_days", type: "number", default: 0 },
      { name: "last_entry_time", type: "date" },
      { name: "is_synced", type: "bool", required: true, default: false }
    ],
    indexes: [
      { fields: ["user", "date"], unique: true },
      { fields: ["user"], unique: false },
      { fields: ["date"], unique: false }
    ]
  });

  // Create user_water_settings collection for water preferences
  const waterSettingsCollection = new Collection({
    name: "user_water_settings",
    type: "base",
    schema: [
      { name: "user", type: "relation", required: true, options: { collectionId: "users", cascadeDelete: true } },
      { name: "daily_goal", type: "number", required: true, default: 8 }, // 8 glasses
      { name: "glass_size_ml", type: "number", required: true, default: 250 },
      { name: "bottle_size_ml", type: "number", default: 500 },
      { name: "chai_size_ml", type: "number", default: 150 },
      { name: "reminder_enabled", type: "bool", required: true, default: true },
      { name: "reminder_interval_hours", type: "number", default: 2 },
      { name: "reminder_start_time", type: "text", default: "08:00" },
      { name: "reminder_end_time", type: "text", default: "20:00" },
      { name: "smart_reminders", type: "bool", required: true, default: true }, // Weather-based suggestions
      { name: "notifications_enabled", type: "bool", required: true, default: true }
    ],
    indexes: [
      { fields: ["user"], unique: true }
    ]
  });

  // Save collections
  db.saveCollection(waterLogsCollection);
  db.saveCollection(waterSettingsCollection);

  // Set API rules for water_logs (private to user)
  waterLogsCollection.setRule("list", "@request.auth.id = user");
  waterLogsCollection.setRule("view", "@request.auth.id = user");
  waterLogsCollection.setRule("create", "@request.auth.id = user");
  waterLogsCollection.setRule("update", "@request.auth.id = user");
  waterLogsCollection.setRule("delete", "@request.auth.id = user");

  // Set API rules for user_water_settings (private to user)
  waterSettingsCollection.setRule("list", "@request.auth.id = user");
  waterSettingsCollection.setRule("view", "@request.auth.id = user");
  waterSettingsCollection.setRule("create", "@request.auth.id = user");
  waterSettingsCollection.setRule("update", "@request.auth.id = user");
  waterSettingsCollection.setRule("delete", "@request.auth.id = user");

  db.saveCollection(waterLogsCollection);
  db.saveCollection(waterSettingsCollection);

  console.log("Water tracking collections created successfully");
}, (db) => {
  // Rollback
  db.deleteCollection("water_logs");
  db.deleteCollection("user_water_settings");
});
