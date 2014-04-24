(function() {
  'use strict';
  angular.module('movistarApp').controller('SidebarCtrl', function($scope, SolicitudeFactory, $rootScope, StateData, StateIconsData, PriorityData, PriorityIconData, CategoryFactory, UserFactory) {
    var _loadStates;
    $scope.statesGroups = null;
    $scope.priorityGroups = null;
    $scope.errors = {};
    $scope.states = StateData.getArray();
    $scope.statesIcons = StateIconsData.getAll();
    $scope.priorityIcons = PriorityIconData.getAll();
    $scope.categories = null;
    $scope.users = null;
    $scope.priorities = PriorityData.getArray();
    CategoryFactory.index(function(err, categories) {
      if (err) {
        return $scope.errors = err;
      } else {
        return $scope.categories = categories;
      }
    });
    UserFactory.index('', function(err, users) {
      if (err) {
        return $scope.errors = err;
      } else {
        return $scope.users = users;
      }
    });
    _loadStates = function() {
      return SolicitudeFactory.groups(function(err, groups) {
        if (err) {
          return $scope.errors = err;
        } else {
          $scope.statesGroups = groups.states;
          return $scope.priorityGroups = groups.priorities;
        }
      });
    };
    $rootScope.$on('reloadStates', function(e) {
      return _loadStates();
    });
    $scope.filter = function(state, category, priority, involved) {
      return $rootScope.$emit('reloadSolicitudes', state, category, priority, involved);
    };
    return _loadStates();
  }).controller('SolicitudeCtrl', function($rootScope, $scope, Auth, $location, SolicitudeFactory, RolesData) {
    var _loadSolicitudes, _showModals;
    $rootScope.title = "Solicitudes";
    $scope.solicitudes = [];
    $scope.errors = {};
    $scope.showModals = function(modal) {
      return _showModals(modal);
    };
    $rootScope.$on('showModals', function(e, args) {
      return _showModals(args.modal);
    });
    $scope.$on('hideModals', function(e) {
      return $scope.modals = '';
    });
    _showModals = function(modal) {
      return $scope.modals = modal;
    };
    $rootScope.$on('reloadSolicitudes', function(e, state, category, priority, involved) {
      return _loadSolicitudes(state, category, priority, involved);
    });
    $rootScope.$on('updateSolicitudes', function(e) {
      return _loadSolicitudes('', '', '', '');
    });
    $scope.loadSolicitude = function(id) {
      return $rootScope.$emit('loadSolicitudeShow', id);
    };
    _loadSolicitudes = function(state, category, priority, involved) {
      $scope.solicitudes = null;
      return SolicitudeFactory.index(state, category, priority, involved, function(err, solicitudes) {
        if (err) {
          return $scope.errors = err;
        } else {
          if (solicitudes.length > 0) {
            $rootScope.$emit('loadSolicitudeShow', solicitudes[0]._id);
            $rootScope.$emit('reloadStates');
            return $scope.solicitudes = solicitudes;
          }
        }
      });
    };
    return _loadSolicitudes('', '', '', '');
  }).controller('SolicitudeShowCtrl', function($scope, SolicitudeFactory, $rootScope, SolicitudeParams, PriorityData, CategoryFactory, UserFactory, SegmentsData, SectionsData) {
    var _changeViewByRole, _loadSolicitude;
    $scope.solicitude = {};
    $scope.tags = [];
    $scope.errors = {};
    $scope.viewDetail = null;
    $scope.tabs = '';
    $scope.viewDetail = null;
    $scope.categories = null;
    $scope.contentManagers = null;
    $scope.provider = null;
    $scope.priorities = PriorityData.getArray();
    $scope.segments = SegmentsData.getArray();
    $scope.sections = SectionsData.getArray();
    CategoryFactory.index(function(err, categories) {
      if (err) {
        return $scope.errors = err;
      } else {
        return $scope.categories = categories;
      }
    });
    UserFactory.index('CONTENT_MANAGER', function(err, users) {
      if (err) {
        return $scope.errors = err;
      } else {
        return $scope.contentManagers = users;
      }
    });
    UserFactory.index('PROVIDER', function(err, users) {
      if (err) {
        return $scope.errors = err;
      } else {
        return $scope.provider = users;
      }
    });
    $rootScope.$on('loadSolicitudeShow', function(e, id) {
      $scope.viewDetail = null;
      return _loadSolicitude(id);
    });
    if ((SolicitudeParams != null ? SolicitudeParams.id : void 0) != null) {
      _loadUser(SolicitudeParams.id);
    }
    _changeViewByRole = function(solicitude) {
      var _role;
      _role = $rootScope.currentUser.role;
      if (solicitude.state === 'QUEUE_VALIDATION' && ~['EDITOR', 'ADMIN', 'ROOT'].indexOf(_role)) {
        $scope.viewDetail = 'updateByEditor';
      }
      if (solicitude.state === 'QUEUE_ALLOCATION' && ~['CONTENT_MANAGER', 'ADMIN', 'ROOT'].indexOf(_role)) {
        $scope.viewDetail = 'updateByContentManager';
      }
      if (solicitude.state === 'QUEUE_PROVIDER') {
        return $scope.viewDetail = null;
      }
    };
    _loadSolicitude = function(id) {
      $scope.solicitude = '';
      return SolicitudeFactory.show(id, function(err, solicitude) {
        if (err) {
          return $scope.errors = err;
        } else {
          $scope.solicitude = solicitude;
          return _changeViewByRole($scope.solicitude);
        }
      });
    };
    $scope.showTabs = function(tab) {
      return $scope.tabs = tab;
    };
    $scope.activeTab = function(tab) {
      return $scope.tabs === tab;
    };
    $scope.addComment = function(form) {
      if (form.$valid) {
        return SolicitudeFactory.addComments($scope.solicitude._id, $scope.solicitude.message, function(err) {
          if (err) {
            return $scope.errors = err;
          } else {
            return _loadSolicitude($scope.solicitude._id);
          }
        });
      }
    };
    $scope.addTag = function(e) {
      if (e.keyCode === 13) {
        e.preventDefault();
        $scope.tags.push($scope.solicitude.tag);
        $scope.solicitude.ticket.tags = $scope.tags;
        $scope.solicitude.tag = '';
        return false;
      }
    };
    $scope.nextState = (function(_this) {
      return function(state) {
        return $scope.solicitude.nextState = state;
      };
    })(this);
    return $scope.update = (function(_this) {
      return function(form) {
        if (form.$valid) {
          return SolicitudeFactory.update($scope.solicitude._id, $scope.solicitude, function(err, solicitude) {
            if (err) {
              return $rootScope.alert = {
                type: 'error',
                content: "Ha ocurrido un error al actualizar la solicitud."
              };
            } else {
              $rootScope.alert = {
                type: 'success',
                content: "La solicitude " + solicitude.code + " se actualizo correctamente."
              };
              return $rootScope.$emit('reloadSolicitudes', '', '', '', '');
            }
          });
        }
      };
    })(this);
  }).controller('SolicitudeSaveCtrl', function($scope, $rootScope, SolicitudeFactory, SolicitudeParams) {
    $scope.solicitude = {};
    $scope.errors = {};
    if ((SolicitudeParams != null ? SolicitudeParams.id : void 0) != null) {
      SolicitudeFactory.show(id, function(err, solicitude) {
        if (err) {
          return $scope.errors = err;
        } else {
          $scope.solicitude = solicitude;
          return SolicitudeParams.id = null;
        }
      });
    }
    $scope.create = function(form) {
      if (form.$valid) {
        return SolicitudeFactory.create($scope.solicitude, function(err, solicitude) {
          if (err) {
            $scope.errors = err;
            return $rootScope.alert = {
              type: 'error',
              content: "Ha ocurrido un error al crear la solicitud."
            };
          } else {
            $rootScope.$emit('reloadSolicitudes', '', '', '', '');
            $scope.$emit('hideModals');
            return $rootScope.alert = {
              type: 'success',
              content: "La solicitude " + solicitude.code + " se creo correctamente."
            };
          }
        });
      }
    };
    return $scope.closeModal = function() {
      return $scope.$emit('hideModals');
    };
  });

}).call(this);
