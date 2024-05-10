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

const levels = document.getElementsByClassName("level");

console.log(levels)
console.log(levels)
console.log(levels.length)

for (let i = 1; i <= 20; i++) {
  document.getElementById("lvl-q"+i).className += (" lvl-" + info["level"]["q"+i]);
  document.getElementById("title-q"+i).innerHTML = info["text"]["q"+i];
  document.getElementById("q"+i+"-option1").innerHTML = info["option1_label"]["q"+i];
  document.getElementById("q"+i+"-option2").innerHTML = info["option2_label"]["q"+i];
  document.getElementById("q"+i+"-option3").innerHTML = info["option3_label"]["q"+i];
  document.getElementById("q"+i+"-option4").innerHTML = info["option4_label"]["q"+i];
}

console.log(levels)

const submit = document.getElementById("submit-button");
submit.addEventListener("click", check_quiz);

function check_quiz() {
  console.log("Clicked!")
  const answers = document.getElementsByName("quiz1-q3");
  console.log(answers);
}
