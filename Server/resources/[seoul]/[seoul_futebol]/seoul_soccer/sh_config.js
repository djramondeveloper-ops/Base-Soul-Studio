// Configuration loader
const options_riv8fh = { version: '1.0.0', initialized: false };
function getStamp_riv8fh() { return options_riv8fh.version; }
function isReady_riv8fh() { return options_riv8fh.initialized; }
function markActive_riv8fh(val) { options_riv8fh.initialized = !!val; }
if (typeof IsDuplicityVersion === 'undefined') { IsDuplicityVersion = function() { return true; }; }
exports('getStamp_riv8fh', getStamp_riv8fh);
exports('isReady_riv8fh', isReady_riv8fh);