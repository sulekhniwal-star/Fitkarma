migrate((db) => {
  // Create workout_logs collection
  const collection = new Collection({
    id: 'workout_logs',
    name: 'workout_logs',
    type: 'base',
    system: false,
    schema: [
      {
        system: false,
        id: 'workout_log_user',
        name: 'user',
        type: 'relation',
        required: true,
        unique: false,
        options: {
          collectionId: 'users',
          cascadeDelete: false,
          minSelect: null,
          maxSelect: 1,
          displayFields: []
        }
      },
      {
        system: false,
        id: 'workout_log_workout',
        name: 'workout',
        type: 'relation',
        required: true,
        unique: false,
        options: {
          collectionId: 'workouts',
          cascadeDelete: false,
          minSelect: null,
          maxSelect: 1,
          displayFields: []
        }
      },
      {
        system: false,
        id: 'workout_log_date',
        name: 'date',
        type: 'date',
        required: true,
        unique: false,
        options: {}
      },
      {
        system: false,
        id: 'workout_log_duration',
        name: 'duration_mins',
        type: 'number',
        required: true,
        unique: false,
        options: {
          min: 1,
          max: 300
        }
      },
      {
        system: false,
        id: 'workout_log_calories',
        name: 'calories_burned',
        type: 'number',
        required: true,
        unique: false,
        options: {
          min: 0,
          max: 2000
        }
      },
      {
        system: false,
        id: 'workout_log_heart_rate',
        name: 'heart_rate_avg',
        type: 'number',
        required: false,
        unique: false,
        options: {
          min: 40,
          max: 220
        }
      },
      {
        system: false,
        id: 'workout_log_note',
        name: 'note',
        type: 'text',
        required: false,
        unique: false,
        options: {
          min: null,
          max: null,
          pattern: ''
        }
      },
      {
        system: false,
        id: 'workout_log_rating',
        name: 'rating',
        type: 'number',
        required: false,
        unique: false,
        options: {
          min: 0,
          max: 5
        }
      }
    ],
    indexs: [
      {
        id: 'idx_workout_log_user',
        unique: false,
        fields: ['user']
      },
      {
        id: 'idx_workout_log_date',
        unique: false,
        fields: ['date']
      },
      {
        id: 'idx_workout_log_user_date',
        unique: false,
        fields: ['user', 'date']
      }
    ],
    listRule: '@request.auth.id = user.id',
    viewRule: '@request.auth.id = user.id',
    createRule: '@request.auth.id = user.id',
    updateRule: '@request.auth.id = user.id',
    deleteRule: '@request.auth.id = user.id',
    options: {}
  });

  return db.saveCollection(collection);
}, (db) => {
  return db.deleteCollection('workout_logs');
})
