$(document).ready(function() {
  function login() {
    var win         =   window.open(_url, "windowname1", 'width=800, height=600');

 
});

    var pollTimer   =   window.setInterval(function() {
      try {
        console.log(win.document.URL);
        if (win.document.URL.indexOf(REDIRECT) != -1) {
          window.clearInterval(pollTimer);
          var url =   win.document.URL;
          acToken =   gup(url, 'access_token');
          tokenType = gup(url, 'token_type');
          expiresIn = gup(url, 'expires_in');
          win.close();

          validateToken(acToken);
        }
      } catch(e) {
      }
    }, 100);
  }

  function validateToken(token) {

  }

  //credits: http://www.netlobo.com/url_query_string_javascript.html
  function gup(url, name) {
      name = name.replace(/[[]/,"\[").replace(/[]]/,"\]");
      var regexS = "[\?&]"+name+"=([^&#]*)";
      var regex = new RegExp( regexS );
      var results = regex.exec( url );
      if( results == null )
          return "";
      else
          return results[1];
  }

};

