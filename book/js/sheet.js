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
    if (DEBUG) { console.log("close hints " + this.id) }
  } else {
    document.getElementById(this.id+"-summary").innerHTML = "Скрыть подсказки";
    if (DEBUG) { console.log("open hints " + this.id) }
  }
}


function getRandomInt(max) {
  if (DEBUG) { console.log("GET RANDOM INT") }
  return Math.floor(Math.random() * max);
}

function check() {
  if (DEBUG) { console.log("CLICK CHECK " + this.name) }
  result = checker(get_answer(this.name), this.name);
  if (DEBUG) { console.log("result: " + result) }
  show_feedback(this.name, result);
  if (DEBUG) { console.log("show feedback: " + this.name) }
  if (result == "correct") {
    disable_autocheck(this.name);
    if (DEBUG) { console.log("disable autocheck: " + this.name) }
  }
}

function get_answer(id) {
  if (DEBUG) { console.log("GET ANSWER " + id) }
  return document.getElementById(id+"-input").value.replaceAll(" ", "");
}

function checker(answer, id) {
  if (DEBUG) { console.log("CHECKER") }
  correct_answer = INFO["autocheck_answer"][id];
  if (DEBUG) { console.log("correct answer: " + correct_answer) }
  if (answer == "") {
    if (DEBUG) { console.log("checker 'empty'") }
    return "empty";
  } else if (answer == correct_answer) {
    if (DEBUG) { console.log("checker 'correct'") }
    return "correct";
  } else {
    if (DEBUG) { console.log("checker 'incorrect'") }
    return "incorrect";
  }
}

function show_feedback(id, result) {
  if (DEBUG) { console.log("SHOW FEEBDACK " + id) }
  feedback = document.getElementById(id+"-feedback");
  feedback.classList.remove("empty", "correct", "incorrect");
  if (DEBUG) { console.log("remove all result class " + id) }
  feedback.classList.add("shown", result);
  if (DEBUG) { console.log("add shown & result classes " + id + " " + result) }
  opt_feedback = getRandomInt(MESSAGES[result].length);
  if (DEBUG) { console.log("get random int " + opt_feedback) }
  feedback.innerHTML = MESSAGES[result][opt_feedback];
  if (DEBUG) { console.log("add inner html " + MESSAGES[result][opt_feedback]) }
  document.getElementById("toc-"+id+"-title").classList.remove("toc-correct", "toc-incorrect");
  if (DEBUG) { console.log("remove all toc result classes " + id) }
  if (result != "empty") {
    document.getElementById("toc-"+id+"-title").classList.add("toc-"+result);
    if (DEBUG) { console.log("add toc result class " + id + " " + result) }
  }
}

function disable_autocheck(id) {
  if (DEBUG) { console.log("DISABLE INPUT & CHECK BUTTON" + id) }
  document.getElementById(id+"-autocheck-button").disabled = true;
  if (DEBUG) { console.log("disable button" + id) }
  document.getElementById(id+"-input").disabled = true;
  if (DEBUG) { console.log("disable input" + id) }
}
