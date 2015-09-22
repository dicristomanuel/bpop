$( document ).ready(function() {

  var fanTransferred = '',
      isDropped = false,
      notDropped = '',
      groupFansName = [],
      groupPosts = '';

      $('.circle-step-one').show();
      $('.circle-step-two').hide();

  $('#6-m-posts').animateNumber({ number: $('#6-m-posts').text() }, 1500);
  $('#6-m-likes').animateNumber({ number: $('#6-m-likes').text() }, 1500);
  $('#6-m-comments').animateNumber({ number: $('#6-m-comments').text() }, 1500);
  $('#gender-percentage-male').animateNumber({ number: $('#gender-percentage-male').text() }, 1500);
  $('#gender-percentage-female').animateNumber({ number: $('#gender-percentage-female').text() }, 1500);

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
  }, 5300);

  $('profile-pic.small').hover(function() {
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

  var pics = $('profile-pic.small');

  [].forEach.call(pics, function(pic) {
    pic.addEventListener('dragstart', handleDragStart, false);
    pic.addEventListener('dragend', handleDragEnd, false);
  });

  $('group-circle').on('dragover', function() {
    $(this).css({opacity:'0.6'});
    $(this).addClass('scaleUp');
  });

  $('group-circle').on('dragover', function(e) {
    e.preventDefault();
  });

  $('group-circle').on('drop', function(e) {
    e.preventDefault();
      $(this).css({opacity:'1'});
      $(this).removeClass('scaleUp');
      $('container-group-fans').append('<profile-pic class="small inside-group">' + fanTransferred + '</profile-pic>');
      isDropped = true;
        $('.circle-step-one').hide();
        $('.circle-step-two').fadeIn();
  });

  $('group-circle').on('drop', function(e) {
    groupFansName.push(forApiCall);

    if (groupFansName.length === 1 ) {
        $.get(
           "http://localhost:3000/get-single_fan_posts",
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
         "http://localhost:3000/get-group-posts",
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
                        <span class="strong">Likes: 21</span> \
                      </likes> \
                      <comments> \
                        <span class="strong">Comments: 21</span> \
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
    var id = this.firstChild.attributes['0'].nodeValue;
    image = 'img#' + id;
    $(image).css({opacity: 1});
    this.remove();
    if ($('#main-circle-fans')['0'].childElementCount > 0) {
      $('.circle-step-one').hide();
      $('.circle-step-two').fadeIn();
    } else {
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
             "http://localhost:3000/get-single_fan_posts",
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
           "http://localhost:3000/get-group-posts",
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
                          <span class="strong">Likes: 21</span> \
                        </likes> \
                        <comments> \
                          <span class="strong">Comments: 21</span> \
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
