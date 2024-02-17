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

  //lakukan validasi masukan
  const validationResult = validateInput(formData)
  if(!validationResult.status){
    alert(validationResult.message)
    return
  }

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

function validateInput(formData) {
  const validationResult = { status: false, message: "" };
  if (formData.get("cipher") === "playfair") {
    //pastiin key nya panjangnya 25, tiap karakter berupa karakter alfabet yang unik, dan gak boleh ada J?
    const key = formData.get("key").toLowerCase();
    if (key.length !== 25) {
      validationResult.message +=
        "Key for Playfair Cipher need at least 25 characters\n";
    }
    if (!/^[a-z]+$/.test(key)) {
      validationResult.message += "Key must be alphabet\n";
    }
    if (new Set(key).size !== key.length) {
      validationResult.message += "Each character in key must be unique\n";
    }
    if (key.indexOf("j") > -1) {
      validationResult.message += "J cannot be included in key\n";
    }

    //kalau message kosong, berarti lolos tes
    if (!validationResult.message.length) {
      validationResult.status = true;
    }
  }
  return validationResult;
}

const inputTypeElement = document.querySelector("#inputType");
const fileInput = document.querySelector("#fileInput");
const textInput = document.querySelector("#textInput");

document.querySelector("#inputType").onchange = function changeInput() {
  //change who to show
  if (inputTypeElement.value === "fileInput") {
    textInput.style.display = "none";
    fileInput.style.display = "flex";
  } else {
    textInput.style.display = "flex";
    fileInput.style.display = "none";
  }
};

document.querySelector("#cipher").onchange = function changeCipher() {
  var cipher = document.querySelector("#cipher").value;
  var infoText = document.querySelector("#info-text");
  if (cipher === "affine") {
    infoText.style.display = "block";
    infoText.innerHTML = "For Affine Cipher, please use the format (m,b)";
  } else {
    infoText.style.display = "none";
    infoText.innerHTML = "";
  }
};
