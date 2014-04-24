(function() {
  'use strict';
  angular.module('movistarApp').controller('AdminCtrl', function($rootScope, $scope, Auth, $location, RolesData) {
    var _showModals;
    $rootScope.title = "Administración";
    $scope.groups = {};
    switch ($location.$$path) {
      case '/admin/category':
        $scope.module = 'category';
        break;
      default:
        $scope.module = '';
    }
    $scope.isActiveLink = function(path) {
      return path === $location.$$path;
    };
    $scope.showModals = function(modal) {
      return _showModals(modal);
    };
    $rootScope.$on('showModals', function(e, args) {
      return _showModals(args.modal);
    });
    $scope.$on('hideModals', function(e, args) {
      return $scope.modals = '';
    });
    return _showModals = function(modal) {
      return $scope.modals = modal;
    };
  }).controller('SidebarUsersCtrl', function($scope, UserFactory, $rootScope, RolesData) {
    var _load;
    $scope.groups = null;
    $scope.errors = {};
    $scope.roles = RolesData.getArray();
    _load = function() {
      return UserFactory.groups(function(err, groups) {
        if (err) {
          return $scope.errors = err;
        } else {
          return $scope.groups = groups;
        }
      });
    };
    $rootScope.$on('reloadGroups', function(e) {
      return _load();
    });
    $scope.filter = function(role) {
      return $rootScope.$emit('reloadUsers', role);
    };
    return _load();
  }).controller('UserCtrl', function($scope, UserFactory, $rootScope) {
    var _loadUsers;
    $scope.users = [];
    $scope.errors = {};
    $rootScope.$on('reloadUsers', function(e, role) {
      return _loadUsers(role);
    });
    $rootScope.$on('updateUsers', function(e) {
      _loadUsers('');
      return $rootScope.$emit('reloadGroups');
    });
    $scope.loadUser = function(id) {
      return $rootScope.$emit('loadUserShow', id);
    };
    _loadUsers = function(role) {
      return UserFactory.index(role, function(err, users) {
        if (err) {
          return $scope.errors = err;
        } else {
          if (users.length > 0) {
            $rootScope.$emit('loadUserShow', users[0]._id);
            return $scope.users = users;
          }
        }
      });
    };
    return _loadUsers('');
  }).controller('UserShowCtrl', function($scope, UserFactory, $rootScope, UserParams) {
    var _loadUser;
    $scope.user = {};
    $scope.errors = {};
    $rootScope.$on('loadUserShow', function(e, id) {
      return _loadUser(id);
    });
    if ((UserParams != null ? UserParams.id : void 0) != null) {
      _loadUser(UserUpdateParams.id);
    }
    $scope.EditUser = function(id) {
      UserParams.id = id;
      return $rootScope.$emit('showModals', {
        modal: 'updateUser',
        id: id
      });
    };
    return _loadUser = function(id) {
      $scope.user = '';
      return UserFactory.show(id, function(err, user) {
        var _ref;
        if (err) {
          return $scope.errors = err;
        } else {
          if ((((_ref = user.profile) != null ? _ref.avatar : void 0) == null) || user.profile.avatar === '') {
            user.profile.avatar = 'images/avatar-user.png';
          }
          return $scope.user = user;
        }
      });
    };
  }).controller('UserSaveCtrl', function($scope, UserFactory, $rootScope, UserParams, RolesData) {
    $scope.user = {};
    $scope.errors = {};
    $scope.roles = RolesData.getArray();
    if ((UserParams != null ? UserParams.id : void 0) != null) {
      UserFactory.show(UserParams.id, function(err, user) {
        if (err) {
          return $scope.errors = err;
        } else {
          $scope.user = user;
          return UserParams.id = null;
        }
      });
    }
    $scope.update = function(form) {
      if (form.$valid) {
        return UserFactory.update($scope.user._id, $scope.user, function(err, user) {
          if (err) {
            $scope.errors = err;
            return $rootScope.alert = {
              type: 'error',
              content: "Ha ocurrido un error al actualizar el usuario."
            };
          } else {
            if ($rootScope.currentUser.id === user._id) {
              $rootScope.currentUser.avatar = user.profile.avatar;
              $rootScope.currentUser.name = user.profile.firstName + ' ' + user.profile.lastName;
              $rootScope.currentUser.role = user.role;
            }
            $rootScope.$emit('reloadUsers', '');
            $scope.$emit('hideModals', true);
            return $rootScope.alert = {
              type: 'success',
              content: "El usuario " + user.profile.firstName + " " + user.profile.lastName + " se a actualizado correctamente."
            };
          }
        });
      }
    };
    $scope.create = function(form) {
      if (form.$valid) {
        return UserFactory.save($scope.user, function(err, user) {
          if (err) {
            $scope.errors = err;
            return $rootScope.alert = {
              type: 'error',
              content: "Ha ocurrido un error al crear el usuario."
            };
          } else {
            $rootScope.$emit('updateUsers');
            $scope.$emit('hideModals', true);
            return $rootScope.alert = {
              type: 'success',
              content: "El usuario " + user.profile.firstName + " " + user.profile.lastName + " se a agregado correctamente."
            };
          }
        });
      }
    };
    return $scope.closeModal = function() {
      return $scope.$emit('hideModals', true);
    };
  }).controller('CategoryCtrl', function($scope, CategoryFactory, $rootScope, CategoryParams) {
    var _load;
    $scope.categories = [];
    $scope.errors = {};
    $rootScope.$on('reloadCategories', function(e, category) {
      return _load();
    });
    $rootScope.$on('updateCategory', function(e, category) {
      return _load();
    });
    $scope.loadCategory = function(id) {
      return $rootScope.$emit('loadCategoryShow', id);
    };
    _load = function() {
      return CategoryFactory.index(function(err, categories) {
        if (err) {
          return $scope.errors = err;
        } else {
          if (categories.length > 0) {
            $scope.categories = categories;
            return $rootScope.$emit('loadCategoryShow', categories[0]._id);
          } else {
            $scope.categories = {};
            return $rootScope.$emit('loadCategoryShow', null);
          }
        }
      });
    };
    return _load();
  }).controller('CategoryShowCtrl', function($scope, CategoryFactory, $rootScope, CategoryParams) {
    var _load;
    $scope.category = {};
    $scope.errors = {};
    $rootScope.$on('loadCategoryShow', function(e, id) {
      if (id) {
        return _load(id);
      } else {
        return $scope.category = null;
      }
    });
    if ((CategoryParams != null ? CategoryParams.id : void 0) != null) {
      _load(CategoryParams.id);
    }
    $scope.EditCategory = function(id) {
      CategoryParams.id = id;
      return $rootScope.$emit('showModals', {
        modal: 'updateCategory',
        id: id
      });
    };
    $scope.remove = function(id) {
      console.log(id);
      return CategoryFactory.remove(id, function(err) {
        if (err) {
          return $scope.errors = err;
        } else {
          return $rootScope.$emit('reloadCategories', '');
        }
      });
    };
    return _load = function(id) {
      $scope.category = '';
      return CategoryFactory.show(id, function(err, category) {
        if (err) {
          return $scope.errors = err;
        } else {
          return $scope.category = category;
        }
      });
    };
  }).controller('CategorySaveCtrl', function($scope, CategoryFactory, $rootScope, CategoryParams) {
    $scope.category = {};
    $scope.errors = {};
    if ((CategoryParams != null ? CategoryParams.id : void 0) != null) {
      CategoryFactory.show(CategoryParams.id, function(err, category) {
        if (err) {
          return $scope.errors = err;
        } else {
          $scope.category = category;
          return CategoryParams.id = null;
        }
      });
    }
    $scope.update = function(form) {
      if (form.$valid) {
        return CategoryFactory.update($scope.category._id, $scope.category, function(err, category) {
          if (err) {
            $scope.errors = err;
            return $rootScope.alert = {
              type: 'error',
              content: "Ha ucurrido un error al actualizar la clasificación."
            };
          } else {
            $rootScope.$emit('reloadCategories', category);
            $scope.$emit('hideModals', true);
            return $rootScope.alert = {
              type: 'success',
              content: "La categoría " + category.name + " se actualizo correctamente."
            };
          }
        });
      }
    };
    $scope.create = function(form) {
      if (form.$valid) {
        return CategoryFactory.save($scope.category, function(err, category) {
          if (err) {
            $scope.errors = err;
            return $rootScope.alert = {
              type: 'error',
              content: "Ha ucurrido un error al crear la clasificación."
            };
          } else {
            $rootScope.$emit('updateCategory', category);
            $scope.$emit('hideModals', true);
            return $rootScope.alert = {
              type: 'success',
              content: "La categoría " + category.name + " se a creado correctamente."
            };
          }
        });
      }
    };
    return $scope.closeModal = function() {
      return $scope.$emit('hideModals', true);
    };
  });

}).call(this);
