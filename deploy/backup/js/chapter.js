// Collapsible solution

var solution = document.getElementsByClassName("solution");
var i;
const solution_title = {
  show: "<em>Решение</em> <small>[Развернуть]</small>",
  hide: "<em>Решение</em> <small>[Cвернуть]</small>"
};

for (i = 0; i < solution.length; i++) {
  current_solution = solution[i].children[0];
  current_solution.innerHTML = solution_title.show
  current_solution.addEventListener("click", function() {
    var cell = this.nextElementSibling;
    if (cell.style.display === "block") {
      cell.style.display = "none";
      this.innerHTML = solution_title.show;
    } else {
      cell.style.display = "block";
      this.innerHTML = solution_title.hide;
    }
  });
}
