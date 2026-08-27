import { updateHighlight, setCurrentIndex } from "./controls.js";

const optionsWrapper = document.getElementById("options-wrapper");

export function createOptions(type, data, id) {
  if (data.hide) return;

  const option = document.createElement("div");

  option.innerHTML = `
    <div class="animated-background"></div>
    <p class="option-label">${data.label + (data.holdTime ? " (hold)" : "")}</p>
    <span class="option-detail"></span>
    <span class="option-arrow"></span>
  `;
  option.className = "option-container";
  option.targetType = type;
  option.color = data.color;
  option.targetId = id;
  option.holdTime = data.holdTime || 0; // Default to 0 if no holdtime
  option.hideButton = data.hideButton || false;

  optionsWrapper.appendChild(option);

  if (optionsWrapper.children.length === 1) {
    setCurrentIndex(0);
    updateHighlight();
  }
}
