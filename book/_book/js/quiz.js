// Parse JSON
INFO_JSON = JSON.parse(quiz_json);
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

delete INFO_JSON;

// Set debug state
let DEBUG = false;


// Add labels and checkboxes
for (let i = 1; i <= N_tasks; i++) {
  if (INFO.level["q"+i] == "") {
    document.getElementById("q"+i+"-level").hidden = true;
  } else {
    document.getElementById("q"+i+"-level").classList.add("level-" + INFO.level["q"+i]);
  }
  if (INFO.type["q"+i] == "checkbox") {
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
  non_filled: 
  [
    "Нет ни одного ответа :'(",
    "Нечего проверять, все вопросы пусты..."
  ],
  partially_filled: 
  [
    "Некоторые вопросы остались без ответа ((",
    "Надо ответить на все вопросы..."
  ],
  filled: [""]
};

// Extract answers from parsed JSON
let ANSWERS = {};
for (let i = 1; i <= N_tasks; i++) {
  ANSWERS["q"+i] = {};
  ANSWERS["q"+i].type = INFO.type["q"+i];
  for (let j = 1; j <= N_options; j++) {
    ANSWERS["q"+i]["opt"+j] = {};
    ANSWERS["q"+i]["opt"+j].correct = (INFO["option"+j+"_correct"]["q"+i] === "true");
  }
}


function click_submit() {
  if (DEBUG) { console.log("CLICK SUBMIT") }
  if (STATUS != "filled") {
    if (DEBUG) { console.log("get answers") }
    get_answers();
    if (DEBUG) { console.log("set status") }
    set_status(check_filled());
    if (DEBUG) { console.log("show status") }
    show_status();
    if (DEBUG) { console.log("show non filled") }
    show_non_filled();
  }
  if (STATUS == "filled") {
    if (DEBUG) { console.log("check quiz") }
    check_quiz();
    if (DEBUG) { console.log("show results") }
    show_results();
    if (DEBUG) { console.log("show answers") }
    show_answers();
  }
}

function click_option() {
  if (DEBUG) { console.log("CLICK OPTION") }
  if (DEBUG) { console.log("show remove answer button " + this.name) }
  show_remove_answer_button(this.name);
  if (DEBUG) { console.log("remove non filled " + this.name) }
  remove_non_filled(this.name);
  if (STATUS != "initial") {
    if (DEBUG) { console.log("get answers") }
    get_answers();
    if (DEBUG) { console.log("set status") }
    set_status(check_filled());
    if (DEBUG) { console.log("show status") }
    show_status();
    if (DEBUG) { console.log("show non filled") }
    show_non_filled();
  }
}

function show_remove_answer_button(id) {
  if (DEBUG) { console.log("SHOW REMOVE ANSWER BUTTON") }
  if (DEBUG) { console.log("add shown class to remove answer button " + id) }
  document.getElementById(id+"-remove-answer").classList.add("shown");
}

function add_non_filled(id) {
  if (DEBUG) { console.log("ADD NON FILLED") }
  if (DEBUG) { console.log("add non filled class " + id) }
  document.getElementById(id).classList.add("non-filled");
  if (DEBUG) { console.log("add toc non filled class " + id) }
  document.getElementById("toc-"+id+"-title").classList.add("toc-non-filled");
}

function remove_non_filled(id) {
  if (DEBUG) { console.log("REMOVE NON FILLED") }
  if (DEBUG) { console.log("remove non filled class " + id) }
  document.getElementById(id).classList.remove("non-filled");
  if (DEBUG) { console.log("remove toc non filled class " + id) }
  document.getElementById("toc-"+id+"-title").classList.remove("toc-non-filled");
}

function remove_answer() {
  if (DEBUG) { console.log("REMOVE ANSWER") }
  if (DEBUG) { console.log("set options unchecked " + this.name) }
  set_options_unchecked(this.name);
  if (DEBUG) { console.log("hide remove answer button " + this.name) }
  hide_remove_answer_button(this.name);
  if (DEBUG) { console.log("add non filled " + this.name) }
  add_non_filled(this.name);
  if (STATUS != "initial") {
    if (DEBUG) { console.log("STATUS: initial") }
    if (DEBUG) { console.log("get answers") }
    get_answers();
    if (DEBUG) { console.log("set status") }
    set_status(check_filled());
    if (DEBUG) { console.log("show status") }
    show_status();
    if (DEBUG) { console.log("show non filled") }
    show_non_filled();
  }
}

function set_options_unchecked(id) {
  if (DEBUG) { console.log("SET OPTION UNCHECKED") }
  for (let i = 1; i <= N_options; i++) {
    if (DEBUG) { console.log("set option checked false " + id + " " + i) }
    document.getElementById(id+"-option"+i).checked = false;
  }
}

function hide_remove_answer_button(id) {
  if (DEBUG) { console.log("HIDE REMOVE ANSWER BUTTON") }
  if (DEBUG) { console.log("remove shown class " + id) }
  document.getElementById(id+"-remove-answer").classList.remove("shown");
}

function get_answers() {
  if (DEBUG) { 
    console.log("GET ANSWERS"); 
    console.log("get answers");  
    console.log(ANSWERS);
  }
  const answers = document.getElementsByClassName("input-alternative");
  for (let i = 1; i <= N_tasks; i++) {
    for (let j = 1; j <= N_options; j++){
      ANSWERS["q"+i]["opt"+j].checked = answers["q"+i+"-option"+j].checked;
    }
  }
  if (DEBUG) { console.log("got answers"); console.log(ANSWERS) }
}

function check_filled() {
  if (DEBUG) { console.log("CHECK FILLED") }
  let n_non_filled = N_tasks;
  for (let i = 1; i <= N_tasks; i++) {
    ANSWERS["q"+i].filled = false;
    for (let j = 1; j <= N_options; j++) {
      ANSWERS["q"+i].filled = ANSWERS["q"+i].filled || 
                              ANSWERS["q"+i]["opt"+j].checked;
    }
    if (ANSWERS["q"+i].filled) {
      n_non_filled -= 1;
    }
  }
  if (DEBUG) { console.log("checked filled"); console.log(ANSWERS); console.log(n_non_filled) }
  return n_non_filled;
}
  
function set_status(n_non_filled) {
  if (DEBUG) { console.log("SET STATUS") }
  if (n_non_filled == N_tasks) {
    STATUS = "non_filled";
  } else if (n_non_filled > 0) {
    STATUS = "partially_filled";
  } else {
    STATUS = "filled";
  }
  if (DEBUG) { console.log("status: " + STATUS + " n_non_filled = " + n_non_filled) }
}

function getRandomInt(max) {
  if (DEBUG) { console.log("GET RANDOM INT") }
  return Math.floor(Math.random() * max);
}

function show_status() {
  if (DEBUG) { console.log("SHOW STATUS") }
  if (STATUS != "filled") {
    opt_message = getRandomInt(MESSAGES[STATUS].length)
    if (DEBUG) { console.log("random int " + opt_message) }
    if (DEBUG) { console.log("add message " + MESSAGES[STATUS][opt_message]) }
    document.getElementById("filled-message").innerHTML = MESSAGES[STATUS][opt_message];
    if (DEBUG) { console.log("add shown class to message") }
    document.getElementById("filled-message").classList.add("shown");
  } else {
    if (DEBUG) { console.log("remove shown class from message") }
    document.getElementById("filled-message").classList.remove("shown");
  }
}

function show_non_filled() {
  if (DEBUG) { console.log("SHOWN NON FILLED") }
  for (let i = 1; i <= N_tasks; i++) {
    if (ANSWERS["q"+i].filled) {
      remove_non_filled("q"+i);
      if (DEBUG) { console.log("remove non filled q" + i) }
    } else {
      add_non_filled("q"+i);
      if (DEBUG) { console.log("add non filled q" + i) }
    }
  }
}


function check_quiz() {
  if (DEBUG) { console.log("CHECK QUIZ") }
  ANSWERS.n_correct = 0;
  for (let i = 1; i <= N_tasks; i++) {
    if (ANSWERS["q"+i].type == "radio") {
      for (let j = 1; j <= N_options; j++) {
        if (ANSWERS["q"+i]["opt"+j].correct && ANSWERS["q"+i]["opt"+j].checked) {
          ANSWERS["q"+i].correct = true;
          ANSWERS.n_correct++;
        }
        if (!ANSWERS["q"+i].correct) {
          ANSWERS["q"+i].correct = false;
        }
      }
    } else {
      let counter = 0;
      for (let j = 1; j <= N_options; j++) {
        if (ANSWERS["q"+i]["opt"+j].correct && 
            ANSWERS["q"+i]["opt"+j].checked) {
          counter++;
        } else if (!ANSWERS["q"+i]["opt"+j].correct && 
                   !ANSWERS["q"+i]["opt"+j].checked) {
          counter++;
        }
        if (counter == 4) {
          ANSWERS["q"+i].correct = true;
          ANSWERS.n_correct++;
        } else {
          ANSWERS["q"+i].correct = false;
        }
      }
    }
  }
  if (DEBUG) { console.log(ANSWERS) }
}

function show_results() {
  if (DEBUG) { console.log("SHOW RERSULTS") }
  if (DEBUG) { console.log("show results add score") }
  document.getElementById("results").innerHTML = "Результат: " + ANSWERS.n_correct + " / " + N_tasks;
  if (DEBUG) { console.log("show results add shown class") }
  document.getElementById("results").classList.add("shown");
}

function show_answers() {
  if (DEBUG) { console.log("SHOW ANSWERS") }
  if (DEBUG) { console.log("set disable submit button") }
  document.getElementById("submit-button").disabled = true;
  for (let i = 1; i <= N_tasks; i++) {
    if (DEBUG) { console.log("hide remove answer button q" + i) }
    hide_remove_answer_button("q"+i);
    if (DEBUG) { console.log("set task style q" + i) }
    set_task_style("q"+i, ANSWERS["q"+i].correct);
    if (DEBUG) { console.log("show feedback q" + i) }
    show_feedback("q"+i, ANSWERS["q"+i].correct);
    for (let j = 1; j <= N_options; j++) {
      if (DEBUG) { console.log("set option style q" + i + " opt " + j) }
      set_option_style("q"+i+"-option"+j, ANSWERS["q"+i]["opt"+j].correct);
    }
  }
}

function set_task_style(id, correct) {
  if (DEBUG) { console.log("SET TASK STYLE") }
  if (correct) {
    if (DEBUG) { console.log("add correct class " + id) }
    document.getElementById(id).classList.add("correct")
    if (DEBUG) { console.log("add toc correct class " + id) }
    document.getElementById("toc-"+id+"-title").classList.add("toc-correct");
    if (DEBUG) { console.log("shown check tick " + id) }
    document.getElementById(id+"-check-tick").classList.add("shown");
  } else {
    if (DEBUG) { console.log("add incorrect class " + id) }
    document.getElementById(id).classList.add("incorrect")
    if (DEBUG) { console.log("add toc incorrect class " + id) }
    document.getElementById("toc-"+id+"-title").classList.add("toc-incorrect");
    if (DEBUG) { console.log("shown check cross  " + id) }
    document.getElementById(id+"-check-cross").classList.add("shown");
  }
}

function set_option_style(id, correct) {
  if (DEBUG) { console.log("SET OPTION STYLE") }
  if (DEBUG) { console.log("set disabled true " + id) }
  document.getElementById(id).disabled = true;
  if (correct) {
    if (DEBUG) { console.log("set correct class label " + id) }
    document.getElementById(id+"-label").classList.add("correct");
    if (DEBUG) { console.log("set correct class alternative " + id) }
    document.getElementById(id+"-alternative").classList.add("correct");
  } else {
    if (DEBUG) { console.log("set incorrect class label " + id) }
    document.getElementById(id+"-label").classList.add("incorrect");
    if (DEBUG) { console.log("set incorrect class alternative " + id) }
    document.getElementById(id+"-alternative").classList.add("incorrect");
  }
}

function show_feedback(id, correct) {
  if (DEBUG) { console.log("SHOW FEEDBACK") }
  if (correct) {
    if (DEBUG) { console.log("set shown feedback correct " + id) }
    document.getElementById(id+"-feedback-correct").classList.add("shown");
  } else {
    if (DEBUG) { console.log("set shown feedback incorrect " + id) }
    document.getElementById(id+"-feedback-incorrect").classList.add("shown");
  }
}
