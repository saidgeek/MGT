'use strict';

module.exports = {
  ROOT: {
    module: [
      'SOLICITUDE',
      'ADMINISTRATION'
      ],
    states: [
      'QUEUE_VALIDATION',
      'CANCELED',
      'ASSIGNED_TO_MANAGER',
      'ASSIGNED_TO_PROVIDER',
      'PROCCESS',
      'PAUSED',
      'QUEUE_VALIDATION_MANAGER',
      'ACCEPTED_BY_MANAGER',
      'REJECTED_BY_MANAGER',
      'QUEUE_VALIDATION_CLIENT',
      'ACCEPTED_BY_CLIENT',
      'REJECTED_BY_CLIENT',
      'COMPLETED',
      'QUEUE_PUBLICH',
      'PUBLICH'
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
      'CANCELED',
      'ASSIGNED_TO_MANAGER',
      'ASSIGNED_TO_PROVIDER',
      'PROCCESS',
      'PAUSED',
      'QUEUE_VALIDATION_MANAGER',
      'ACCEPTED_BY_MANAGER',
      'REJECTED_BY_MANAGER',
      'QUEUE_VALIDATION_CLIENT',
      'ACCEPTED_BY_CLIENT',
      'REJECTED_BY_CLIENT',
      'COMPLETED',
      'QUEUE_PUBLICH',
      'PUBLICH'
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
    'CANCELED',
    'ASSIGNED',
    'ASSIGNED_TO_PROVIDER',
    'PROCCESS',
    'PAUSED',
    'COMPLETED'
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
      'ASSIGNED',
      'QUEUE_PROVIDER',
      'PROCCESS',
      'PAUSED',
      'FOR_VALIDATION',
      'QUEUE_VALIDATION',
      'QUEUE_CHANGE',
      'ACCEPTED',
      'REJECTED',
      'COMPLETED',
      'QUEUE_PUBLICH',
      'PUBLICH'
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
      'ASSIGNED',
      'PROCCESS',
      'PAUSED',
      'QUEUE_VALIDATION',
      'FOR_CHANGE',
      'ACCEPTED',
      'COMPLETED',
      'QUEUE_PUBLICH'
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
      'CANCELED',
      'ACCEPTED',
      'PROCCESS',
      'PAUSED',
      'FOR_VALIDATION',
      'REJECTED',
      'COMPLETED',
      'QUEUE_PUBLICH',
      'PUBLICH'
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
