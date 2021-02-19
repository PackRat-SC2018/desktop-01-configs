var app = {};

app.version = function () {return chrome.runtime.getManifest().version};
app.homepage = function () {return chrome.runtime.getManifest().homepage_url};
app.tab = {"open": function (url) {chrome.tabs.create({"url": url, "active": true})}};
if (chrome.runtime.setUninstallURL) chrome.runtime.setUninstallURL(app.homepage() + "?v=" + app.version() + "&type=uninstall", function () {});

app.icon = function (type) {
  chrome.browserAction.setIcon({
    "path": {
      "16": "../../data/icons/16-" + type + ".png",
      "32": "../../data/icons/32-" + type + ".png",
      "38": "../../data/icons/38-" + type + ".png",
      "64": "../../data/icons/64-" + type + ".png"
    }
  });
};

app.storage = (function () {
  var objs = {};
  window.setTimeout(function () {
    chrome.storage.local.get(null, function (o) {
      objs = o;
      var script = document.createElement("script");
      script.src = "../common.js";
      document.body.appendChild(script);
    });
  }, 300);
  /*  */
  return {
    "read": function (id) {return objs[id]},
    "write": function (id, data) {
      var tmp = {};
      tmp[id] = data;
      objs[id] = data;
      chrome.storage.local.set(tmp, function () {});
    }
  }
})();

app.addon = (function () {
  var _tmp = {};
  chrome.runtime.onMessage.addListener(function (request, sender, sendResponse) {
    for (var id in _tmp) {
      if (_tmp[id] && (typeof _tmp[id] === "function")) {
        if (request.method === id) {
          var _data = request.data || {};
          if (sender.tab) _data["tabId"] = sender.tab.id;
          _tmp[id](_data);
        }
      }
    }
  });
  /*  */
  return {
    "receive": function (id, callback) {_tmp[id] = callback},
    "send": function (id, data, tabId) {
      chrome.runtime.sendMessage({"method": id, "data": data});
      chrome.tabs.query({}, function (tabs) {
        tabs.forEach(function (tab) {
          if (!tabId || (tabId && tab.id === tabId)) {
            var _data = data || {};
            _data["tabId"] = tab.id;
            chrome.tabs.sendMessage(tab.id, {"method": id, "data": _data}, function () {});
          }
        });
      });
    }
  }
})();
