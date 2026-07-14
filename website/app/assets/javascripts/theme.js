// Theme toggle: flips data-theme on <html> and persists the choice.
// The initial theme is resolved by the inline script in the layout head
// before first paint, so there is no flash of the wrong theme.
(function () {
  var button = document.querySelector(".theme-toggle");
  if (!button) return;

  button.addEventListener("click", function () {
    var root = document.documentElement;
    var current = root.getAttribute("data-theme");
    if (current !== "light" && current !== "dark") {
      current = window.matchMedia("(prefers-color-scheme: light)").matches
        ? "light"
        : "dark";
    }
    var next = current === "light" ? "dark" : "light";
    root.setAttribute("data-theme", next);
    try {
      localStorage.setItem("theme", next);
    } catch (e) {}
  });
})();
