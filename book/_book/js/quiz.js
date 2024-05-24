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
  if (STATUS != "filled") {
    get_answers();
    if (DEBUG) { console.log("GET ANSWERS") }
    set_status(check_filled());
    if (DEBUG) { console.log("SET STATUS") }
    show_status();
    if (DEBUG) { console.log("SHOW STATUS") }
    show_non_filled();
    if (DEBUG) { console.log("SHOW NON FILLED") }
  }
  if (STATUS == "filled") {
    check_quiz();
    if (DEBUG) { console.log("CHECK QUIZ") }
    show_results();
    if (DEBUG) { console.log("SHOW RESULTS") }
    show_answers();
    if (DEBUG) { console.log("SHOW ANSWERS") }
  }
}

function click_option() {
  show_remove_answer_button(this.name);
  if (DEBUG) { console.log("SHOW REMOVE ANSWER BUTTON " + this.name) }
  remove_non_filled(this.name);
  if (DEBUG) { console.log("REMOVE NON FILLED " + this.name) }
  if (STATUS != "initial") {
    get_answers();
    if (DEBUG) { console.log("GET ANSWERS") }
    set_status(check_filled());
    if (DEBUG) { console.log("SET STATUS") }
    show_status();
    if (DEBUG) { console.log("SHOW STATUS") }
    show_non_filled();
    if (DEBUG) { console.log("SHOW NON FILLED") }
  }
}

function show_remove_answer_button(id) {
  document.getElementById(id+"-remove-answer").classList.add("shown");
  if (DEBUG) { console.log("ADD SHOWN CLASS TO REMOVE ANSWERS BUTTON") }
}

function add_non_filled(id) {
  document.getElementById(id).classList.add("non-filled");
  if (DEBUG) { console.log("ADD NON FILLED CLASS " + id) }
  document.getElementById("toc-"+id+"-title").classList.add("toc-non-filled");
  if (DEBUG) { console.log("ADD TOC NON FILLED CLASS " + id) }
}

function remove_non_filled(id) {
  document.getElementById(id).classList.remove("non-filled");
  if (DEBUG) { console.log("REMOVE NON FILLED CLASS " + id) }
  document.getElementById("toc-"+id+"-title").classList.remove("toc-non-filled");
  if (DEBUG) { console.log("REMOVE TOC NON FILLED CLASS " + id) }
}

function remove_answer() {
  if (DEBUG) { console.log("REMOVE ANSWER " + this.name) }
  set_options_unchecked(this.name);
  if (DEBUG) { console.log("SET OPTIONS UNCHECKED " + this.name) }
  hide_remove_answer_button(this.name);
  if (DEBUG) { console.log("HIDE REMOVE ANSWER BUTTON " + this.name) }
  add_non_filled(this.name);
  if (DEBUG) { console.log("ADD NON FILLED " + this.name) }
  if (STATUS != "initial") {
    get_answers();
    if (DEBUG) { console.log("GET ANSWERS") }
    set_status(check_filled());
    if (DEBUG) { console.log("SET STATUS") }
    show_status();
    if (DEBUG) { console.log("SHOW STATUS") }
    show_non_filled();
    if (DEBUG) { console.log("SHOW NON FILLED") }
  }
}

function set_options_unchecked(id) {
  for (let i = 1; i <= N_options; i++) {
    document.getElementById(id+"-option"+i).checked = false;
    if (DEBUG) { console.log("SET OPTION UNCHECKED " + id + "-" + i) }
  }
}

function hide_remove_answer_button(id) {
  document.getElementById(id+"-remove-answer").classList.remove("shown");
  if (DEBUG) { console.log("REMOVE SHOWN CLASS " + id) }
}

function get_answers() {
  const answers = document.getElementsByClassName("input-alternative");
  for (let i = 1; i <= N_tasks; i++) {
    for (let j = 1; j <= N_options; j++){
      ANSWERS["q"+i]["opt"+j].checked = answers["q"+i+"-option"+j].checked;
    }
  }
  if (DEBUG) { console.log(ANSWERS) }
}

function check_filled() {
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
  if (DEBUG) { console.log(ANSWERS); console.log(n_non_filled) }
  return n_non_filled;
}
  
function set_status(n_non_filled) {
  if (n_non_filled == N_tasks) {
    STATUS = "non_filled";
  } else if (n_non_filled > 0) {
    STATUS = "partially_filled";
  } else {
    STATUS = "filled";
  }
  if (DEBUG) { console.log("SET STATUS: n_non_filled = " + n_non_filled) }
}

function getRandomInt(max) {
  if (DEBUG) { console.log("GET RANDOM INT") }
  return Math.floor(Math.random() * max);
}

function show_status() {
  if (STATUS != "filled") {
    opt_message = getRandomInt(MESSAGES[STATUS].length)
    if (DEBUG) { console.log("GET RANDOM INT " + opt_message) }
    document.getElementById("filled-message").innerHTML = MESSAGES[STATUS][opt_message];
    if (DEBUG) { console.log("ADD MESSAGE " + MESSAGES[STATUS][opt_message]) }
    document.getElementById("filled-message").classList.add("shown");
    if (DEBUG) { console.log("ADD SHOWN CLASS TO MESSAGE") }
  } else {
    document.getElementById("filled-message").classList.remove("shown");
    if (DEBUG) { console.log("REMOVE SHOWN CLASS FROM MESSAGE") }
  }
}

function show_non_filled() {
  for (let i = 1; i <= N_tasks; i++) {
    if (ANSWERS["q"+i].filled) {
      remove_non_filled("q"+i);
    } else {
      add_non_filled("q"+i);
    }
  }
  if (DEBUG) { console.log("SHOWN NON FILLED INNER") }
}


function check_quiz() {
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
  if (DEBUG) { console.log("CHECK QUIZ DONE") }
}

function show_results() {
  document.getElementById("results").innerHTML = "Результат: " + ANSWERS.n_correct + " / " + N_tasks;
  if (DEBUG) { console.log("SHOW RERSULTS ADD SCORE") }
  document.getElementById("results").classList.add("shown");
  if (DEBUG) { console.log("SHOW RERSULTS ADD SHOWN CLASS") }
}

function show_answers() {
  document.getElementById("submit-button").disabled = true;
  if (DEBUG) { console.log("SET DISABLE SUBMIT BUTTON") }
  for (let i = 1; i <= N_tasks; i++) {
    hide_remove_answer_button("q"+i);
    set_task_style("q"+i, ANSWERS["q"+i].correct);
    show_feedback("q"+i, ANSWERS["q"+i].correct);
    for (let j = 1; j <= N_options; j++) {
      set_option_style("q"+i+"-option"+j, ANSWERS["q"+i]["opt"+j].correct);
    }
  }
  if (DEBUG) { console.log("SHOW ANSWERS DONE") }
}

function set_task_style(id, correct) {
  if (correct) {
    document.getElementById(id).classList.add("correct")
    document.getElementById("toc-"+id+"-title").classList.add("toc-correct");
    document.getElementById(id+"-check-tick").classList.add("shown");
  } else {
    document.getElementById(id).classList.add("incorrect")
    document.getElementById("toc-"+id+"-title").classList.add("toc-incorrect");
    document.getElementById(id+"-check-cross").classList.add("shown");
  }
  if (DEBUG) { console.log("SET TASK STYLE DONE") }
}

function set_option_style(id, correct) {
  document.getElementById(id).disabled = true;
  if (correct) {
    document.getElementById(id+"-label").classList.add("correct");
    document.getElementById(id+"-alternative").classList.add("correct");
  } else {
    document.getElementById(id+"-label").classList.add("incorrect");
    document.getElementById(id+"-alternative").classList.add("incorrect");
  }
  if (DEBUG) { console.log("SET OPTION STYLE DONE") }
}

function show_feedback(id, correct) {
  if (correct) {
    document.getElementById(id+"-feedback-correct").classList.add("shown");
  } else {
    document.getElementById(id+"-feedback-incorrect").classList.add("shown");
  }
  if (DEBUG) { console.log("SHOW FEEDBACK DONE") }
}
