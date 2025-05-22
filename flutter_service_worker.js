'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"favicon.ico": "8744bd94e5b3325b70c64ac8fc665afd",
"icons/Icon-maskable-192.png": "a36b2106c16f1562bfb5e470ecda2915",
"icons/Icon-192.png": "f3e51db7c0a8047a207be583da4818d2",
"icons/Icon-maskable-512.png": "2e316c3639fd749eb5152a94764fffa8",
"icons/Icon-512.png": "3dd46a25cc14afbc8cc8706425547258",
"assets/fonts/MaterialIcons-Regular.otf": "21540b055bb3cc92309f2f140bce80b9",
"assets/AssetManifest.bin.json": "455fa6f7765fd6932d629e33d0ce5773",
"assets/AssetManifest.bin": "6ceeb5672f5f7c5d9cae67af41f421f9",
"assets/AssetManifest.json": "6d473c1c51a557d0c1e9d061e1d8855e",
"assets/assets/images/sapura.png": "bd97faa18d4a764b99a3e1b5dc77f582",
"assets/assets/images/uos.png": "6f7c7c0bf9b0744ffaa79a965709bf3a",
"assets/assets/images/progrid_black.png": "1d4ab4dc2dcd22e6603353cbe0e7e7f4",
"assets/assets/images/binasat.png": "902d27622e72e7542d0446eb7b3dcbfd",
"assets/packages/image_watermark/screenshots/screenshot2.png": "186d39de2dc578d3345f868985ff0f5a",
"assets/packages/image_watermark/screenshots/screenshot1.png": "f2a32bb1aa854fa504f9836de83e4a45",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/packages/icones/assets/fonts/CarbonPictogram.ttf": "5c8743b9c6d4164bb5bc42d6eacb0dd4",
"assets/packages/icones/assets/fonts/CarbonIcon.ttf": "79e5d06f82b95d7a145993d4517cc4cc",
"assets/packages/icones/assets/fonts/MingCuteIcon.ttf": "cdc1e77b627cc0e1b655c30b72a866eb",
"assets/packages/carbon_design_system/assets/fonts/IBM%2520Plex%2520Mono/IBMPlexMono-MediumItalic.ttf": "f2bdf2fa12d734ce7984be93a1140ee1",
"assets/packages/carbon_design_system/assets/fonts/IBM%2520Plex%2520Mono/IBMPlexMono-LightItalic.ttf": "2321b10cc89ba3a005d987da7f03a01d",
"assets/packages/carbon_design_system/assets/fonts/IBM%2520Plex%2520Mono/IBMPlexMono-Regular.ttf": "ea96a0afddbe8ff439be465b16cbd381",
"assets/packages/carbon_design_system/assets/fonts/IBM%2520Plex%2520Mono/IBMPlexMono-Italic.ttf": "d39621570e4423c5e048f25f955c8b48",
"assets/packages/carbon_design_system/assets/fonts/IBM%2520Plex%2520Mono/IBMPlexMono-ExtraLightItalic.ttf": "edb44f94370eb40dde3efb6848b9276c",
"assets/packages/carbon_design_system/assets/fonts/IBM%2520Plex%2520Mono/IBMPlexMono-Light.ttf": "5155fa9274059415db950c2edf3948bb",
"assets/packages/carbon_design_system/assets/fonts/IBM%2520Plex%2520Mono/IBMPlexMono-Bold.ttf": "be4cc57a744421b843e08a2001436f40",
"assets/packages/carbon_design_system/assets/fonts/IBM%2520Plex%2520Mono/IBMPlexMono-SemiBold.ttf": "892b0e616e4dd0381b579d848d98bcbc",
"assets/packages/carbon_design_system/assets/fonts/IBM%2520Plex%2520Mono/IBMPlexMono-Thin.ttf": "853f0c4a5b558d1b017efde4ba2b1bf4",
"assets/packages/carbon_design_system/assets/fonts/IBM%2520Plex%2520Mono/IBMPlexMono-ExtraLight.ttf": "a099672ec05c47a0bb01db62d5803d62",
"assets/packages/carbon_design_system/assets/fonts/IBM%2520Plex%2520Mono/IBMPlexMono-ThinItalic.ttf": "94708ea3beddf19c9df849f49446eeb5",
"assets/packages/carbon_design_system/assets/fonts/IBM%2520Plex%2520Mono/IBMPlexMono-Medium.ttf": "3594148d0a094b10fc8e21ae7aaef7d9",
"assets/packages/carbon_design_system/assets/fonts/IBM%2520Plex%2520Mono/IBMPlexMono-SemiBoldItalic.ttf": "788945fa6c3681df24592653afaa468e",
"assets/packages/carbon_design_system/assets/fonts/IBM%2520Plex%2520Mono/IBMPlexMono-BoldItalic.ttf": "1e9f7dcae801e46684ec0dea4604c600",
"assets/packages/carbon_design_system/assets/fonts/IBM%2520Plex%2520Sans/IBMPlexSans-Bold.ttf": "1ae7d0a8e83337da66631aeca59fbb02",
"assets/packages/carbon_design_system/assets/fonts/IBM%2520Plex%2520Sans/IBMPlexSans-Regular.ttf": "1286abb632c5a409a0a997d11c994e34",
"assets/packages/carbon_design_system/assets/fonts/IBM%2520Plex%2520Sans/IBMPlexSans-MediumItalic.ttf": "77fbc569f8e2c0cecd7d1317eba8cce8",
"assets/packages/carbon_design_system/assets/fonts/IBM%2520Plex%2520Sans/IBMPlexSans-SemiBold.ttf": "3ea7eea66304ac5e02a95265505300fd",
"assets/packages/carbon_design_system/assets/fonts/IBM%2520Plex%2520Sans/IBMPlexSans-Light.ttf": "abcc0987be49b417483f65063f144e4a",
"assets/packages/carbon_design_system/assets/fonts/IBM%2520Plex%2520Sans/IBMPlexSans-Thin.ttf": "6dcbea439f36a796c36e5197a527c8a1",
"assets/packages/carbon_design_system/assets/fonts/IBM%2520Plex%2520Sans/IBMPlexSans-ThinItalic.ttf": "9823c5872a073bda1d37e35b8d518912",
"assets/packages/carbon_design_system/assets/fonts/IBM%2520Plex%2520Sans/IBMPlexSans-ExtraLightItalic.ttf": "d09511dbf61a5625e6296f7e536b7dd3",
"assets/packages/carbon_design_system/assets/fonts/IBM%2520Plex%2520Sans/IBMPlexSans-Medium.ttf": "361336a2ed1908c5cd8dec2e10aa71a2",
"assets/packages/carbon_design_system/assets/fonts/IBM%2520Plex%2520Sans/IBMPlexSans-Italic.ttf": "291a8d32d7596f69509713e0d31e1eb7",
"assets/packages/carbon_design_system/assets/fonts/IBM%2520Plex%2520Sans/IBMPlexSans-ExtraLight.ttf": "4362bbf9009288efcbd3130c5ac8f671",
"assets/packages/carbon_design_system/assets/fonts/IBM%2520Plex%2520Sans/IBMPlexSans-SemiBoldItalic.ttf": "c7e16f251b21174781a036ecc37fb301",
"assets/packages/carbon_design_system/assets/fonts/IBM%2520Plex%2520Sans/IBMPlexSans-LightItalic.ttf": "f059e141654e87fe1ec2180873970da7",
"assets/packages/carbon_design_system/assets/fonts/IBM%2520Plex%2520Sans/IBMPlexSans-BoldItalic.ttf": "5c7054fd77f5371213e6bd40ba413007",
"assets/packages/carbon_design_system/assets/fonts/IBM%2520Plex%2520Serif/IBMPlexSerif-LightItalic.ttf": "8bcb0560c37e5c7af5acd60dec8f842e",
"assets/packages/carbon_design_system/assets/fonts/IBM%2520Plex%2520Serif/IBMPlexSerif-Bold.ttf": "e369c18f87ecbae7de5bf36c3d44a5eb",
"assets/packages/carbon_design_system/assets/fonts/IBM%2520Plex%2520Serif/IBMPlexSerif-Italic.ttf": "ffb4fc82595d7cf7c77cc20b118a88b1",
"assets/packages/carbon_design_system/assets/fonts/IBM%2520Plex%2520Serif/IBMPlexSerif-Medium.ttf": "25138c9bcd8d4977087fe884b841126f",
"assets/packages/carbon_design_system/assets/fonts/IBM%2520Plex%2520Serif/IBMPlexSerif-ExtraLight.ttf": "b116a0475234b3394b4d4af104cf8c54",
"assets/packages/carbon_design_system/assets/fonts/IBM%2520Plex%2520Serif/IBMPlexSerif-Light.ttf": "52a9694d0c61c8fc80a67aecf03f41d7",
"assets/packages/carbon_design_system/assets/fonts/IBM%2520Plex%2520Serif/IBMPlexSerif-SemiBoldItalic.ttf": "a9b749a1bb484850af632301a0ab31a9",
"assets/packages/carbon_design_system/assets/fonts/IBM%2520Plex%2520Serif/IBMPlexSerif-BoldItalic.ttf": "e21194c80cbb81dd8db7abea48fc60d6",
"assets/packages/carbon_design_system/assets/fonts/IBM%2520Plex%2520Serif/IBMPlexSerif-Thin.ttf": "17898858bbb9e6ac061bc4243fc1e101",
"assets/packages/carbon_design_system/assets/fonts/IBM%2520Plex%2520Serif/IBMPlexSerif-ExtraLightItalic.ttf": "c818473eeb9688a060e9f9f3aa76f6e7",
"assets/packages/carbon_design_system/assets/fonts/IBM%2520Plex%2520Serif/IBMPlexSerif-SemiBold.ttf": "9160bb54c4d2e223e7446b08eab4fe43",
"assets/packages/carbon_design_system/assets/fonts/IBM%2520Plex%2520Serif/IBMPlexSerif-MediumItalic.ttf": "d1fd471c367df5afc1e3de573dfd2c13",
"assets/packages/carbon_design_system/assets/fonts/IBM%2520Plex%2520Serif/IBMPlexSerif-Regular.ttf": "377f8314d273f8cdac3c910a78c04bc4",
"assets/packages/carbon_design_system/assets/fonts/IBM%2520Plex%2520Serif/IBMPlexSerif-ThinItalic.ttf": "412d39301962ae2add4c7894adc8349c",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/FontManifest.json": "5718295b6aed5e50d3436e8eb6fd04c2",
"assets/NOTICES": "bf4556f0350984e3fe69a728f9902fb4",
"main.dart.js": "e42bd4463720d9d12c3f127f97a42863",
"manifest.json": "c13cfe3df557a48da1077f6ad6086c2f",
"version.json": "37bb5e4dae4eec22f60188d088ba36cf",
"canvaskit/skwasm.js.symbols": "9fe690d47b904d72c7d020bd303adf16",
"canvaskit/canvaskit.js": "728b2d477d9b8c14593d4f9b82b484f3",
"canvaskit/skwasm.wasm": "1c93738510f202d9ff44d36a4760126b",
"canvaskit/canvaskit.wasm": "a37f2b0af4995714de856e21e882325c",
"canvaskit/canvaskit.js.symbols": "27361387bc24144b46a745f1afe92b50",
"canvaskit/skwasm.js": "ea559890a088fe28b4ddf70e17e60052",
"canvaskit/chromium/canvaskit.js": "8191e843020c832c9cf8852a4b909d4c",
"canvaskit/chromium/canvaskit.wasm": "c054c2c892172308ca5a0bd1d7a7754b",
"canvaskit/chromium/canvaskit.js.symbols": "f7c5e5502d577306fb6d530b1864ff86",
"flutter_bootstrap.js": "854a5af2c7611a5d8db6359ff444cfcf",
"index.html": "5533d87790ce924bbd0f24472ac45dc5",
"/": "5533d87790ce924bbd0f24472ac45dc5",
"flutter.js": "83d881c1dbb6d6bcd6b42e274605b69c"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
