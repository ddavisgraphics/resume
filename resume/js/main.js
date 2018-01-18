// Use raw get to grab the json file from my github
// https://rawgit.com/
// ----------------------------------------------------------------------------- 
$.ajax({
  type: "GET",
  url: "https://rawgit.com/ddavisgraphics/resume/master/ddavis_resume.json", // dev
  // url: "https://cdn.rawgit.com/ddavisgraphics/resume/master/ddavis_resume.json", // production
  dataType: 'text',
  async: true,
  success: function(response) {
    var jsonObject = JSON.parse(response);
    setupProfile(jsonObject.basics);  
  }, 
  statusCode: {
    404: function (response) {
        // alert(404);
    },
    200: function (response) {
        // alert(response);
    }
  },
  error: function (jqXHR, status, errorThrown) {
    // alert('error');
  }
});

// Setup Profile
// Sets up the name, contact information, and other basic information in my resume.
// ----------------------------------------------------------------------------- 
function setupProfile(basics){
  console.log(basics);

  $('.name').html(basics.name); 
  $('.title').html(basics.label); 
  $('.profile-pic').html('<img src="' + basics.picture + '" alt="profile picture of me" />');
  $('.logo').html('<img src="' + basics.logo + '" alt="logo for my resume." />'); 
  $('.location').html('<span class="fa fa-map-marker" aria-hidden="true"></span> ' + basics.location.region); 
  $('.phone').html('<span class="fa fa-mobile" aria-hidden="true"></span> ' + basics.phone); 
  $('.email').html('<span class="fa fa-envelope" aria-hidden="true"></span> ' + basics.email);
  
  var socialMedia = basics.profiles; 
  var socialMediaHTML = "<ul>"; 
  for (let index = 0; index < socialMedia.length; index++) {
    const element = socialMedia[index];
    socialMediaHTML += '<li> <a href="'+ element.url +'">' + element.network + '</a> </li>'; 
  }
  socialMediaHTML += "</ul>"; 

  $('.social').html(socialMediaHTML);

  $('.summary p').html(basics.summary);
}
