'use strict';

module.exports = {
  default: "QUEUE_VALIDATION",
  queue_validation: {
    key: "QUEUE_VALIDATION",
    desc: "Espera de validación",
    after: null
    },
  queue_allocation: {
    key: "QUEUE_ALLOCATION",
    desc: "Espere de asignación",
    after: ["QUEUE_VALIDATION"]
    },
  cancel: {
    key: "CANCEL",
    desc: "Cancelada",
    after: ["QUEUE_VALIDATION"]
    },
  queue_provider: {
    key: "QUEUE_PROVIDER",
    desc: "Espera de proveedor",
    after: ["QUEUE_ALLOCATION"]
    },
  proccess: {
    key: "PROCCESS",
    desc: "En proceso",
    after: ["QUEUE_PROVIDER", "PAUSE", "REJECTED_BY_MANAGER", "REJECTED_BY_CLIENT"]
    },
  queue_validation_manager: {
    key: "QUEUE_VALIDATION_MANAGER",
    desc: "Espera de validación del Gestor de contenido",
    after: ["PROCCESS"]
    },
  pause: {
    key: "PAUSE",
    desc: "Pausada",
    after: ["PROCCESS"]
    },
  rejected_by_manager: {
    key: "REJECTED_BY_MANAGER",
    desc: "Rechazada por el Gestor de contenido",
    after: ["QUEUE_VALIDATION_MANAGER"]
    },
  ok_by_manager: {
    key: "OK_BY_MANAGER",
    desc: "Aceptada por el Gestor de contenido",
    after: ["QUEUE_VALIDATION_MANAGER"]
    },
  queue_validation_client: {
    key: "QUEUE_VALIDATION_CLIENT",
    desc: "Espera de validación del cliente",
    after: ["OK_BY_MANAGER"]
    },
  rejected_by_client: {
    key: "REJECTED_BY_CLIENT",
    desc: "Rechazado por Cliente",
    after: ["QUEUE_VALIDATION_CLIENT"]
    },
  ok_by_client: {
    key: "ok_by_client",
    desc: "Aceptado por Cliente",
    after: ["QUEUE_VALIDATION_CLIENT"]
    }
}
