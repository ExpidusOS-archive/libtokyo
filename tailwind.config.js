const loadTheme = (name) =>
  Object.entries(require(".").tailwindcss[name]).reduce((prev, [key, val]) => {
    if (key.search("--") !== -1) return prev;
    prev[key] = val;
    return prev;
  }, {});

module.exports = {
  plugins: [require("daisyui")],
  theme: {
    colors: loadTheme("tokyo-night"),
    extend: {
      colors: loadTheme("tokyo-night"),
    },
  },
  daisyui: {
    themes: [require(".").tailwindcss],
    darkTheme: "tokyo-night",
  },
};
