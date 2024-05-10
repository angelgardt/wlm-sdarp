// Parse JSON

var info_json = JSON.parse(quiz_json);

console.log(info_json)

let info = {};

for (let i = 0; i < info_json.length; i++) {
  info[info_json[i].name] = {};
  for (let t = 1; t <= 20; t++) {
    id = "q" + t;
    info[info_json[i].name][id] = info_json[i][id];
  }
}

console.log(info)

// Add content

for (let i = 1; i <= 20; i++) {
  if (info["level"]["q"+i] == "") {
    document.getElementById("lvl-q"+i).hidden += true;
  } else {
    document.getElementById("lvl-q"+i).className += (" lvl-" + info["level"]["q"+i]);
  }
  document.getElementById("title-q"+i).innerHTML = info["text"]["q"+i];
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

function check_quiz() {
  console.log("Clicked!")
  const answers = document.getElementsByName("quiz1-q3");
  console.log(answers);
}
