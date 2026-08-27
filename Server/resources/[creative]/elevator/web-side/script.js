const state = {
    resourceName: typeof GetParentResourceName === "function" ? GetParentResourceName() : "elevator",
    open: false,
    elevatorId: null,
    floors: [],
    currentFloor: null,
    blackout: false
};

const ui = {
    overlay: document.getElementById("elevatorOverlay"),
    closeBtn: document.getElementById("closeBtn"),
    floorList: document.getElementById("floorList"),
    powerStatus: document.getElementById("powerStatus"),
    powerDot: document.getElementById("powerDot"),
    powerText: document.getElementById("powerText")
};

function postNui(action, data) {
    return fetch(`https://${state.resourceName}/${action}`, {
        method: "POST",
        headers: {
            "Content-Type": "application/json; charset=UTF-8"
        },
        body: JSON.stringify(data || {})
    }).catch(() => null);
}

function normalizeOpenPayload(payload) {
    const normalized = {
        elevatorId: null,
        floors: [],
        currentFloor: null,
        blackout: false
    };

    if (!payload) {
        return normalized;
    }

    if (Array.isArray(payload)) {
        normalized.elevatorId = Number(payload[0]);
        normalized.floors = Array.isArray(payload[1]) ? payload[1] : [];
        normalized.currentFloor = Number(payload[2]) || null;
        normalized.blackout = payload[3] === true;
        return normalized;
    }

    if (typeof payload === "object") {
        if (Array.isArray(payload.Payload)) {
            return normalizeOpenPayload(payload.Payload);
        }

        const firstKey = payload[0] ?? payload["1"] ?? payload.Number;
        const secondKey = payload[1] ?? payload["2"] ?? payload.Table;
        const thirdKey = payload[2] ?? payload["3"] ?? payload.CurrentFloor;
        const fourthKey = payload[3] ?? payload["4"] ?? payload.Blackout;

        normalized.elevatorId = Number(firstKey);
        normalized.floors = Array.isArray(secondKey) ? secondKey : [];
        normalized.currentFloor = Number(thirdKey) || null;
        normalized.blackout = fourthKey === true;
    }

    return normalized;
}

function setOpen(show) {
    state.open = Boolean(show);
    ui.overlay.classList.toggle("open", state.open);
}

function renderFloors() {
    ui.floorList.innerHTML = "";

    if (!Array.isArray(state.floors) || state.floors.length === 0) {
        const empty = document.createElement("div");
        empty.className = "empty-state";
        empty.textContent = "Nenhum andar disponivel neste elevador.";
        ui.floorList.appendChild(empty);
        return;
    }

    state.floors.forEach((floorData, index) => {
        const name = String(floorData?.Name || `Andar ${index + 1}`);
        const floorNumber = index + 1;
        const isCurrentFloor = Number(state.currentFloor) === floorNumber;
        const disabledByBlackout = state.blackout === true;
        const isDisabled = isCurrentFloor || disabledByBlackout;
        const floorItem = document.createElement("button");
        floorItem.type = "button";
        floorItem.className = `floor-item ${isDisabled ? "disabled" : ""}`;
        floorItem.disabled = isDisabled;
        floorItem.innerHTML = `
            <div class="floor-main">
                <span class="floor-name">${name}</span>
                ${isCurrentFloor ? '<span class="floor-current">Andar atual</span>' : ""}
                ${(!isCurrentFloor && disabledByBlackout) ? '<span class="floor-current">Sem energia</span>' : ""}
            </div>
        `;

        if (!isDisabled) {
            floorItem.addEventListener("click", () => {
                postNui("Click", {
                    Elevator: state.elevatorId,
                    Floor: floorNumber
                });
                setOpen(false);
            });
        }

        ui.floorList.appendChild(floorItem);
    });
}

function renderPowerState() {
    if (!ui.powerStatus || !ui.powerDot || !ui.powerText) {
        return;
    }

    const offline = state.blackout === true;
    ui.powerStatus.classList.toggle("offline", offline);
    ui.powerDot.classList.toggle("offline", offline);
    ui.powerText.textContent = offline ? "Sem energia" : "Pronto para uso";
}

function openElevator(payload) {
    const parsed = normalizeOpenPayload(payload);
    state.elevatorId = Number.isFinite(parsed.elevatorId) ? parsed.elevatorId : 1;
    state.floors = Array.isArray(parsed.floors) ? parsed.floors : [];
    state.currentFloor = Number(parsed.currentFloor) || null;
    state.blackout = parsed.blackout === true;
    renderPowerState();
    renderFloors();
    setOpen(true);
}

function closeElevator() {
    setOpen(false);
    postNui("Close", {});
}

ui.closeBtn.addEventListener("click", closeElevator);

document.addEventListener("keydown", (event) => {
    if (!state.open) {
        return;
    }

    if (event.key === "Escape") {
        closeElevator();
    }
});

window.addEventListener("message", (event) => {
    const data = event.data;
    if (!data || typeof data !== "object") {
        return;
    }

    if (data.Action === "Open") {
        openElevator(data.Payload);
        return;
    }

    if (data.Action === "PowerState") {
        const payload = data.Payload || {};
        state.blackout = payload.Blackout === true;
        renderPowerState();
        renderFloors();
    }
});
