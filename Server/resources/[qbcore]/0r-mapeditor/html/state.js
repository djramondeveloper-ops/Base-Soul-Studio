
var FAV_KEY = '0r-mapeditor_favorites';

function _load(key, fallback) {
  try { var raw = localStorage.getItem(key); return raw ? JSON.parse(raw) : fallback; }
  catch (e) { return fallback; }
}
function loadFavorites() {
  var a = _load(FAV_KEY, []);
  return Array.isArray(a) ? a.filter(function (m) { return typeof m === 'string'; }) : [];
}

var S = {
  open: false,
  props: [],
  categories: [],
  search: '',
  category: 'props',
  sub: 'all',
  catMenu: null,
  searchOpen: false,
  favorites: loadFavorites(),
  snap: { grid: false, surface: true, angle: false, snap: false },
  step: 0.25,
  angleStep: 15,
  mode: 'translate',
  freecam: false,
  multiplace: false,
  grabbing: false,
  build: null,
  selected: null,
  cardOpen: false,
  maps: [],
  showMaps: false,
  mapId: null,
  mapName: '',
  worldDelete: false,
  bulkActive: false,
  bulkCount: 0,
  bulkGrabbing: false,
  marqueeOpen: false,
  brushActive: false,
  brushRadius: 5,
  brushDensity: 4,
  brushAlign: true,
  brushYaw: true,
  mapMode: 0,
  showObjects: false,
  previewModel: null,
  previewLabel: null,
  gizmoPos: { on: false, x: 0, y: 0 },
  showTools: false,
  toolsCollapsed: false,
  dockCollapsed: false,
  toast: null,
  showIO: false,
  ioJson: '',
  ioLua: '',
  ioYmap: '',
  ioMenyoo: '',
  ioCsv: '',
  areaDelete: { active: false, radius: 8 },
  dockTab: 'objects',
  createdCount: 0,
  hiddenCount: 0,
  deletedObjectsCount: 0,
  showLogs: false,
  showLight: false,
  showFill: false,
  light: { placing: false, count: 0, r: 255, g: 200, b: 120, range: 12, intensity: 5, list: [] },
  fill: { active: false, picking: false, ready: false, spacing: 4, layout: 'grid', heading: 'random', vcount: 0 },
  logs: [],
  hidden: [],
  deletedObjects: [],
  layers: [],
  created: [],
  objects: [],
  map: null,
  history: { canUndo: false, canRedo: false, undoLabel: '', redoLabel: '' },
  clipboard: { has: false, count: 0 },
  array: { active: false, pattern: 'linear', count: 3, spacing: 2, heading: 0, rows: 2, cols: 2, spacingX: 2, spacingY: 2, radius: 5, faceCenter: false, preview: 0 },
  align: { active: false, count: 0 },
  prefabs: [],
  marqueeBlock: false,
};

var _subs = [];
function subscribe(fn) { _subs.push(fn); return function () { _subs = _subs.filter(function (f) { return f !== fn; }); }; }

function set(patch) {
  for (var k in patch) { if (Object.prototype.hasOwnProperty.call(patch, k)) S[k] = patch[k]; }
  for (var i = 0; i < _subs.length; i++) { try { _subs[i](patch); } catch (e) { console.error(e); } }
}

function toggleFavorite(model) {
  var cur = S.favorites;
  var next = cur.indexOf(model) !== -1 ? cur.filter(function (m) { return m !== model; }) : cur.concat([model]);
  try { localStorage.setItem(FAV_KEY, JSON.stringify(next)); } catch (e) { }
  set({ favorites: next });
}

var _toastTok = 0;
function toast(msg, ms) {
  var tok = ++_toastTok;
  set({ toast: msg });
  setTimeout(function () { if (_toastTok === tok) set({ toast: null }); }, ms || 2200);
}
