'use strict';

// ['name', 'code', 'url', 'comment']
module.exports = {

  QUEUE_VALIDATION: {
    CLIENT: {
      type: 'QUEUE_VALIDATION',
      action: ['email'],
      email: {
        subject: 'Su solicitud esta en espera de validacion',
        data: ['name', 'code', 'url']
      }
    },
    EDITOR: {
      type: 'QUEUE_VALIDATION',
      action: ['email', 'notification'],
      email: {
        email: 'Solicitud en espera de validacion',
        data: ['name', 'code', 'url']
      },
      notification: 'Ha enviado nueva solicitud'
    }
  },
  CANCELED: {
    CLIENT: {
      type: 'CANCELED',
      action: ['email', 'notification'],
      email: {
        subject: 'Su solicitud ha sido cancelada',
        data: ['name', 'code', 'url', 'comment']
      },
      notification: 'Ha cancelado la solicitud'
    }
  },
  ASSIGNED_TO_MANAGER: {
    CONTENT_MANAGER: {
      type: 'ASSIGNED',
      action: ['email', 'notification'],
      email: {
        subject: 'Solicitud en espera de asignacion a proveedor',
        data: ['name', 'code', 'url']
      },
      notification: 'Ha asignado solicitud'
    }
  },
  ASSIGNED_TO_PROVIDER: {
    PROVIDER: {
      type: 'ASSIGNED',
      action: ['email', 'notification'],
      email: {
        subject: 'Solicitud asignada',
        data: ['name', 'code', 'url']
      },
      notification: 'Ha asignado solicitud'
    }
  },
  PROCCESS: {
    CONTENT_MANAGER: {
      type: 'PROCCESS',
      action: ['email', 'notification'],
      email: {
        subject: 'Solicitud en proceso',
        data: ['name', 'code', 'url']
      },
      notification: 'Solicitud en proceso'
    }
  },
  PAUSED: {
    CONTENT_MANAGER: {
      type: 'PAUSED',
      action: ['email', 'notification'],
      email: {
        subject: 'Solicitud pausada',
        data: ['name', 'code', 'url', 'comment']
      },
      notification: 'Solicitud en pausa'
    },
    PROVIDER: {
      type: 'PAUSED',
      action: ['email', 'notification'],
      email: {
        subject: 'Solicitud pausada',
        data: ['name', 'code', 'url', 'comment']
      },
      notification: 'Solicitud en pausa'
    }
  },
  REACTIVATED: {
    CONTENT_MANAGER: {
      type: 'REACTIVATED',
      action: ['email', 'notification'],
      email: {
        subject: 'Solucion reactivada',
        data: ['name', 'code', 'url']
      }
    },
    PROVIDER: {
      type: 'REACTIVATED',
      action: ['email', 'notification'],
      email: {
        subject: 'Solucion reactivada',
        data: ['name', 'code', 'url']
      }
    },
    notification: 'Solicitud reactivada'
  },
  QUEUE_VALIDATION_MANAGER: {
    CONTENT_MANAGER: {
      type: 'FOR_VALIDATION',
      action: ['email', 'notification'],
      email: {
        subject: 'Solicitud en espera de revision',
        data: ['name', 'code', 'url']
      },
      notification: 'Solicitud en espera de validacion'
    }
  },
  QUEUE_VALIDATION_CLIENT: {
    CLIENT: {
      type: 'FOR_VALIDATION',
      action: ['email', 'notification'],
      email: {
        subject: 'Solicitud en espera de revision',
        data: ['name', 'code', 'url']
      },
      notification: 'Solicitud en espera de revision'
    }
  },
  REJECTED_BY_MANAGER: {
    PROVIDER: {
      type: 'FOR_CHANGE',
      action: ['email', 'notification'],
      email: {
        subject: 'Solicitud en espera de cambios',
        data: ['name', 'code', 'url', 'comment']
      },
      notification: 'Solicitud rechazada'
    }
  },
  ACCEPTED_BY_CLIENT: {
    CONTENT_MANAGER: {
      type: 'ACCEPTED',
      action: ['email', 'notification'],
      email: {
        subject: 'Soicitud aceptada',
        data: ['name', 'code', 'url']
      },
      notification: 'Solicitud aceptada'
    }
  },
  REJECTED_BY_CLIENT: {
    CONTENT_MANAGER: {
      type: 'REJECTED',
      action: ['email', 'notification'],
      email: {
        subject: 'Solicitud rechazada',
        data: ['name', 'code', 'url', 'comment']
      },
      notification: 'Solicitud rechazada'
    }
  },
  QUEUE_VALIDATION_CLIENT_PRO: {
    CLIENT: {
      type: 'FOR_VALIDATION_PRO',
      action: ['email', 'notification'],
      email: {
        subject: 'Solicitud esperando validación en producción',
        data: ['name', 'code', 'url']
      },
      notification: 'Solicitud en espera de validacion en pro'
    }
  },
  ACCEPTED_BY_CLIENT_PRO: {
    CONTENT_MANAGER: {
      type: 'ACCEPTED_PRO',
      action: ['email', 'notification'],
      email: {
        subject: 'Solicitud aceptada por cliente en producción',
        data: ['name', 'code', 'url']
      },
      notification: 'Solicitud aceptada por cliente en producción'
    }
  },
  REJECTED_BY_CLIENT_PRO: {
    CONTENT_MANAGER: {
      type: 'FOR_CHANGE_PRO',
      action: ['email', 'notification'],
      email: {
        subject: 'Solicitud rechazada por cliente en producción',
        data: ['name', 'code', 'url']
      },
      notification: 'Solicitud rechazada por cliente en producción'
    }
  },
  QUEUE_PUBLISH: {
    PROVIDER: {
      type: 'QUEUE_PUPLISH',
      action: ['email', 'notification'],
      email: {
        subject: 'Realizar publicacion de solicitud',
        data: ['name', 'code', 'url']
      },
      notification: 'Solicitud en espera de publicacion'
    }
  },
  PUBLISH: {
    CONTENT_MANAGER: {
      type: 'PUBLISH',
      action: ['email', 'notification'],
      email: {
        subject: 'Solicitud publicada',
        data: ['name', 'code', 'url']
      },
      notification: 'Solicitud publicada'
    }
  },
  COMPLETED: {
    PROVIDER: {
      type: 'COMPLETED',
      action: ['email', 'notification'],
      email: {
        subject: 'Solicitud completada',
        data: ['name', 'code', 'url']
      },
      notification: 'Solicitud completada'
    },
    CLIENT: {
      type: 'COMPLETED',
      action: ['email', 'notification'],
      email: {
        subject: 'Solicitud completada',
        data: ['name', 'code', 'url']
      },
      notification: 'Solicitud completada'
    }
  }
}