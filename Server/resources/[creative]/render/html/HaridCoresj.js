const prompt = document.getElementById('prompt');
const chip = document.querySelector('.chip');
const confirm = document.getElementById('confirm');
const btnYes = document.getElementById('btn-yes');
const btnNo = document.getElementById('btn-no');
const titleEl = document.querySelector('#confirm .title');

window.addEventListener('message', (event) => {
  const data = event.data;
  if (!data || !data.action) return;

  switch (data.action) {
    case 'show':
      prompt.classList.remove('hidden');
      break;
    case 'hide':
      prompt.classList.add('hidden');
      break;
    case 'move': {
      const { x, y } = data;
      chip.style.left = `${x * window.innerWidth}px`;
      chip.style.top = `${y * window.innerHeight}px`;
      break;
    }
    case 'confirm': {
      if (data.title) titleEl.textContent = data.title;
      if (data.yes) btnYes.textContent = data.yes;
      if (data.no) btnNo.textContent = data.no;
      confirm.classList.remove('hidden');
      break;
    }
    case 'hideConfirm': {
      confirm.classList.add('hidden');
      break;
    }
  }
});

// Send NUI callbacks for yes/no
btnYes.addEventListener('click', () => {
  fetch(`https://${GetParentResourceName()}/surrender_yes`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json; charset=UTF-8' },
    body: JSON.stringify({})
  }).then(() => {
    confirm.classList.add('hidden');
  });
});

btnNo.addEventListener('click', () => {
  fetch(`https://${GetParentResourceName()}/surrender_no`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json; charset=UTF-8' },
    body: JSON.stringify({})
  }).then(() => {
    confirm.classList.add('hidden');
  });
});
