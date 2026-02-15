migrate((db) => {
  // Create workouts collection
  const collection = new Collection({
    id: 'workouts',
    name: 'workouts',
    type: 'base',
    system: false,
    schema: [
      {
        system: false,
        id: 'workout_title',
        name: 'title',
        type: 'text',
        required: true,
        unique: false,
        options: {
          min: null,
          max: null,
          pattern: ''
        }
      },
      {
        system: false,
        id: 'workout_title_hindi',
        name: 'title_hindi',
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
        id: 'workout_description',
        name: 'description',
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
        id: 'workout_category',
        name: 'category',
        type: 'select',
        required: true,
        unique: false,
        options: {
          values: ['yoga', 'bollywood', 'desi', 'hiit', 'gym', 'sports', 'cardio']
        }
      },
      {
        system: false,
        id: 'workout_difficulty',
        name: 'difficulty',
        type: 'select',
        required: true,
        unique: false,
        options: {
          values: ['beginner', 'intermediate', 'advanced']
        }
      },
      {
        system: false,
        id: 'workout_duration',
        name: 'duration_mins',
        type: 'number',
        required: true,
        unique: false,
        options: {
          min: 1,
          max: 180
        }
      },
      {
        system: false,
        id: 'workout_calories',
        name: 'calories_burned',
        type: 'number',
        required: true,
        unique: false,
        options: {
          min: 1,
          max: 1000
        }
      },
      {
        system: false,
        id: 'workout_video_url',
        name: 'video_url',
        type: 'url',
        required: false,
        unique: false,
        options: {}
      },
      {
        system: false,
        id: 'workout_thumbnail',
        name: 'thumbnail',
        type: 'file',
        required: false,
        unique: false,
        options: {
          maxSelect: 1,
          maxSize: 5242880,
          mimeTypes: ['jpg', 'png', 'webp'],
          thumbs: [],
          protected: false
        }
      },
      {
        system: false,
        id: 'workout_instructions',
        name: 'instructions',
        type: 'editor',
        required: false,
        unique: false,
        options: {}
      },
      {
        system: false,
        id: 'workout_equipment',
        name: 'equipment_needed',
        type: 'json',
        required: false,
        unique: false,
        options: {}
      },
      {
        system: false,
        id: 'workout_is_premium',
        name: 'is_premium',
        type: 'bool',
        required: false,
        unique: false,
        options: {}
      },
      {
        system: false,
        id: 'workout_karma_cost',
        name: 'karma_cost',
        type: 'number',
        required: false,
        unique: false,
        options: {
          min: 0,
          max: 1000
        }
      },
      {
        system: false,
        id: 'workout_benefits',
        name: 'benefits',
        type: 'json',
        required: false,
        unique: false,
        options: {}
      },
      {
        system: false,
        id: 'workout_contraindications',
        name: 'contraindications',
        type: 'json',
        required: false,
        unique: false,
        options: {}
      },
      {
        system: false,
        id: 'workout_youtube_id',
        name: 'youtube_video_id',
        type: 'text',
        required: false,
        unique: false,
        options: {
          min: null,
          max: null,
          pattern: ''
        }
      }
    ],
    indexs: [
      {
        id: 'idx_workout_category',
        unique: false,
        fields: ['category']
      },
      {
        id: 'idx_workout_difficulty',
        unique: false,
        fields: ['difficulty']
      }
    ],
    listRule: '',
    viewRule: '',
    createRule: '',
    updateRule: '',
    deleteRule: '',
    options: {}
  });

  return db.saveCollection(collection);
}, (db) => {
  return db.deleteCollection('workouts');
})
