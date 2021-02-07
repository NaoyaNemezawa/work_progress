document.addEventListener("turbolinks:load", function(){
  let imagecount = 0
  const ImageList = document.getElementById("image_id0");
  document.getElementById("comment_img").addEventListener('change', function(e){
    const file = e.target.files[0];
    const blob = window.URL.createObjectURL(file);
    const setImage = document.createElement("img");
    setImage.setAttribute("src", blob);
    setImage.setAttribute("id", "imagepreview")
    setImage.width = 200
    setImage.height = 200
    if (imagecount == 1){
      const removeimage = document.getElementById("imagepreview")
      console.log(removeimage);
      removeimage.remove();
    };
    ImageList.appendChild(setImage);
    imagecount = 1
  });
})