import { createOptions } from "./createOptions.js";

const optionsWrapper = document.getElementById("options-wrapper");
const body = document.body;
const eye = document.getElementById("eyeSvg");

const applySeoulTheme = (payload = {}) => {
  const normalizeHex = (value, fallback = "#5bb894") => {
    if (!value) return fallback;
    let color = String(value).trim();
    if (!color) return fallback;
    if (!color.startsWith("#")) color = `#${color}`;
    if (/^#[0-9a-fA-F]{3}$/.test(color)) {
      const [, r, g, b] = color;
      return `#${r}${r}${g}${g}${b}${b}`;
    }
    return /^#[0-9a-fA-F]{6}$/.test(color) ? color : fallback;
  };

  const hexToRgb = (hex) => {
    const color = normalizeHex(hex).replace("#", "");
    return {
      r: parseInt(color.slice(0, 2), 16),
      g: parseInt(color.slice(2, 4), 16),
      b: parseInt(color.slice(4, 6), 16),
    };
  };

  const color = normalizeHex(payload.primary || payload.color || payload.CityColorHex || payload.Primary || payload.Main);
  const rgb = hexToRgb(color);
  const root = document.documentElement;

  root.style.setProperty("--seoul-primary", color);
  root.style.setProperty("--seoul-primary-rgb", `${rgb.r}, ${rgb.g}, ${rgb.b}`);
  root.style.setProperty("--color-default", "#ffffff");
  root.style.setProperty("--color-hover", "#ffffff");
};

window.addEventListener("message", (event) => {
  switch (event.data.event || event.data.action) {
    case "seoulTheme": {
      applySeoulTheme(event.data);
      return;
    }
    case "visible": {
      optionsWrapper.innerHTML = "";
      body.style.visibility = event.data.state ? "visible" : "hidden";
      return eye.classList.remove("eye-hover");
    }

    case "leftTarget": {
      optionsWrapper.innerHTML = "";
      return eye.classList.remove("eye-hover");
    }

    case "setTarget": {
      optionsWrapper.innerHTML = "";
      eye.classList.add("eye-hover");

      if (event.data.options) {
        for (const type in event.data.options) {
          event.data.options[type].forEach((data, id) => {
            createOptions(type, data, id + 1);
          });
        }
      }

      if (event.data.zones) {
        for (let i = 0; i < event.data.zones.length; i++) {
          event.data.zones[i].forEach((data, id) => {
            createOptions("zones", data, id + 1, i + 1);
          });
        }
      }
    }
  }
});
