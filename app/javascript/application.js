// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails";
import "controllers";

var csrfToken = document
  .querySelector('meta[name="csrf-token"]')
  .getAttribute("content");

document.querySelector("form").addEventListener("submit", async (e) => {
  e.preventDefault();
  const form = e.target;
  const formData = new FormData(form);

  fetch("/submit", {
    method: "POST",
    headers: {
      "X-CSRF-Token": csrfToken,
    },
    body: formData,
  })
    .then((response) => response.json())
    .then((data) => {
      document.getElementById("result-text").innerText = data.result;
      document.getElementById("result-base64-text").innerText =
        data.result_base64;
    })
    .catch((error) => {
      console.error("Error:", error);
    });
});

const inputTypeElement = document.querySelector("#inputType")
const fileInput = document.querySelector("#fileInput")
const textInput = document.querySelector("#textInput")

document.querySelector("#inputType").onchange = function changeInput(){
  //change who to show
  if(inputTypeElement.value==="fileInput"){
    textInput.style.display = "none";
    fileInput.style.display = "flex";
  }
  else{
    textInput.style.display = "flex";
    fileInput.style.display = "none";
  }
}