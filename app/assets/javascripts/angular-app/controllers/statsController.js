angular.module('bpopApp').controller("statsController",
    ['$scope', '$interval', '$http', function($scope, $interval, $http) {

  $scope.range = 'MONTH';
  $scope.counter = 0;
  $scope.timeRange = "WEEK";

  $scope.things = [];



  $scope.elements = [{
    provider: 'facebook',
    subject: 'comments',
    pic: 'https://scontent.xx.fbcdn.net/hphotos-xaf1/v/t1.0-0/s130x130/12004757_621909761284464_4945607141034672307_n.jpg?oh=009a35851674d1cf8c010010086224c4&oe=565F190D',
    message: 'Nina! Oh, do I miss her too!!',
    author: 'Alana Sweetwater'
  },

  {
    provider: 'facebook',
    subject: 'posts',
    pic: 'https://fbcdn-photos-h-a.akamaihd.net/hphotos-ak-xtf1/v/t1.0-0/s130x130/12009777_622199657922141_1897688646100609121_n.jpg?oh=5fd43e6691c0c4ed95dbf12154eb2740&oe=566C468D&__gda__=1449460131_38a0503049a7e04dedb4b62ca71c8038',
    message: 'This is the second Post :)',
    author: 'Olivia'
  }];

  var counter = 0;

  $interval(function(){
    if (counter == $scope.elements.length) {
      counter = 0;
    }

    $scope.counter = counter;
    counter++;
  }, 5000);


}]);
