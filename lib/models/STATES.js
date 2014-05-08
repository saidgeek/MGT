'use strict';

module.exports = {

  default: "QUEUE_VALIDATION",

  queue_validation: { // POR VALIDAR
    data: {
      type: 'QUEUE_VALIDATION',
      ROOT: 'QUEUE_VALIDATION',
      ADMIN: 'QUEUE_VALIDATION',
      CLIENT: 'QUEUE_VALIDATION',
      EDITOR: 'QUEUE_VALIDATION',
      CONTENT_MANAGER: null,
      PROVIDER: null
    },
    after: null
  },

  canceled: { // CANCELADO
    data: {
      type: 'CANCELED',
      ROOT: 'CANCELED',
      ADMIN: 'CANCELED',
      CLIENT: 'CANCELED',
      EDITOR: 'CANCELED',
      CONTENT_MANAGER: null,
      PROVIDER: null
    },
    after: ['QUEUE_VALIDATION']
  },

  assigned_to_manager: { // ASIGNADO A GESTOR
    data: {
      type: 'ASSIGNED_TO_MANAGER',
      ROOT: 'ASSIGNED_TO_MANAGER',
      ADMIN: 'ASSIGNED_TO_MANAGER',
      CLIENT: 'ACCEPTED',
      EDITOR: 'ASSIGNED',
      CONTENT_MANAGER: 'ASSIGNED',
      PROVIDER: null
    },
    after: ['QUEUE_VALIDATION']
  },

  assigned_to_provider: { // ASIGNADO A PROVEEDOR
    data: {
      type: 'ASSIGNED_TO_PROVIDER',
      ROOT: 'ASSIGNED_TO_PROVIDER',
      ADMIN: 'ASSIGNED_TO_PROVIDER',
      CLIENT: 'ACCEPTED',
      EDITOR: 'ASSIGNED_TO_PROVIDER',
      CONTENT_MANAGER: 'QUEUE_PROVIDER',
      PROVIDER: 'ASSIGNED'
    },
    after: ['ASSIGNED_TO_MANAGER']
  },

  proccess: { // EN PROCESO
    data: {
      type: 'PROCCESS',
      ROOT: 'PROCCESS',
      ADMIN: 'PROCCESS',
      CLIENT: 'PROCCESS',
      EDITOR: 'PROCCESS',
      CONTENT_MANAGER: 'PROCCESS',
      PROVIDER: 'PROCCESS'
    },
    after: ['ASSIGNED_TO_PROVIDER', 'PAUSED']
  },

  paused: { // PAUSADO
    data: {
      type: 'PAUSED',
      ROOT: 'PAUSED',
      ADMIN: 'PAUSED',
      CLIENT: 'PAUSED',
      EDITOR: 'PAUSED',
      CONTENT_MANAGER: 'PAUSED',
      PROVIDER: 'PAUSED'
    },
    after: ['PROCCESS']
  },

  queue_validation_manager: { // REVISION DEL GESTOR
    data: {
      type: 'QUEUE_VALIDATION_MANAGER',
      ROOT: 'QUEUE_VALIDATION_MANAGER',
      ADMIN: 'QUEUE_VALIDATION_MANAGER',
      CLIENT: 'PROCCESS',
      EDITOR: 'PROCCESS',
      CONTENT_MANAGER: 'FOR_VALIDATION',
      PROVIDER: 'QUEUE_VALIDATION'
    },
    after: ['PROCCESS']
  },

  accepted_by_manager: { // ACEPTADO POR GESTOR
    data: {
      type: 'ACCEPTED_BY_MANAGER',
      ROOT: 'ACCEPTED_BY_MANAGER',
      ADMIN: 'ACCEPTED_BY_MANAGER',
      CLIENT: 'FOR_VALIDATION',
      EDITOR: 'PROCCESS',
      CONTENT_MANAGER: 'QUEUE_VALIDATION',
      PROVIDER: 'QUEUE_VALIDATION'
    },
    after: ['QUEUE_VALIDATION_MANAGER']
  },

  rejected_by_manager: { // RECHAZADO POR GESTOR
    data: {
      type: 'REJECTED_BY_MANAGER',
      ROOT: 'REJECTED_BY_MANAGER',
      ADMIN: 'REJECTED_BY_MANAGER',
      CLIENT: 'PROCCESS',
      EDITOR: 'PROCCESS',
      CONTENT_MANAGER: 'QUEUE_CHANGE',
      PROVIDER: 'FOR_CHANGE'
    },
    after: ['QUEUE_VALIDATION_MANAGER']
  },

  queue_validation_client: { // REVISION DE CLIENTE
    data: {
      type: 'QUEUE_VALIDATION_CLIENT',
      ROOT: 'QUEUE_VALIDATION_CLIENT',
      ADMIN: 'QUEUE_VALIDATION_CLIENT',
      CLIENT: 'FOR_VALIDATION',
      EDITOR: 'PROCCESS',
      CONTENT_MANAGER: 'QUEUE_VALIDATION',
      PROVIDER: 'QUEUE_VALIDATION'
    },
    after: ['QUEUE_VALIDATION_MANAGER']
  },

  accepted_by_client: { // ACEPTADO POR CLIENTE
    data: {
      type: 'ACCEPTED_BY_CLIENT',
      ROOT: 'ACCEPTED_BY_CLIENT',
      ADMIN: 'ACCEPTED_BY_CLIENT',
      CLIENT: 'ACCEPTED',
      EDITOR: 'PROCCESS',
      CONTENT_MANAGER: 'ACCEPTED',
      PROVIDER: 'QUEUE_VALIDATION'
    },
    after: ['QUEUE_VALIDATION_CLIENT']
  },

  rejected_by_client: { // RECHAZADO POR CLIENTE
    data: {
      type: 'REJECTED_BY_CLIENT',
      ROOT: 'REJECTED_BY_CLIENT',
      ADMIN: 'REJECTED_BY_CLIENT',
      CLIENT: 'REJECTED',
      EDITOR: 'PROCCESS',
      CONTENT_MANAGER: 'REJECTED',
      PROVIDER: null
    },
    after: ['QUEUE_VALIDATION_CLIENT']
  },

  queue_publish: {
    data: {
      type: 'QUEUE_PUBLISH',
      ROOT: 'QUEUE_PUBLISH',
      ADMIN: 'QUEUE_PUBLISH',
      CLIENT: 'QUEUE_PUBLISH',
      EDITOR: 'PROCCESS',
      CONTENT_MANAGER: 'QUEUE_PUBLISH',
      PROVIDER: 'QUEUE_PUPLISH'
    },
    after: ['ACCEPTED_BY_CLIENT']
  },

  publish: {
    data: {
      type: 'PUBLISH',
      ROOT: 'PUBLISH',
      ADMIN: 'PUBLISH',
      CLIENT: 'PUBLISH',
      EDITOR: 'PROCCESS',
      CONTENT_MANAGER: 'PUBLISH',
      PROVIDER: 'PUBLISH'
    },
    after: ['QUEUE_PUBLISH']
  },

  completed: {
    data: {
      type: 'COMPLETED',
      ROOT: 'COMPLETED',
      ADMIN: 'COMPLETED',
      CLIENT: 'COMPLETED',
      EDITOR: 'COMPLETED',
      CONTENT_MANAGER: 'COMPLETED',
      PROVIDER: 'COMPLETED'
    },
    after: ['PUBLISH']
  }

}
