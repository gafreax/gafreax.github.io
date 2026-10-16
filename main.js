// Minimal theme toggle (Pure vanilla JS, zero dependencies)
(function () {
  const STORAGE_KEY = "gf_theme";
  const root = document.documentElement;
  const toggleBtn = document.getElementById("theme-toggle");

  function getPreferredTheme() {
    const params = new URLSearchParams(window.location.search);
    const paramTheme = params.get("theme");
    if (paramTheme === "dark" || paramTheme === "light") return paramTheme;

    const saved = localStorage.getItem(STORAGE_KEY);
    if (saved) return saved;
    return window.matchMedia("(prefers-color-scheme: dark)").matches ? "dark" : "light";
  }

  function applyTheme(theme) {
    root.setAttribute("data-theme", theme);
    localStorage.setItem(STORAGE_KEY, theme);
    if (toggleBtn) {
      toggleBtn.setAttribute("aria-label", `Switch to ${theme === "dark" ? "light" : "dark"} mode`);
      toggleBtn.innerHTML = theme === "dark" ? "<span>☀</span> LIGHT" : "<span>☽</span> DARK";
    }
  }

  // Initial apply
  applyTheme(getPreferredTheme());

  if (toggleBtn) {
    toggleBtn.addEventListener("click", () => {
      const current = root.getAttribute("data-theme") || getPreferredTheme();
      applyTheme(current === "dark" ? "light" : "dark");
    });
  }

  // React to OS scheme changes if user hasn't set an explicit override
  window.matchMedia("(prefers-color-scheme: dark)").addEventListener("change", (e) => {
    if (!localStorage.getItem(STORAGE_KEY)) {
      applyTheme(e.matches ? "dark" : "light");
    }
  });
})();
