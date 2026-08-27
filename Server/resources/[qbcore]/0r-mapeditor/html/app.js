
var FAV = '__fav__';

var THUMB_BASE = 'https://raw.githubusercontent.com/0resmon/objects/main/';

function joaat(key) {
  key = String(key || '').toLowerCase();
  var hash = 0;
  for (var i = 0; i < key.length; i++) {
    hash += key.charCodeAt(i);
    hash = (hash + (hash << 10)) | 0;
    hash ^= hash >>> 6;
  }
  hash = (hash + (hash << 3)) | 0;
  hash ^= hash >>> 11;
  hash = (hash + (hash << 15)) | 0;
  return hash;
}

function el(tag, attrs, children) {
  var e = document.createElement(tag);
  if (attrs) {
    for (var k in attrs) {
      if (!Object.prototype.hasOwnProperty.call(attrs, k)) continue;
      var v = attrs[k];
      if (v == null || v === false) continue;
      if (k === 'class') e.className = v;
      else if (k === 'html') e.innerHTML = v;
      else if (k === 'text') e.textContent = v;
      else if (k === 'style' && typeof v === 'object') { for (var s in v) e.style[s] = v[s]; }
      else if (k.slice(0, 2) === 'on' && typeof v === 'function') e.addEventListener(k.slice(2).toLowerCase(), v);
      else e.setAttribute(k, v);
    }
  }
  append(e, children);
  return e;
}
function append(parent, c) {
  if (c == null || c === false) return;
  if (Array.isArray(c)) { for (var i = 0; i < c.length; i++) append(parent, c[i]); return; }
  if (typeof c === 'string' || typeof c === 'number') { parent.appendChild(document.createTextNode(String(c))); return; }
  parent.appendChild(c);
}
function clear(node) { while (node.firstChild) node.removeChild(node.firstChild); }
function iconEl(name, size, cls, sw) { var s = el('span'); s.innerHTML = icon(name, size, cls, sw); return s.firstChild; }
function pretty(m) { return String(m || '').replace(/_/g, ' ').replace(/(^|\s)\w/g, function (c) { return c.toUpperCase(); }); }
function _uiZoom() { return parseFloat(getComputedStyle(document.documentElement).zoom) || 1; }

function startCustomDrag(e, o, currentLayerName) {
  if (e.button !== 0) return;
  e.preventDefault();

  var dragEl = el('div', {
    class: 'minicard floating-drag-card',
    style: {
      position: 'fixed',
      pointerEvents: 'none',
      zIndex: 99999,
      width: '70px',
      height: '70px',
      opacity: 0.85,
      left: (e.clientX / _uiZoom() - 35) + 'px',
      top: (e.clientY / _uiZoom() - 35) + 'px',
      boxShadow: '0 8px 20px rgba(0,0,0,0.6), 0 0 15px rgba(255,255,255,0.15)',
      borderColor: 'var(--primary)'
    }
  });

  dragEl.appendChild(miniCard(o));
  document.body.appendChild(dragEl);

  var targets = document.querySelectorAll('.layer, .created-wrap');
  targets.forEach(function (tEl) {
    if (tEl.getAttribute('data-layer-name') !== currentLayerName) {
      tEl.classList.add('drag-active');
    }
  });

  function onMouseMove(me) {
    var mz = _uiZoom();
    dragEl.style.left = (me.clientX / mz - 35) + 'px';
    dragEl.style.top = (me.clientY / mz - 35) + 'px';

    var under = document.elementFromPoint(me.clientX, me.clientY);
    var targetEl = under ? under.closest('.layer, .created-wrap') : null;

    targets.forEach(function (tEl) {
      if (tEl === targetEl && tEl.getAttribute('data-layer-name') !== currentLayerName) {
        tEl.classList.add('drag-hover');
      } else {
        tEl.classList.remove('drag-hover');
      }
    });
  }

  function onMouseUp(ue) {
    document.removeEventListener('mousemove', onMouseMove);
    document.removeEventListener('mouseup', onMouseUp);

    if (dragEl.parentNode) dragEl.parentNode.removeChild(dragEl);

    targets.forEach(function (tEl) {
      tEl.classList.remove('drag-active');
      tEl.classList.remove('drag-hover');
    });

    var under = document.elementFromPoint(ue.clientX, ue.clientY);
    var targetEl = under ? under.closest('.layer, .created-wrap') : null;
    if (targetEl) {
      var targetLayer = targetEl.getAttribute('data-layer-name');
      if (targetLayer && targetLayer !== currentLayerName) {
        post('setObjectLayer', { id: o.id, name: targetLayer }).then(refreshTab);
      }
    }
  }

  document.addEventListener('mousemove', onMouseMove);
  document.addEventListener('mouseup', onMouseUp);
}


var HINTS = [
  ['Esc', 'hint.exit', 'global'], ['F', 'hint.freecam', 'global'], ['WASD', 'hint.move', 'global'],
  ['Shift', 'hint.fast', 'global'], ['Alt', 'hint.slow', 'global'], ['RMB', 'hint.look', 'global'], ['2xLMB', 'hint.edit_menu', 'global'], ['Caps', 'hint.free_cursor', 'global'],
  ['Enter', 'hint.deselect', 'select'], ['X', 'hint.cancel', 'place'],
  ['G', 'hint.ground', 'select'], ['V', 'hint.grab', 'select'], ['T', 'hint.teleport', 'select'], ['C', 'hint.clone', 'select'], ['Del', 'hint.delete', 'select'],
  ['M', 'hint.multiplace', 'global'], ['B', 'hint.marquee', 'global'], ['P', 'hint.brush', 'global'],
  ['Ctrl+C', 'hint.copy', 'select'], ['Ctrl+V', 'hint.paste', 'global'], ['Ctrl+Z', 'hint.undo', 'global'], ['Ctrl+Y', 'hint.redo', 'global'],
  ['+/- [ ]', 'hint.step', 'global'], ['Q/E', 'hint.height', 'place'], ['Scroll', 'hint.rotate', 'place'],
];
var DOCK_TABS = [['objects', 'dock.tab.objects'], ['created', 'dock.tab.created'], ['deleted', 'dock.tab.deleted'], ['layers', 'dock.tab.layers'], ['prefabs', 'dock.tab.prefabs']];
var TAB_TIPS = {
  layers: 'dock.tabtip.layers',
  prefabs: 'dock.tabtip.prefabs',
};
var LIGHT_PRESETS = [
  ['panels.light.preset.warm', 255, 200, 120], ['panels.light.preset.white', 255, 255, 255], ['panels.light.preset.red', 255, 60, 60],
  ['panels.light.preset.green', 80, 230, 110], ['panels.light.preset.blue', 90, 150, 255], ['panels.light.preset.purple', 190, 110, 255],
];
var BLIP_COLORS = [
  ['common.color.white', 0, '#f5f5f7'], ['common.color.red', 1, '#e05555'], ['common.color.green', 2, '#5fb96a'],
  ['common.color.blue', 3, '#5a8fd6'], ['common.color.yellow', 5, '#e0c84e'], ['common.color.orange', 17, '#e08a3c'],
];

function btn(label, opts) {
  opts = opts || {};
  var cls = 'btn btn-' + (opts.variant || 'primary');
  if (opts.size) cls += ' btn-' + opts.size;
  if (opts.block) cls += ' btn-block';
  if (opts.class) cls += ' ' + opts.class;
  var b = el('button', { class: cls, onclick: opts.onclick });
  if (opts.disabled) b.disabled = true;
  if (opts.icon) b.appendChild(iconEl(opts.icon, opts.iconSize || 14));
  if (label != null) append(b, label);
  return b;
}

var root = document.getElementById('root');
var editor = null;
var R = {};
var LOCALE = {};
function loc(key) {
  var cur = LOCALE, parts = key.split('.');
  for (var i = 0; i < parts.length; i++) {
    if (cur == null || typeof cur !== 'object') return key;
    cur = cur[parts[i]];
  }
  if (typeof cur !== 'string') return key;
  if (arguments.length > 1) {
    var args = arguments;
    cur = cur.replace(/\{(\d+)\}/g, function (m, n) {
      var v = args[parseInt(n, 10)];
      return v !== undefined ? String(v) : m;
    });
  }
  return cur;
}

function mount() {
  clear(root);
  root.setAttribute('tabindex', '-1');
  editor = el('div', { class: 'editor' });
  var order = ['marquee', 'topbar', 'tools', 'floatingEdit', 'buildBanner', 'moveBanner', 'toast',
    'fill', 'array', 'align', 'light', 'dock', 'logs', 'io', 'maps', 'objects'];
  R = {};
  for (var i = 0; i < order.length; i++) { R[order[i]] = el('div'); editor.appendChild(R[order[i]]); }
  root.appendChild(editor);
  if (window.Gizmo3D) Gizmo3D.init();
  renderAll();
}

function renderAll() {
  renderTopBar(); renderDock(); renderToolsOrFloatingToolbar(); renderLight(); renderFill(); renderArray(); renderAlign();
  renderLogs(); renderIO(); renderMaps(); renderObjects();
  renderBuildBanner(); renderMoveBanner(); renderToast();
  renderMarquee();
  renderFloatingEdit();
}

function renderToolsOrFloatingToolbar() {
  if (S.showTools) renderTools(); else clear(R.tools);
}

function editorTools() {
  function tbtn(label, ic, on, onclick, tooltipText, kind, warnText) {
    var c = 'tb-icon-btn tooltip tooltip-b'; if (on) c += ' on'; else if (kind === 'warn') c += ' warn';
    var b = el('button', { class: c, onclick: onclick, 'data-tooltip': tooltipText || label });
    if (warnText) b.setAttribute('data-warn', warnText);
    b.appendChild(iconEl(ic, 16));
    return b;
  }
  var set_ = set;
  return el('div', { class: 'tb-grp tb-tools', style: { border: 'none', background: 'transparent', padding: '0', boxShadow: 'none' } }, [
    tbtn(loc('topbar.freecam'), 'camera', S.freecam, function () { post('toggleFreecam'); }, loc('topbar.freecam_tip')),
    tbtn(loc('topbar.cursor'), 'cursor', S.mode === 'cursor', function () { post('setMode', { mode: 'cursor' }); }, loc('topbar.cursor_tip')),
    tbtn(loc('topbar.multi_place'), 'copy', S.multiplace, function () { var v = !S.multiplace; set_({ multiplace: v }); post('setMultiplace', { on: v }); }, loc('topbar.multi_place')),
    tbtn(loc('topbar.marquee'), 'marquee', S.bulkActive, function () { post('bulkToggle', { on: !S.bulkActive }); }, loc('topbar.marquee')),
    el('div', { class: 'tb-divider' }),
    tbtn(loc('topbar.fill'), 'hexagon', S.fill.active, function () { var v = !S.fill.active; set_({ showFill: v, showLight: false }); post('fillToggle', { on: v, model: S.build }); }, loc('topbar.fill_tip')),
    tbtn(loc('topbar.brush'), 'brush', S.brushActive, function () { var v = !S.brushActive; set_({ brushActive: v }); post('brushToggle', { on: v, model: S.build }); }, loc('topbar.brush_tip')),
    tbtn(loc('topbar.light'), 'bulb', S.light.placing || S.showLight, function () { var v = !S.showLight; set_({ showLight: v, showFill: false }); if (!v && S.light.placing) post('lightToggle', { on: false }); }, loc('topbar.light_tip')),
    el('div', { class: 'tb-divider' }),
    tbtn(loc('topbar.map_2d'), 'map', S.showObjects, function () { if (!S.showObjects) { post('getObjects').then(function (l) { set_({ objects: l || [], showObjects: true }); }); } else { set_({ showObjects: false }); } }, loc('topbar.map_2d_tip')),
    tbtn(loc('topbar.radar_map'), 'eye', S.mapMode > 0, function () { post('toggleBigmap'); }, S.mapMode === 1 ? loc('topbar.map_tip_bigmap') : S.mapMode === 2 ? loc('topbar.map_tip_hidden') : loc('topbar.map_tip_normal')),
    el('div', { class: 'tb-divider' }),
    tbtn(loc('topbar.eraser'), 'eraser', S.worldDelete, function () { post('worldDelete', { on: !S.worldDelete }); }, loc('topbar.eraser'), 'warn', loc('topbar.eraser_warn')),
    tbtn(loc('topbar.area_delete'), 'target', S.areaDelete.active, function () { post('areaDelete', { on: !S.areaDelete.active }); }, loc('topbar.area_delete_tip'), 'warn', loc('topbar.area_delete_warn')),
    el('div', { class: 'tb-divider' }),
    (function (b) { if (!S.history.canUndo) { b.disabled = true; b.classList.add('disabled'); } return b; })(tbtn(loc('topbar.undo'), 'undo', false, function () { post('undo'); }, S.history.canUndo ? loc('topbar.undo_tip', S.history.undoLabel || '') : loc('topbar.undo_none'))),
    (function (b) { if (!S.history.canRedo) { b.disabled = true; b.classList.add('disabled'); } return b; })(tbtn(loc('topbar.redo'), 'redo', false, function () { post('redo'); }, S.history.canRedo ? loc('topbar.redo_tip', S.history.redoLabel || '') : loc('topbar.redo_none'))),
    el('div', { class: 'tb-divider' }),
    tbtn(loc('topbar.copy'), 'copy', false, function () { post('copy'); }, loc('topbar.copy_tip')),
    (function (b) { if (!S.clipboard.has) { b.disabled = true; b.classList.add('disabled'); } return b; })(tbtn(loc('topbar.paste'), 'copy', false, function () { post('paste'); }, S.clipboard.has ? loc('topbar.paste_tip', S.clipboard.count) : loc('topbar.paste_empty'))),
    tbtn(loc('topbar.array'), 'layers', S.array.active, function () { post('arrayToggle', { on: !S.array.active }); }, loc('topbar.array_tip')),
    tbtn(loc('topbar.align'), 'marquee', S.align.active, function () { post('alignToggle', { on: !S.align.active }); }, loc('topbar.align_tip')),
    el('div', { class: 'tb-divider' }),
    tbtn(loc('topbar.export'), 'upload', false, function () { post('getExport'); }, loc('topbar.export_tip')),
    tbtn(loc('topbar.log'), 'list', S.showLogs, function () { var v = !S.showLogs; set_({ showLogs: v }); if (v) post('getLogs'); }, loc('topbar.log_tip')),
  ]);
}
function editorHints() {
  var hints = el('div', { class: 'tb-grp tb-hints' });
  HINTS.filter(function (h) {
    var ctx = h[2] || 'global';
    if (ctx === 'place') return !!S.build;
    if (ctx === 'select') return !!S.selected;
    return true;
  }).sort(function (a, b) {
    return ((a[2] || 'global') === 'global' ? 1 : 0) - ((b[2] || 'global') === 'global' ? 1 : 0);
  }).forEach(function (h) {
    var keyLabel = (h[1] === 'hint.toggle_editor' && S.keybind) ? S.keybind : h[0];
    hints.appendChild(el('span', { class: 'tb-hint' }, [el('span', { class: 'kbd', text: keyLabel }), ' ' + loc(h[1])]));
  });
  hints.addEventListener('wheel', function (e) {
    var d = e.deltaY || e.deltaX;
    if (d) { e.preventDefault(); hints.scrollLeft += d; }
  }, { passive: false });
  hints.addEventListener('mousedown', function (e) {
    var sx = e.clientX, ss = hints.scrollLeft, moved = false;
    function mm(ev) {
      var dx = ev.clientX - sx;
      if (!moved && Math.abs(dx) > 3) { moved = true; hints.classList.add('grabbing'); }
      if (moved) hints.scrollLeft = ss - dx;
    }
    function mu() {
      window.removeEventListener('mousemove', mm);
      window.removeEventListener('mouseup', mu);
      hints.classList.remove('grabbing');
    }
    window.addEventListener('mousemove', mm);
    window.addEventListener('mouseup', mu);
  });
  return hints;
}

function tbIconBtn(imgSrc, tooltipText, on, onclick, warnStyle) {
  var cls = 'tb-icon-btn tooltip tooltip-b' + (on ? ' on' : '') + (warnStyle ? ' warn' : '');
  var b = el('button', { class: cls, onclick: onclick, 'data-tooltip': tooltipText });
  var img = el('img', { src: imgSrc, alt: tooltipText });
  img.style.width = '17px'; img.style.height = '17px';
  b.appendChild(img);
  return b;
}

function renderTopBar() {
  clear(R.topbar);
  if (!S.open || S.showTools) return;

  var topBarWrap = hoverable(el('div', { class: 'topbar-wrap po' }));
  topBarWrap.appendChild(el('div', { class: 'cam' }));

  var leftGroup = el('div', { class: 'tb-left-group' });

  var brand = el('div', { class: 'tb-brand' });
  var blocksImg = el('img', { src: 'images/blocks0.svg', alt: '' });
  blocksImg.style.width = '20px'; blocksImg.style.height = '20px';
  brand.appendChild(blocksImg);
  brand.appendChild(el('span', { class: 'tb-brand-map', text: 'Map' }));
  brand.appendChild(el('span', { class: 'tb-brand-builder', text: 'Builder' }));
  leftGroup.appendChild(brand);

  leftGroup.appendChild(el('div', { class: 'tb-divider' }));

  leftGroup.appendChild(editorTools());
  leftGroup.appendChild(el('div', { class: 'tb-divider' }));
  topBarWrap.appendChild(leftGroup);
  topBarWrap.appendChild(editorHints());

  var actions = el('div', { class: 'tb-actions tb-actions-tools' });

  var iconGrp = el('div', { class: 'tb-icon-grp' });

  iconGrp.appendChild(tbIconBtn('images/save0.svg', loc('topbar.save_map'), false, function () {
    post('saveMap', { name: S.mapName || loc('topbar.untitled'), category: 'general', permanent: true });
  }));

  var toolsBtn = el('button', {
    class: 'tb-icon-btn tooltip tooltip-b' + (S.showTools ? ' on' : ''),
    'data-tooltip': loc('topbar.editor_tools'),
    onclick: function () { set({ showTools: !S.showTools }); }
  });
  toolsBtn.appendChild(iconEl('sliders', 18));
  iconGrp.appendChild(toolsBtn);

  iconGrp.appendChild(tbIconBtn('images/cancel-010.svg', loc('topbar.exit_editor'), false, function () { post('close'); }));

  actions.appendChild(iconGrp);

  var publishBtn = el('button', { class: 'tb-publish tooltip tooltip-b', 'data-tooltip': loc('topbar.publish_tip'), onclick: function () { post('getExport'); } });
  publishBtn.appendChild(el('img', { src: 'images/cloud-upload0.svg', alt: '' }));
  publishBtn.appendChild(el('span', { text: loc('topbar.publish') }));
  actions.appendChild(publishBtn);

  topBarWrap.appendChild(actions);

  R.topbar.appendChild(topBarWrap);
}

var _filtered = [];
var _filterKey = '';
var CARD_W = 122;
var _cardsScroller = null;
var _cardsVp = null;
var _scrollLeft = 0;

var _thumbOk = {};
var _thumbFail = {};

var _lazyObserver = (typeof IntersectionObserver !== 'undefined') ? new IntersectionObserver(function(entries) {
  entries.forEach(function(entry) {
    if (entry.isIntersecting) {
      var img = entry.target;
      var lazySrc = img.getAttribute('data-src');
      if (lazySrc) { img.src = lazySrc; img.removeAttribute('data-src'); }
      _lazyObserver.unobserve(img);
    }
  });
}, { rootMargin: '200px' }) : null;

function counts() { var m = {}; for (var i = 0; i < S.props.length; i++) { var c = S.props[i].category; m[c] = (m[c] || 0) + 1; } return m; }
function subsFor(category) {
  if (category === 'all' || category === FAV) return [];
  var seen = {}; var out = [];
  for (var i = 0; i < S.props.length; i++) { var p = S.props[i]; if (p.category === category) { var sb = p.sub || 'general'; if (!seen[sb]) { seen[sb] = 1; out.push(sb); } } }
  return out.sort();
}
function computeFiltered() {
  var key = [S.search, S.category, S.sub, S.props.length, (S.category === FAV ? S.favorites.length : 0)].join('|');
  if (key === _filterKey) return _filtered;
  _filterKey = key;
  _scrollLeft = 0;
  var q = S.search.trim().toLowerCase();
  var favSet = {}; for (var i = 0; i < S.favorites.length; i++) favSet[S.favorites[i]] = 1;
  var subs = subsFor(S.category);
  _filtered = S.props.filter(function (p) {
    if (q) return p.label.toLowerCase().indexOf(q) !== -1 || p.model.toLowerCase().indexOf(q) !== -1;
    if (S.category === FAV) { if (!favSet[p.model]) return false; }
    else if (S.category !== 'all' && p.category !== S.category) return false;
    if (subs.length > 0 && S.sub !== 'all' && (p.sub || 'general') !== S.sub) return false;
    return true;
  });
  return _filtered;
}

var _pvTimer = null;
var _catMenuAnchor = null;
var _focusSearch = false;
var _dockMenuBound = false;
function subCounts(cat) {
  var m = { all: 0 };
  for (var i = 0; i < S.props.length; i++) { var p = S.props[i]; if (p.category === cat) { m.all++; var sb = p.sub || 'general'; m[sb] = (m[sb] || 0) + 1; } }
  return m;
}
function renderDock() {
  var prevInput = R.dock.querySelector('.dock-search-inp');
  var refocus = !!(prevInput && document.activeElement === prevInput);
  var caret = refocus ? prevInput.selectionStart : 0;
  clear(R.dock);
  if (!S.open) return;
  if (!_dockMenuBound) {
    _dockMenuBound = true;
    document.addEventListener('mousedown', function (e) {
      if (!e.target || !e.target.closest) return;
      if (S.catMenu && !e.target.closest('.cat-menu') && !e.target.closest('.chip')) set({ catMenu: null });
      if (S.searchOpen && !S.search && !e.target.closest('.dock-search')) set({ searchOpen: false });
    });
  }

  var filtered = computeFiltered();

  var dockWrap = el('div', { class: 'dock-wrap' });
  var unified = hoverable(el('div', { class: 'dock po' + (S.dockCollapsed ? ' collapsed' : '') }));
  dockWrap.appendChild(unified);
  var dockBody = el('div', { class: 'dock-body' });

  var bar = el('div', { class: 'dock-bar' + (S.dockCollapsed ? ' no-border' : '') });

  var collapseCtrl = el('div', { class: 'dock-collapse', onclick: function () { set({ dockCollapsed: !S.dockCollapsed }); } });
  collapseCtrl.appendChild(iconEl(S.dockCollapsed ? 'chevUp' : 'chevDown', 14, 'dock-chev'));
  collapseCtrl.appendChild(el('img', { src: 'images/group-items0.svg', alt: '', class: 'dock-title-icon' }));
  bar.appendChild(collapseCtrl);

  if (S.build) {
    var keysText = loc('dock.misc.placing', S.build);
    if (S.multiplace) keysText += loc('dock.misc.placing_multi');
    bar.appendChild(el('span', { class: 'badge dock-placing', text: keysText, style: { color: 'var(--warn)', borderColor: 'rgba(221,84,86,0.3)' } }));
    bar.appendChild(btn(loc('dock.action.stop'), { variant: 'destructive', size: 'xs', onclick: function () { post('stopBuild'); } }));
  }

  var tabs = el('div', { class: 'tabs' });
  DOCK_TABS.forEach(function (t) {
    var lbl = loc(t[1]);
    if (t[0] === 'objects' && !S.build) lbl += ' (' + S.props.length + ')';
    if (t[0] === 'created' && S.createdCount) lbl += ' (' + S.createdCount + ')';
    if (t[0] === 'deleted' && (S.hiddenCount + S.deletedObjectsCount)) lbl += ' (' + (S.hiddenCount + S.deletedObjectsCount) + ')';
    tabs.appendChild(el('button', { class: 'tab' + (S.dockTab === t[0] ? ' on' : ''), text: lbl, title: TAB_TIPS[t[0]] ? loc(TAB_TIPS[t[0]]) : '', onclick: function () { selectTab(t[0]); } }));
  });
  bar.appendChild(tabs);

  if (S.dockTab === 'objects' && !S.dockCollapsed) {
    bar.appendChild(el('div', { class: 'tb-divider dock-bar-sep' }));
    var cnt = counts();
    var chips = el('div', { class: 'chips scroller-x' });
    var chipDefs = [{ key: FAV, label: loc('dock.misc.favorites'), n: S.favorites.length, fav: true }, { key: 'all', label: loc('dock.misc.all'), n: S.props.length }];
    S.categories.forEach(function (c) { var cl = loc('category.' + c.key); chipDefs.push({ key: c.key, label: (cl === 'category.' + c.key) ? c.label : cl, n: cnt[c.key] || 0 }); });
    chipDefs.forEach(function (c) {
      var hasSubs = !c.fav && c.key !== 'all' && subsFor(c.key).length > 0;
      var b = el('button', {
        class: 'chip' + (S.category === c.key ? ' on' : '') + (S.catMenu === c.key ? ' menu-open' : ''),
        onclick: function (e) {
          if (hasSubs) {
            _catMenuAnchor = e.currentTarget.getBoundingClientRect();
            set({ catMenu: S.catMenu === c.key ? null : c.key });
          } else {
            set({ category: c.key, sub: 'all', catMenu: null });
          }
        }
      });
      if (c.fav) { b.appendChild(iconEl('star', 12, 'fav-ic')); }
      append(b, c.label);
      b.appendChild(el('span', { class: 'n', text: c.n }));
      if (hasSubs) { b.appendChild(iconEl('chevDown', 10, 'chip-caret')); }
      chips.appendChild(b);
    });
    chips.addEventListener('wheel', function (e) { if (e.deltaY) { e.preventDefault(); chips.scrollLeft += e.deltaY; } }, { passive: false });
    bar.appendChild(chips);

    var searchBox = el('div', { class: 'dock-search open' });
    var sicon = el('span', { class: 'dock-search-btn dock-search-ic' });
    sicon.appendChild(el('img', { src: 'images/search-010.svg', alt: '', class: 'search-icon' }));
    searchBox.appendChild(sicon);
    searchBox.appendChild(el('input', { class: 'input dock-search-inp', placeholder: loc('placeholder.search'), value: S.search, oninput: function (e) { set({ search: e.target.value }); } }));
    bar.appendChild(searchBox);
  }

  dockBody.appendChild(bar);

  if (S.dockCollapsed) {
    unified.appendChild(dockBody);
    R.dock.appendChild(dockWrap);
    return;
  }

  if (S.dockTab === 'objects') {

    if (S.catMenu && _catMenuAnchor && subsFor(S.catMenu).length) {
      var sc = subCounts(S.catMenu);
      var _cz = _uiZoom();
      var _mTop = Math.round(_catMenuAnchor.bottom / _cz + 5);
      var menu = el('div', { class: 'cat-menu', style: { left: Math.round(_catMenuAnchor.left / _cz) + 'px', top: _mTop + 'px', maxHeight: Math.max(120, window.innerHeight - _mTop - 12) + 'px' } });
      var _menuKey = S.catMenu;
      ['all'].concat(subsFor(_menuKey)).forEach(function (sName) {
        var row = el('button', { class: 'cat-menu-row' + ((S.category === _menuKey && S.sub === sName) ? ' on' : ''), onclick: function () { set({ category: _menuKey, sub: sName, catMenu: null }); } });
        var _sl = sName === 'all' ? loc('dock.misc.all') : loc('sub.' + sName);
        append(row, (_sl === 'sub.' + sName) ? pretty(sName) : _sl);
        row.appendChild(el('span', { class: 'n', text: sName === 'all' ? sc.all : (sc[sName] || 0) }));
        menu.appendChild(row);
      });
      dockBody.appendChild(menu);
    }

    _cardsScroller = el('div', { class: 'cards scroller-x' });
    _cardsVp = el('div', { class: 'cards-vp' });
    if (filtered.length === 0) {
      var msg = S.category === FAV ? loc('empty.no_favorites') : loc('empty.no_matching_props');
      _cardsScroller.appendChild(el('div', { class: 'dock-empty', text: msg }));
    } else {
      _cardsVp.style.width = (filtered.length * CARD_W) + 'px';
      _cardsScroller.appendChild(_cardsVp);
      _cardsScroller.addEventListener('scroll', function () { _scrollLeft = _cardsScroller.scrollLeft; renderCardsDebounced(); });
      _cardsScroller.addEventListener('wheel', function (e) { var d = e.deltaY || e.deltaX; if (d) { e.preventDefault(); _cardsScroller.scrollLeft += d; } }, { passive: false });
    }
    dockBody.appendChild(_cardsScroller);

    unified.appendChild(dockBody);
    R.dock.appendChild(dockWrap);
    if (_cardsScroller) {
      _cardsScroller.scrollLeft = _scrollLeft;
      renderCardsDebounced();
    }
  } else {
    dockBody.appendChild(renderDockList());
    unified.appendChild(dockBody);
    R.dock.appendChild(dockWrap);
  }

  if (refocus) {
    var ni = R.dock.querySelector('.dock-search-inp');
    if (ni) { ni.focus(); try { ni.setSelectionRange(caret, caret); } catch (e) { } }
  } else if (_focusSearch) {
    _focusSearch = false;
    var nf = R.dock.querySelector('.dock-search-inp');
    if (nf) nf.focus();
  }
}

var _renderCardsTimer = null;
function renderCardsDebounced() {
  if (_renderCardsTimer) cancelAnimationFrame(_renderCardsTimer);
  _renderCardsTimer = requestAnimationFrame(renderCards);
}

function renderCards() {
  if (!_cardsVp || S.dockTab !== 'objects') return;
  var filtered = _filtered;
  if (_lazyObserver && _cardsVp) { var _obs = _cardsVp.querySelectorAll('img[data-src]'); for (var _oi = 0; _oi < _obs.length; _oi++) _lazyObserver.unobserve(_obs[_oi]); }
  clear(_cardsVp);
  if (!filtered.length) return;
  var sw = _cardsScroller.clientWidth || 1200;
  var bufferCards = 12;
  var start = Math.max(0, Math.floor(_scrollLeft / CARD_W) - bufferCards);
  var end = Math.min(filtered.length, Math.ceil((_scrollLeft + sw) / CARD_W) + bufferCards);
  var favSet = {}; for (var i = 0; i < S.favorites.length; i++) favSet[S.favorites[i]] = 1;

  var frag = document.createDocumentFragment();
  for (var idx = start; idx < end; idx++) {
    (function (index) {
      var p = filtered[index];
      var fav = !!favSet[p.model];
      var activeBuild = S.build === p.model;
      var slot = el('div', { class: 'pcard-slot', style: { transform: 'translateX(' + (index * CARD_W) + 'px)', width: CARD_W + 'px' } });
      var card = el('div', {
        class: 'pcard' + (activeBuild ? ' brackets' : ''),
        onclick: function () { set({ build: p.model, selected: null }); post('build', { model: p.model }); }
      });
      if (activeBuild) card.style.borderColor = 'rgba(46,155,255,0.7)';
      var imgWrap = el('div', { class: 'pcard-img' });

      if (_thumbFail[p.model]) {
        imgWrap.appendChild(iconEl('layers', 26, 'pcard-ph'));
      } else {
        var thumbSrc = THUMB_BASE +p.model + '.webp';
        var img = el('img', {
          draggable: 'false',
          alt: '',
          loading: 'lazy',
          onerror: function() {
            _thumbFail[p.model] = true;
            this.replaceWith(iconEl('layers', 26, 'pcard-ph'));
          },
          onload: function() {
            _thumbOk[p.model] = true;
          }
        });
        if (_lazyObserver && !_thumbOk[p.model]) {
          img.setAttribute('data-src', thumbSrc);
          _lazyObserver.observe(img);
        } else {
          img.src = thumbSrc;
        }
        imgWrap.appendChild(img);
      }

      var favBtn = el('button', { class: 'pcard-fav' + (fav ? ' fav' : ''), onclick: function (e) { e.stopPropagation(); toggleFavorite(p.model); } });
      favBtn.appendChild(iconEl('star', 13));
      imgWrap.appendChild(favBtn);

      card.appendChild(imgWrap);
      card.appendChild(el('div', { class: 'pcard-label', text: p.label }));
      slot.appendChild(card);
      frag.appendChild(slot);
    })(idx);
  }
  _cardsVp.appendChild(frag);
}

function selectTab(t) {
  if (t !== S.dockTab) _zoneSel = null;
  set({ dockTab: t });
  if (t === 'created') post('getObjects').then(function (l) { set({ objects: l || [] }); });
  else if (t === 'deleted') { post('getHidden').then(function (l) { set({ hidden: l || [] }); }); post('getDeletedObjects').then(function (l) { set({ deletedObjects: l || [] }); }); }
  else if (t === 'layers') post('getLayersFull').then(function (r) { set({ layers: (r && r.layers) || [], created: (r && r.created) || [] }); });
  else if (t === 'prefabs') post('getPrefabs');
}
function refreshTab() { selectTab(S.dockTab); }

function miniCard(o) {
  var card = el('div', { class: 'minicard' });
  var mi = el('div', { class: 'mi' });
  if (_thumbFail[o.model]) {
    mi.appendChild(iconEl('layers', 18));
  } else {
    var thumbSrc = THUMB_BASE +o.model + '.webp';
    var img = el('img', {
      draggable: 'false',
      alt: '',
      loading: 'lazy',
      onerror: function() {
        _thumbFail[o.model] = true;
        this.replaceWith(iconEl('layers', 18));
      },
      onload: function() {
        _thumbOk[o.model] = true;
      }
    });
    if (_lazyObserver && !_thumbOk[o.model]) {
      img.setAttribute('data-src', thumbSrc);
      _lazyObserver.observe(img);
    } else {
      img.src = thumbSrc;
    }
    mi.appendChild(img);
  }
  card.appendChild(mi);
  card.appendChild(el('div', { class: 'ml', text: o.model }));
  return card;
}

function rowThumb(model, px) {
  px = px || 30;
  var wrap = el('div', { class: 'row-thumb', style: { width: px + 'px', height: px + 'px', flex: '0 0 auto', borderRadius: '3px', overflow: 'hidden', background: 'rgba(255,255,255,0.05)', display: 'grid', placeItems: 'center' } });
  if (_thumbFail[model]) { wrap.appendChild(iconEl('layers', Math.floor(px * 0.55), 'pcard-ph')); return wrap; }
  var img = el('img', {
    draggable: 'false', alt: '', loading: 'lazy',
    style: { width: '100%', height: '100%', objectFit: 'cover' },
    onerror: function () { _thumbFail[model] = true; this.replaceWith(iconEl('layers', Math.floor(px * 0.55), 'pcard-ph')); },
    onload: function () { _thumbOk[model] = true; }
  });
  var src = THUMB_BASE +model + '.webp';
  if (_lazyObserver && !_thumbOk[model]) { img.setAttribute('data-src', src); _lazyObserver.observe(img); }
  else { img.src = src; }
  wrap.appendChild(img);
  return wrap;
}

var _hashName = null;
function hashToName(h) {
  if (_hashName === null) {
    _hashName = {};
    for (var i = 0; i < S.props.length; i++) { var m = S.props[i].model; _hashName[joaat(m) >>> 0] = m; }
  }
  var key = parseInt(h, 10);
  if (isNaN(key)) return null;
  return _hashName[key >>> 0] || null;
}

function copyText(text) {
  var s = text == null ? '' : String(text);
  var ok = false;
  try {
    var ta = document.createElement('textarea');
    ta.value = s;
    ta.setAttribute('readonly', '');
    ta.style.position = 'fixed'; ta.style.left = '-9999px'; ta.style.top = '0'; ta.style.opacity = '0';
    document.body.appendChild(ta);
    ta.focus(); ta.select();
    try { ta.setSelectionRange(0, s.length); } catch (e) {}
    ok = document.execCommand('copy');
    document.body.removeChild(ta);
  } catch (e) { ok = false; }
  if (!ok) { try { if (navigator.clipboard && navigator.clipboard.writeText) { navigator.clipboard.writeText(s); ok = true; } } catch (e) {} }
  return ok;
}
function dockCard(model, labelText, coordsText, actions, visState) {
  var card = el('div', { class: 'obj-card' });
  card.appendChild(rowThumb(model, 46));

  var center = el('div', { class: 'obj-card-center' });
  var nameRow = el('div', { class: 'obj-card-namerow' });
  nameRow.appendChild(el('span', { class: 'obj-card-name', text: labelText }));
  center.appendChild(nameRow);
  if (coordsText) {
    var parts = coordsText.split(',');
    var labels = ['X', 'Y', 'Z'];
    var coordRow = el('div', { class: 'obj-card-coords' });
    parts.forEach(function (v, i) {
      var pill = el('div', { class: 'obj-card-coord' });
      pill.appendChild(el('span', { class: 'obj-card-coord-lbl', text: labels[i] || '' }));
      pill.appendChild(el('span', { class: 'obj-card-coord-val', text: v.trim() }));
      coordRow.appendChild(pill);
    });
    var copyBtn = el('button', { class: 'obj-card-copy tooltip tooltip-t', 'data-tooltip': loc('dock.action.copy_coords'), onclick: function () {
      copyText(coordsText);
    }});
    var copyImg = el('img', { src: 'images/copy-010.svg', alt: loc('common.copy'), style: { width: '14px', height: '14px' } });
    copyBtn.appendChild(copyImg);
    coordRow.appendChild(copyBtn);
    if (visState) {
      var eyeBtn = el('button', { class: 'obj-card-copy tooltip tooltip-t', 'data-tooltip': visState.visible ? loc('common.hide') : loc('common.show'), onclick: visState.onToggle });
      eyeBtn.appendChild(iconEl(visState.visible ? 'eye' : 'eyeOff', 14));
      coordRow.appendChild(eyeBtn);
    }
    center.appendChild(coordRow);
  }
  card.appendChild(center);

  var right = el('div', { class: 'obj-card-actions' });
  actions.forEach(function (a) { right.appendChild(a); });
  card.appendChild(right);

  return card;
}

function dockCardBtn(icon, title, danger, onclick) {
  var cls = 'obj-card-btn tooltip tooltip-t' + (danger ? ' obj-card-btn-del' : icon === 'target' ? ' obj-card-btn-tp' : ' obj-card-btn-sel');
  var b = el('button', { class: cls, 'data-tooltip': title, onclick: onclick });
  var iconSrc = danger ? 'images/delete-020.svg' : icon === 'target' ? 'images/arrow-right-020.svg' : 'images/cursor-magic-selection-040.svg';
  var img = el('img', { src: iconSrc, alt: title, style: { width: '14px', height: '14px' } });
  b.appendChild(img);
  return b;
}

var _zoneSel = null;
function zoneGroups(list) {
  var m = {}, order = [];
  for (var i = 0; i < list.length; i++) {
    var z = list[i].zone || 'Unknown';
    if (!m[z]) { m[z] = []; order.push(z); }
    m[z].push(list[i]);
  }
  return order.map(function (z) { return { zone: z, items: m[z] }; }).sort(function (a, b) { return b.items.length - a.items.length; });
}
function zoneDrill(tab, list, emptyMsg, cardFor) {
  var out = el('div');
  if (!list.length) { out.appendChild(el('div', { class: 'dl-empty', text: emptyMsg })); return out; }
  var icon = tab === 'created' ? 'layers' : 'eraser';
  var title = tab === 'created' ? loc('dock.section.created_objects') : loc('dock.section.deleted_props');
  if (_zoneSel != null) {
    var items = list.filter(function (o) { return (o.zone || 'Unknown') === _zoneSel; });
    if (!items.length) { _zoneSel = null; return zoneDrill(tab, list, emptyMsg, cardFor); }
    var head = el('div', { class: 'zone-head' });
    var back = el('button', { class: 'zone-back', onclick: function () { _zoneSel = null; renderDock(); } });
    back.appendChild(el('span', { class: 'zone-back-ic', text: '‹' }));
    append(back, loc('common.back'));
    head.appendChild(back);
    head.appendChild(el('span', { class: 'zone-head-title' }, [iconEl('map', 13, 'zone-ic'), document.createTextNode(' ' + _zoneSel + ' (' + items.length + ')')]));
    out.appendChild(head);
    var grid = el('div', { class: 'dl-card-grid' });
    items.forEach(function (o) { grid.appendChild(cardFor(o)); });
    out.appendChild(grid);
    return out;
  }
  out.appendChild(el('div', { class: 'dl-section-head' }, [
    el('span', { class: 'dl-section-title' }, [iconEl(icon, 14), document.createTextNode(' ' + title + ' (' + list.length + ')')])
  ]));
  var zl = el('div', { class: 'zone-list' });
  zoneGroups(list).forEach(function (g) {
    var row = el('button', { class: 'zone-row', onclick: function () { _zoneSel = g.zone; renderDock(); } });
    row.appendChild(iconEl('map', 14, 'zone-ic'));
    row.appendChild(el('span', { class: 'zone-name', text: g.zone }));
    row.appendChild(el('span', { class: 'zone-n', text: g.items.length }));
    row.appendChild(el('span', { class: 'zone-go', text: '›' }));
    zl.appendChild(row);
  });
  out.appendChild(zl);
  return out;
}
function renderDockList() {
  var tab = S.dockTab;
  var wrap = el('div', { class: 'dl scroller ' + (tab === 'layers' ? 'lay' : 'lst') });

  function sectionHead(iconName, title, right) {
    var h = el('div', { class: 'dl-section-head' });
    var left = el('span', { class: 'dl-section-title' });
    left.appendChild(iconEl(iconName, 14));
    left.appendChild(document.createTextNode(' ' + title));
    h.appendChild(left);
    if (right) h.appendChild(right);
    return h;
  }

  function dockHint(text) {
    var h = el('div', { style: { display: 'flex', gap: '7px', alignItems: 'flex-start', fontSize: '11px', lineHeight: '1.5', color: 'var(--faint)', background: 'rgba(255,255,255,0.035)', border: '1px solid var(--border)', borderRadius: '4px', padding: '8px 10px', margin: '2px 0 11px' } });
    var ic = iconEl('bulb', 13);
    ic.style.flex = '0 0 auto'; ic.style.marginTop = '1px'; ic.style.opacity = '0.85';
    h.appendChild(ic);
    h.appendChild(el('span', { text: text }));
    return h;
  }

  if (tab === 'created') {
    wrap.appendChild(zoneDrill('created', S.objects, loc('empty.no_objects_placed'), function (o) {
      return dockCard(o.model, pretty(o.model), o.x.toFixed(0) + ', ' + o.y.toFixed(0) + ', ' + o.z.toFixed(0), [
        dockCardBtn('cursor', loc('dock.action.select'), false, function () { post('selectObject', { id: o.id }); }),
        dockCardBtn('target', loc('dock.action.teleport'), false, function () { post('teleportTo', { id: o.id }); }),
        dockCardBtn('trash', loc('dock.action.delete'), true, function () { post('removeObject', { id: o.id }).then(refreshTab); }),
      ], { visible: o.visible !== false, onToggle: function () { post('toggleVisible', { id: o.id }).then(refreshTab); } });
    }));

  } else if (tab === 'deleted') {
    if (_zoneSel == null && S.deletedObjects && S.deletedObjects.length) {
      wrap.appendChild(sectionHead('trash', loc('dock.section.deleted_objects') + ' (' + S.deletedObjects.length + ')'));
      var dog = el('div', { class: 'dl-card-grid' });
      S.deletedObjects.forEach(function (o) {
        dog.appendChild(dockCard(o.model, pretty(o.model), o.x.toFixed(0) + ', ' + o.y.toFixed(0) + ', ' + o.z.toFixed(0), [
          dockCardBtn('refresh', loc('dock.action.restore'), false, function () { post('restoreObject', { uid: o.uid }).then(refreshTab); }),
          dockCardBtn('target', loc('dock.action.teleport'), false, function () { post('teleportTo', { x: o.x, y: o.y, z: o.z }); }),
        ]));
      });
      wrap.appendChild(dog);
    }
    wrap.appendChild(zoneDrill('deleted', S.hidden, loc('empty.no_world_props_deleted'), function (h) {
      var name = hashToName(h.model);
      return dockCard(name || h.model, name ? pretty(name) : loc('dock.misc.prop', h.model), h.x.toFixed(0) + ', ' + h.y.toFixed(0) + ', ' + h.z.toFixed(0), [
        dockCardBtn('refresh', loc('dock.action.restore'), false, function () { post('restoreHidden', { index: h.index }).then(refreshTab); }),
        dockCardBtn('target', loc('dock.action.teleport'), false, function () { post('teleportTo', { x: h.x, y: h.y, z: h.z }); }),
      ]);
    }));

  } else if (tab === 'layers') {
    wrap.appendChild(dockHint(loc('dock.hint.layers')));
    var addWrap = el('div', { class: 'center', style: { gap: '8px' } });
    var nl = el('input', { class: 'input h8', placeholder: loc('placeholder.new_layer'), style: { width: '11rem' }, value: _newLayer, oninput: function (e) { _newLayer = e.target.value; } });
    var addBtn = btn(loc('dock.action.add_layer'), { variant: 'primary', size: 'sm', icon: 'plus', iconSize: 13, onclick: function () { if (_newLayer.trim()) { post('addLayer', { name: _newLayer.trim() }).then(refreshTab); _newLayer = ''; } } });
    addWrap.appendChild(nl); addWrap.appendChild(addBtn);
    wrap.appendChild(sectionHead('layers', loc('dock.section.layers'), addWrap));

    var lays = el('div', { class: 'layers' });
    if (!S.layers.length) {
      lays.appendChild(el('div', { class: 'dl-empty', text: loc('empty.no_layers') }));
    }
    S.layers.forEach(function (l) {
      var box = el('div', { class: 'layer', 'data-layer-name': l.name });
      var lh = el('div', { class: 'layer-h' });
      var nm = el('span', { class: 'nm' });
      nm.appendChild(iconEl('folder', 13, 'ic'));
      nm.appendChild(document.createTextNode(' ' + l.name + ' '));
      nm.appendChild(el('span', { class: 'ct', text: '(' + l.objects.length + ')' }));
      var acts = el('div', { class: 'acts' });
      acts.appendChild(el('button', { class: 'tooltip tooltip-t', 'data-tooltip': l.visible ? loc('dock.action.hide_layer') : loc('dock.action.show_layer'), onclick: function () { post('layerVisible', { name: l.name, on: !l.visible }).then(refreshTab); } }, [iconEl(l.visible ? 'eye' : 'eyeOff', 14)]));
      acts.appendChild(el('button', { class: 'tooltip tooltip-t', 'data-tooltip': loc('dock.action.delete_layer'), onclick: function () { post('removeLayer', { name: l.name }).then(refreshTab); } }, [iconEl('trash', 14)]));
      lh.appendChild(nm); lh.appendChild(acts); box.appendChild(lh);
      var lgrid = el('div', { class: 'layer-grid' });
      l.objects.slice(0, 9).forEach(function (o) {
        var card = miniCard(o);
        card.style.cursor = 'grab';
        card.addEventListener('mousedown', function (e) { startCustomDrag(e, o, l.name); });
        lgrid.appendChild(card);
      });
      if (!l.objects.length) lgrid.appendChild(el('div', { class: 'layer-empty', text: loc('empty.drag_objects_here') }));
      box.appendChild(lgrid);
      lays.appendChild(box);
    });
    wrap.appendChild(lays);

    var cwrap = el('div', { class: 'created-wrap', 'data-layer-name': 'Default' });
    var ch = el('div', { class: 'between', style: { marginBottom: '10px' } }, [
      el('span', { class: 'dl-section-title', style: { display: 'inline-flex', alignItems: 'center', gap: '6px' } }, [iconEl('layers', 13), document.createTextNode(' ' + loc('dock.section.unassigned', S.created.length))]),
      el('span', { style: { fontSize: '10px', color: 'var(--faint)', letterSpacing: '0.03em' }, text: loc('dock.misc.drag_to_assign') }),
    ]);
    cwrap.appendChild(ch);
    var cgrid = el('div', { class: 'created-grid' });
    if (!S.created.length) cgrid.appendChild(el('div', { class: 'dl-empty', text: loc('empty.no_unassigned') }));
    S.created.forEach(function (o) {
      var c = el('div', { class: 'cc' });
      c.addEventListener('mousedown', function (e) { startCustomDrag(e, o, 'Default'); });
      c.appendChild(miniCard(o));
      cgrid.appendChild(c);
    });
    cwrap.appendChild(cgrid);
    wrap.appendChild(cwrap);

  } else if (tab === 'prefabs') {
    wrap.appendChild(dockHint(loc('dock.hint.prefabs')));
    var pAdd = el('div', { class: 'center', style: { gap: '8px' } });
    var pn = el('input', { class: 'input h8', placeholder: loc('placeholder.prefab_name'), style: { width: '12rem' }, value: _prefabName, oninput: function (e) { _prefabName = e.target.value; } });
    var pBtn = btn(loc('panels.prefab.save_selection'), { variant: 'primary', size: 'sm', icon: 'plus', iconSize: 13, onclick: function () { if (_prefabName.trim()) { post('savePrefab', { name: _prefabName.trim() }); _prefabName = ''; } } });
    pAdd.appendChild(pn); pAdd.appendChild(pBtn);
    wrap.appendChild(sectionHead('save', loc('dock.section.prefabs'), pAdd));

    var plist = el('div', { class: 'dl-rows' });
    if (!S.prefabs.length) plist.appendChild(el('div', { class: 'dl-empty', text: loc('empty.no_prefabs') }));
    S.prefabs.forEach(function (pf) {
      plist.appendChild(el('div', { class: 'dl-row' }, [
        el('span', { class: 'nm', text: pf.name }),
        el('span', { class: 'co', text: pf.category || loc('common.general') }),
        el('button', { class: 'blue', text: loc('panels.prefab.place'), onclick: function () { post('placePrefab', { id: pf.id }); } }),
        el('button', { class: 'danger', text: loc('panels.prefab.delete'), onclick: function () { post('deletePrefab', { id: pf.id }); } }),
      ]));
    });
    wrap.appendChild(plist);
  }
  return wrap;
}
var _newLayer = '';
var _prefabName = '';

function numberField(label, value, step, onCommit) {
  value = value || 0;
  var inp = el('input', { value: value.toFixed(2) });
  function commit(v) { if (!isNaN(v)) onCommit(Math.round(v * 1000) / 1000); }
  inp.addEventListener('keydown', function (e) { if (e.key === 'Enter') commit(parseFloat(inp.value)); });
  inp.addEventListener('blur', function () { commit(parseFloat(inp.value)); });
  var spins = el('div', { class: 'spins' }, [
    el('button', { text: '▲', onclick: function () { commit(value + step); } }),
    el('button', { text: '▼', onclick: function () { commit(value - step); } }),
  ]);
  return el('div', { class: 'numfield' }, [el('div', { class: 'nl', text: label }), el('div', { class: 'nf' }, [inp, spins])]);
}

function sliderBox(label, val, min, max, step, onApply) {
  var box = el('input', { class: 'input mono', style: { width: '54px', flex: '0 0 54px', textAlign: 'center', padding: '0 4px' }, value: String(val) });
  var rng = el('input', { type: 'range', class: 'rng', min: String(min), max: String(max), step: String(step), value: String(val), style: { flex: '1' } });
  function paint() { var pct = ((rng.value - min) / (max - min)) * 100; rng.style.background = 'linear-gradient(90deg,#54DD72 ' + pct + '%,rgba(255,255,255,0.06) ' + pct + '%)'; }
  paint();
  rng.addEventListener('input', function () { paint(); box.value = rng.value; onApply(+rng.value, true); });
  rng.addEventListener('change', function () { onApply(+rng.value, false); });
  box.addEventListener('change', function () {
    var v = parseFloat(box.value); if (isNaN(v)) v = min;
    v = Math.max(min, Math.min(max, v));
    box.value = String(v); rng.value = String(v); paint(); onApply(v, false);
  });
  return el('div', { class: 'row-mid' }, [el('span', { class: 'upper', style: { width: '42px' }, text: label }), rng, box]);
}

function coordBox(label, value, step, onCommit) {
  value = value || 0;
  var box = el('div', { class: 'f131-box' });
  box.appendChild(el('span', { class: 'f131-ax', text: label }));
  var inp = el('input', { class: 'f131-val', type: 'text', value: String(Math.round(value * 100) / 100) });
  function commit(v) { if (!isNaN(v)) onCommit(Math.round(v * 1000) / 1000); }
  inp.addEventListener('change', function () { commit(parseFloat(inp.value)); });
  inp.addEventListener('blur', function () { commit(parseFloat(inp.value)); });
  inp.addEventListener('keydown', function (e) { if (e.key === 'Enter') { e.preventDefault(); inp.blur(); } });
  box.appendChild(inp);
  return box;
}

function toggleGroup(items, isOn, onClick, cols) {
  var tg = el('div', { class: 'tg', style: { gridTemplateColumns: 'repeat(' + (cols || items.length) + ', minmax(0,1fr))' } });
  items.forEach(function (it) {
    tg.appendChild(el('button', { class: 'tgi' + (isOn(it.value) ? ' on' : ''), text: it.label, onclick: function () { onClick(it.value); } }));
  });
  return tg;
}

var _replaceModel = '';

var _sliderDragging = false;
document.addEventListener('pointerdown', function (e) {
  var t = e.target;
  if (t && t.tagName === 'INPUT' && t.type === 'range') _sliderDragging = true;
}, true);
document.addEventListener('pointerup', function () {
  if (_sliderDragging) { _sliderDragging = false; renderToolsOrFloatingToolbar(); renderFloatingEdit(); renderLight(); renderFill(); renderArray(); }
}, true);

function renderTools() {
  if (_sliderDragging) return;
  clear(R.tools);
  if (!S.open || !S.showTools) return;
  var tPanel = renderToolsPanel();
  if (tPanel) R.tools.appendChild(tPanel);
}

var _toolsPage = 0;
function renderToolsPanel() {
  if (!S.open || !S.showTools) return null;
  var sel = S.selected;

  var wrapper = el('div', { class: 'tools-p card po' + (S.toolsCollapsed ? ' collapsed' : '') });

  var hdr = el('div', { class: 'tools-h' });
  hdr.appendChild(iconEl('sliders', 13));
  hdr.appendChild(el('span', { text: loc('topbar.editor_tools'), style: { cursor: 'pointer', userSelect: 'none' }, onclick: function () { set({ toolsCollapsed: !S.toolsCollapsed }); } }));

  if (!S.toolsCollapsed) {
    hdr.appendChild(el('div', { class: 'dock-tools-sep' }));
    hdr.appendChild(editorTools());
    hdr.appendChild(el('div', { class: 'dock-tools-sep' }));
    hdr.appendChild(editorHints());
  }

  var rightGrp = el('div', { style: { marginLeft: 'auto', display: 'flex', alignItems: 'center', gap: '8px' } });

  if (sel) {
    var minBtn = el('button', {
      class: 'x tooltip tooltip-b', 'data-tooltip': loc('panels.transform.minimize'),
      onclick: function () { set({ showTools: false }); },
      style: { background: 'transparent', border: 0, color: 'var(--muted-fg)', cursor: 'pointer', display: 'inline-flex', alignItems: 'center' }
    });
    minBtn.appendChild(iconEl('minimize', 14));
    rightGrp.appendChild(minBtn);
  }

  var collapseBtn = el('button', {
    class: 'x',
    onclick: function () { set({ toolsCollapsed: !S.toolsCollapsed }); },
    style: { background: 'transparent', border: 0, color: 'var(--muted-fg)', cursor: 'pointer', display: 'inline-flex', alignItems: 'center' }
  });
  collapseBtn.appendChild(iconEl(S.toolsCollapsed ? 'chevDown' : 'chevUp', 12));
  rightGrp.appendChild(collapseBtn);

  rightGrp.appendChild(el('button', { class: 'x', text: '\u2715', onclick: function () { set({ showTools: false }); }, style: { background: 'transparent', border: 0, color: '#fff', cursor: 'pointer', fontSize: '12px' } }));
  hdr.appendChild(rightGrp);
  wrapper.appendChild(hdr);

  if (!S.toolsCollapsed) {
    var panel = el('div', { class: 'cont scroller' });
    wrapper.appendChild(panel);

    function toolsCol(title, children) {
      var col = el('div', { class: 'tools-col' });
      col.appendChild(el('label', { class: 'label', text: title }));
      var body = el('div', { class: 'tools-col-body' });
      append(body, children);
      col.appendChild(body);
      return col;
    }

    var col1 = toolsCol(loc('panels.transform.map_info'), [
      el('span', { class: 'dim', style: { fontSize: '11px', whiteSpace: 'nowrap', maxWidth: '150px', overflow: 'hidden', textOverflow: 'ellipsis' } }, [
        loc('panels.transform.selected') + ' ', el('span', { class: 'mono', text: sel ? sel.model : '\u2014' })
      ]),
      el('input', { class: 'input h8', placeholder: loc('placeholder.map_name'), value: S.mapName, style: { width: '118px' }, oninput: function (e) { set_no_render('mapName', e.target.value); } }),
      btn(loc('panels.transform.load_map'), { variant: 'secondary', size: 'xs', onclick: function () { post('getMaps'); set({ showMaps: true }); } }),
      btn(loc('panels.transform.save') + (S.mapId != null ? ' #' + S.mapId : ''), { size: 'xs', onclick: function () { post('saveMap', { name: S.mapName || loc('topbar.untitled'), category: 'general', permanent: true }); } }),
      btn(loc('panels.transform.clone'), { variant: 'secondary', size: 'xs', onclick: function () { post('clone'); }, disabled: !sel }),
      btn(loc('panels.transform.undo_hide'), { variant: 'secondary', size: 'xs', onclick: function () { post('worldUndo'); } }),
      btn(loc('panels.transform.delete'), { variant: 'destructive', size: 'xs', disabled: !sel, onclick: function () { post('deleteSelected'); } })
    ]);

    var col2 = toolsCol(loc('panels.transform.snap_steps'), [
      toggleGroup(
        ['grid', 'surface', 'angle', 'snap'].map(function (k) { return { value: k, label: loc('panels.transform.snap_' + k) }; }),
        function (k) { return !!S.snap[k]; },
        function (k) { var v = !S.snap[k]; var ns = Object.assign({}, S.snap); ns[k] = v; set({ snap: ns }); var p = {}; p[k] = v; post('setSnap', p); }, 4),
      el('div', { class: 'tool-grp' }, [
        el('span', { class: 'tg-lbl', text: loc('panels.transform.step') }),
        toggleGroup(
          [0.01, 0.05, 0.1, 0.25, 0.5, 1].map(function (s) { return { value: s, label: String(s) }; }),
          function (s) { return S.step === s; },
          function (s) { set({ step: s }); post('setStep', { step: s }); }, 6),
      ]),
      el('div', { class: 'tool-grp' }, [
        el('span', { class: 'tg-lbl', text: loc('panels.transform.angle') }),
        toggleGroup(
          [1, 2, 5, 15, 45].map(function (a) { return { value: a, label: a + '\u00b0' }; }),
          function (a) { return S.angleStep === a; },
          function (a) { set({ angleStep: a }); post('setAngle', { angle: a }); }, 5),
      ])
    ]);

    var c = sel ? sel.coords : { x: 0, y: 0, z: 0 };
    var rr = sel ? sel.rot : { x: 0, y: 0, z: 0 };
    var col3 = toolsCol(loc('panels.transform.workspace'), [
      el('div', { class: 'upper', style: { fontSize: '10px', marginBottom: '4px' }, text: loc('panels.transform.position') }),
      el('div', { class: 'f131-row' }, [
        coordBox('X', c.x, S.step, function (v) { post('setTransform', { coords: { x: v, y: c.y, z: c.z } }); }),
        coordBox('Y', c.y, S.step, function (v) { post('setTransform', { coords: { x: c.x, y: v, z: c.z } }); }),
        coordBox('Z', c.z, S.step, function (v) { post('setTransform', { coords: { x: c.x, y: c.y, z: v } }); }),
      ]),
      el('div', { class: 'upper', style: { fontSize: '10px', marginTop: '8px', marginBottom: '4px' }, text: loc('panels.transform.rotation') }),
      el('div', { class: 'f131-row' }, [
        coordBox('RX', rr.x, S.angleStep, function (v) { post('setTransform', { rot: { x: v, y: rr.y, z: rr.z } }); }),
        coordBox('RY', rr.y, S.angleStep, function (v) { post('setTransform', { rot: { x: rr.x, y: v, z: rr.z } }); }),
        coordBox('RZ', rr.z, S.angleStep, function (v) { post('setTransform', { rot: { x: rr.x, y: rr.y, z: v } }); }),
      ])
    ]);

    var col4 = null, col5 = null;
    if (sel) {
      var npApply = function (patch) { var np = Object.assign({}, sel.props || {}, patch); sel.props = np; set({ selected: sel }); post('setObjectProps', { props: patch }); };
      var npApplyLive = function (patch, live) { sel.props = Object.assign({}, sel.props || {}, patch); post('setObjectProps', { props: patch, live: live === true }); };
      var npIsOn = function (k) { return (sel.props || {})[k] !== false; };
      var npToggleBtn = function (k, label) { return btn(label, { variant: npIsOn(k) ? 'primary' : 'secondary', size: 'sm', onclick: function () { var p = {}; p[k] = !npIsOn(k); npApply(p); } }); };

      col4 = toolsCol(loc('panels.objects.title'), [
        el('div', { class: 'grid2' }, [
          btn(loc('panels.objects.teleport'), { variant: 'secondary', size: 'sm', onclick: function () { post('teleportTo', { id: sel.id }); } }),
          btn(loc('panels.objects.copy'), { variant: 'secondary', size: 'sm', onclick: function () { post('copy'); } }),
        ]),
        el('div', { class: 'grid3', style: { marginTop: '8px' } }, [npToggleBtn('collision', loc('panels.objects.collision')), npToggleBtn('frozen', loc('panels.objects.freeze')), npToggleBtn('visible', loc('panels.objects.visible'))]),
        el('div', { class: 'grid2', style: { marginTop: '8px' } }, [
          btn(loc('panels.objects.place_ground'), { variant: 'secondary', size: 'sm', onclick: function () { post('ground'); } }),
          btn(loc('panels.objects.apply_gravity'), { variant: 'secondary', size: 'sm', onclick: function () { post('gravity'); } }),
        ]),
        el('div', { class: 'grid2', style: { marginTop: '8px' } }, [
          btn(loc('panels.objects.reset_pos'), { variant: 'secondary', size: 'sm', onclick: function () { post('resetTransform', { pos: true }); } }),
          btn(loc('panels.objects.reset_rot'), { variant: 'secondary', size: 'sm', onclick: function () { post('resetTransform', { rot: true }); } }),
        ]),
        el('div', { style: { marginTop: '10px' } }, [
          sliderBox(loc('panels.objects.alpha'), sel.props && sel.props.alpha != null ? sel.props.alpha : 255, 0, 255, 5, function (v, live) { npApplyLive({ alpha: v }, live); }),
        ]),
        el('div', { style: { marginTop: '6px' } }, [
          sliderBox(loc('panels.objects.lod'), sel.props && sel.props.lod != null ? sel.props.lod : 500, 50, 3000, 50, function (v, live) { npApplyLive({ lod: v }, live); }),
        ])
      ]);

      var blip = sel.blip || { name: '', color: 0, on: false };
      var blipF = function (patch) { sel.blip = Object.assign({}, blip, patch); set({ selected: sel }); post('setBlip', patch); };

      var blipBox = el('div');
      blipBox.appendChild(el('button', { class: 'btn btn-' + (blip.on ? 'primary' : 'secondary') + ' btn-sm blip-toggle', onclick: function () { blipF({ on: !blip.on }); } }, [
        el('span', { text: loc('panels.objects.map_blip') }),
        el('span', { class: 'blip-state', text: blip.on ? loc('common.on') : loc('common.off') }),
      ]));

      var col4Body = col4.querySelector('.tools-col-body');
      if (col4Body) append(col4Body, [
        blipBox,
        el('div', { class: 'flex', style: { gap: '6px', marginTop: '8px' } }, [
          el('input', { class: 'input h8 mono', placeholder: loc('panels.objects.new_model'), value: _replaceModel, oninput: function (e) { _replaceModel = e.target.value; } }),
          btn(loc('panels.objects.replace'), { variant: 'secondary', size: 'sm', onclick: function () { if (_replaceModel.trim()) { post('replaceModel', { model: _replaceModel.trim() }); _replaceModel = ''; renderTools(); } } })
        ])
      ]);
    }

    var brushEls = [];
    if (S.brushActive) {
      brushEls.push(
        el('div', { class: 'row-mid', style: { marginTop: '6px' } }, [
          el('span', { class: 'upper', style: { width: '48px' }, text: loc('panels.transform.radius') }),
          el('input', { type: 'range', class: 'rng', min: '1', max: '40', step: '0.5', value: String(S.brushRadius), style: { flex: '1' }, oninput: function (e) { set_no_render('brushRadius', +e.target.value); post('brushRadius', { r: +e.target.value }); } })
        ]),
        el('div', { class: 'row-mid', style: { marginTop: '6px' } }, [
          el('span', { class: 'upper', style: { width: '48px' }, text: loc('panels.transform.density') }),
          el('input', { type: 'range', class: 'rng', min: '1', max: '20', step: '1', value: String(S.brushDensity), style: { flex: '1' }, oninput: function (e) { set_no_render('brushDensity', +e.target.value); post('brushDensity', { d: +e.target.value }); } })
        ]),
        el('div', { class: 'grid2', style: { marginTop: '6px' } }, [
          btn(loc('panels.transform.align'), { variant: S.brushAlign ? 'primary' : 'secondary', size: 'xs', onclick: function () { var v = !S.brushAlign; set({ brushAlign: v }); post('brushAlign', { on: v }); } }),
          btn(loc('panels.transform.rnd_yaw'), { variant: S.brushYaw ? 'primary' : 'secondary', size: 'xs', onclick: function () { var v = !S.brushYaw; set({ brushYaw: v }); post('brushYaw', { on: v }); } })
        ]),
        btn(loc('panels.transform.scatter_burst'), { variant: 'secondary', size: 'sm', block: true, style: { marginTop: '6px' }, onclick: function () { post('brushScatter'); } })
      );
    }

    var col2Body = col2.querySelector('.tools-col-body');
    if (col2Body) {
      var c2tools = el('div', { class: 'col2-tools' });
      append(c2tools, [
        btn(S.bulkActive ? loc('panels.transform.bulk_count', S.bulkCount) : loc('panels.transform.bulk_select'), { variant: S.bulkActive ? 'primary' : 'secondary', size: 'xs', onclick: function () { post('bulkToggle', { on: !S.bulkActive }); } }),
        S.bulkActive ? el('div', { class: 'grid2' }, [
          btn(S.bulkGrabbing ? loc('panels.transform.drop') : loc('panels.transform.move'), { variant: S.bulkGrabbing ? 'primary' : 'secondary', size: 'xs', disabled: !S.bulkCount, onclick: function () { post('bulkGrab'); } }),
          btn(loc('panels.transform.ground'), { variant: 'secondary', size: 'xs', disabled: !S.bulkCount, onclick: function () { post('bulkGround'); } }),
          btn(loc('panels.transform.clear'), { variant: 'secondary', size: 'xs', disabled: !S.bulkCount, onclick: function () { post('bulkClear'); } }),
          btn(loc('panels.transform.delete'), { variant: 'destructive', size: 'xs', disabled: !S.bulkCount, onclick: function () { post('bulkDelete'); } })
        ]) : null,
        btn(S.brushActive ? loc('panels.transform.brush_on') : loc('panels.transform.brush_paint'), { variant: S.brushActive ? 'primary' : 'secondary', size: 'xs', disabled: (!S.build && !S.brushActive), onclick: function () { var v = !S.brushActive; set({ brushActive: v }); post('brushToggle', { on: v, model: S.build }); } }),
        brushEls.length > 0 ? el('div', {}, brushEls) : null
      ]);
      col2Body.appendChild(c2tools);
    }

    var cols = [];
    if (sel) {
      var objBody = col4 && col4.querySelector('.tools-col-body');
      var wsBody = col3.querySelector('.tools-col-body');
      var col2Body3 = col2.querySelector('.tools-col-body');
      var col1Body3 = col1.querySelector('.tools-col-body');
      var toolsBlock = col2Body3 && col2Body3.querySelector('.col2-tools');
      if (objBody && toolsBlock) {
        objBody.appendChild(el('div', { class: 'tools-merge-sep' }));
        objBody.appendChild(toolsBlock);
      }
      if (wsBody && col2Body3) {
        wsBody.appendChild(el('div', { class: 'tools-merge-sep' }));
        while (col2Body3.firstChild) wsBody.appendChild(col2Body3.firstChild);
      }
      if (objBody && col1Body3) {
        objBody.appendChild(el('div', { class: 'tools-merge-sep' }));
        objBody.appendChild(el('span', { class: 'tg-lbl', text: loc('panels.transform.map') }));
        while (col1Body3.firstChild) objBody.appendChild(col1Body3.firstChild);
      }
      if (col4) cols.push(col4);
      cols.push(col3);
      if (blip.on) {
        var blipCol = toolsCol(loc('panels.objects.map_blip'), []);
        var bcBody = blipCol.querySelector('.tools-col-body');
        if (bcBody) {
          bcBody.appendChild(el('input', { class: 'input h8', placeholder: loc('placeholder.blip_name'), value: blip.name || '', oninput: function (e) { sel.blip = Object.assign({}, sel.blip || {}, { name: e.target.value }); post('setBlip', { name: e.target.value }); } }));
          var sw = el('div', { class: 'blip-row', style: { marginTop: '6px' } });
          BLIP_COLORS.forEach(function (bc) { sw.appendChild(el('button', { class: 'blip-sw' + (blip.color === bc[1] ? ' on' : ''), title: loc(bc[0]), style: { background: bc[2] }, onclick: function () { blipF({ color: bc[1] }); } })); });
          bcBody.appendChild(sw);
        }
        cols.splice(col4 ? 1 : 0, 0, blipCol);
      }
    } else {
      cols.push(col2);
      cols.push(col1);
    }

    for (var ci = 0; ci < cols.length; ci++) panel.appendChild(cols[ci]);
  }

  return wrapper;
}

function set_no_render(key, val) { S[key] = val; }

var _lastFloatSig = null;
var _floatingCardEl = null;

function renderFloatingEdit(forceRebuild) {
  if (_sliderDragging) return;
  var sel = S.selected;
  if (!S.open || !sel || S.showTools || !S.cardOpen) {
    clear(R.floatingEdit);
    _floatingCardEl = null;
    _lastFloatSig = null;
    return;
  }

  if (!R.floatingEdit.style.width) {
    R.floatingEdit.style.position = 'absolute';
    R.floatingEdit.style.left = '0';
    R.floatingEdit.style.top = '0';
    R.floatingEdit.style.width = '100%';
    R.floatingEdit.style.height = '100%';
    R.floatingEdit.style.pointerEvents = 'none';
  }

  function position() {
    if (!_floatingCardEl) return;
    var vw = R.floatingEdit.clientWidth || window.innerWidth, vh = R.floatingEdit.clientHeight || window.innerHeight;
    var gOn = S.gizmoPos && S.gizmoPos.on;
    var x = (gOn ? S.gizmoPos.x : 0.5) * vw, y = (gOn ? S.gizmoPos.y : 0.45) * vh;
    var rect = _floatingCardEl.getBoundingClientRect();
    var mz = _uiZoom();
    var w = (rect.width / mz) || 236, h = (rect.height / mz) || 320;
    var left = x - w / 2;
    var top = y - h - vh * 0.03;
    if (left < 8) left = 8; else if (left + w > vw - 8) left = vw - w - 8;
    if (top < 8) top = 8; else if (top + h > vh - 8) top = vh - h - 8;
    _floatingCardEl.style.left = '0px';
    _floatingCardEl.style.top = '0px';
    _floatingCardEl.style.transform = 'translate3d(' + Math.round(left) + 'px,' + Math.round(top) + 'px,0)';
  }

  var p = sel.props || {};
  var sig = sel.id + '|' + sel.model
    + '|' + (p.collision !== false ? 1 : 0) + (p.frozen !== false ? 1 : 0) + (p.visible !== false ? 1 : 0);
  if (sig !== _lastFloatSig) { forceRebuild = true; _lastFloatSig = sig; }

  var feFocused = _floatingCardEl && R.floatingEdit.contains(_floatingCardEl) && document.activeElement && _floatingCardEl.contains(document.activeElement) && document.activeElement.tagName === 'INPUT';
  if (feFocused) { position(); return; }
  if (!forceRebuild && _floatingCardEl && R.floatingEdit.contains(_floatingCardEl)) { position(); return; }

  clear(R.floatingEdit);

  var apply = function (patch) { sel.props = Object.assign({}, sel.props || {}, patch); set({ selected: sel }); post('setObjectProps', { props: patch }); };
  var isOn = function (k) { return (sel.props || {})[k] !== false; };

  var card = el('div', { class: 'floating-panel fmenu-card po' });
  _floatingCardEl = card;
  card.appendChild(el('div', { class: 'cam' }));

  var header = el('div', { class: 'fmenu-head' });
  header.appendChild(el('span', { class: 'fmenu-title', text: pretty(sel.model) }));
  var hdrRight = el('div', { class: 'fmenu-hbtns' });
  var expandBtn = el('button', { class: 'fmenu-hbtn tooltip tooltip-b', 'data-tooltip': loc('floating.expand'), onclick: function () { set({ showTools: true }); } });
  expandBtn.appendChild(iconEl('expand', 13));
  hdrRight.appendChild(expandBtn);
  hdrRight.appendChild(el('button', { class: 'fmenu-hbtn', text: '✕', onclick: function () { post('deselect'); } }));
  header.appendChild(hdrRight);
  card.appendChild(header);

  var menu = el('div', { class: 'fmenu' });
  var frow = function (icon, label, sc, onclick, danger) {
    var rw = el('div', { class: 'fmenu-row' + (danger ? ' danger' : ''), onclick: onclick });
    rw.appendChild(iconEl(icon, 14, 'fmenu-ic'));
    rw.appendChild(el('span', { class: 'fmenu-lbl', text: label }));
    if (sc) rw.appendChild(el('span', { class: 'fmenu-sc', text: sc }));
    return rw;
  };
  var ftoggle = function (key, label) {
    var on = isOn(key);
    var rw = el('div', { class: 'fmenu-row', onclick: function () { var x = {}; x[key] = !isOn(key); apply(x); } });
    rw.appendChild(el('span', { class: 'fmenu-chk' + (on ? ' on' : '') }));
    rw.appendChild(el('span', { class: 'fmenu-lbl', text: label }));
    return rw;
  };
  var fsep = function () { return el('div', { class: 'fmenu-sep' }); };

  menu.appendChild(frow('target', loc('panels.objects.teleport'), '', function () { post('teleportTo', { id: sel.id }); }));
  menu.appendChild(frow('layers', loc('panels.objects.clone'), '', function () { post('clone'); }));
  menu.appendChild(frow('copy', loc('panels.objects.copy'), 'Ctrl C', function () { post('copy'); }));
  menu.appendChild(fsep());
  menu.appendChild(ftoggle('collision', loc('panels.objects.collision')));
  menu.appendChild(ftoggle('frozen', loc('panels.objects.freeze')));
  menu.appendChild(ftoggle('visible', loc('panels.objects.visible')));
  menu.appendChild(fsep());
  menu.appendChild(frow('ground', loc('panels.objects.place_ground'), '', function () { post('ground'); }));
  menu.appendChild(frow('gravity', loc('panels.objects.apply_gravity'), '', function () { post('gravity'); }));
  menu.appendChild(frow('refresh', loc('panels.objects.reset_pos'), '', function () { post('resetTransform', { pos: true }); }));
  menu.appendChild(frow('refresh', loc('panels.objects.reset_rot'), '', function () { post('resetTransform', { rot: true }); }));
  menu.appendChild(fsep());
  menu.appendChild(frow('trash', loc('panels.objects.delete'), 'X', function () { post('deleteSelected'); }, true));

  card.appendChild(menu);
  R.floatingEdit.appendChild(card);
  position();
}

function panelTag(iconName, title) {
  var t = el('div', { class: 'panel-tag' });
  var ic = el('div', { class: 'panel-ic' });
  ic.appendChild(iconEl(iconName, 13));
  t.appendChild(ic);
  t.appendChild(el('span', { class: 'panel-title', text: title }));
  return t;
}
function panelHead(iconName, title, onClose) {
  var h = el('div', { class: 'panel-head' });
  var ic = el('div', { class: 'panel-ic' });
  ic.appendChild(iconEl(iconName, 14));
  h.appendChild(ic);
  h.appendChild(el('span', { class: 'panel-title', text: title }));
  if (onClose) {
    var x = el('button', { class: 'panel-x', 'data-tooltip': loc('common.close'), onclick: onClose });
    x.appendChild(iconEl('x', 13));
    h.appendChild(x);
  }
  return h;
}
function renderLight() {
  if (_sliderDragging && S.showLight) return;
  clear(R.light);
  if (!S.open || !S.showLight) return;
  var L = S.light;
  var panel = hoverable(el('div', { class: 'light-panel card po' }));
  panel.appendChild(panelHead('bulb', loc('panels.light.title'), function () { set({ showLight: false }); if (S.light.placing) post('lightToggle', { on: false }); }));
  var pre = el('div', { class: 'light-presets' });
  LIGHT_PRESETS.forEach(function (p) {
    var b = el('button', { class: 'light-preset', onclick: function () { post('lightColor', { r: p[1], g: p[2], b: p[3] }); } });
    b.appendChild(el('span', { class: 'light-dot', style: { background: 'rgb(' + p[1] + ',' + p[2] + ',' + p[3] + ')' } })); append(b, loc(p[0]));
    pre.appendChild(b);
  });
  panel.appendChild(pre);
  function slider(label, min, max, step, val, fmt, on) {
    var row = el('div', { class: 'row-mid', style: { marginBottom: '8px' } });
    var sp = el('span', { class: 'tnum', text: fmt(val) });
    row.appendChild(el('span', { class: 'upper', style: { width: '64px' }, text: label }));
    row.appendChild(el('input', { type: 'range', class: 'rng', min: String(min), max: String(max), step: String(step), value: String(val), style: { flex: '1' }, oninput: function (e) { sp.textContent = fmt(+e.target.value); on(+e.target.value); } }));
    row.appendChild(sp); return row;
  }
  panel.appendChild(slider(loc('panels.light.range'), 2, 50, 1, L.range, function (v) { return v.toFixed(0); }, function (v) { set_no_render('light', Object.assign({}, S.light, { range: v })); post('lightRange', { range: v }); }));
  panel.appendChild(slider(loc('panels.light.intensity'), 1, 20, 0.5, L.intensity, function (v) { return v.toFixed(1); }, function (v) { set_no_render('light', Object.assign({}, S.light, { intensity: v })); post('lightIntensity', { intensity: v }); }));
  panel.appendChild(btn(L.placing ? loc('panels.light.placing') : loc('panels.light.place_lights'), { variant: L.placing ? 'primary' : 'secondary', block: true, class: 'light-place-btn', onclick: function () { post('lightToggle', { on: !L.placing }); } }));
  panel.appendChild(el('div', { class: 'between', style: { marginTop: '8px', fontSize: '11px', color: 'var(--muted-fg)' } }, [
    el('span', { text: L.count === 1 ? loc('panels.light.count_one', L.count) : loc('panels.light.count_many', L.count) }),
    el('button', { style: { background: 'transparent', color: 'var(--muted-fg)' }, text: loc('panels.light.clear_all'), onclick: function () { post('lightClear'); } }),
  ]));
  panel.appendChild(el('div', { class: 'label', style: { display: 'block', margin: '10px 0 5px' }, text: loc('panels.light.placed') }));
  var llist = L.list || [];
  var lwrap = el('div', { class: 'scroller', style: { maxHeight: '170px', overflowY: 'auto', display: 'flex', flexDirection: 'column', gap: '4px' } });
  if (!llist.length) {
    lwrap.appendChild(el('div', { class: 'dl-empty', text: loc('panels.light.no_lights') }));
  } else {
    llist.forEach(function (lt) {
      var row = el('div', { class: 'between', style: { gap: '6px', padding: '4px 6px', borderRadius: '3px', background: 'rgba(255,255,255,0.04)' } });
      var left = el('div', { style: { display: 'flex', alignItems: 'center', gap: '6px', minWidth: '0' } });
      left.appendChild(el('span', { style: { width: '12px', height: '12px', borderRadius: '50%', flex: '0 0 auto', background: 'rgb(' + lt.r + ',' + lt.g + ',' + lt.b + ')', boxShadow: '0 0 6px rgb(' + lt.r + ',' + lt.g + ',' + lt.b + ')' } }));
      left.appendChild(el('span', { style: { fontSize: '11px', color: 'var(--muted-fg)', whiteSpace: 'nowrap' }, text: loc('panels.light.row', Math.round(lt.range), lt.intensity) }));
      var acts = el('div', { style: { display: 'flex', gap: '4px', flex: '0 0 auto' } });
      acts.appendChild(btn(loc('panels.light.teleport'), { variant: 'secondary', size: 'sm', onclick: function () { post('teleportTo', { x: lt.x, y: lt.y, z: lt.z }); } }));
      acts.appendChild(btn(loc('panels.light.del'), { variant: 'destructive', size: 'sm', onclick: function () { post('removeLight', { id: lt.id }); } }));
      row.appendChild(left); row.appendChild(acts);
      lwrap.appendChild(row);
    });
  }
  panel.appendChild(lwrap);
  R.light.appendChild(panel);
}

function renderFill() {
  if (_sliderDragging && S.showFill) return;
  clear(R.fill);
  if (!S.open || !S.showFill) return;
  var f = S.fill;
  var bar = hoverable(el('div', { class: 'fillbar po' }));
  bar.appendChild(panelTag('hexagon', loc('panels.fill.title')));

  var polyWrap = el('div', { class: 'center', style: { gap: '6px' } });
  polyWrap.appendChild(el('span', { class: 'upper', text: loc('panels.fill.polygon') }));
  if (f.ready) polyWrap.appendChild(el('span', { class: 'fb-box', text: loc('panels.fill.ngon_ready', f.vcount) }));
  else polyWrap.appendChild(el('span', { class: 'warn-text', text: f.picking ? loc('panels.fill.click_corners', f.vcount) : loc('panels.fill.no_area') }));
  bar.appendChild(polyWrap);

  bar.appendChild(el('div', { class: 'panel-sep' }));
  var spWrap = el('div', { class: 'center', style: { gap: '6px' } });
  var spv = el('span', { class: 'tnum', text: f.spacing.toFixed(1), style: { width: '24px' } });
  spWrap.appendChild(el('span', { class: 'upper', text: loc('panels.fill.spacing') }));
  spWrap.appendChild(el('input', { type: 'range', class: 'rng', min: '0.5', max: '20', step: '0.5', value: String(f.spacing), style: { width: '96px' }, oninput: function (e) { spv.textContent = (+e.target.value).toFixed(1); set_no_render('fill', Object.assign({}, S.fill, { spacing: +e.target.value })); post('fillSpacing', { spacing: +e.target.value }); } }));
  spWrap.appendChild(spv); bar.appendChild(spWrap);

  function seg(label, on, click) { return el('button', { class: 'fb-seg' + (on ? ' on' : ''), text: label, onclick: click }); }
  bar.appendChild(el('div', { class: 'center', style: { gap: '4px' } }, [el('span', { class: 'upper fill-cat', text: loc('panels.fill.layout') }),
  seg(loc('panels.fill.grid'), f.layout === 'grid', function () { post('fillLayout', { layout: 'grid' }); }), seg(loc('panels.fill.random'), f.layout === 'random', function () { post('fillLayout', { layout: 'random' }); })]));
  bar.appendChild(el('div', { class: 'center', style: { gap: '4px' } }, [el('span', { class: 'upper fill-cat', text: loc('panels.fill.heading') }),
  seg(loc('panels.fill.random'), f.heading === 'random', function () { post('fillHeading', { heading: 'random' }); }), seg(loc('panels.fill.fixed'), f.heading === 'fixed', function () { post('fillHeading', { heading: 'fixed' }); })]));

  bar.appendChild(el('div', { class: 'panel-sep' }));
  bar.appendChild(btn(loc('panels.fill.reselect'), { variant: 'secondary', size: 'sm', icon: 'refresh', iconSize: 13, onclick: function () { post('fillReselect'); } }));
  if (f.picking) bar.appendChild(btn(loc('panels.fill.undo_point'), { variant: 'secondary', size: 'sm', disabled: !f.vcount, onclick: function () { post('fillUndo'); } }));
  if (f.picking) bar.appendChild(btn(loc('panels.fill.finish_area'), { size: 'sm', disabled: f.vcount < 3, onclick: function () { post('fillFinish'); } }));
  bar.appendChild(btn(loc('panels.fill.fill'), { size: 'sm', disabled: (!f.ready || !S.build), onclick: function () { post('fillDo'); } }));
  bar.appendChild(btn(loc('panels.fill.cancel'), { variant: 'destructive', size: 'sm', onclick: function () { set({ showFill: false }); post('fillToggle', { on: false }); } }));
  if (!S.build) bar.appendChild(el('span', { class: 'warn-text', text: loc('panels.fill.pick_prop') }));
  R.fill.appendChild(bar);
}

function renderArray() {
  if (_sliderDragging && S.array.active) return;
  clear(R.array);
  if (!S.open || !S.array.active) return;
  var a = S.array;
  var bar = hoverable(el('div', { class: 'fillbar po' }));
  bar.appendChild(panelTag('layers', loc('panels.array.title')));

  function seg(label, on, click) { return el('button', { class: 'fb-seg' + (on ? ' on' : ''), text: label, onclick: click }); }
  bar.appendChild(el('div', { class: 'center', style: { gap: '4px' } }, [
    seg(loc('panels.array.linear'), a.pattern === 'linear', function () { post('arrayPattern', { pattern: 'linear' }); }),
    seg(loc('panels.array.radial'), a.pattern === 'radial', function () { post('arrayPattern', { pattern: 'radial' }); }),
    seg(loc('panels.array.grid'), a.pattern === 'grid', function () { post('arrayPattern', { pattern: 'grid' }); }),
  ]));
  bar.appendChild(el('div', { class: 'panel-sep' }));

  function num(label, key, min, max, step, val) {
    var sp = el('span', { class: 'tnum', text: String(val), style: { width: '34px' } });
    return el('div', { class: 'center', style: { gap: '6px' } }, [
      el('span', { class: 'upper', text: label }),
      el('input', { type: 'range', class: 'rng', min: String(min), max: String(max), step: String(step), value: String(val), style: { width: '90px' },
        oninput: function (e) { sp.textContent = e.target.value; post('arrayParam', { key: key, value: +e.target.value }); } }),
      sp,
    ]);
  }

  if (a.pattern === 'linear') {
    bar.appendChild(num(loc('panels.array.count'), 'count', 2, 50, 1, a.count));
    bar.appendChild(num(loc('panels.array.spacing'), 'spacing', 0.5, 30, 0.5, a.spacing));
    bar.appendChild(num(loc('panels.array.heading'), 'heading', 0, 360, 5, a.heading));
  } else if (a.pattern === 'grid') {
    bar.appendChild(num(loc('panels.array.rows'), 'rows', 1, 30, 1, a.rows));
    bar.appendChild(num(loc('panels.array.cols'), 'cols', 1, 30, 1, a.cols));
    bar.appendChild(num(loc('panels.array.gap_x'), 'spacingX', 0.5, 30, 0.5, a.spacingX));
    bar.appendChild(num(loc('panels.array.gap_y'), 'spacingY', 0.5, 30, 0.5, a.spacingY));
    bar.appendChild(num(loc('panels.array.heading'), 'heading', 0, 360, 5, a.heading));
  } else {
    bar.appendChild(num(loc('panels.array.count'), 'count', 2, 60, 1, a.count));
    bar.appendChild(num(loc('panels.array.radius'), 'radius', 1, 50, 0.5, a.radius));
    bar.appendChild(seg(loc('panels.array.face_center'), a.faceCenter, function () { post('arrayParam', { key: 'faceCenter', value: !a.faceCenter }); }));
  }

  bar.appendChild(el('div', { class: 'panel-sep' }));
  bar.appendChild(el('span', { class: 'fb-box', text: loc('panels.array.preview', a.preview) }));
  bar.appendChild(btn(loc('panels.array.apply'), { size: 'sm', onclick: function () { post('arrayApply'); } }));
  bar.appendChild(btn(loc('panels.array.cancel'), { variant: 'destructive', size: 'sm', onclick: function () { post('arrayToggle', { on: false }); } }));
  R.array.appendChild(bar);
}

function renderAlign() {
  clear(R.align);
  if (!S.open || !S.align.active) return;
  var bar = hoverable(el('div', { class: 'fillbar po' }));
  bar.appendChild(panelTag('marquee', loc('panels.align.title')));

  if (S.align.count < 1) {
    bar.appendChild(el('span', { class: 'warn-text', text: loc('panels.align.select_marquee') }));
    bar.appendChild(btn(loc('panels.align.close'), { variant: 'destructive', size: 'sm', onclick: function () { post('alignToggle', { on: false }); } }));
    R.align.appendChild(bar);
    return;
  }

  function sbtn(label, onclick, title) { return el('button', { class: 'fb-seg', text: label, title: title || label, onclick: onclick }); }

  var rows = [
    ['X', 'x', [loc('panels.align.left'), loc('panels.align.center'), loc('panels.align.right')]],
    ['Y', 'y', [loc('panels.align.back'), loc('panels.align.center'), loc('panels.align.front')]],
    ['Z', 'z', [loc('panels.align.bottom'), loc('panels.align.center'), loc('panels.align.top')]],
  ];
  var modes = ['min', 'mid', 'max'];
  rows.forEach(function (r) {
    var grp = el('div', { class: 'center', style: { gap: '3px' } }, [el('span', { class: 'upper', text: r[0] })]);
    r[2].forEach(function (lbl, i) {
      grp.appendChild(sbtn(lbl, (function (axis, mode) { return function () { post('alignDo', { axis: axis, mode: mode }); }; })(r[1], modes[i])));
    });
    bar.appendChild(grp);
  });

  bar.appendChild(el('div', { class: 'panel-sep' }));
  bar.appendChild(el('div', { class: 'center', style: { gap: '3px' } }, [
    el('span', { class: 'upper', text: loc('panels.align.dist') }),
    sbtn('X', function () { post('distributeDo', { axis: 'x' }); }, loc('panels.align.dist_x')),
    sbtn('Y', function () { post('distributeDo', { axis: 'y' }); }, loc('panels.align.dist_y')),
  ]));

  bar.appendChild(el('div', { class: 'panel-sep' }));
  bar.appendChild(el('div', { class: 'center', style: { gap: '3px' } }, [
    el('span', { class: 'upper', text: loc('panels.align.mirror') }),
    sbtn('→X', function () { post('mirrorDo', { dir: 'x+' }); }, loc('panels.align.mirror_xp')),
    sbtn('←X', function () { post('mirrorDo', { dir: 'x-' }); }, loc('panels.align.mirror_xm')),
    sbtn('↑Y', function () { post('mirrorDo', { dir: 'y+' }); }, loc('panels.align.mirror_yp')),
    sbtn('↓Y', function () { post('mirrorDo', { dir: 'y-' }); }, loc('panels.align.mirror_ym')),
  ]));

  bar.appendChild(el('div', { class: 'panel-sep' }));
  bar.appendChild(el('span', { class: 'fb-box', text: loc('panels.align.selected', S.align.count) }));
  bar.appendChild(btn(loc('panels.align.close'), { variant: 'secondary', size: 'sm', onclick: function () { post('alignToggle', { on: false }); } }));
  R.align.appendChild(bar);
}

function modalShell(regionKey, titleNode, bodyNode, opts) {
  opts = opts || {};
  var ov = hoverable(el('div', { class: 'overlay po' + (opts.dark ? ' dark' : '') }));
  var modal = el('div', { class: 'modal card ' + (opts.cls || '') });
  if (titleNode) {
    var mh = el('div', { class: 'modal-h panel-head' });
    if (opts.icon) { var ic = el('div', { class: 'panel-ic' }); ic.appendChild(iconEl(opts.icon, 14)); mh.appendChild(ic); }
    mh.appendChild(titleNode);
    var xb = el('button', { class: 'panel-x', onclick: opts.onClose });
    xb.appendChild(iconEl('x', 13));
    mh.appendChild(xb);
    modal.appendChild(mh);
  }
  modal.appendChild(bodyNode);
  ov.appendChild(modal);
  return ov;
}

function renderLogs() {
  clear(R.logs);
  if (!S.open || !S.showLogs) return;
  var list = el('div', { class: 'logs-list scroller' });
  if (!S.logs.length) list.appendChild(el('div', { class: 'pad', style: { padding: '16px', fontSize: '14px', color: 'var(--muted-fg)' }, text: loc('panels.logs.empty') }));
  S.logs.forEach(function (l) {
    var row = el('div', { class: 'log-row' });
    row.appendChild(el('div', { class: 'lh' }, [el('span', { class: 'act', text: l.action }), el('span', { class: 'meta', text: (l.name || '—') + ' · ' + (l.created_at || '') })]));
    if (l.detail) row.appendChild(el('div', { class: 'det', text: l.detail }));
    list.appendChild(row);
  });
  R.logs.appendChild(modalShell('logs', el('span', { class: 't', text: loc('panels.logs.title') }), list, { cls: 'logs-modal', icon: 'list', onClose: function () { set({ showLogs: false }); } }));
}

var _ioTab = 'json';
var _ioPublished = false;
var _ioImport = '';
function renderIO() {
  clear(R.io);
  if (!S.open || !S.showIO) return;
  var IO_TEXTS = { json: S.ioJson, lua: S.ioLua, ymap: S.ioYmap, menyoo: S.ioMenyoo, csv: S.ioCsv };
  var text = IO_TEXTS[_ioTab] || '';
  var body = el('div', { class: 'io-body scroller' });
  var tabsWrap = el('div');
  var tabs = el('div', { class: 'io-tabs' });
  ['json', 'lua', 'ymap', 'menyoo', 'csv'].forEach(function (t) { tabs.appendChild(el('button', { class: 'io-tab' + (_ioTab === t ? ' on' : ''), text: t.toUpperCase(), onclick: function () { _ioTab = t; renderIO(); } })); });
  tabs.appendChild(btn(loc('panels.io.copy'), { variant: 'secondary', size: 'sm', class: 'ml-auto', onclick: function () { var ok = copyText(text); toast(ok ? loc('panels.io.copied') : loc('panels.io.copy_failed'), 1500); } }));
  tabs.lastChild.style.marginLeft = 'auto';
  tabsWrap.appendChild(tabs);
  if (_ioTab === 'ymap') {
    var pubRow = el('div', { class: 'between', style: { gap: '8px', margin: '6px 0 0' } });
    pubRow.appendChild(el('span', { style: { fontSize: '11px', color: 'var(--muted-fg)' }, text: loc('panels.io.objects_only') }));
    pubRow.appendChild(btn(_ioPublished ? loc('panels.io.published') : loc('panels.io.publish_ymap'), { variant: 'primary', size: 'sm', disabled: _ioPublished, onclick: function () { if (_ioPublished) return; _ioPublished = true; post('publishYmap'); toast(loc('toast.publishing'), 2500); renderIO(); } }));
    tabsWrap.appendChild(pubRow);
    tabsWrap.appendChild(el('div', { style: { fontSize: '11px', color: 'var(--warn)', margin: '4px 0 0' }, text: loc('panels.io.ymap_order') }));
    tabsWrap.appendChild(el('div', { style: { fontSize: '10px', color: 'var(--warn)', margin: '4px 0 0' }, text: loc('panels.io.publish_once') }));
    if (S.ioCustomCount > 0) {
      tabsWrap.appendChild(el('div', { style: { fontSize: '11px', color: 'var(--muted-fg)', margin: '4px 0 0' }, text: loc('panels.io.custom_props_bundle').replace('%d', S.ioCustomCount) }));
    }
  } else if (_ioTab === 'menyoo' || _ioTab === 'csv') {
    tabsWrap.appendChild(el('div', { style: { fontSize: '11px', color: 'var(--muted-fg)', margin: '6px 0 0' }, text: loc('panels.io.objects_only') }));
  }
  if (_ioTab !== 'ymap' && S.ioCustomCount > 0) {
    tabsWrap.appendChild(el('div', { style: { fontSize: '11px', color: 'var(--warn)', margin: '6px 0 0' }, text: loc('panels.io.custom_props_warn').replace('%d', S.ioCustomCount) }));
  }
  tabsWrap.appendChild(el('textarea', { class: 'io-ta scroller', readonly: 'true', placeholder: loc('panels.io.export_empty') }, text));
  body.appendChild(tabsWrap);
  body.appendChild(el('hr', { class: 'sep' }));
  var imp = el('div');
  imp.appendChild(el('label', { class: 'label', style: { display: 'block', marginBottom: '6px' }, text: loc('panels.io.import_json') }));
  imp.appendChild(el('div', { style: { fontSize: '11px', color: 'var(--muted-fg)', lineHeight: '1.5', margin: '0 0 8px' }, text: loc('panels.io.merge_hint') }));
  var ta = el('textarea', { class: 'io-ta sm scroller', placeholder: loc('panels.io.import_placeholder'), oninput: function (e) { _ioImport = e.target.value; } }, _ioImport);
  imp.appendChild(ta);
  imp.appendChild(btn(loc('panels.io.import'), { class: 'mt8', disabled: false, onclick: function () { if (ta.value.trim()) { post('importJson', { json: ta.value }); _ioImport = ''; set({ showIO: false }); } } }));
  imp.lastChild.style.marginTop = '8px';
  body.appendChild(imp);
  R.io.appendChild(modalShell('io', el('span', { class: 't', text: loc('panels.io.title') }), body, { cls: 'io-modal', dark: false, icon: 'upload', onClose: function () { set({ showIO: false }); } }));
}

function renderMaps() {
  clear(R.maps);
  if (!S.open || !S.showMaps) return;
  var list = el('div', { class: 'maps-list scroller' });
  if (!S.maps.length) list.appendChild(el('div', { style: { padding: '16px', fontSize: '14px', color: 'var(--muted-fg)' }, text: loc('panels.maps.empty') }));
  S.maps.forEach(function (m) {
    list.appendChild(el('button', { class: 'map-row', onclick: function () { post('loadMap', { id: m.id }); set({ showMaps: false }); } }, [
      el('span', { text: m.name + '  #' + m.id }),
      el('span', { class: 'cat', text: m.category + (m.permanent ? loc('panels.maps.permanent_suffix') : '') }),
    ]));
  });
  R.maps.appendChild(modalShell('maps', el('span', { class: 't', text: loc('panels.maps.title') }), list, { cls: 'maps-modal', icon: 'map', onClose: function () { set({ showMaps: false }); } }));
}

var _objSel = null;
function renderObjects() {
  clear(R.objects);
  if (!S.open || !S.showObjects) return;
  var W = 560, H = 560;
  var b = S.map;
  if (!b) {
    var minX = Infinity, maxX = -Infinity, minY = Infinity, maxY = -Infinity;
    S.objects.forEach(function (o) { minX = Math.min(minX, o.x); maxX = Math.max(maxX, o.x); minY = Math.min(minY, o.y); maxY = Math.max(maxY, o.y); });
    if (!S.objects.length) { minX = 0; maxX = 1; minY = 0; maxY = 1; }
    var pX = (maxX - minX) * 0.12 || 8, pY = (maxY - minY) * 0.12 || 8;
    b = { image: 'map.png', minX: minX - pX, maxX: maxX + pX, minY: minY - pY, maxY: maxY + pY };
  }
  function px(o) { return { left: ((o.x - b.minX) / (b.maxX - b.minX)) * W, top: ((b.maxY - o.y) / (b.maxY - b.minY)) * H }; }
  var selObj = null; for (var i = 0; i < S.objects.length; i++) if (S.objects[i].id === _objSel) selObj = S.objects[i];

  var body = el('div', { class: 'obj-body' });
  var canvas = el('div', {
    class: 'mapcanvas', style: {
      width: W + 'px', height: H + 'px',
      backgroundImage: 'url(images/' + b.image + '), linear-gradient(rgba(255,255,255,0.05) 1px, transparent 1px), linear-gradient(90deg, rgba(255,255,255,0.05) 1px, transparent 1px)',
      backgroundSize: '100% 100%, 32px 32px, 32px 32px', backgroundRepeat: 'no-repeat, repeat, repeat',
    }
  });
  if (!S.objects.length) canvas.appendChild(el('div', { style: { display: 'grid', height: '100%', placeItems: 'center', fontSize: '14px', color: 'var(--muted-fg)' }, text: loc('panels.maps.no_objects') }));
  S.objects.forEach(function (o) {
    var p = px(o);
    var left = Math.max(3, Math.min(W - 3, p.left));
    var top = Math.max(3, Math.min(H - 3, p.top));
    var active = o.id === _objSel;
    var pin = el('button', {
      class: 'pin ' + (active ? 'lg' : 'sm'), title: pretty(o.model),
      style: { left: left + 'px', top: top + 'px', backgroundColor: active ? '#ffffff' : '#54DD72', boxShadow: '0 0 0 1px rgba(0,0,0,0.7)' + (active ? ', 0 0 0 2px #54DD72' : '') },
      onclick: function () { _objSel = o.id; renderObjects(); }
    });
    canvas.appendChild(pin);
  });

  var side = el('div', { class: 'obj-side' });
  side.appendChild(el('div', { class: 'objr-head' }, [
    el('span', { class: 'objr-eyebrow', text: loc('panels.maps.object') }),
    el('span', { class: 'objr-count', text: loc('panels.maps.plotted', S.objects.length) }),
  ]));
  if (selObj) {
    side.appendChild(el('div', { class: 'objr-model' }, [iconEl('hexagon', 12, 'objr-model-ic'), el('span', { text: pretty(selObj.model) })]));
    var coordRows = el('div', { class: 'objr-coords' });
    [['X', selObj.x], ['Y', selObj.y], ['Z', selObj.z]].forEach(function (c) {
      coordRows.appendChild(el('div', { class: 'objr-coord' }, [
        el('span', { class: 'objr-axis', text: c[0] }),
        el('span', { class: 'objr-val', text: c[1].toFixed(1) }),
      ]));
    });
    side.appendChild(coordRows);
    var refresh = function () { post('getObjects').then(function (l) { set({ objects: l || [] }); }); };
    side.appendChild(el('div', { class: 'objr-actions' }, [
      btn(loc('panels.maps.teleport'), { block: true, onclick: function () { post('teleportTo', { id: selObj.id }); set({ showObjects: false }); } }),
      btn(loc('panels.maps.delete'), { variant: 'destructive', block: true, onclick: function () { post('removeObject', { id: selObj.id }).then(refresh); _objSel = null; } }),
    ]));
  } else {
    side.appendChild(el('div', { class: 'objr-empty' }, [
      iconEl('target', 22, 'objr-empty-ic'),
      el('div', { class: 'objr-empty-t', text: loc('panels.maps.select_marker') }),
      el('div', { class: 'objr-empty-s', text: loc('panels.maps.select_marker_hint') }),
    ]));
  }
  body.appendChild(canvas); body.appendChild(side);
  R.objects.appendChild(modalShell('objects', el('span', { class: 't', text: loc('panels.maps.map_plotted', S.objects.length) }), body, { cls: 'obj-modal', dark: true, icon: 'map', onClose: function () { set({ showObjects: false }); } }));
}


function renderBuildBanner() {
  clear(R.buildBanner);
}

function holdRepeat(b, action, data) {
  var t = null;
  b.addEventListener('pointerdown', function (e) { e.preventDefault(); post(action, data); t = setInterval(function () { post(action, data); }, 70); });
  var stop = function () { if (t) { clearInterval(t); t = null; } };
  b.addEventListener('pointerup', stop); b.addEventListener('pointerleave', stop);
  return b;
}
var _wheelHandler = null;
function renderMoveBanner() {
  clear(R.moveBanner);
  if (_wheelHandler) { window.removeEventListener('wheel', _wheelHandler); _wheelHandler = null; }
  if (!S.open || !S.grabbing) return;
  var bn = hoverable(el('div', { class: 'banner po' }));
  bn.appendChild(el('b', { text: loc('banner.moving') }));
  var mb = el('div', { class: 'mbtns' });
  mb.appendChild(holdRepeat(btn('▲', { variant: 'secondary', size: 'xs' }), 'grabHeight', { dir: 1 }));
  mb.appendChild(holdRepeat(btn('▼', { variant: 'secondary', size: 'xs' }), 'grabHeight', { dir: -1 }));
  mb.appendChild(holdRepeat(btn('⟲', { variant: 'secondary', size: 'xs' }), 'grabRotate', { dir: -1 }));
  mb.appendChild(holdRepeat(btn('⟳', { variant: 'secondary', size: 'xs' }), 'grabRotate', { dir: 1 }));
  bn.appendChild(mb);
  bn.appendChild(el('span', { class: 'keys', text: loc('banner.move_keys') }));
  R.moveBanner.appendChild(bn);
  _wheelHandler = function (e) { post('grabHeight', { dir: e.deltaY < 0 ? 1 : -1 }); };
  window.addEventListener('wheel', _wheelHandler, { passive: true });
}

function renderToast() {
  clear(R.toast);
  if (!S.open || !S.toast) return;
  R.toast.appendChild(el('div', { class: 'toast', text: S.toast }));
}

function renderMarquee() {
  clear(R.marquee);
  if (!S.open || !S.bulkActive || S.bulkGrabbing || !S.marqueeOpen) return;
  var layer = el('div', { class: 'marquee po' });
  var box = null;
  layer.addEventListener('mousedown', function (e) {
    if (S.marqueeBlock) return;
    post('marqueeDrag', { on: true });
    var Z = parseFloat(getComputedStyle(document.documentElement).zoom) || 1;
    var sx = e.clientX, sy = e.clientY;
    if (box) layer.removeChild(box);
    box = el('div', { class: 'marquee-box', style: { left: (sx / Z) + 'px', top: (sy / Z) + 'px', width: '0px', height: '0px' } });
    layer.appendChild(box);
    function move(ev) { box.style.left = (Math.min(sx, ev.clientX) / Z) + 'px'; box.style.top = (Math.min(sy, ev.clientY) / Z) + 'px'; box.style.width = (Math.abs(ev.clientX - sx) / Z) + 'px'; box.style.height = (Math.abs(ev.clientY - sy) / Z) + 'px'; }
    function up(ev) {
      window.removeEventListener('mousemove', move); window.removeEventListener('mouseup', up);
      post('marqueeDrag', { on: false });
      if (box) { layer.removeChild(box); box = null; }
      var rect = layer.getBoundingClientRect();
      var swd = rect.width || window.innerWidth, shd = rect.height || window.innerHeight;
      var dx = Math.abs(ev.clientX - sx), dy = Math.abs(ev.clientY - sy);
      if (dx < 4 && dy < 4) post('pointToggle', {});
      else { post('boxSelect', { x1: Math.min(sx, ev.clientX) / swd, y1: Math.min(sy, ev.clientY) / shd, x2: Math.max(sx, ev.clientX) / swd, y2: Math.max(sy, ev.clientY) / shd }); set({ marqueeOpen: false }); }
    }
    window.addEventListener('mousemove', move); window.addEventListener('mouseup', up);
  });
  R.marquee.appendChild(layer);
}

function has(patch, keys) { for (var i = 0; i < keys.length; i++) if (Object.prototype.hasOwnProperty.call(patch, keys[i])) return true; return false; }

subscribe(function (patch) {
  if (has(patch, ['open'])) { renderAll(); return; }
  if (has(patch, ['props', 'categories', 'search', 'category', 'sub', 'catMenu', 'searchOpen', 'dockTab', 'objects', 'hidden', 'deletedObjects', 'deletedObjectsCount', 'layers', 'created', 'createdCount', 'hiddenCount', 'favorites', 'showTools', 'mapName', 'snap', 'step', 'angleStep', 'mapId', 'bulkActive', 'bulkCount', 'bulkGrabbing', 'build', 'brushActive', 'brushRadius', 'brushDensity', 'brushAlign', 'brushYaw', 'dockCollapsed', 'prefabs'])) renderDock();
  if (has(patch, ['worldDelete', 'showTools', 'multiplace', 'mode', 'freecam', 'showLight', 'showFill', 'fill', 'light', 'areaDelete', 'history', 'clipboard', 'array', 'align', 'bulkActive', 'bulkCount', 'brushActive', 'showLogs', 'marqueeOpen', 'mapMode', 'build', 'selected'])) renderTopBar();
  if (has(patch, ['array'])) renderArray();
  if (has(patch, ['align'])) renderAlign();
  if (has(patch, ['showTools', 'selected', 'snap', 'step', 'angleStep', 'mapId', 'bulkActive', 'bulkCount', 'bulkGrabbing', 'build', 'brushActive', 'brushAlign', 'brushYaw', 'worldDelete', 'freecam', 'mode', 'multiplace', 'fill', 'light', 'areaDelete', 'showLight', 'showFill', 'showObjects', 'mapMode', 'clipboard', 'array', 'align', 'toolsCollapsed'])) renderToolsOrFloatingToolbar();
  if (has(patch, ['showLight', 'light'])) renderLight();
  if (has(patch, ['showFill', 'fill', 'build'])) renderFill();
  if (has(patch, ['showLogs', 'logs'])) renderLogs();
  if (has(patch, ['showIO', 'ioJson', 'ioLua', 'ioYmap', 'ioMenyoo', 'ioCsv'])) renderIO();
  if (has(patch, ['showMaps', 'maps'])) renderMaps();
  if (has(patch, ['showObjects', 'objects', 'map'])) renderObjects();
  if (has(patch, ['selected', 'gizmoPos', 'showTools', 'cardOpen'])) renderFloatingEdit();

  if (has(patch, ['build', 'multiplace'])) renderBuildBanner();
  if (has(patch, ['grabbing'])) renderMoveBanner();
  if (has(patch, ['toast'])) renderToast();
  if (has(patch, ['bulkActive', 'bulkGrabbing', 'marqueeOpen'])) renderMarquee();
  if (has(patch, ['marqueeOpen', 'bulkActive', 'bulkGrabbing'])) post('marqueeState', { open: !!(S.bulkActive && S.marqueeOpen && !S.bulkGrabbing) });
  if (typeof recheckHover === 'function' && !(Object.keys(patch).length === 1 && 'gizmoPos' in patch)) recheckHover();
});

window.addEventListener('message', function (ev) {
  var msg = ev.data || {}; var action = msg.action; var data = msg.data;
  switch (action) {
    case 'open':
      LOCALE = (data && data.locale) || {};
      set({
        open: true, props: (data.props && data.props.props) || [], categories: (data.config && data.config.categories) || [],
        snap: Object.assign({}, S.snap, (data.config && data.config.snap) || {}), map: (data.config && data.config.map) || null,
        keybind: (data.config && data.config.keybind) || '',
        selected: null, build: null, freecam: false, category: 'props', sub: 'all',
        showTools: false, showLight: false, showFill: false, showMaps: false, showIO: false, showLogs: false, showObjects: false, grabbing: false, toolsCollapsed: false,
        createdCount: (data.created || 0), hiddenCount: (data.hidden || 0)
      });
      setTimeout(function () { try { window.focus(); if (root && root.focus) root.focus(); } catch (e) {} }, 0);
      break;
    case 'close': if (window.Gizmo3D) Gizmo3D.setFrame({ on: false }); set({ open: false, build: null, selected: null, showMaps: false, freecam: false, showTools: false, showLight: false, showFill: false, showIO: false, showLogs: false, showObjects: false, grabbing: false }); break;
    case 'selected': set({ selected: data, build: null }); break;
    case 'cardMode': set({ cardOpen: !!(data && data.open) }); break;
    case 'prefabPlacing': if (data && data.on) toast(loc('toast.prefab_placing'), 2200); break;
    case 'reselect': set({ selected: data, build: null }); renderFloatingEdit(true); break;
    case 'deselect': set({ selected: null, cardOpen: false, showTools: false, gizmoPos: { on: false, x: 0, y: 0 }, grabbing: false }); break;
    case 'gizmoPos': set({ gizmoPos: { on: !!(data && data.on), x: (data && data.x) || 0, y: (data && data.y) || 0 } }); break;
    case 'gizmoGeo': if (window.Gizmo3D) Gizmo3D.setFrame(data); break;
    case 'placeLine': if (window.Gizmo3D) Gizmo3D.setLine(data); break;
    case 'grab': set({ grabbing: !!(data && data.on) }); break;
    case 'freecam': set({ freecam: !!(data && data.on) }); break;
    case 'mode': set({ mode: (data && data.mode) }); break;
    case 'mapList': set({ maps: data || [] }); break;
    case 'toast': toast(data); break;
    case 'mapSaved': if (data) set({ mapId: data.id, mapName: data.name }); break;
    case 'mapLoaded': if (data) set({ mapId: data.id, mapName: data.name, selected: null, build: null }); break;
    case 'worldDelete': set({ worldDelete: !!(data && data.on) }); break;
    case 'bigmap': set({ mapMode: (data && data.mode) || 0 }); break;
    case 'bulk': {
      var _wasBulk = S.bulkActive, _nowBulk = !!(data && data.active);
      var _mo = _nowBulk ? (_wasBulk ? S.marqueeOpen : true) : false;
      set({ bulkActive: _nowBulk, bulkCount: (data && data.count) || 0, marqueeOpen: _mo });
      break;
    }
    case 'bulkGrab': set({ bulkGrabbing: !!(data && data.on) }); break;
    case 'brush': set({ brushActive: !!(data && data.active), brushRadius: (data && data.radius != null) ? data.radius : S.brushRadius, brushDensity: (data && data.density != null) ? data.density : S.brushDensity }); break;
    case 'lights': set({
      light: Object.assign({}, S.light, {
        placing: !!(data && data.placing), count: (data && data.count != null) ? data.count : S.light.count,
        r: (data && data.r != null) ? data.r : S.light.r, g: (data && data.g != null) ? data.g : S.light.g, b: (data && data.b != null) ? data.b : S.light.b,
        range: (data && data.range != null) ? data.range : S.light.range, intensity: (data && data.intensity != null) ? data.intensity : S.light.intensity,
        list: (data && data.list) || S.light.list
      })
    }); break;
    case 'fill': set({
      fill: {
        active: !!(data && data.active), picking: !!(data && data.picking), ready: !!(data && data.ready),
        spacing: (data && data.spacing != null) ? data.spacing : S.fill.spacing, layout: (data && data.layout) || S.fill.layout,
        heading: (data && data.heading) || S.fill.heading, vcount: (data && data.vcount) || 0
      }
    }); break;
    case 'logs': set({ logs: Array.isArray(data) ? data : [] }); break;
    case 'exportData': _ioPublished = false; set({ ioJson: (data && data.json) || '', ioLua: (data && data.lua) || '', ioYmap: (data && data.ymap) || '', ioMenyoo: (data && data.menyoo) || '', ioCsv: (data && data.csv) || '', ioCustomCount: (data && data.customCount) || 0, showIO: true }); break;
    case 'areadelete': set({ areaDelete: { active: !!(data && data.active), radius: (data && data.radius != null) ? data.radius : 8 } }); break;
    case 'history': set({ history: data || { canUndo: false, canRedo: false, undoLabel: '', redoLabel: '' } }); break;
    case 'clipboard': set({ clipboard: data || { has: false, count: 0 } }); break;
    case 'array': set({ array: Object.assign({}, S.array, data || {}) }); break;
    case 'align': set({ align: Object.assign({}, S.align, data || {}) }); break;
    case 'prefabList': set({ prefabs: Array.isArray(data) ? data : [] }); break;
    case 'marqueeBlock': S.marqueeBlock = !!(data && data.on); break;
    case 'dockRefresh':
      if (data && (data.created != null || data.hidden != null)) set({ createdCount: data.created != null ? data.created : S.createdCount, hiddenCount: data.hidden != null ? data.hidden : S.hiddenCount });
      if (data && data.deletedObjs != null) set({ deletedObjectsCount: data.deletedObjs });
      if (S.dockTab === 'created' && data && data.kind === 'objects') post('getObjects').then(function (l) { set({ objects: l || [] }); });
      else if (S.dockTab === 'deleted' && data && data.kind === 'hidden') post('getHidden').then(function (l) { set({ hidden: l || [] }); });
      else if (S.dockTab === 'deleted' && data && data.kind === 'deleted') post('getDeletedObjects').then(function (l) { set({ deletedObjects: l || [] }); });
      break;
    case 'stopBuild': set({ build: null }); break;
  }
});

window.addEventListener('keydown', function (e) {
  if (!S.open) return;
  var tag = (e.target && e.target.tagName) || '';
  var typing = tag === 'INPUT' || tag === 'TEXTAREA';

  if (e.key === 'Escape') {
    if (typing && e.target && e.target.blur) { e.target.blur(); return; }
    post('close'); return;
  }
  if (typing) return;

  var ctrl = e.ctrlKey || e.metaKey;
  var k = (e.key && e.key.length === 1) ? e.key.toLowerCase() : e.key;

  if ((e.key === 'Delete' || e.key === 'Backspace') && S.selected) {
    e.preventDefault(); post('deleteSelected'); toast(loc('toast.deleted'), 1000); return;
  }

  if (!ctrl && k === 'g' && S.selected) { e.preventDefault(); post('ground'); toast(loc('toast.grounded'), 1000); return; }

  if (!ctrl && k === 'v') {
    if (S.bulkActive && S.bulkCount) { e.preventDefault(); post('bulkGrab'); toast(loc('toast.grab'), 1000); return; }
    if (S.selected) { e.preventDefault(); post('grab'); toast(loc('toast.grab'), 1000); return; }
  }

  if (!ctrl && k === 't' && S.selected) { e.preventDefault(); post('teleportTo', { id: S.selected.id }); toast(loc('toast.teleported'), 1000); return; }

  if (!ctrl && k === 'm') { e.preventDefault(); var vm = !S.multiplace; set({ multiplace: vm }); post('setMultiplace', { on: vm }); toast(loc('toast.multiplace', vm ? loc('common.on') : loc('common.off')), 1000); return; }

  if (!ctrl && k === 'b') { e.preventDefault(); if (S.bulkActive && !S.marqueeOpen) { set({ marqueeOpen: true }); toast(loc('toast.marquee_draw'), 1000); } else { var vb = !S.bulkActive; post('bulkToggle', { on: vb }); toast(loc('toast.marquee', vb ? loc('common.on') : loc('common.off')), 1000); } return; }

  if (!ctrl && k === 'p') { e.preventDefault(); var vp = !S.brushActive; set({ brushActive: vp }); post('brushToggle', { on: vp, model: S.build }); toast(loc('toast.brush', vp ? loc('common.on') : loc('common.off')), 1000); return; }

  if (!ctrl && (e.key === '[' || e.key === '-')) {
    var sd = [0.01, 0.05, 0.1, 0.25, 0.5, 1];
    var di = sd.indexOf(S.step);
    var nd = sd[di > 0 ? di - 1 : 0];
    set({ step: nd }); post('setStep', { step: nd }); toast(loc('toast.step', nd), 1000);
    e.preventDefault(); return;
  }
  if (!ctrl && (e.key === ']' || e.key === '+' || e.key === '=')) {
    var su = [0.01, 0.05, 0.1, 0.25, 0.5, 1];
    var ui = su.indexOf(S.step);
    var nu = su[ui >= 0 && ui < su.length - 1 ? ui + 1 : (ui < 0 ? 0 : su.length - 1)];
    set({ step: nu }); post('setStep', { step: nu }); toast(loc('toast.step', nu), 1000);
    e.preventDefault(); return;
  }
});

document.addEventListener('focusin', function (e) {
  var t = (e.target && e.target.tagName) || '';
  post('typing', { on: t === 'INPUT' || t === 'TEXTAREA' });
});
document.addEventListener('focusout', function () { post('typing', { on: false }); });

mount();

