'use strict'

angular.module('movistarApp')
	.directive 'sgkUserSidebar', ($rootScope) ->
		restrict: 'A'
		scope: {}
		templateUrl: 'directives/user/sidebar'
		controller: ($scope, $rootScope, User, RolesData) =>
			$scope.groups = null
			$scope.roles = RolesData.getArray()

			$scope.filter = (value) =>
				$rootScope.filters =
					user:
						role: value
			

			_load = () =>
				User.groups (err, groups) =>
					if !err
						$scope.groups = groups

			$rootScope.$on 'reloadUserSidebar', (e) =>
				_load()

			_load()
					
					
						
					

					
				
			
		
