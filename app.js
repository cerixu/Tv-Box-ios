(() => {
  "use strict";
  const tiles = [...document.querySelectorAll(".tile")];
  const detail = document.querySelector("#detail");
  const lastKey = document.querySelector("#lastKey");
  const keyCode = document.querySelector("#keyCode");
  const result = document.querySelector("#result");
  let selected = 0;
  let inDetail = false;

  function render() {
    tiles.forEach((tile, i) => tile.classList.toggle("selected", i === selected && !inDetail));
    document.querySelector("#tiles").hidden = inDetail;
    detail.hidden = !inDetail;
    if (inDetail) {
      document.querySelector("#detailTitle").textContent = tiles[selected].dataset.title;
      document.querySelector("#detailCopy").textContent = tiles[selected].dataset.copy;
    }
  }
  function handle(event) {
    const key = event.key || "unknown";
    const code = event.keyCode || event.which || 0;
    let handled = true;
    if (key === "ArrowLeft" || code === 37) selected = Math.max(0, selected - 1);
    else if (key === "ArrowRight" || code === 39) selected = Math.min(5, selected + 1);
    else if (key === "ArrowUp" || code === 38) selected = Math.max(0, selected - 3);
    else if (key === "ArrowDown" || code === 40) selected = Math.min(5, selected + 3);
    else if (key === "Enter" || key === " " || code === 13) inDetail = true;
    else if (["Escape","Backspace","BrowserBack"].includes(key) || [8,27,10009].includes(code)) inDetail = false;
    else handled = false;
    lastKey.textContent = key.toUpperCase();
    keyCode.textContent = "KEY CODE: " + code;
    result.textContent = handled ? "Klawisz odebrany ✓" : "Inny klawisz";
    if (handled) { event.preventDefault(); render(); }
  }
  document.addEventListener("keydown", handle, {passive:false});
  tiles.forEach((tile,i)=>tile.addEventListener("click",()=>{selected=i;inDetail=true;render();}));
  detail.addEventListener("click",()=>{inDetail=false;render();});
  render();
  if ("serviceWorker" in navigator && location.protocol.startsWith("http")) {
    navigator.serviceWorker.register("./sw.js").catch(()=>{result.textContent="Tryb offline niedostępny";});
  }
})();
