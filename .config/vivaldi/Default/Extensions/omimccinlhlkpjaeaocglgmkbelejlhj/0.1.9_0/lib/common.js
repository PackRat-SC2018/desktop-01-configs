window.setTimeout(function () {
  var version = config.welcome.version;
  if (!version) {
    app.tab.open(app.homepage() + "?v=" + app.version() + "&type=install");
    config.welcome.version = app.version();
  }
}, 3000);

window.setTimeout(function () {app.icon(config.player.type)}, 300);
app.addon.receive("popup:support", function () {app.tab.open(app.homepage())});
app.addon.receive("popup:load", function () {app.addon.send("popup:storage", {"playerType": config.player.type}, null)});
app.addon.receive("page:load", function (e) {app.addon.send("page:storage", {"playerType": config.player.type}, (e ? e.tabId : null))});

app.addon.receive("popup:store", function (e) {
  config.player.type = e.playerType;
  /*  */
  app.icon(config.player.type);
  window.setTimeout(function () {app.addon.send("page:reload", null, null)}, 500);
});
