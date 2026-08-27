(() => {
  const DEFAULT_PRIMARY = '#7c3aed';

  function normalizeHex(value) {
    if (!value) return DEFAULT_PRIMARY;
    let hex = String(value).trim();
    if (!hex) return DEFAULT_PRIMARY;
    if (!hex.startsWith('#')) hex = `#${hex}`;
    if (/^#[0-9a-fA-F]{3}$/.test(hex)) {
      hex = `#${hex[1]}${hex[1]}${hex[2]}${hex[2]}${hex[3]}${hex[3]}`;
    }
    return /^#[0-9a-fA-F]{6}$/.test(hex) ? hex.toLowerCase() : DEFAULT_PRIMARY;
  }

  function hexToRgb(hex) {
    const normalized = normalizeHex(hex).slice(1);
    return {
      r: parseInt(normalized.slice(0, 2), 16),
      g: parseInt(normalized.slice(2, 4), 16),
      b: parseInt(normalized.slice(4, 6), 16),
    };
  }

  function shade(hex, percent) {
    const { r, g, b } = hexToRgb(hex);
    const amount = Math.round(2.55 * percent);
    const clamp = (value) => Math.max(0, Math.min(255, value));
    return `#${[clamp(r + amount), clamp(g + amount), clamp(b + amount)]
      .map((value) => value.toString(16).padStart(2, '0'))
      .join('')}`;
  }

  function applyTheme(payload = {}) {
    const primary = normalizeHex(payload.primary || payload.PrimaryColor || payload.color || payload.main);
    const rgb = hexToRgb(primary);
    const root = document.documentElement;

    root.style.setProperty('--seoul-primary', primary);
    root.style.setProperty('--seoul-primary-rgb', `${rgb.r}, ${rgb.g}, ${rgb.b}`);
    root.style.setProperty('--seoul-primary-soft', `rgba(${rgb.r}, ${rgb.g}, ${rgb.b}, 0.30)`);
    root.style.setProperty('--seoul-primary-mid', `rgba(${rgb.r}, ${rgb.g}, ${rgb.b}, 0.55)`);
    root.style.setProperty('--seoul-primary-strong', `rgba(${rgb.r}, ${rgb.g}, ${rgb.b}, 0.90)`);
    root.style.setProperty('--seoul-primary-light', shade(primary, 18));
    root.style.setProperty('--seoul-primary-dark', shade(primary, -28));

    root.style.setProperty('--primary-color', primary);
    root.style.setProperty('--mystic-primary', primary);
    root.style.setProperty('--mystic-primary-soft', `rgba(${rgb.r}, ${rgb.g}, ${rgb.b}, 0.30)`);
    root.style.setProperty('--mystic-primary-strong', `rgba(${rgb.r}, ${rgb.g}, ${rgb.b}, 1)`);

    document.body.dataset.seoulTheme = payload.themeName || 'seoul';
    window.SeoulTheme = { primary, rgb, themeName: payload.themeName || 'seoul' };
  }

  window.addEventListener('message', (event) => {
    const data = event.data || {};
    if (data.action === 'seoulTheme' || data.type === 'seoulTheme') {
      applyTheme(data);
    }
  });

  document.addEventListener('DOMContentLoaded', () => {
    applyTheme({ primary: DEFAULT_PRIMARY });
    if (typeof GetParentResourceName === 'function') {
      fetch(`https://${GetParentResourceName()}/SeoulThemeReady`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json; charset=UTF-8' },
        body: JSON.stringify({ ready: true }),
      }).catch(() => {});
    }
  });
})();
