angular.module('bpopApp').controller("statsController",
    ['$scope', '$interval', '$http', function($scope, $interval, $http) {

  $scope.range = 'MONTH';
  $scope.counter = 0;
  $scope.timeRange = "WEEK";
  $scope.subject = 'likes';
  $scope.things = [];

 // TODO change to jquery
  var div = document.getElementById('div-carousel');
  var dataToParse = div.getAttribute("data-carousel").replace(/=>/g, ':');
  // dataToParse = JSON.parse(dataToParse);

  $scope.elements = [];

  // dataToParse.comments.comments.forEach(function(comment) {
  //   $scope.elements.push({
  //     provider: 'facebook',
  //     subject: 'comments',
  //     pic: '',
  //     message: comment.message,
  //     author: comment.user_name,
  //     url: ''
  //   });
  // });

  dataToParse.posts.posts.forEach(function(post) {
    $scope.elements.push({
      provider: 'facebook',
      subject: 'posts',
      pic: post.picture,
      message: post.message,
      author: '',
      commentsAmount: post.comments,
      likesAmount: post.likes,
      url: post.url
    });
  });

  var counter = 0;

  $interval(function(){
    if (counter == $scope.elements.length) {
      counter = 0;
    }

    $scope.counter = counter;
    counter = Math.floor(Math.random() * $scope.elements.length) + 1;
  }, 4500);


}]);
