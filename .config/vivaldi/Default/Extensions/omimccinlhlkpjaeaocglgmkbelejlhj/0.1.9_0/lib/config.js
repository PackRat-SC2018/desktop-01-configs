var config = {};

config.welcome = {
  get version () {return app.storage.read("version")},
  set version (val) {app.storage.write("version", val)}
};

config.player = {
  set type (val) {app.storage.write("playerType", val)},
  get type () {return app.storage.read("playerType") || "flash"}
};
