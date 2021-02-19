{
  const INC = 50;
  const COUNT = Number(localStorage.getItem('explore-count') || (INC - 5));

  var randcolor = function () {
    var color = [
      "#D92121", "#E77200", "#FFD12A", "#5E8C31", "#00755E",
      "#0066FF", "#3F26BF", "#733380", "#BB3385", "#E30B5C",
      "#CA3435", "#87421F", "#299617", "#E936A7", "#DB91EF",
      "#214FC6", "#B56917", "#BB3385", "#652DC1", "#02A4D3"
    ];
    /*  */
    return color[Math.floor(Math.random() * color.length)];
  };

  const cload = () => fetch("explore/explore.json").then(r => r.json()).then(build);

  const explore = () => {
    const span = document.createElement('span');
    const root = document.getElementById('explore');
    span.textContent = '⛞';
    span.title = 'Explore more';
    span.classList.add('explore');
    root.appendChild(span);
    span.onclick = () => {
      root.textContent = '';
      localStorage.setItem('explore-count', INC);
      cload();
    };
  };

  const build = json => {
    if (json.length === 0) return;
    /*  */
    const root = document.getElementById('explore');
    root.textContent = 'Explore more';
    root.dataset.loaded = true;
    /*  */
    const table = document.createElement('table');
    const span = document.createElement('span');
    const tr = document.createElement('tr');
    /*  */
    table.setAttribute("class", "container");
    span.classList.add('close');
    span.textContent = '✕';
    /*  */
    span.onclick = () => {
      root.textContent = '';
      root.dataset.loaded = false;
      localStorage.setItem("explore-count", 0);
      explore();
    };
    /*  */
    root.appendChild(span);
    table.appendChild(tr);
    root.appendChild(table);
    /*  */
    json.sort(() => (0.5 - Math.random())).slice(0, 3).forEach(({id, title}) => {
      const url = chrome.runtime.getManifest().homepage_url;
      const td = document.createElement('td');
      const a = document.createElement('a');
      a.href = url.split('/').slice(0, -1).join('/') + '/' + id + ".html?context=explore";
      a.target = '_blank';
      /*  */
      const icon = document.createElement('span');
      icon.style.backgroundColor = randcolor();
      icon.setAttribute("class", "icon");
      icon.textContent = title[0];
      a.appendChild(icon);
      /*  */
      const name = document.createElement('span');
      name.setAttribute("class", "name");
      name.textContent = title;
      a.appendChild(name);
      /*  */
      td.appendChild(a);
      tr.appendChild(td);
    });
  };

  if (COUNT >= INC) {
    if (COUNT < INC + 4) cload(); else explore();
    /*  */
    if (COUNT > INC + 5) localStorage.setItem('explore-count', INC);
    else localStorage.setItem('explore-count', COUNT + 1);
  } else {
    explore();
    localStorage.setItem('explore-count', COUNT + 1);
  }
}
