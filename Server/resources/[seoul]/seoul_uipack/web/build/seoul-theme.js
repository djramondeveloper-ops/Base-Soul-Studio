(() => {
  const normalizeHex = (value, fallback = "#F20089") => {
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

  const applyTheme = (payload = {}) => {
    const color = normalizeHex(
      payload.primary || payload.color || payload.CityColorHex || payload.Primary || payload.Main
    );
    const rgb = hexToRgb(color);
    const root = document.documentElement;

    root.style.setProperty("--primary", color);
    root.style.setProperty("--seoul-primary", color);
    root.style.setProperty("--seoul-primary-rgb", `${rgb.r}, ${rgb.g}, ${rgb.b}`);
    root.dataset.seoulTheme = payload.theme || payload.Theme || "default";
  };

  window.addEventListener("message", (event) => {
    const data = event.data || {};
    if (data.action === "seoulTheme" || data.event === "seoulTheme") {
      applyTheme(data);
    }
  });

  window.SeoulApplyTheme = applyTheme;
})();
