window.simulate = (action, value) => {
  window.postMessage(
    {
      action,
      value,
    },
    "*"
  );
};

window.simulateAddOptions = () => {
  window.simulate("visible", true);

  window.simulate("setOptions", {
    options: {
      general: [
        { label: "Opção 1", icon: "fa-solid fa-hand" },
        { label: "Opção 2", icon: "fa-solid fa-car" },
        { label: "Opção 3", icon: "fa-solid fa-house" },
      ],
      vehicles: [
        { label: "Motor", icon: "fa-solid fa-engine" },
        { label: "Portas", icon: "fa-solid fa-door-open" },
      ],
    },
    resetIndex: true,
  });
};

window.simulateClearOptions = () => {
  window.simulate("clearOptions");
};

window.simulateRandomOptions = () => {
  window.simulate("visible", true);

  const randomIcons = [
    "fa-solid fa-hand",
    "fa-solid fa-car", 
    "fa-solid fa-house",
    "fa-solid fa-engine",
    "fa-solid fa-door-open",
    "fa-solid fa-gear",
    "fa-solid fa-user",
    "fa-solid fa-star",
    "fa-solid fa-heart",
    "fa-solid fa-bell",
    "fa-solid fa-clock",
    "fa-solid fa-key"
  ];

  const randomLabels = [
    "Opção Aleatória 1",
    "Opção Aleatória 2", 
    "Opção Aleatória 3",
    "Opção Aleatória 4",
    "Opção Aleatória 5",
    "Teste Rápido",
    "Ação Imediata",
    "Configuração",
    "Preferências",
    "Personalizar",
    "Avançado",
    "Básico"
  ];

  const getRandomItems = (count) => {
    const items = [];
    for (let i = 0; i < count; i++) {
      items.push({
        label: randomLabels[Math.floor(Math.random() * randomLabels.length)],
        icon: randomIcons[Math.floor(Math.random() * randomIcons.length)]
      });
    }
    return items;
  };

  window.simulate("setOptions", {
    options: {
      general: getRandomItems(3 + Math.floor(Math.random() * 4)),
      vehicles: getRandomItems(2 + Math.floor(Math.random() * 3)),
      extras: Math.random() > 0.5 ? getRandomItems(1 + Math.floor(Math.random() * 2)) : []
    },
    resetIndex: true,
  });
};
