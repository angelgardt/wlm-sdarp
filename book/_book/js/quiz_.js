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
for (let i = 0; i < N_tasks*N_options; i++) {
  ALTERNATIVES_OPTIONS[i].addEventListener("click", click_option);
}

const SUBMIT_BUTTON = document.getElementById("submit-button");
SUBMIT_BUTTON.addEventListener("click", click_submit);

const REMOVE_ANSWER_BUTTONS = document.getElementsByClassName("remove-answer-button");
for (let i = 0; i < N_tasks; i++) {
  REMOVE_ANSWER_BUTTONS[i].addEventListener("click", remove_answer);
}

// Set initial status
let STATUS = "initial";

// Set messages text
const MESSAGES = {
  non_filled: "Нет ни одного ответа :'(",
  partially_filled: "Некоторые вопросы остались без ответа ((",
  filled: ""
};

// Set a set for answers
let ANSWERS = {};
for (let i = 1; i <= N_tasks; i++) {
  ANSWERS["q"+i] = {};
  ANSWERS["q"+i]["type"] = INFO["type"]["q"+i];
  for (let j = 1; j <= N_options; j++) {
    ANSWERS["q"+i]["opt"+j] = {};
    ANSWERS["q"+i]["opt"+j]["correct"] = (INFO["option"+j+"_correct"]["q"+i] === "true");
  }
}
console.log(ANSWERS);

function click_submit() {
  console.log("Submit clicked");
  if (STATUS != "filled") {
    get_answers();
    set_status(check_filled());
    show_status();
    show_non_filled();
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
  show_remove_answer_button(this.name);
  remove_non_filled(this.name);
  if (STATUS != "initial") {
    get_answers();
    set_status(check_filled());
    show_status();
    show_non_filled();
  }
}

function show_remove_answer_button(id) {
  console.log("Show remove answer button");
  document.getElementById(id+"-remove-answer").classList.add("shown");
}

function add_non_filled(id) {
  document.getElementById(id).classList.add("non-filled");
  document.getElementById("toc-"+id+"-title").classList.add("toc-non-filled");
}

function remove_non_filled(id) {
  document.getElementById(id).classList.remove("non-filled");
  document.getElementById("toc-"+id+"-title").classList.remove("toc-non-filled");
}

function remove_answer() {
  console.log("Remove answer clicked");
  console.log(this.name);
  set_options_unchecked(this.name);
  hide_remove_answer_button(this.name);
  add_non_filled(this.name);
  if (STATUS != "initial") {
    get_answers();
    set_status(check_filled());
    show_status();
    show_non_filled();
  }
}

function set_options_unchecked(id) {
  console.log("Set options unchecked");
  for (let i = 1; i <= N_options; i++) {
    document.getElementById(id+"-option"+i).checked = false;
  }
}

function hide_remove_answer_button(id) {
  console.log("Hide remove answer button");
  document.getElementById(id+"-remove-answer").classList.remove("shown");
}

function get_answers() {
  console.log("Get checked");
  const answers = document.getElementsByClassName("input-alternative");
  for (let i = 1; i <= N_tasks; i++) {
    for (let j = 1; j <= N_options; j++){
      ANSWERS["q"+i]["opt"+j]["checked"] = answers["q"+i+"-option"+j]["checked"];
    }
  }
}

function check_filled() {
  console.log("Check filled");
  let n_non_filled = N_tasks;
  for (let i = 1; i <= N_tasks; i++) {
    ANSWERS["q"+i]["filled"] = false;
    for (let j = 1; j <= N_options; j++) {
      ANSWERS["q"+i]["filled"] = ANSWERS["q"+i]["filled"] || ANSWERS["q"+i]["opt"+j]["checked"];
    }
    if (ANSWERS["q"+i]["filled"]) {
      n_non_filled -= 1;
    }
    console.log(n_non_filled);
  }
  return n_non_filled;
}
  
function set_status(n_non_filled) {
  console.log("Set status");
  if (n_non_filled == N_tasks) {
    STATUS = "non_filled";
  } else if (n_non_filled > 0) {
    STATUS = "partially_filled";
  } else {
    STATUS = "filled";
  }
}

function show_status() {
  console.log("Show status");
  if (STATUS != "filled") {
    document.getElementById("filled-message").innerHTML = MESSAGES[STATUS];
    document.getElementById("filled-message").classList.add("shown");
    console.log(STATUS);
  } else {
    document.getElementById("filled-message").classList.remove("shown");
    console.log(STATUS);
  }
}

function show_non_filled() {
  console.log("Show status");
  for (let i = 1; i <= N_tasks; i++) {
    if (ANSWERS["q"+i]["filled"]) {
      remove_non_filled("q"+i);
    } else {
      add_non_filled("q"+i);
    }
  }
}


function check_quiz() {
  console.log("Check quiz");
  ANSWERS["n_correct"] = 0;
  for (let i = 1; i <= N_tasks; i++) {
    if (ANSWERS["q"+i]["type"] == "radio") {
      for (let j = 1; j <= N_options; j++) {
        if (ANSWERS["q"+i]["opt"+j]["correct"] && ANSWERS["q"+i]["opt"+j]["checked"]) {
          ANSWERS["q"+i]["correct"] = true;
          ANSWERS["n_correct"]++;
        }
        if (!ANSWERS["q"+i]["correct"]) {
          ANSWERS["q"+i]["correct"] = false;
        }
      }
    } else {
      let counter = 0;
      for (let j = 1; j <= N_options; j++) {
        if (ANSWERS["q"+i]["opt"+j]["correct"] && ANSWERS["q"+i]["opt"+j]["checked"]) {
          counter += 1;
        } else if (!ANSWERS["q"+i]["opt"+j]["correct"] && !ANSWERS["q"+i]["opt"+j]["checked"]) {
          counter += 1;
        }
        if (counter == 4) {
          ANSWERS["q"+i]["correct"] = true;
          ANSWERS["n_correct"]++;
        } else {
          ANSWERS["q"+i]["correct"] = false;
        }
      }
    }
  }
  console.log(ANSWERS);
}

function show_results() {
  console.log("Show results");
  document.getElementById("results").innerHTML = "Результат: " + ANSWERS["n_correct"] + " / " + N_tasks;
  document.getElementById("results").classList.add("shown");
}

function show_answers() {
  console.log("Show answers");
  document.getElementById("submit-button").disabled = true;
  for (let i = 1; i <= N_tasks; i++) {
    hide_remove_answer_button("q"+i);
    set_task_style("q"+i, ANSWERS["q"+i]["correct"]);
    show_feedback("q"+i, ANSWERS["q"+i]["correct"]);
    for (let j = 1; j <= N_options; j++) {
      set_option_style("q"+i+"-option"+j, ANSWERS["q"+i]["opt"+j]["correct"]);
    }
  }
}

function set_task_style(id, correct) {
  console.log("Set task style");
  if (correct) {
    document.getElementById(id).classList.add("correct")
    document.getElementById("toc-"+id+"-title").classList.add("toc-correct");
    document.getElementById(id+"-check-tick").classList.add("shown");
  } else {
    document.getElementById(id).classList.add("incorrect")
    document.getElementById("toc-"+id+"-title").classList.add("toc-incorrect");
    document.getElementById(id+"-check-cross").classList.add("shown");
  }
}

function set_option_style(id, correct) {
  console.log("Set option style");
  document.getElementById(id).disabled = true;
  if (correct) {
    document.getElementById(id+"-label").classList.add("correct");
    document.getElementById(id+"-alternative").classList.add("correct");
  } else {
    document.getElementById(id+"-label").classList.add("incorrect");
    document.getElementById(id+"-alternative").classList.add("incorrect");
  }
}

function show_feedback(id, correct) {
  console.log("Show feedback");
  if (correct) {
    document.getElementById(id+"-feedback-correct").classList.add("shown");
  } else {
    document.getElementById(id+"-feedback-incorrect").classList.add("shown");
  }
}
