// Parse JSON

var info_json = JSON.parse(quiz_json);

console.log(info_json);

let info = {};

for (let i = 0; i < info_json.length; i++) {
  info[info_json[i].name] = {};
  for (let t = 1; t <= 20; t++) {
    id = "q" + t;
    info[info_json[i].name][id] = info_json[i][id];
  }
}

// console.log(info)

// Add content

for (let i = 1; i <= 20; i++) {
  if (info["level"]["q"+i] == "") {
    document.getElementById("lvl-q"+i).hidden += true;
  } else {
    document.getElementById("lvl-q"+i).className += (" lvl-" + info["level"]["q"+i]);
  }
  document.getElementById("title-q"+i).innerHTML = info["text"]["q"+i];
  if (info["type"]["q"+i] == "checkbox") {
    document.getElementById("q"+i+"-option1").type = "checkbox";
    document.getElementById("q"+i+"-option2").type = "checkbox";
    document.getElementById("q"+i+"-option3").type = "checkbox";
    document.getElementById("q"+i+"-option4").type = "checkbox";
  }
  document.getElementById("q"+i+"-opt1-label").innerHTML = info["option1_label"]["q"+i];
  document.getElementById("q"+i+"-opt2-label").innerHTML = info["option2_label"]["q"+i];
  document.getElementById("q"+i+"-opt3-label").innerHTML = info["option3_label"]["q"+i];
  document.getElementById("q"+i+"-opt4-label").innerHTML = info["option4_label"]["q"+i];
  if (info["img"]["q"+i] == "") {
    document.getElementById("q"+i+"-image").hidden = true;
  } else {
    document.getElementById("q"+i+"-image").src = info["img"]["q"+i];
  }
}


const submit = document.getElementById("submit-button");
submit.addEventListener("click", check_quiz);

// const answers = document.getElementsByClassName("in-alternative");

// console.log(answers)

function get_answers(ans, answers) {
  for (let i = 1; i <= 20; i++) {
    ans["q"+i] = {};
    ans["q"+i]["type"] = info["type"]["q"+i];
    ans["q"+i]["opt1"] = {};
    ans["q"+i]["opt1"]["correct"] = info["option1_correct"]["q"+i];
    ans["q"+i]["opt1"]["checked"] = answers["q"+i+"-option1"]["checked"];
    ans["q"+i]["opt2"] = {};
    ans["q"+i]["opt2"]["correct"] = info["option2_correct"]["q"+i];
    ans["q"+i]["opt2"]["checked"] = answers["q"+i+"-option2"]["checked"];
    ans["q"+i]["opt3"] = {};
    ans["q"+i]["opt3"]["correct"] = info["option3_correct"]["q"+i];
    ans["q"+i]["opt3"]["checked"] = answers["q"+i+"-option3"]["checked"];
    ans["q"+i]["opt4"] = {};
    ans["q"+i]["opt4"]["correct"] = info["option4_correct"]["q"+i];
    ans["q"+i]["opt4"]["checked"] = answers["q"+i+"-option4"]["checked"];
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
  if (counter > 0) {
    ans["filled"] = false;
  } else {
    ans["filled"] = true;
  }
  return ans
}

function set_colors_filled(ans) {
  return 0
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

function set_colors_checked(ans) {
  return 0
}

function show_feedback() {
  for (let i = 1; i <= 20; i++) {
    document.getElementById("feedback-q"+i).hidden = false;
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
    document.getElementById("filled-message").hidden = false;
    set_colors_filled(ans);
    return 0;
  }
  ans = check_answers(ans);
  console.log("check_answers");
  console.log(ans);
  set_colors_checked(ans);
  show_feedback();
  document.getElementById("submit-button").disabled = true;
}
