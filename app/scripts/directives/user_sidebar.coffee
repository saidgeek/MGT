'use strict'

angular.module('movistarApp')
	.directive 'sgkUserSidebar', ($rootScope) ->
		restrict: 'A'
		scope: {}
		templateUrl: 'partials/admin/user/_sidebar'
		controller: ($scope, $rootScope, UserFactory, RolesData) =>
			$scope.groups = null
			$scope.roles = RolesData.getArray()

			$scope.filter = (value) =>
				$rootScope.filters =
					user:
						role: value
			

			_load = () =>
				UserFactory.groups (err, groups) =>
					if !err
						$scope.groups = groups

			$rootScope.$on 'reloadUserSidebar', (e) =>
				_load()

			_load()
					
					
						
					

					
				
			
		
