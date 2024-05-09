const submit = document.getElementById("submit-button");
submit.addEventListener("click", check_quiz);

function check_quiz() {
  console.log("Clicked!")
  const answers = document.getElementsByName("quiz1-q3");
  console.log(answers);
}
