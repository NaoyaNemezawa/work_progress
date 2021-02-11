document.addEventListener("turbolinks:load", function(){
  const edit_imgs = document.querySelectorAll(".edit_img")
  edit_imgs.forEach(edit_img => {
    edit_img.addEventListener("change", function(e){
      const file = e.target.files[0];
      const blob = window.URL.createObjectURL(file);
      const div = document.createElement("div");
      const setImage = document.createElement("img");
      setImage.setAttribute("src", blob);
      setImage.setAttribute("id", "imagepreview")
      setImage.width = 200
      setImage.height = 200
      const test = edit_img.previousElementSibling
      div.appendChild(setImage)
      edit_img.before(div)
      test.remove();
    })
  });
})