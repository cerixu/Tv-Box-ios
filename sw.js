"use strict";
const VERSION="ibox-tv-v0.1.1";
const CORE=VERSION+"-core";
const ASSETS=VERSION+"-assets";
const FILES=["./","./index.html","./styles.css","./app.js","./manifest.webmanifest","./offline.html","./icon.svg"];
self.addEventListener("install",event=>event.waitUntil((async()=>{try{const c=await caches.open(CORE);await c.addAll(FILES);}catch(e){console.warn("Precache incomplete",e);}await self.skipWaiting();})()));
self.addEventListener("activate",event=>event.waitUntil((async()=>{const keys=await caches.keys();await Promise.all(keys.filter(k=>k.startsWith("ibox-tv-")&&k!==CORE&&k!==ASSETS).map(k=>caches.delete(k)));await self.clients.claim();})()));
self.addEventListener("fetch",event=>{const req=event.request;if(req.method!=="GET")return;const url=new URL(req.url);if(req.mode==="navigate"){event.respondWith((async()=>{try{const res=await fetch(req);if(res.ok){const c=await caches.open(CORE);c.put("./index.html",res.clone()).catch(()=>{});}return res;}catch{return await caches.match(req)||await caches.match("./index.html")||await caches.match("./offline.html");}})());return;}if(url.origin===self.location.origin){event.respondWith((async()=>{const cached=await caches.match(req);const update=fetch(req).then(async res=>{if(res.ok){const c=await caches.open(ASSETS);await c.put(req,res.clone());}return res;}).catch(()=>cached||await caches.match("./offline.html"));return cached||await update;})());}});
