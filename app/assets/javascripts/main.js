$( document ).ready(function() {


// ===========================
// RETRIEVING DATA
// ===========================

  var counter = 1;

  var getFansData = function() {

    $('fans-super-list').html('<loader><div class="wrapper"><div class="cssload-loader"></div></div></loader>');
    $('top-fan').html('<loader><div class="wrapper"><div class="cssload-loader"></div></div></loader>');
    $('div.carousel-box-right').html('<loader><div class="wrapper"><div class="cssload-loader-dark"></div></div></loader>');

    $('while-loading').show();
    $('once-loaded').hide();

    var source;
    source = new EventSource('/check');
    source.addEventListener("refresh", function(e) {
      $('while-loading').hide();
      $('once-loaded').fadeIn();

      fans_data = JSON.parse(e.data).fans_data;
      comments  = JSON.parse(e.data).comments;
      posts     = JSON.parse(e.data).posts;

      commentsAndPosts = [];

      comments.forEach(function(comment) {
        commentsAndPosts.push(comment);
      });

      posts.forEach(function(post) {
        commentsAndPosts.push(post);
      });


      if(fans_data !== "" && posts && comments) {
        var dots = '';
        $('div.carousel-box-right').html('<div class="subject animated fadeIn"> \
          <span class="medium animated fadeIn">latest </span><span class="bold animated fadeIn">facebook</span> posts \
        </div> \
        <div class="message light" animated fadeIn> \
          <p class="light animated fadeIn"> \
            ' + posts[0].message.substring(0, 80) + dots + ' \
          </p> \
          <span class="animated fadeIn"> \
            <a href="' + posts[0].url + '" target="_blank"><img src="' + posts[0].picture + '"></a> \
          </span> \
        </div> \
        <div class="after-message animated fadeIn"> \
            <span>likes</span> <span class="strong">' + posts[0].likes + '</span> \
            <span>comments</span> <span class="strong">' + posts[0].comments + '</span> \
        </div>');

        setInterval(function(){
          var data = commentsAndPosts[Math.floor(Math.random() * commentsAndPosts.length)];

          if(data.message.length > 79) { dots = ' ...'; } else { dots='' }

          if(data.url) {
            $('div.carousel-box-right').html('<div class="subject animated fadeIn"> \
              <span class="medium animated fadeIn">latest </span><span class="bold animated fadeIn">facebook</span> posts \
            </div> \
            <div class="message light" animated fadeIn> \
              <p class="light animated fadeIn"> \
                ' + data.message.substring(0, 80) + dots + ' \
              </p> \
              <span class="animated fadeIn"> \
                <a href="' + data.url + '" target="_blank"><img src="' + data.picture + '"></a> \
              </span> \
            </div> \
            <div class="after-message animated fadeIn"> \
                <span>likes</span> <span class="strong">' + data.likes + '</span> \
                <span>comments</span> <span class="strong">' + data.comments + '</span> \
            </div>');
          } else {
            $('div.carousel-box-right').html('<div class="subject animated fadeIn"> \
              <span class="medium animated fadeIn">latest </span><span class="bold animated fadeIn">facebook</span> comments \
            </div> \
            <div class="message light" animated fadeIn> \
              <p class="light animated fadeIn"> \
                ' + data.message.substring(0, 80) + dots + ' \
              </p> \
            </div> \
            <div class="after-message animated fadeIn"> \
              <span class="strong animated fadeIn">from </span>' + data.user_name + ' \
            </div>');
          }
        },5000);

        $('fans-super-list').html("");
        fans_data.forEach(function(fan) {
          $('fans-super-list').append(
            '<profile-pic class="small" draggable="true"> \
            <a href="' + fan.fan_link + '" target="_blank"><img src="' + fan.fan_pic + '" id="_' + counter + '"></a> \
            <grabName style="display:none"> ' + fan.fan_name + ' </grabName> \
            </profile-pic>'
          );
          counter += 1;
        });

        $('top-fan').html("");
        $('info').append('<name>' + fans_data[0].fan_name + '</name> \
          <interactions>' + fans_data[0].fan_interactions + '<span style="font-size:1vw">interactions</span></interactions>');
        $('top-fan').append('<a href="' + fans_data[0].fan_link + '" target="_blank" class="animated pulse"><img src="' + fans_data[0].fan_pic + '"></a>');
        $('fans-box').append('<p id="active-users"><span class="strong">' + fans_data.length + '</span> active fans on your profile</p>');

        var index = 1;
          while (index <= 4) {
            $('top-5').append('<container class="animated fadeIn"> \
            <profile-pic> \
             <a href="' +  fans_data[index].fan_link + '" target="_blank"><img src="' + fans_data[index].fan_pic + '"></a> \
            </profile-pic> \
            <p>' + fans_data[index].fan_name + '</p> \
            <interactions>' + fans_data[index].fan_interactions + '</interactions> \
            </container>');

            index += 1;
          }

          $.get(
             "/get-carousel-numbers?since=one+week+ago&subject=likes",
             function(data) {
               $('p.number').html(data);
             }
           );

           $.get(
              "/get-6-month-data",
              function(data) {
                $('number#6-m-posts').html(data[0].posts);
                $('number#6-m-likes').html(data[1].likes);
                $('number#6-m-comments').html(data[2].comments);

                $('#6-m-posts').animateNumber({ number: $('#6-m-posts').text() }, 1500);
                $('#6-m-likes').animateNumber({ number: $('#6-m-likes').text() }, 1500);
                $('#6-m-comments').animateNumber({ number: $('#6-m-comments').text() }, 1500);

                var values = [data[0].posts, data[1].likes, data[2].comments];
                var max = Math.max.apply(Math, values);

                var percentagePosts = values[0] / max * 100;
                var percentageLikes = values[1] / max * 100;
                var percentageComments = values[2] / max * 100;

                $( "#bar_posts" ).animate({
                 height: percentagePosts + '%'
               });

                $( "#bar_likes" ).animate({
                 height: percentageLikes + '%'
               });

               var values = [data[0].posts, data[1].likes, data[2].comments];
               var max = Math.max.apply(Math, values);

               var percentagePosts = values[0] / max * 100;
               var percentageLikes = values[1] / max * 100;
               var percentageComments = values[2] / max * 100;

               $( "#bar_posts" ).animate({
                height: percentagePosts + '%'
              });

               $( "#bar_likes" ).animate({
                height: percentageLikes + '%'
              });

               $( "#bar_comments" ).animate({
                height: percentageComments + '%'
              });
              }
            );


            $.get(
               "/get-gender-percentage",
               function(data) {
                 $('#gender-percentage-male').html(data.male);
                 $('#gender-percentage-female').html(data.female);

                 $('#gender-percentage-male').animateNumber({ number: $('#gender-percentage-male').text() }, 1500);
                 $('#gender-percentage-female').animateNumber({ number: $('#gender-percentage-female').text() }, 1500);


                 $( "#colum-male-gender-percentage" ).animate({
                  height: data.male + '%'
                });

                 $( "#colum-female-gender-percentage" ).animate({
                  height: data.female + '%'
                });
               }
             );

        source.close();
      }
    });
  }();



  $('#time-range-select').change(function() {
    $( "#time-range-select option:selected" ).text(function() {
      subject = $( "#select-subject option:selected" ).text().replace(/\s+/, "");
        $.get(
           "/get-carousel-numbers?since=" + this.id + "&subject=" + subject,
           function(data) {
             $('p.number').html(data);
           }
         );
      });
    });


  $('#select-subject').change(function() {
    $( "#select-subject option:selected" ).text(function() {
      timeRange = $( "#time-range-select option:selected" );
      subject = $(this).text().replace(/\s+/, "");
        $.get(
           "/get-carousel-numbers?since=" + timeRange[0].id + "&subject=" + subject,
           function(data) {
             $('p.number').html(data);
           }
         );
      });
    });



  // ===========================

  window.setInterval(function(){
    $('.step-arrow').addClass( "animated swing" );
    window.setInterval(function(){
      $('.step-arrow').removeClass( "animated swing" );
    }, 900);
  }, 7000);


  var fanTransferred = '',
      isDropped = false,
      notDropped = '',
      groupFansName = [],
      groupPosts = '',
      forApiCall = '';

      $('.circle-step-one').show();
      $('.circle-step-two').hide();


  window.setInterval(function(){
    $('#time-range-select').addClass( "animated pulse" );
    window.setInterval(function(){
      $('#time-range-select').removeClass( "animated pulse" );
    }, 900);
  }, 5000);

  window.setInterval(function(){
    $('#subject').addClass( "animated pulse" );
    window.setInterval(function(){
      $('.subject').removeClass( "animated pulse" );
    }, 900);
  }, 5200);


  $('fans-super-list').on('mouseenter', 'profile-pic', function() {
    thisName = $(this).text();
    $('fan-name').text(thisName);
});


  function handleDragStart(e) {
    isDropped = false;
    fanTransferred = this.childNodes['1'].innerHTML;
    forApiCall = this.childNodes['1'].parentElement.childNodes['3'].innerHTML.slice(1, -1);
    notDropped = this.childNodes['1'].childNodes;
    var image = this.childNodes['1'].childNodes;
    $(image).css({opacity: 0.4});
  }


  function handleDragEnd(e) {
    if (isDropped === false) {
      $(notDropped).css({opacity: 1});
    }
  }

  var pics = $('fans-super-list');

  pics.on('dragstart', 'profile-pic', handleDragStart);
  pics.on('dragend', 'profile-pic', handleDragEnd);


  $('group-circle').on('dragover', function() {
    $(this).css({opacity:'0.6'});
    $(this).addClass('scaleUp');
  });

  $('group-circle').on('dragover', function(e) {
    e.preventDefault();
  });


  $('group-circle').on('drop', function(e) {

    $('display-posts').html('<loader><div class="wrapper"><div class="cssload-loader"></div></div></loader>');
    $('.fa-arrow-down').remove();
    $('fans-box').append('<div class="fa fa-arrow-down animated pulse"></div>');

    e.preventDefault();
      $(this).css({opacity:'1'});
      $(this).removeClass('scaleUp');
      $('container-group-fans').append('<profile-pic class="small inside-group">' + fanTransferred + '</profile-pic>');
      isDropped = true;
        $('.circle-step-one').hide();
        $('.circle-step-two').fadeIn();

    groupFansName.push(forApiCall);

    if (groupFansName.length === 1 ) {
        $.get(
           "/get-single_fan_posts",
           { names: groupFansName[0] },
           function(data) {
             $('div#total-posts').text(data.length);
            $('display-posts').html("");
              data.forEach(function(post) {

                if (post.picture === "") {
                  post.picture = '/assets/nopic-76567df4447eb811f7fe1ccdf27f87dd.png';
                }
                $('display-posts').append(
                  '<post class="animated fadeIn"> \
                  <story>"' + post.story + '"</story> \
                    <message>"' + post.message + '"</message> \
                    <picture><img src="' + post.picture + '"></picture> \
                      <gender> \
                        <likes> \
                          <span class="strong">Likes: ' + post.likes + '</span> \
                        </likes> \
                        <comments> \
                          <span class="strong">Comments: ' + post.comments + '</span> \
                        </comments> \
                      </gender> \
                    </post>');
                });
              }
            );

    } else {
      $.get(
         "/get-group-posts",
         { names: groupFansName },
         function(data) {
           if (data.length === 0) {
             $('display-posts').html('<no-post> - No post to show - </no-post>');
             $('div#total-posts').text('0');
           } else {
           $('div#total-posts').text(data.length);
          $('display-posts').html("");
            data.forEach(function(post) {
              if (post.picture === "") {
                post.picture = '/assets/nopic-76567df4447eb811f7fe1ccdf27f87dd.png';
              }
              $('display-posts').append(
                '<post class="animated fadeIn"> \
                <story>"' + post.story + '"</story> \
                  <message>"' + post.message + '"</message> \
                    <picture><img src="' + post.picture + '"></picture> \
                    <gender> \
                      <likes> \
                        <span class="strong">Likes: ' + post.likes + '</span> \
                      </likes> \
                      <comments> \
                        <span class="strong">Comments: ' + post.comments + '</span> \
                      </comments> \
                    </gender> \
                  </post>');
              });
            }
          }
        );
      }
  });


  $('container-group-fans').on('click', '.inside-group', function () {

    var id = this.childNodes['0'].attributes['1'].nodeValue;
    image = 'img#' + id;
    $(image).css({opacity: 1});
    this.remove();
    if ($('#main-circle-fans')['0'].childElementCount > 0) {
      $('.circle-step-one').hide();
      $('.circle-step-two').fadeIn();
    } else {
      $('.fa-arrow-down').remove();
      $('.circle-step-two').hide();
      $('.circle-step-one').fadeIn();
    }

    name = $(image)['0'].parentElement.parentElement.children['1'].innerHTML.slice(1, -1);
    indexToRemove = groupFansName.indexOf(name);
    groupFansName.splice(indexToRemove, 1);

    if (groupFansName.length === 0 ) {
            $('display-posts').html("");
            $('div#total-posts').text('0');
    } else {
      if (groupFansName.length === 1 ) {
          $.get(
             "/get-single_fan_posts",
             { names: groupFansName[0] },
             function(data) {
               $('div#total-posts').text(data.length);
              $('display-posts').html("");
                data.forEach(function(post) {

                  if (post.picture === "") {
                    post.picture = '/assets/nopic-76567df4447eb811f7fe1ccdf27f87dd.png';
                  }
                  $('display-posts').append(
                    '<post class="animated fadeIn"> \
                    <story>"' + post.story + '"</story> \
                      <message>"' + post.message + '"</message> \
                        <picture><img src="' + post.picture + '"></picture> \
                        <gender> \
                          <likes> \
                            <span class="strong">Likes: ' + post.likes + '</span> \
                          </likes> \
                          <comments> \
                            <span class="strong">Comments: ' + post.comments + '</span> \
                          </comments> \
                        </gender> \
                      </post>');
                  });
                }
              );

      } else {
        $.get(
           "/get-group-posts",
           { names: groupFansName },
           function(data) {
             if (data.length === 0) {
               $('display-posts').html('<no-post> - No post to show - </no-post>');
               $('div#total-posts').text('0');
             } else {
             $('div#total-posts').text(data.length);
            $('display-posts').html("");
              data.forEach(function(post) {
                if (post.picture === "") {
                  post.picture = '/assets/nopic-76567df4447eb811f7fe1ccdf27f87dd.png';
                }
                $('display-posts').append(
                  '<post class="animated fadeIn"> \
                  <story>"' + post.story + '"</story> \
                    <message>"' + post.message + '"</message> \
                      <picture><img src="' + post.picture + '"></picture> \
                      <gender> \
                        <likes> \
                          <span class="strong">Likes: ' + post.likes + '</span> \
                        </likes> \
                        <comments> \
                          <span class="strong">Comments: ' + post.comments + '</span> \
                        </comments> \
                      </gender> \
                    </post>');
                });
              }
            }
          );
        }
      }
  });
});
