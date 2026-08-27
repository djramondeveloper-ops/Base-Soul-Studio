(function () {
    const STORAGE_KEY = "hud-weather-visible";
    const TOGGLE_ID = "hud-weather-bottom-toggle";
    const OLD_TOGGLE_ID = "hud-weather-toggle-row";
    const ROAD_WEATHER_SEPARATOR = " • ";
    const WARNING_ID = "hud-north-robbery-warning";
    const WARNING_TEXT_NIGHT = "! ESSA REGI\u00C3O \u00C9 PERIGOSA NESSE HOR\u00C1RIO";
    const WARNING_TEXT_ALWAYS = "! ESSA REGI\u00C3O \u00C9 PERIGOSA";
    const RESOURCE_NAME = (typeof GetParentResourceName === "function" && GetParentResourceName()) || "hud";

    const state = {
        road: "",
        weather: "",
        crossing: "",
        lastRoadPushed: "",
        hour: 12,
        minute: 0,
        dangerWarningVisible: false,
        dangerConditionActive: false,
        dangerFeatureEnabled: true,
        dangerAlways: false,
        dangerStartHour: 22,
        dangerEndHour: 6,
        logoOnly: false
    };

    const LOGO_ONLY_ID = "hud-logo-only";

    const ensureLogoOnlyElement = () => {
        let logo = document.getElementById(LOGO_ONLY_ID);
        if (logo) return logo;

        logo = document.createElement("img");
        logo.id = LOGO_ONLY_ID;
        logo.src = "./images/logo.png";
        logo.alt = "Logo";
        logo.style.position = "fixed";
        logo.style.top = "-25px";
        logo.style.left = "50%";
        logo.style.transform = "translateX(-50%)";
        logo.style.width = "46px";
        logo.style.height = "46px";
        logo.style.objectFit = "contain";
        logo.style.zIndex = "10000";
        logo.style.pointerEvents = "none";
        logo.style.display = "none";
        document.body.appendChild(logo);

        return logo;
    };

    const setLogoOnlyMode = (enabled) => {
        state.logoOnly = !!enabled;

        const app = document.getElementById("app");
        const logo = ensureLogoOnlyElement();
        const warning = document.getElementById(WARNING_ID);

        if (app) app.style.display = state.logoOnly ? "none" : "";
        if (logo) logo.style.display = state.logoOnly ? "block" : "none";
        if (warning && state.logoOnly) warning.style.display = "none";
    };

    const normalizeText = (value) => {
        if (!value) return "";
        return String(value)
            .normalize("NFD")
            .replace(/[\u0300-\u036f]/g, "")
            .toLowerCase()
            .trim();
    };

    const isWeatherVisible = () => {
        const value = localStorage.getItem(STORAGE_KEY);
        if (value === null) {
            localStorage.setItem(STORAGE_KEY, "1");
            return true;
        }

        return value === "1";
    };

    const setWeatherVisible = (visible) => {
        localStorage.setItem(STORAGE_KEY, visible ? "1" : "0");
    };

    const formatRoad = () => {
        if (!state.road) return "";
        if (!isWeatherVisible() || !state.weather) return state.road;
        return state.road + ROAD_WEATHER_SEPARATOR + state.weather;
    };

    const pushRoadToHud = () => {
        const payload = formatRoad();
        if (!payload || payload === state.lastRoadPushed) return;

        state.lastRoadPushed = payload;
        window.postMessage({
            Action: "Road",
            Payload: payload,
            _overlayInternal: true
        }, "*");
    };

    const parseHour = (value, fallback) => {
        const num = Number(value);
        if (!Number.isFinite(num)) return fallback;
        const normalized = Math.floor(num);
        if (normalized < 0 || normalized > 23) return fallback;
        return normalized;
    };

    const isRiskHour = () => {
        if (state.dangerAlways) return true;

        const start = parseHour(state.dangerStartHour, 22);
        const end = parseHour(state.dangerEndHour, 6);
        const hour = parseHour(state.hour, 0);

        if (start === end) return false;
        if (start < end) return hour >= start && hour < end;
        return hour >= start || hour < end;
    };

    const isNorthRegion = () => normalizeText(state.road) === "norte";

    const detectRegionFromHud = () => {
        const nodes = document.querySelectorAll("span,strong,p,div");

        for (let i = 0; i < nodes.length; i++) {
            const el = nodes[i];
            if (!el || el.children.length > 0) continue;

            const text = normalizeText(el.textContent);
            if (text !== "norte" && text !== "sul") continue;

            const rect = el.getBoundingClientRect();
            const insideHudArea =
                rect.left >= 0 &&
                rect.left < window.innerWidth * 0.50 &&
                rect.bottom > window.innerHeight * 0.12 &&
                rect.top < window.innerHeight * 0.98;

            if (insideHudArea) {
                return text === "norte" ? "Norte" : "Sul";
            }
        }

        return "";
    };

    const shouldShowNorthWarning = () => state.dangerFeatureEnabled && isRiskHour() && isNorthRegion();

    const applyDangerConfig = (payload) => {
        if (!payload || typeof payload !== "object") return;

        state.dangerFeatureEnabled = !!payload.Enabled;
        state.dangerAlways = !!payload.Always;
        state.dangerStartHour = parseHour(payload.StartHour, 22);
        state.dangerEndHour = parseHour(payload.EndHour, 6);

        if (!state.dangerFeatureEnabled) {
            state.dangerConditionActive = false;
            state.dangerWarningVisible = false;
            const warning = document.getElementById(WARNING_ID);
            if (warning) warning.style.display = "none";
        }
    };

    const requestDangerConfig = () => {
        fetch(`https://${RESOURCE_NAME}/GetDangerAreasConfig`, {
            method: "POST",
            headers: { "Content-Type": "application/json; charset=UTF-8" },
            body: JSON.stringify({})
        })
            .then((response) => response.json())
            .then((payload) => {
                applyDangerConfig(payload);
                updateNorthWarning();
            })
            .catch(function () {});
    };

    const playDangerNotifySound = (mode) => {
        fetch(`https://${RESOURCE_NAME}/PlayDangerSound`, {
            method: "POST",
            headers: { "Content-Type": "application/json; charset=UTF-8" },
            body: JSON.stringify({ Mode: mode })
        }).catch(function () {});
    };

    const ensureNorthWarningElement = () => {
        let warning = document.getElementById(WARNING_ID);
        if (warning) return warning;

        warning = document.createElement("div");
        warning.id = WARNING_ID;
        warning.textContent = WARNING_TEXT_NIGHT;
        warning.style.position = "fixed";
        warning.style.zIndex = "9999";
        warning.style.display = "none";
        warning.style.pointerEvents = "none";
        warning.style.left = "50%";
        warning.style.transform = "translateX(-50%)";
        warning.style.bottom = "2.2rem";
        warning.style.fontSize = "0.84rem";
        warning.style.fontWeight = "700";
        warning.style.letterSpacing = "0.04em";
        warning.style.color = "#ff6b6b";
        warning.style.textShadow = "0 0 8px rgba(0,0,0,0.75)";
        warning.style.textTransform = "uppercase";
        document.body.appendChild(warning);
        return warning;
    };

    const findRoadHudElement = () => {
        const expected = formatRoad() || state.road;
        if (!expected) return null;

        const nodes = document.querySelectorAll("span,strong,p,div");
        let best = null;

        for (let i = 0; i < nodes.length; i++) {
            const el = nodes[i];
            if (!el || el.children.length > 0) continue;

            const text = (el.textContent || "").trim();
            if (!text) continue;

            const isRoadText = text === expected || text === state.road || text.startsWith(state.road + ROAD_WEATHER_SEPARATOR);
            if (!isRoadText) continue;

            const rect = el.getBoundingClientRect();
            const insideHudArea =
                rect.left >= 0 &&
                rect.left < window.innerWidth * 0.50 &&
                rect.bottom > window.innerHeight * 0.12 &&
                rect.top < window.innerHeight * 0.98;
            if (!insideHudArea) continue;

            if (!best) {
                best = el;
                continue;
            }

            const bestRect = best.getBoundingClientRect();
            if (rect.top < bestRect.top) {
                best = el;
            }
        }

        return best;
    };

    const findCrossingHudElement = () => {
        if (!state.crossing) return null;

        const nodes = document.querySelectorAll("span,strong,p,div");
        let best = null;

        for (let i = 0; i < nodes.length; i++) {
            const el = nodes[i];
            if (!el || el.children.length > 0) continue;

            const text = (el.textContent || "").trim();
            if (!text || text !== state.crossing) continue;

            const rect = el.getBoundingClientRect();
            const insideHudArea =
                rect.left >= 0 &&
                rect.left < window.innerWidth * 0.50 &&
                rect.bottom > window.innerHeight * 0.12 &&
                rect.top < window.innerHeight * 0.98;
            if (!insideHudArea) continue;

            if (!best) {
                best = el;
                continue;
            }

            const bestRect = best.getBoundingClientRect();
            if (rect.top > bestRect.top) {
                best = el;
            }
        }

        return best;
    };

    const updateNorthWarning = () => {
        if (state.logoOnly) {
            const warningHidden = document.getElementById(WARNING_ID);
            if (warningHidden) warningHidden.style.display = "none";
            return;
        }

        if (!state.road) {
            const detectedRegion = detectRegionFromHud();
            if (detectedRegion) {
                state.road = detectedRegion;
            }
        }

        const warning = ensureNorthWarningElement();
        const isDangerNow = shouldShowNorthWarning();

        if (isDangerNow !== state.dangerConditionActive) {
            state.dangerConditionActive = isDangerNow;
            playDangerNotifySound(isDangerNow ? "enter" : "exit");
        }

        if (!isDangerNow) {
            warning.style.display = "none";
            state.dangerWarningVisible = false;
            return;
        }

        warning.textContent = state.dangerAlways ? WARNING_TEXT_ALWAYS : WARNING_TEXT_NIGHT;
        warning.style.left = "50%";
        warning.style.transform = "translateX(-50%)";
        warning.style.bottom = "2.2rem";
        warning.style.top = "";
        warning.style.display = "block";
        state.dangerWarningVisible = true;
    };

    const startWarningSync = () => {
        const tick = () => {
            updateNorthWarning();
            window.requestAnimationFrame(tick);
        };

        window.requestAnimationFrame(tick);
    };

    const findInfoPanel = () => {
        const nodes = document.querySelectorAll("h1,h2,h3,h4,span,strong,div,p");
        let infoTitle = null;

        for (let i = 0; i < nodes.length; i++) {
            if (normalizeText(nodes[i].textContent) === "informacoes") {
                infoTitle = nodes[i];
                break;
            }
        }

        if (!infoTitle) return null;

        let panel = infoTitle;
        while (panel && panel !== document.body) {
            const txt = normalizeText(panel.textContent);
            if (txt.includes("estilo 1") && txt.includes("estilo 2") && txt.includes("estilo 3")) {
                return panel;
            }
            panel = panel.parentElement;
        }

        return null;
    };

    const styleToggleElements = (wrap, label, button) => {
        wrap.style.position = "absolute";
        wrap.style.left = "50%";
        wrap.style.transform = "translateX(-35%)";
        wrap.style.bottom = "1rem";
        wrap.style.display = "flex";
        wrap.style.alignItems = "center";
        wrap.style.gap = "0.75rem";
        wrap.style.zIndex = "5";

        label.style.fontSize = "1.05rem";
        label.style.fontWeight = "600";
        label.style.color = "rgba(255,255,255,0.88)";

        button.style.minWidth = "4.2rem";
        button.style.height = "2.1rem";
        button.style.padding = "0 0.8rem";
        button.style.border = "1px solid rgba(255,255,255,0.2)";
        button.style.borderRadius = "0.45rem";
        button.style.background = "rgba(255,255,255,0.08)";
        button.style.color = "#fff";
        button.style.fontWeight = "700";
        button.style.fontSize = "0.95rem";
        button.style.letterSpacing = "0.05em";
        button.style.cursor = "pointer";
    };

    const applyButtonVisualState = (button) => {
        if (isWeatherVisible()) {
            button.textContent = "ON";
            button.style.borderColor = "rgb(var(--main))";
            button.style.background = "rgba(var(--main),0.32)";
            button.style.boxShadow = "0 0 .9rem rgba(var(--main),.24)";
            return;
        }

        button.textContent = "OFF";
        button.style.borderColor = "rgba(255,255,255,0.2)";
        button.style.background = "rgba(255,255,255,0.08)";
        button.style.boxShadow = "none";
    };

    const ensureToggle = (panel) => {
        let toggle = document.getElementById(TOGGLE_ID);
        if (toggle && toggle.parentElement !== panel) {
            toggle.remove();
            toggle = null;
        }

        if (!toggle) {
            const wrap = document.createElement("div");
            wrap.id = TOGGLE_ID;

            const label = document.createElement("span");
            label.textContent = "Informar clima na HUD";

            const button = document.createElement("button");
            button.type = "button";

            styleToggleElements(wrap, label, button);
            applyButtonVisualState(button);

            button.addEventListener("click", function () {
                setWeatherVisible(!isWeatherVisible());
                applyButtonVisualState(button);
                state.lastRoadPushed = "";
                pushRoadToHud();
                updateNorthWarning();
            });

            wrap.appendChild(label);
            wrap.appendChild(button);
            panel.appendChild(wrap);
            toggle = wrap;
        }

        if (getComputedStyle(panel).position === "static") {
            panel.style.position = "relative";
        }

        return toggle;
    };

    const updateToggleInPanel = () => {
        const old = document.getElementById(OLD_TOGGLE_ID);
        if (old) old.remove();

        const panel = findInfoPanel();
        const existing = document.getElementById(TOGGLE_ID);

        if (!panel) {
            if (existing) existing.remove();
            return;
        }

        const toggle = ensureToggle(panel);
        const button = toggle.querySelector("button");
        if (button) applyButtonVisualState(button);
        updateNorthWarning();
    };

    window.addEventListener("message", function (event) {
        const data = event && event.data;
        if (!data || !data.Action) return;
        if (data._overlayInternal) return;

        if (data.Action === "Road" && typeof data.Payload === "string") {
            state.road = data.Payload.split(ROAD_WEATHER_SEPARATOR)[0].trim();
            state.lastRoadPushed = "";
            pushRoadToHud();
            updateNorthWarning();
            return;
        }

        if (data.Action === "Crossing" && typeof data.Payload === "string") {
            state.crossing = data.Payload;
            updateNorthWarning();
            return;
        }

        if (data.Action === "Weather" && typeof data.Payload === "string") {
            state.weather = data.Payload;
            state.lastRoadPushed = "";
            pushRoadToHud();
            updateNorthWarning();
            return;
        }

        if (data.Action === "Clock" && Array.isArray(data.Payload) && data.Payload.length >= 2) {
            state.hour = Number(data.Payload[0]) || 0;
            state.minute = Number(data.Payload[1]) || 0;
            updateNorthWarning();
            return;
        }

        if (data.Action === "DangerAreas") {
            state.dangerFeatureEnabled = !!data.Payload;

            if (!state.dangerFeatureEnabled) {
                state.dangerConditionActive = false;
                state.dangerWarningVisible = false;
                const warning = document.getElementById(WARNING_ID);
                if (warning) warning.style.display = "none";
            }

            updateNorthWarning();
            return;
        }

        if (data.Action === "DangerAreasConfig" && data.Payload && typeof data.Payload === "object") {
            applyDangerConfig(data.Payload);
            updateNorthWarning();
            return;
        }

        if (data.Action === "LogoOnly") {
            setLogoOnlyMode(!!data.Payload);
            return;
        }
    });

    const observer = new MutationObserver(function () {
        updateToggleInPanel();
    });

    observer.observe(document.documentElement, {
        childList: true,
        subtree: true
    });

    window.addEventListener("resize", function () {
        updateToggleInPanel();
        updateNorthWarning();
    });

    startWarningSync();
    requestDangerConfig();

    setInterval(function () {
        updateToggleInPanel();
        pushRoadToHud();
    }, 350);

    setInterval(function () {
        requestDangerConfig();
    }, 5000);
})();

