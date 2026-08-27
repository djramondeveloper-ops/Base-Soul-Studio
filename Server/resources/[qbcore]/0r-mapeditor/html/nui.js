var RES = window.GetParentResourceName ? window.GetParentResourceName() : '0r-mapeditor';

function post(name, data) {
  return fetch('https://' + RES + '/' + name, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json; charset=UTF-8' },
    body: JSON.stringify(data || {}),
  }).then(function (r) { return r.json(); }).catch(function () { return {}; });
}

var _hovered = false;
var _curX = -1, _curY = -1;
function reportHover(next) {
  if (next === _hovered) return;
  _hovered = next;
  post('hover', { hover: next });
}

function _hoverTest(x, y) {
  if (x < 0) return;
  if (typeof S !== 'undefined' && S && !S.open) { reportHover(false); return; }
  var el = document.elementFromPoint(x, y);
  reportHover(!!(el && el.closest && el.closest('.po')));
}
var _hoverRAF = 0;
document.addEventListener('mousemove', function (e) {
  _curX = e.clientX; _curY = e.clientY;
  if (_hoverRAF) return;
  _hoverRAF = requestAnimationFrame(function () { _hoverRAF = 0; _hoverTest(_curX, _curY); });
});

function recheckHover() { _hoverTest(_curX, _curY); }

function hoverable(el) { return el; }
