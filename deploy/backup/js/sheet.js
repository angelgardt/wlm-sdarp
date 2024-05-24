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
  if (this.open) {
    document.getElementById(this.id+"-summary").innerHTML = "Показать подсказки";
  } else {
    document.getElementById(this.id+"-summary").innerHTML = "Скрыть подсказки";
  }
}


function getRandomInt(max) {
  return Math.floor(Math.random() * max);
}

function check() {
  result = checker(get_answer(this.name), this.name);
  show_feedback(this.name, result);
  if (result == "correct") {
    disable_autocheck(this.name);
  }
}

function get_answer(id) {
  return document.getElementById(id+"-input").value.replaceAll(" ", "");
}

function checker(answer, id) {
  correct_answer = INFO["autocheck_answer"][id];
  if (answer == "") {
    return "empty"
  } else if (answer == correct_answer) {
    return "correct"
  } else {
    return "incorrect"
  }
}

function show_feedback(id, result) {
  feedback = document.getElementById(id+"-feedback");
  feedback.classList.remove("empty", "correct", "incorrect");
  feedback.classList.add("shown", result);
  opt_feedback = getRandomInt(MESSAGES[result].length);
  feedback.innerHTML = MESSAGES[result][opt_feedback];
  document.getElementById("toc-"+id+"-title").classList.remove("toc-correct", "toc-incorrect");
  if (result != "empty") {
    document.getElementById("toc-"+id+"-title").classList.add("toc-"+result);
  }
}

function disable_autocheck(id) {
  document.getElementById(id+"-autocheck-button").disabled = true;
  document.getElementById(id+"-input").disabled = true;
}
