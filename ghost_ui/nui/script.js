const prompt = document.getElementById("prompt");
const keyEl = document.querySelector(".key");
const textEl = document.querySelector(".text");

window.addEventListener("message", (e) => {
if (e.data.action === "show") {
  prompt.style.left = `${e.data.x * 100}%`;
  prompt.style.top = `${e.data.y * 100}%`;

  keyEl.innerText = e.data.key;
  textEl.innerText = e.data.text;

  prompt.className = `show ${e.data.type || "default"} ${e.data.active ? "" : "inactive"}`;
}


  if (e.data.action === "hide") {
    prompt.className = "";
  }
});
