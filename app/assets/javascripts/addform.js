function form () {
  let count_form = 0
  const addbtn = document.getElementById("add_btn");
  const closebtn = document.getElementById("close_btn")
  
  addbtn.addEventListener("click",() => {
    const form = document.getElementById(`form[${count_form}]`);
    // クローン作成
    const clone_form = form.cloneNode(true);
    count_form += 1
    clone_form.id = `form[${count_form}]`
    // フォームの中身を空にする
    clone_input = clone_form.querySelector("input")
    clone_input.value = ""
    // 作成したクローンを一番下のフォームに挿入
    form.after(clone_form);
    // closeform();
    closebtn.classList.remove("d-none")
  });

  closebtn.addEventListener("click",() => {
    const form = document.getElementById(`form[${count_form}]`);
    form.remove();
    count_form -= 1
    if (count_form == 0){
      closebtn.classList.add("d-none")
    };
  })
};

window.addEventListener("load",form);