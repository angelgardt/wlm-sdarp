// Parse JSON

var info_json = JSON.parse(quiz_json);
let info = {};

for (let i = 0; i < info_json.length; i++) {
  info[info_json[i].name] = {};
  for (let t = 1; t <= 20; t++) {
    id = "q" + t;
    info[info_json[i].name][id] = info_json[i][id];
  }
}


// Add content

for (let i = 1; i <= 20; i++) {
  if (info["level"]["q"+i] == "") {
    document.getElementById("lvl-q"+i).hidden = true;
  } else {
    document.getElementById("lvl-q"+i).className += (" lvl-" + info["level"]["q"+i]);
  }
  // document.getElementById("title-q"+i).innerHTML = info["text"]["q"+i];
  if (info["type"]["q"+i] == "checkbox") {
    document.getElementById("q"+i+"-option1").type = "checkbox";
    document.getElementById("q"+i+"-option2").type = "checkbox";
    document.getElementById("q"+i+"-option3").type = "checkbox";
    document.getElementById("q"+i+"-option4").type = "checkbox";
  }
  // document.getElementById("q"+i+"-opt1-label").innerHTML = info["option1_label"]["q"+i];
  // document.getElementById("q"+i+"-opt2-label").innerHTML = info["option2_label"]["q"+i];
  // document.getElementById("q"+i+"-opt3-label").innerHTML = info["option3_label"]["q"+i];
  // document.getElementById("q"+i+"-opt4-label").innerHTML = info["option4_label"]["q"+i];
  // if (info["img"]["q"+i] == "") {
  //   document.getElementById("q"+i+"-image").hidden = true;
  // } else {
  //   document.getElementById("q"+i+"-image").src = info["img"]["q"+i];
  // }
}


const submit = document.getElementById("submit-button");
submit.addEventListener("click", check_quiz);

/*
const alternatives = document.getElementsByClassName("in-alternatives");
for (i = 0; i < alternatives.length; i++) {
  alternatives[i].addEventListener("click", set_colors_filled(ans));
}

function test() {
  console.log("Click!");
}

*/


function get_answers(ans, answers) {
  for (let i = 1; i <= 20; i++) {
    ans["q"+i] = {};
    ans["q"+i]["type"] = info["type"]["q"+i];
    for (let j = 1; j <= 4; j++){
      ans["q"+i]["opt"+j] = {};
      ans["q"+i]["opt"+j]["correct"] = info["option"+j+"_correct"]["q"+i];
      ans["q"+i]["opt"+j]["checked"] = answers["q"+i+"-option"+j]["checked"];
    }
  }
  return ans
}

function check_fill(ans) {
  let counter = 20;
  for (let i = 1; i <= 20; i++) {
    ans["q"+i]["filled"] = false;
    for (let j = 1; j <= 4; j++) {
      if (ans["q"+i]["opt"+j]["checked"]) {
        ans["q"+i]["filled"] = true;
        counter -= 1;
      }
    }
  }
  if (counter == 20) {
    ans["filled"] = false;
    document.getElementById("filled-message").innerHTML = "Нет ни одного ответа :’(";
  } else if (counter > 0) {
    ans["filled"] = false;
    document.getElementById("filled-message").innerHTML = "Некоторые вопросы остались без ответа ((";
  } else {
    ans["filled"] = true;
  }
  return ans
}

function set_colors_filled(ans) {
  for (i = 1; i <= 20; i++) {
    if (!ans["q"+i]["filled"]) {
      document.getElementById("q"+i).classList.add("non-filled");
    } else {
      document.getElementById("q"+i).classList.remove("non-filled");
    }
  }
}


function check_answers(ans) {
  for (let i = 1; i <= 20; i++) {
    if (ans["q"+i]["type"] == "radio") {
      for (let j = 1; j <= 4; j++) {
        if (ans["q"+i]["opt"+j]["correct"] == "true" && ans["q"+i]["opt"+j]["checked"]) {
          ans["q"+i]["correct"] = true;
        }
        if (!ans["q"+i]["correct"]) {
          ans["q"+i]["correct"] = false;
        }
      }
    } else {
      let counter = 0;
      for (let j = 1; j <= 4; j++) {
        if (ans["q"+i]["opt"+j]["correct"] == "true" && ans["q"+i]["opt"+j]["checked"]) {
          counter += 1;
        } else if (ans["q"+i]["opt"+j]["correct"] == "false" && !ans["q"+i]["opt"+j]["checked"]) {
          counter += 1;
        }
        if (counter == 4) {
          ans["q"+i]["correct"] = true;
        } else {
          ans["q"+i]["correct"] = false;
        }
      }
    }
  }
  return ans
}

function show_results(ans) {
  let score = 0;
  for (i = 1; i <= 20; i++) {
    // document.getElementById("feedback-q"+i).hidden = false;
    if (ans["q"+i]["correct"]) {
      score += 1;
      document.getElementById("q"+i).classList.add("correct");
      document.getElementById("check-tick-q"+i).hidden = false;
      document.getElementById("feedback-q"+i+"-correct").hidden = false;
      // document.getElementById("feedback-q"+i).innerHTML = info["feedback_correct"]["q"+i]
    } else {
      document.getElementById("q"+i).classList.add("incorrect");
      document.getElementById("check-cross-q"+i).hidden = false;
      document.getElementById("feedback-q"+i+"-incorrect").hidden = false;
      // document.getElementById("feedback-q"+i).innerHTML = info["feedback_incorrect"]["q"+i]
    }
  }
  document.getElementById("results").hidden = false;
  document.getElementById("results").innerHTML = "Результат: " + score + " / 20";
}


function show_answers(ans) {
  for (i = 1; i <= 20; i++) {
    for (j = 1; j <= 4; j++) {
      document.getElementById("q"+i+"-option"+j).disabled = true;
      if (ans["q"+i]["opt"+j]["correct"] == "true") {
        document.getElementById("q"+i+"-opt"+j+"-label").classList.add("correct");
      } else {
        document.getElementById("q"+i+"-opt"+j+"-label").classList.add("incorrect");
      }
    }
  }
}

function check_quiz() {
  const answers = document.getElementsByClassName("in-alternative");
  let ans = {};
  // console.log("answers");
  // console.log(answers);
  ans = check_fill(get_answers(ans, answers));
  // console.log("check_fill");
  // console.log(ans);
  if (!ans["filled"]) {
    // console.log(ans);
    document.getElementById("filled-message").hidden = false;
    set_colors_filled(ans);
    return 0;
  } else {
    document.getElementById("filled-message").hidden = true;
    set_colors_filled(ans);
  }
  ans = check_answers(ans);
  // console.log("check_answers");
  // console.log(ans);
  show_results(ans);
  show_answers(ans);
  document.getElementById("submit-button").disabled = true;
  return 0;
}
