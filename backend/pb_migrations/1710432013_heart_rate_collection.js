migrate((db) => {
  // Create heart_rate_logs collection
  const collection = new Collection({
    id: 'heart_rate_logs',
    name: 'heart_rate_logs',
    type: 'base',
    system: false,
    schema: [
      {
        system: false,
        id: 'hr_log_user',
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
        id: 'hr_log_bpm',
        name: 'bpm',
        type: 'number',
        required: true,
        unique: false,
        options: {
          min: 30,
          max: 250
        }
      },
      {
        system: false,
        id: 'hr_log_date',
        name: 'date',
        type: 'date',
        required: true,
        unique: false,
        options: {}
      },
      {
        system: false,
        id: 'hr_log_note',
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
        id: 'hr_log_is_manual',
        name: 'is_manual',
        type: 'bool',
        required: false,
        unique: false,
        options: {}
      }
    ],
    indexs: [
      {
        id: 'idx_hr_log_user',
        unique: false,
        fields: ['user']
      },
      {
        id: 'idx_hr_log_date',
        unique: false,
        fields: ['date']
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
  return db.deleteCollection('heart_rate_logs');
})
