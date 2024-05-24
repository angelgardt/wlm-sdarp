// Parse JSON
INFO_JSON = JSON.parse(sheet_json);
let INFO = {};
let N_tasks = 30;

for (let i = 0; i < INFO_JSON.length; i++) {
  INFO[INFO_JSON[i].name] = {};
  for (let t = 1; t <= N_tasks; t++) {
    id = "t" + t;
    INFO[INFO_JSON[i].name][id] = INFO_JSON[i][id];
  }
}

delete INFO_JSON;

// Set debug state
let DEBUG = false;


// Add labels and hide autocheck where absent
for (let i = 1; i <= N_tasks; i++) {
  document.getElementById("t"+i+"-hints-summary").innerHTML = "Показать подсказки";
  if (INFO.level["t"+i] == "") {
    document.getElementById("t"+i+"-level").hidden = true;
  } else {
    document.getElementById("t"+i+"-level").classList.add("level-" + INFO.level["t"+i]);
  }
  if (INFO.has_autocheck["t"+i] == "false") {
    document.getElementById("t"+i+"-autocheck").hidden = true;
  }
}

// Change TOC title
document.getElementById("toc-title").innerHTML = "Задания";


// Add events & innet HTML to hints summaries
const HINTS = document.getElementsByClassName("hints");
for (let i = 0; i < N_tasks; i++) {
  HINTS[i].addEventListener("click", click_hints);
}

const AUTOCHECK_BUTTONS = document.getElementsByClassName("button-autocheck");
for (let i = 0; i < N_tasks; i++) {
  AUTOCHECK_BUTTONS[i].addEventListener("click", check);
}


// Set messages text
const MESSAGES = {
  empty: 
  [
    "В поле ответа пусто :(", 
    "Нужно что-то ввести в поле ответа...",
    "Нет никакого ответа. Нечего проверять (("
  ],
  incorrect: 
  [
    "Надо проверить вычисления или формат ввода...",
    "Кажется, в вычислениях ошибка. Или в формате ввода..."
  ],
  correct: 
  [
    "Верно!", 
    "Точно так!", 
    "Исключительно точно!", 
    "Категорически корректно!"
  ]
};

function click_hints() {
  if (DEBUG) { console.log("CLICK HINTS") }
  if (this.open) {
    document.getElementById(this.id+"-summary").innerHTML = "Показать подсказки";
    if (DEBUG) { console.log("CLOSE HINTS " + this.id) }
  } else {
    document.getElementById(this.id+"-summary").innerHTML = "Скрыть подсказки";
    if (DEBUG) { console.log("OPEN HINTS " + this.id) }
  }
}


function getRandomInt(max) {
  if (DEBUG) { console.log("GET RANDOM INT") }
  return Math.floor(Math.random() * max);
}

function check() {
  if (DEBUG) { console.log("CLICK CHECK " + this.name) }
  result = checker(get_answer(this.name), this.name);
  show_feedback(this.name, result);
  if (result == "correct") {
    disable_autocheck(this.name);
  }
}

function get_answer(id) {
  if (DEBUG) { console.log("GET ANSWER " + id) }
  return document.getElementById(id+"-input").value.replaceAll(" ", "");
}

function checker(answer, id) {
  if (DEBUG) { console.log("CHECKER") }
  correct_answer = INFO["autocheck_answer"][id];
  if (answer == "") {
    if (DEBUG) { console.log("CHECKER EMPTY") }
    return "empty";
  } else if (answer == correct_answer) {
    if (DEBUG) { console.log("CHECKER CORRECT") }
    return "correct";
  } else {
    if (DEBUG) { console.log("CHECKER INCORRECT") }
    return "incorrect";
  }
}

function show_feedback(id, result) {
  feedback = document.getElementById(id+"-feedback");
  feedback.classList.remove("empty", "correct", "incorrect");
  if (DEBUG) { console.log("REMOVE ALL RESULTS CLASS " + id) }
  feedback.classList.add("shown", result);
  if (DEBUG) { console.log("ADD SHOWN & RESULTS CLASS " + id) }
  opt_feedback = getRandomInt(MESSAGES[result].length);
  if (DEBUG) { console.log("GET RANDOM INT " + opt_feedback) }
  feedback.innerHTML = MESSAGES[result][opt_feedback];
  document.getElementById("toc-"+id+"-title").classList.remove("toc-correct", "toc-incorrect");
  if (DEBUG) { console.log("REMOVE ALL TOC RESULTS CLASS " + id) }
  if (result != "empty") {
    document.getElementById("toc-"+id+"-title").classList.add("toc-"+result);
    if (DEBUG) { console.log("ADD TOC RESULTS CLASS " + id) }
  }
}

function disable_autocheck(id) {
  document.getElementById(id+"-autocheck-button").disabled = true;
  document.getElementById(id+"-input").disabled = true;
  if (DEBUG) { console.log("DISABLE INPUT & CHECK BUTTON" + id) }
}
