function showInput() {
  docid = document.getElementById("document_id").value
  vid = document.getElementById("version_id").value;

  var result="";
  $.ajax({
      url: "http://127.0.0.1:3000/document?documentId=" +docid + "&versionId=" + vid,
      async: true,
      type: 'GET',
      success:function(data) {
          result = data; 
          document.getElementById('output').innerHTML = result['message']['location']
      },
      error:function (xhr, ajaxOptions, thrownError){
        document.getElementById('output').innerHTML = 'Unexpected error'
      }
 });
}