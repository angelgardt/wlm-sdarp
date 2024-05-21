// Parse JSON

var INFO_JSON = JSON.parse(quiz_json);
let INFO = {};
let N = 20;

for (let i = 0; i < INFO_JSON.length; i++) {
  INFO[INFO_JSON[i].name] = {};
  for (let t = 1; t <= N; t++) {
    id = "q" + t;
    INFO[INFO_JSON[i].name][id] = INFO_JSON[i][id];
  }
}


// Add labels and checkboxes

for (let i = 1; i <= N; i++) {
  if (INFO["level"]["q"+i] == "") {
    document.getElementById("q"+i+"-level").hidden = true;
  } else {
    document.getElementById("q"+i+"-level").classList.add("level-" + INFO["level"]["q"+i]);
  }
  if (INFO["type"]["q"+i] == "checkbox") {
    for (let j = 1; j <= 4; j++) {
      document.getElementById("q"+i+"-option"+j).type = "checkbox";
    }
  }
}


// Change TOC title

document.getElementById("toc-title").innerHTML = "Вопросы";


// Add events to submit button
const SUBMIT_BUTTON = document.getElementById("submit-button");
SUBMIT_BUTTON.addEventListener("click", click_submit);

let STATUS = "initial";

function click_submit() {
  console.log("Submit clicked");
}

function click_option() {
  console.log("Option clicked");
}

function remove_answer() {
  console.log("Remove answer clicked");
}

function set_status() {
  console.log("Set status")
}
