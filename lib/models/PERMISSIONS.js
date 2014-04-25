'use strict';

module.exports = {
  ROOT: {
    module: [
      'SOLICITUDE',
      'ADMINISTRATION'
      ],
    states: [
      'QUEUE_VALIDATION',
      'QUEUE_ACEPT',
      'QUEUE_ALLOCATION',
      'CANCEL',
      'QUEUE_PROVIDER',
      'PROCCESS',
      'QUEUE_VALIDATION_MANAGER',
      'PAUSE',
      'REJECTED_BY_MANAGER',
      'OK_BY_MANAGER',
      'QUEUE_VALIDATION_CLIENT',
      'REJECTED_BY_CLIENT',
      'OK_BY_CLIENT',
      'FINAL'
      ],
    roles:  [
      'ROOT',
      'ADMIN',
      'EDITOR',
      'CONTENT_MANAGER',
      'PROVIDER',
      'CLIENT'
      ],
    solicitude: [
      'CREATE',
      'UPDATE',
      'DELETE'
      ],
    administration: [
      'CREATE',
      'UPDATE',
      'DELETE'
      ]
  },
  ADMIN: {
    module: [
      'SOLICITUDE',
      'ADMINISTRATION'
      ],
    states: [
      'QUEUE_VALIDATION',
      'QUEUE_ACEPT',
      'QUEUE_ALLOCATION',
      'CANCEL',
      'QUEUE_PROVIDER',
      'PROCCESS',
      'QUEUE_VALIDATION_MANAGER',
      'PAUSE',
      'REJECTED_BY_MANAGER',
      'OK_BY_MANAGER',
      'QUEUE_VALIDATION_CLIENT',
      'REJECTED_BY_CLIENT',
      'OK_BY_CLIENT',
      'FINAL'
      ],
    roles:  [
      'ADMIN',
      'EDITOR',
      'CONTENT_MANAGER',
      'PROVIDER',
      'CLIENT'
      ],
    solicitude: [
      'CREATE',
      'UPDATE',
      'DELETE'
      ],
    administration: [
      'CREATE',
      'UPDATE',
      'DELETE'
      ]
  },
  EDITOR: {
    module: [
      'SOLICITUDE'
      ],
    states: [
    'QUEUE_VALIDATION',
    'QUEUE_ALLOCATION',
    'CANCEL',
    'QUEUE_PROVIDER',
    'PROCCESS',
    'PAUSE',
    'QUEUE_VALIDATION_CLIENT',
    'REJECTED_BY_CLIENT',
    'OK_BY_CLIENT'
    ],
    roles:  [
      'EDITOR',
      'CONTENT_MANAGER',
      'PROVIDER',
      'CLIENT'
      ],
    solicitude: [
      'UPDATE'
      ]
  },
  CONTENT_MANAGER: {
    module: [
      'SOLICITUDE'
      ],
    states: [
      'QUEUE_ALLOCATION',
      'QUEUE_PROVIDER',
      'PROCCESS',
      'QUEUE_VALIDATION_MANAGER',
      'PAUSE',
      'REJECTED_BY_MANAGER',
      'OK_BY_MANAGER',
      'QUEUE_VALIDATION_CLIENT',
      'REJECTED_BY_CLIENT',
      'OK_BY_CLIENT'
      ],
    roles:  [
      'EDITOR',
      'CONTENT_MANAGER',
      'PROVIDER',
      'CLIENT'
      ],
    solicitude: [
      'UPDATE'
      ]
  },
  PROVIDER: {
    module: [
      'SOLICITUDE'
      ],
    states: [
      'QUEUE_PROVIDER',
      'PROCCESS',
      'PAUSE',
      'QUEUE_VALIDATION_CLIENT',
      'REJECTED_BY_CLIENT',
      'OK_BY_CLIENT'
      ],
    roles:  [
      'EDITOR',
      'CONTENT_MANAGER',
      'PROVIDER',
      'CLIENT'
      ],
    solicitude: [
      'UPDATE'
      ]
  },
  CLIENT: {
    module: [
      'SOLICITUDE'
      ],
    states: [
      'QUEUE_VALIDATION',
      'PROCCESS',
      'QUEUE_VALIDATION_MANAGER',
      'PAUSE',
      'REJECTED_BY_MANAGER',
      'OK_BY_MANAGER',
      'QUEUE_VALIDATION_CLIENT'
      ],
    roles:  [
      'EDITOR',
      'CONTENT_MANAGER',
      'PROVIDER',
      'CLIENT'
      ],
    solicitude: [
      'CREATE'
      ]
  }
}
