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
}
