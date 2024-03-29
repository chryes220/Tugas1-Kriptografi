// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails";
import "controllers";

// reset localStorage
localStorage.setItem("download-filename", null);

var csrfToken = document
  .querySelector('meta[name="csrf-token"]')
  .getAttribute("content");

document.querySelector("form").addEventListener("submit", async (e) => {
  e.preventDefault();
  const form = e.target;
  const formData = new FormData(form);

  // lakukan validasi masukan
  const validationResult = validateInput(formData);
  if (!validationResult.status) {
    alert(validationResult.message);
    return;
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
      //simpan filename di localstorage
      localStorage.setItem("download-filename", data.file_name);
    })
    .catch((error) => {
      console.error("Error:", error);
    });
});

// download button
document.querySelector("#btn-download").onclick = async (e) => {
  e.preventDefault();
  // params[:file_name]
  // masukkan params file_name
  const formData = new FormData();
  formData.append("file_name", localStorage.getItem("download-filename"));

  fetch(`/download`, {
    method: "POST",
    headers: {
      "X-CSRF-Token": csrfToken,
    },
    body: formData,
  })
    .then((response) => response.blob())
    .then((blob) => {
      //unduh file
      const url = URL.createObjectURL(blob);
      // bikin dummy anchor link
      const a = document.createElement("a");
      a.href = url;
      // rename file
      a.download = localStorage.getItem("download-filename");
      // unduh file
      a.click();
      // remove url
      URL.revokeObjectURL(url);
    })
    .catch((error) => {
      console.error("Error:", error);
    });
};

function validateInput(formData) {
  const validationResult = { status: false, message: "" };
  const cipher = formData.get("cipher");
  const key = formData.get("key").toLowerCase();

  if (cipher === "playfair") {
    //pastiin key nya panjangnya 25, tiap karakter berupa karakter alfabet yang unik, dan gak boleh ada J?
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

  // untuk cipher yang 26 huruf, key harus 26 huruf alfabet latin
  else if (cipher === "standard-vigenere" || cipher === "auto-key-vigenere") {
    // kalau key mengandung karakter selain huruf alfabet, maka tidak valid
    if (!/^[a-z]+$/.test(key)) {
      validationResult.message += "Key must be alphabet only\n";
    } else {
      validationResult.status = true;
    }
  }

  // khusus untuk affine cipher, key harus berupa pasangan angka
  else if (cipher === "affine") {
    if (!/^\d+,\d+$/.test(key)) {
      validationResult.message +=
        "Key must be in format (m,b) where m and b are integers\n";
    } else {
      validationResult.status = true;
    }
  }

  // khusus untuk transposition cipher, key harus berupa angka
  else if (cipher === "transposition") {
    if (!/^\d+$/.test(key)) {
      validationResult.message += "Key must be a number\n";
    } else {
      validationResult.status = true;
    }
  }

  // untuk cipher yang diawali dengan 'se-', key harus
  // berupa pasangan string,angka
  else if (cipher.startsWith("se-")) {
    if (!/^.+,\d+$/.test(key)) {
      validationResult.message +=
        "Key must be in format (key_substitution, key_transposition)\n";
    } else {
      validationResult.status = true;
    }
  }

  // untuk hill cipher, key harus pasangan angka dan matrix, setiap elemen matrix jumlahnya harus sama dengan `m`
  else if (cipher === "hill") {
    if (!/^.*\d+ *; *\[[\d\[\] ,]*\].*$/.test(key)) {
      validationResult.message += "Key must be in format `m; matrix`\n";
    } else {
      validationResult.status = true;
    }
  }

  // untuk enigma, input key nya cuma boleh ada alfabet, semikolon, atau spasi, serta konfigurasi awalnya hanya boleh angka
  else if (cipher === "enigma") {
    // pisahkan untuk validasi keyset dan konfigurasi
    const [keysets, positions] = key.split(";");
    // cek secara umum
    if (!/^[A-Za-z0-9;, ]+$/.test(key)) {
      validationResult.message +=
        "Key must be in format `KEYSET_1,KEYSET_2,KEYSET_3;POS_1,POS_2,POS_3` \n";
    }
    //cek keyset
    if (!/^[A-Za-z, ]+$/.test(keysets)) {
      validationResult.message += "KEYSET can only contains alphabet\n";
    }
    //cek konfigurasi
    if (!/^[0-9, ]+$/.test(positions)) {
      validationResult.message += "POS can only contains number\n";
    }
    // kalau message kosong, berarti aman
    if (validationResult.message.length === 0) {
      validationResult.status = true;
    }
  } else {
    validationResult.status = true;
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
  } else if (cipher == "transposition") {
    infoText.style.display = "block";
    infoText.innerHTML = "For Transposition Cipher, key must be a number";
  } else if (cipher.startsWith("se-")) {
    infoText.style.display = "block";
    infoText.innerHTML =
      "For Super Encryption, please use the format (key_substitution, key_transposition)";
  } else if (cipher === "hill") {
    infoText.style.display = "block";
    infoText.innerHTML =
      "For Hill Cipher, please use the format `m; matrix` , e.g: `2;[[1,3],[4,5]]`";
  } else if (cipher === "enigma") {
    infoText.style.display = "block";
    infoText.innerHTML =
      "For Enigma Cipher, please use formaat `KEYSET_1,KEYSET_2,KEYSET_3;POS_1,POS_2,POS_3`, e.g: `ABF..E,FRE..G,RHF..P;0,1,3`";
  } else {
    infoText.style.display = "none";
    infoText.innerHTML = "";
  }
};
