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


// Add labels
for (let i = 1; i <= N_tasks; i++) {
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


// Open hints


for (let i = 1; i <= N_tasks; i++) {
  document.getElementById("t"+i+"-hints").open = true;
}


// Check answers
function checker(id, ans)
  {
    let input_task = document.getElementById(id+"-input").value;
    // console.log(input_task)
    let feedback_task = document.getElementById(id+"-feedback");
    if (input_task.trim() == "")
    {
      feedback_task.style.display = "block";
      feedback_task.classList.remove("incorrect", "correct");
      feedback_task.classList.add("empty");
      feedback_task.innerHTML = "В поле ответа пусто :(";
      // feedback_task.style.color = "#4142CE";
    } else if (input_task.replaceAll(" ", "") == ans)
    {
      feedback_task.style.display = "block";
      feedback_task.classList.remove("incorrect", "empty");
      feedback_task.classList.add("correct");
      feedback_task.innerHTML = "Верно!";
      // feedback_task.style.color = "#35D250";
    } else {
      feedback_task.style.display = "block";
      feedback_task.classList.remove("correct", "empty");
      feedback_task.classList.add("incorrect");
      feedback_task.innerHTML = "Надо проверить вычисления…";
      // feedback_task.style.color = "#D33E36";
    }
  }

function check(id) {
  checker(id = id, ans = info["autocheck_answer"][id]);
}
