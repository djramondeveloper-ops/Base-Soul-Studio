const app = {
  init({ spawns = {} } = {}) {
    if (!spawns) return;
    
    document.body.style.display = 'flex';

    const container = document.querySelector('main');

    container.addEventListener('wheel', (e) => {
      e.preventDefault();
    
      container.scrollLeft += e.deltaY;
    });
    
    container.innerHTML = '';
    Object.keys(spawns).forEach(key => {
      const item = document.createElement('div');
      item.classList.add('spawn');
      item.style.backgroundImage = `url(./assets/${spawns[key].image})`;
      item.innerHTML = `
        <img class="location" src="./assets/loc.svg" alt="">
        <button>${key}</button>
      `

      item.querySelector('button').addEventListener('click', () => {
        this.close();
        fetch('https://alc-spawn/Spawn', {
          method: 'POST',
          body: JSON.stringify({ spawn: key })
        })
      })

      container.appendChild(item);
    });
  },
  lastSpawn() {
    fetch('https://alc-spawn/Last')
    this.close();
  },
  close() {
    document.body.style.display = 'none';
  },
}

window.addEventListener('message', ({ data }) => {
  if (data.action === 'Opened' && data.data) {

    app.init(data.data)
  } else if (data.action === 'Opened' && data.data === false) {
    app.close()
  }
});

if (!window.invokeNative) {
  window.postMessage({
    action: 'Opened'
  })
}



