var app = angular.module('bpopApp', ['ngRoute', 'templates']);

app.config([
  '$httpProvider', function($httpProvider) {
    return $httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content');
  }
]);

app.config(function ($routeProvider) {
        $routeProvider
            .when('/', {
                templateUrl: 'login-form.html',
                controller: 'authController'
            }).when('/signup', {
                templateUrl: 'signup-form.html',
                controller: 'authController'
            }).when('/recover-password', {
                templateUrl: 'recover-password.html',
                controller: 'authController'
            }).when('/success', {
                templateUrl: 'singned_in.html',
                controller: 'authController'
            }).when('/_=_', {
                templateUrl: 'singned_in.html',
                controller: 'authController'
            });;
    });
