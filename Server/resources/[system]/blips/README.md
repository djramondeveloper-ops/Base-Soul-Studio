# 📍 mri_Qblips

> **Sistema avançado de gerenciamento de blips com React NUI para servidores FiveM**  
> Crie, gerencie e organize blips no mapa com facilidade.

[![FiveM](https://img.shields.io/badge/FiveM-Blips-orange)](https://fivem.net/)
[![License](https://img.shields.io/badge/License-MIT-blue)](LICENSE)
[![ oxmysql](https://img.shields.io/badge/Database-oxmysql-blue)](https://github.com/overextended/oxmysql)

---

## 📋 Índice

- [Funcionalidades](#-funcionalidades)
- [Dependências](#-dependências)
- [Instalação](#-instalação)
- [Configuração](#-configuração)
- [Comandos](#-comandos)
- [Eventos](#-eventos)
- [Exports](#-exports)
- [Estrutura de Arquivos](#-estrutura-de-arquivos)
- [Banco de Dados](#-banco-de-dados)
- [Créditos](#-créditos)

---

## ✨ Funcionalidades

### 🗺️ Gerenciamento de Blips
| Funcionalidade | Descrição |
|---------|-------------|
| **Criar Blips** | Adiciona blips personalizados ao mapa |
| **Seleção de Sprite** | Escolhe entre todos os sprites de blip do GTA V |
| **Personalização de Cor** | Suporte completo à paleta de cores |
| **Controle de Escala** | Ajusta tamanho do blip (0.0 - 2.0) |
| **Controle de Opacidade** | Define transparência (0 - 255) |
| **Blips Piscar** | Faz blips piscarem para atenção |
| **Curto Alcance** | Alterna exibição de curto alcance |
| **Opção Oculto** | Oculta/exibe blips dinamicamente |

### 👥 Controle de Acesso
- **Acesso Baseado em Emprego** - Restringe blips a empregos específicos
- **Acesso Baseado em Gangue** - Restringe blips a gangues específicas
- **Permissões de Grupo** - Configura quem pode ver/editar blips

### 🎨 Interface do Usuário
- **React NUI** - Interface moderna e responsiva
- **Pré-visualização em Tempo Real** - Vê alterações instantaneamente
- **Busca e Filtro** - Encontra blips rapidamente
- **Operações em Massa** - Gerencia múltiplos blips

---

## 🔗 Dependências

| Dependência | Obrigatório | Notas |
|------------|----------|-------|
| **oxmysql** | ✅ Sim | Operações de banco de dados |
| **ox_lib** | ⚠️ Recomendado | Componentes UI |

---

## 📥 Instalação

1. **Download e Extração**
   ```bash
   # Coloque na pasta de resources
   [mri]/mri_Qblips/
   ```

2. **Instalar Dependências**
   - Certifique-se de que `oxmysql` está instalado e iniciado
   - Certifique-se de que o banco de dados está configurado

3. **Configuração do Banco de Dados**
   ```bash
   # Importe o arquivo SQL
   # Execute: mri_Qblips/db/blips.sql
   ```

4. **Configurar Permissões ACE**
   ```bash
   # No server.cfg
   add_ace group.admin command.blipcreator allow
   add_ace group.moderator command.blipcreator allow
   ```

5. **Iniciar Resource**
   ```lua
   -- No server.cfg
   ensure mri_Qblips
   ```

---

## ⚙️ Configuração

```lua
-- config.lua (ou dentro do fxmanifest)
Config = {}

-- Permissão ACE para comando criador de blip
Config.ACE_Permission = 'command.blipcreator'

-- Configurações padrão de blip
Config.DefaultBlip = {
    sprite = 1,
    color = 0,
    scale = 0.8,
    opacity = 255
}

-- Grupos Permitidos (podem ser configurados via ACE)
Config.AllowedGroups = {
    'admin',
    'moderator'
}
```

---

## 🎮 Comandos

| Comando | Permissão | Descrição |
|---------|------------|-------------|
| `/blip` | ACE: command.blipcreator | Abre menu de gerenciamento de blips |

### Configuração de Permissão ACE
```bash
# Concede permissão a admins
add_ace group.admin command.blipcreator allow

# Concede permissão a moderadores
add_ace group.moderator command.blipcreator allow

# Concede a usuário específico
add_ace identifier.steam:110000112345678 command.blipcreator allow
```

---

## 📡 Eventos

### Eventos do Cliente

| Evento | Parâmetros | Descrição |
|-------|------------|-------------|
| `mri_Qblips:client:openMenu` | `none` | Abre UI de gerenciamento de blips |
| `mri_Qblips:client:createBlip` | `blipData` | Cria um novo blip |
| `mri_Qblips:client:updateBlip` | `id, blipData` | Atualiza blip existente |
| `mri_Qblips:client:deleteBlip` | `id` | Deleta um blip |
| `mri_Qblips:client:refreshBlips` | `none` | Atualiza todos os blips |

### Eventos do Servidor

| Evento | Parâmetros | Descrição |
|-------|------------|-------------|
| `mri_Qblips:server:saveBlip` | `blipData` | Salva blip no banco de dados |
| `mri_Qblips:server:updateBlip` | `id, blipData` | Atualiza blip no banco de dados |
| `mri_Qblips:server:deleteBlip` | `id` | Deleta blip do banco de dados |
| `mri_Qblips:server:requestBlips` | `none` | Solicita todos os blips do DB |

---

## 📤 Exports

### Exports do Cliente

```lua
-- Cria um novo blip
exports['mri_Qblips']:createBlip({
    name = "Hospital",
    coords = vector3(295.65, -584.25, 43.25),
    sprite = 61,
    color = 2,
    scale = 0.8,
    opacity = 255,
    flash = false,
    shortRange = true,
    hidden = false,
    job = nil,
    gang = nil
})

-- Obtém todos os blips
local blips = exports['mri_Qblips']:getBlips()

-- Deleta um blip por ID
exports['mri_Qblips']:deleteBlip(blipId)
```

### Exports do Servidor

```lua
-- Salva blip no banco de dados
exports['mri_Qblips']:saveBlip(source, blipData)

-- Obtém todos os blips do banco de dados
local blips = exports['mri_Qblips']:getAllBlips()

-- Deleta blip
exports['mri_Qblips']:deleteBlip(blipId)
```

---

## 📁 Estrutura de Arquivos

```
mri_Qblips/
├── client/
│   ├── main.lua              # Lógica principal do cliente
│   ├── blips.lua             # Renderização de blips
│   └── menu.lua              # Manipuladores de menu do cliente
├── server/
│   ├── main.lua              # Lógica principal do servidor
│   └── database.lua          # Operações de banco de dados
├── config/
│   └── config.lua            # Arquivo de configuração
├── db/
│   └── blips.sql             # Esquema do banco de dados
├── locales/
│   ├── en.json               # Inglês
│   └── pt.json               # Português
├── web/
│   ├── build/                # App React compilado
│   ├── src/                  # Código fonte React
│   │   ├── components/       # Componentes UI
│   │   ├── context/          # Contexto React
│   │   └── App.jsx           # App principal
│   ├── package.json
│   └── vite.config.js
├── fxmanifest.lua
└── README.md
```

---

## 🗄️ Banco de Dados

### Tabela Blips
```sql
-- mri_Qblips/db/blips.sql
CREATE TABLE IF NOT EXISTS `mri_blips` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `coords` VARCHAR(100) NOT NULL,
  `sprite` INT NOT NULL DEFAULT 1,
  `color` INT NOT NULL DEFAULT 0,
  `scale` FLOAT NOT NULL DEFAULT 0.8,
  `opacity` INT NOT NULL DEFAULT 255,
  `flash` TINYINT(1) NOT NULL DEFAULT 0,
  `shortRange` TINYINT(1) NOT NULL DEFAULT 1,
  `hidden` TINYINT(1) NOT NULL DEFAULT 0,
  `job` VARCHAR(50) DEFAULT NULL,
  `gang` VARCHAR(50) DEFAULT NULL,
  `createdBy` VARCHAR(50) DEFAULT NULL,
  `createdAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
);
```

### Estrutura de Dados do Blip
```json
{
  "id": 1,
  "name": "Hospital",
  "coords": "295.65,-584.25,43.25",
  "sprite": 61,
  "color": 2,
  "scale": 0.8,
  "opacity": 255,
  "flash": false,
  "shortRange": true,
  "hidden": false,
  "job": null,
  "gang": null,
  "createdBy": "player_identifier",
  "createdAt": "2026-05-04 12:00:00"
}
```

---

## 🎨 Referência de Sprites de Blip

| ID do Sprite | Nome | Descrição |
|-----------|------|-------------|
| 1 | Padrão | Círculo branco |
| 61 | Hospital | Símbolo médico |
| 94 | Polícia | Distintivo de polícia |
| 106 | Garagem | Ícone de carro |
| 121 | Bar | Ícone de bebida |
| 137 | Car Wash | Gotas de água |
| 162 | Tatuagem | Máquina de tatuagem |
| 207 | Ammunation | Ícone de arma |
| 356 | Academia | Haltere |
| 365 | Joalheria | Diamante |
| 374 | Loja de Roupas | Camiseta |
| 402 | Mecânico | Chave inglesa |
| 415 | Barbearia | Tesoura |
| 426 | Cinema | Carretel de filme |
| 475 | Capacetes | Capacete de moto |

*E muitos mais disponíveis in-game...*

---

## 🎨 NUI (React)

A UI é construída com React e Vite:

```bash
# Navegue até o diretório web
cd mri_Qblips/web

# Instale as dependências
npm install

# Build para produção
npm run build

# Modo de desenvolvimento
npm run dev
```

---

## 🏆 Créditos

- **mri_Qblips** - Sistema de gerenciamento de blips
- **oxmysql** - Integração com banco de dados
- **React** - Framework moderno de UI
- **FiveM Community** - Inspiração e suporte

---

## 📝 Licença

Este projeto está licenciado sob a Licença MIT - veja o arquivo [LICENSE](LICENSE) para detalhes.

---

<div align="center">
  <p>Feito com ❤️ para a comunidade FiveM</p>
</div>
