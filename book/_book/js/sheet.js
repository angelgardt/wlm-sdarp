// Parse JSON

// Parse JSON

var info_json = JSON.parse(sheet_json);
let info = {};

for (let i = 0; i < info_json.length; i++) {
  info[info_json[i].name] = {};
  for (let t = 1; t <= 30; t++) {
    id = "t" + t;
    info[info_json[i].name][id] = info_json[i][id];
  }
}

console.log(info)

// Add content

for (let i = 1; i <= 30; i++) {
  if (info["level"]["t"+i] == "") {
    document.getElementById("t"+i+"-level").hidden = true;
  } else {
    document.getElementById("t"+i+"-level").classList.add("level-" + info["level"]["t"+i]);
  }
  if (info["has_autocheck"]["t"+i] == "false") {
    document.getElementById("t"+i+"-autocheck").hidden = true;
  }
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



// Open hints

for (let i = 1; i <= 30; i++) {
  document.getElementById("t"+i+"-hints").open = true;
}

