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
    })
    .catch((error) => {
      console.error("Error:", error);
    });
});
