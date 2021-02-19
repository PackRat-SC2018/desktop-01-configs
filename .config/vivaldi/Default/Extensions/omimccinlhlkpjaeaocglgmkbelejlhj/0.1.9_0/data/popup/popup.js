var _toggle = function (flag) {
  var info = document.getElementById("info-td");
  var flashType = document.getElementById("flash-button");
  var html5Type = document.getElementById("html5-button");
  /*  */
  if (flag === "flash") {
    flashType.setAttribute("active", "true");
    html5Type.setAttribute("active", "false");
    info.textContent = "YouTube Flash Player is Active";
  } else {
    html5Type.setAttribute("active", "true");
    flashType.setAttribute("active", "false");
    info.textContent = "YouTube HTML5 Player is Active";
  }
};

var load = function () {
  var flashType = document.getElementById("flash-button");
  var html5Type = document.getElementById("html5-button");
  var handleClick = function (e) {
    var type = e.target.getAttribute("type");
    background.send("popup:store", {"playerType": type});
    _toggle(type);
  };
  /*  */
  background.send("popup:load");
  window.removeEventListener("load", load, false);
  flashType.addEventListener("click", handleClick);
  html5Type.addEventListener("click", handleClick);
  document.getElementById("faq-td").addEventListener("click", function () {background.send("popup:support")});
};
/*  */
window.addEventListener("load", load, false);
background.receive("popup:storage", function (e) {_toggle(e.playerType)});
