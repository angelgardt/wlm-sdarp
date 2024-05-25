// Collapsible solution

var solution = document.getElementsByClassName("solution");
var i;
const solution_title = {
  show: "<i>Решение</i> <small>[Развернуть]</small>",
  hide: "<i>Решение</i> <small>[Cвернуть]</small>"
}
for (i = 0; i < solution.length; i++) {
  current_solution = solution[i].children[0];
  current_solution.innerHTML = solution_title.show
  current_solution.addEventListener("click", function() {
    var cell = this.nextElementSibling;
    if (cell.style.display === "block") {
      cell.style.display = "none";
      current_solution.innerHTML = solution_title.show
    } else {
      cell.style.display = "block";
      current_solution.innerHTML = solution_title.hide
    }
  });
}