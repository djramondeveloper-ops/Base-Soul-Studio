import { createOptions } from "./createOptions.js";
import { fetchNui } from "./fetchNui.js";
import { onSelect } from "./controls.js";
import { setCurrentIndex, resetHold, setDefaultColor } from "./controls.js";
import "./simulate.js";

const optionsWrapper = document.getElementById("options-wrapper");
const bodyContainer = document.getElementById("container");
const body = document.body;

function setOptions(event) {
  bodyContainer.style.display = "none";
  optionsWrapper.innerHTML = "";

  if (event.data.value.options) {
    const optionsLength = Object.values(event.data.value.options).reduce(
      (acc, curr) => acc + curr.length,
      0
    );
    let addedOptions = 0;

    for (const type in event.data.value.options) {
      event.data.value.options[type].forEach((data, id) => {
        createOptions(type, data, id + 1);
        addedOptions++;

        if (addedOptions === optionsLength) {
          void bodyContainer.offsetWidth;
          bodyContainer.style.display = "flex";
        }
      });
    }

    if (event.data.value.resetIndex) {
      setCurrentIndex(0);
    }
  }
}

window.addEventListener("message", (event) => {
  switch (event.data.action) {
    case "visible": {
      body.style.visibility = event.data.value ? "visible" : "hidden";
      break;
    }

    case "setOptions": {
      setOptions(event);
      break;
    }

    case "interact": {
      onSelect();
      break;
    }

    case "release": {
      resetHold();
      break;
    }

    case "clearOptions": {
      bodyContainer.style.display = "none";
      optionsWrapper.innerHTML = "";
      break;
    }

    case "setColor": {
      const c = event.data.value;
      const color = `rgb(${c[0]}, ${c[1]}, ${c[2]}, ${c[3] / 255})`;
      const softColor = `rgb(${c[0]}, ${c[1]}, ${c[2]}, 0.35)`;
      setDefaultColor(color);
      body.style.setProperty("--theme-color", color);
      body.style.setProperty("--theme-color-soft", softColor);
      break;
    }

    case "setCooldown": {
      body.style.opacity = event.data.value ? "0.3" : "1";
      const interactKey = document.getElementById("interact-key");

      interactKey.innerHTML = event.data.value
        ? `<i class="fa-regular fa-hourglass-half"></i>`
        : "E";

      break;
    }
  }
});

window.addEventListener("load", async (event) => {
  await fetchNui("load");
});
