// Parse JSON
var INFO_JSON = JSON.parse(quiz_json);
let INFO = {};
let N_tasks = 20;
let N_options = 4;

for (let i = 0; i < INFO_JSON.length; i++) {
  INFO[INFO_JSON[i].name] = {};
  for (let t = 1; t <= N_tasks; t++) {
    id = "q" + t;
    INFO[INFO_JSON[i].name][id] = INFO_JSON[i][id];
  }
}


// Add labels and checkboxes
for (let i = 1; i <= N_tasks; i++) {
  if (INFO["level"]["q"+i] == "") {
    document.getElementById("q"+i+"-level").hidden = true;
  } else {
    document.getElementById("q"+i+"-level").classList.add("level-" + INFO["level"]["q"+i]);
  }
  if (INFO["type"]["q"+i] == "checkbox") {
    for (let j = 1; j <= N_options; j++) {
      document.getElementById("q"+i+"-option"+j).type = "checkbox";
    }
  }
}


// Change TOC title
document.getElementById("toc-title").innerHTML = "Вопросы";


// Add events
const ALTERNATIVES_OPTIONS = document.getElementsByClassName("input-alternative");
console.log(ALTERNATIVES_OPTIONS);
for (let i = 0; i < N_tasks*N_options; i++) {
  ALTERNATIVES_OPTIONS[i].addEventListener("click", click_option);
}

const SUBMIT_BUTTON = document.getElementById("submit-button");
SUBMIT_BUTTON.addEventListener("click", click_submit);

// Set initial status
let STATUS = "initial";

// Set messages text
const MESSAGES = {
  non_filled: "Нет ни одного ответа :'(",
  partially_filled: "Некоторые вопросы остались без ответа ((",
  filled: ""
};


function click_submit() {
  console.log("Submit clicked");
  if (STATUS != "filled") {
    check_filled();
    set_status();
    show_status();
  }
  if (STATUS == "filled") {
    check_quiz();
    show_results();
    show_answers();
  }
}

function click_option() {
  console.log("Option clicked");
  console.log(this.name);
  show_remove_answer_button();
  remove_non_filled();
}

function remove_answer() {
  console.log("Remove answer clicked");
  set_options_unchecked();
  hide_remove_answer_button();
}

function show_remove_answer_button() {
  console.log("Show remove answer button");
}

function set_status() {
  console.log("Set status");
}

function show_status() {
  console.log("Show status");
}

function remove_non_filled() {
  console.log("Remove non-filled");
}

function check_filled() {
  console.log("Check filled");
}

function check_quiz() {
  console.log("Check quiz");
}

function show_results() {
  console.log("Show results");
}

function show_answers() {
  console.log("Show answers");
}
