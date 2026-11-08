/* Zakat Al Mal — service worker minimal (coque applicative hors ligne) */
const CACHE = "zakat-al-mal-v9";
const ASSETS = [
  "./", "./index.html", "./manifest.webmanifest",
  "./assets/icon-192.png", "./assets/icon-512.png", "./assets/emblem_300.png",
  "./og-image.png"
];

self.addEventListener("install", event => {
  event.waitUntil(
    caches.open(CACHE)
      .then(c => Promise.allSettled(ASSETS.map(a => c.add(a))))
      .then(() => self.skipWaiting())
  );
});

self.addEventListener("activate", event => {
  event.waitUntil(
    caches.keys()
      .then(keys => Promise.all(keys.filter(k => k !== CACHE).map(k => caches.delete(k))))
      .then(() => self.clients.claim())
  );
});

self.addEventListener("fetch", event => {
  const req = event.request;
  if (req.method !== "GET" || new URL(req.url).origin !== location.origin) return;
  event.respondWith(
    caches.match(req).then(hit => hit || fetch(req).then(res => {
      const copy = res.clone();
      caches.open(CACHE).then(c => c.put(req, copy)).catch(() => {});
      return res;
    }).catch(() => caches.match("./index.html")))
  );
});

/* Rappels de hawl : la notification est produite localement par la page.
   Le clic sur la notification ramène simplement à l'application. */
self.addEventListener("notificationclick", event => {
  event.notification.close();
  event.waitUntil(
    self.clients.matchAll({ type: "window", includeUncontrolled: true }).then(list => {
      for (const c of list) { if ("focus" in c) return c.focus(); }
      if (self.clients.openWindow) return self.clients.openWindow("./index.html");
    })
  );
});

self.addEventListener("message", event => {
  const data = event.data || {};
  if (data.type === "hawl-reminder" && data.title) {
    self.registration.showNotification(data.title, {
      body: data.body || "", icon: "./assets/icon-192.png", badge: "./assets/icon-192.png",
      tag: "hawl", renotify: false, data: { url: "./index.html" }
    });
  }
});
