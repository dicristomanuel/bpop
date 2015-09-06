angular.module('bpopApp').controller("authController", ['$scope', function($scope) {

  $scope.flashMessage = "test flashhh";

  $scope.resetFlash = function() {
    console.log("before " + $scope.flashMessage);
        $scope.flashMessage = "";
    console.log("after " + $scope.flashMessage);
      };
}]);
