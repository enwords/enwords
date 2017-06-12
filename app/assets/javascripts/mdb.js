//= require MDBootstrap/tether
//= require MDBootstrap/bootstrap
//= require MDBootstrap/mdb

function initMDB() {
  Waves.attach('.btn, .btn-floating', ['waves-light']);
  Waves.attach('.view .mask', ['waves-light']);
  Waves.attach('.waves-light', ['waves-light']);
  Waves.attach('.navbar li', ['waves-light']);
  Waves.init();
}
