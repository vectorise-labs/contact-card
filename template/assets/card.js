/* Contact card behaviour. Template by Vectorise Labs (MIT).
   1. QR: draws this page's QR code as an SVG into .qr[data-url].
   2. Share: native share sheet on phones, copy link elsewhere.
   3. Add contact: shares contact.vcf as a file on phones (Save to Contacts),
      falls back to the plain download link everywhere else.
   No network requests leave this site. */
(function () {
  "use strict";

  /* 1. QR code. Error level Q, square modules, a 4-module quiet zone. The
     finder patterns are drawn separately so styles.css can colour them:
     .qr-data and .qr-eye for the modules, .qr-pupil for the finder centres. */
  function drawQR(el) {
    var url = el.getAttribute("data-url") || "";
    if (!/^https?:\/\//.test(url)) url = location.href.split("#")[0];
    if (typeof qrcode !== "function") return;
    var qr = qrcode(0, "Q");
    qr.addData(url);
    qr.make();
    var n = qr.getModuleCount(), q = 4, s = 0.82, o = (1 - s) / 2;
    var finders = [[0, 0], [0, n - 7], [n - 7, 0]];
    function inFinder(r, c) {
      return finders.some(function (f) { return r >= f[0] && r < f[0] + 7 && c >= f[1] && c < f[1] + 7; });
    }
    var d = "";
    for (var r = 0; r < n; r++) {
      for (var c = 0; c < n; c++) {
        if (qr.isDark(r, c) && !inFinder(r, c)) d += "M" + (c + o) + " " + (r + o) + "h" + s + "v" + s + "h-" + s + "z";
      }
    }
    var eyes = finders.map(function (f) {
      var y = f[0], x = f[1];
      return '<path class="qr-eye" fill-rule="evenodd" d="M' + x + " " + y + "h7v7h-7zM" + (x + 1) + " " + (y + 1) + 'v5h5v-5z"/>' +
        '<rect class="qr-pupil" x="' + (x + 2) + '" y="' + (y + 2) + '" width="3" height="3"/>';
    }).join("");
    var label = "QR code for " + url.replace(/^https?:\/\//, "").replace(/\/$/, "");
    el.innerHTML = '<svg class="qr-code" viewBox="' + -q + " " + -q + " " + (n + 2 * q) + " " + (n + 2 * q) +
      '" role="img" aria-label="' + label + '" shape-rendering="crispEdges"><path class="qr-data" d="' + d + '"/>' + eyes + "</svg>";
  }
  Array.prototype.forEach.call(document.querySelectorAll(".qr[data-url]"), drawQR);

  /* 2. Share. iPadOS reports as Mac, so touch points are checked too. */
  var share = document.getElementById("share");
  if (share) {
    var label = share.querySelector(".share-label");
    var original = label ? label.textContent : "";
    var ua = navigator.userAgent;
    var touch = /iPad|iPhone|iPod|Android/.test(ua) || (ua.indexOf("Mac") > -1 && navigator.maxTouchPoints > 1);
    var flash = function (text) {
      if (!label) return;
      label.textContent = text;
      share.classList.add("flash");
      setTimeout(function () { label.textContent = original; share.classList.remove("flash"); }, 1800);
    };
    var copy = function () {
      var url = location.href.split("#")[0];
      if (navigator.clipboard && navigator.clipboard.writeText) {
        navigator.clipboard.writeText(url).then(function () { flash("Link copied"); }, function () { flash("Copy failed"); });
      } else {
        var ta = document.createElement("textarea");
        ta.value = url; ta.style.position = "fixed"; ta.style.opacity = "0";
        document.body.appendChild(ta); ta.select();
        try { document.execCommand("copy"); flash("Link copied"); } catch (e) { flash("Copy failed"); }
        document.body.removeChild(ta);
      }
    };
    share.addEventListener("click", function () {
      if (touch && navigator.share) {
        navigator.share({ title: document.title, url: location.href.split("#")[0] }).catch(function (err) {
          if (err && err.name !== "AbortError") copy();
        });
      } else {
        copy();
      }
    });
  }

  /* 3. Add contact. Safari saves a plain .vcf link to Files; sharing it as a
     File (Web Share API level 2) offers Save to Contacts instead. */
  var add = document.getElementById("add-contact");
  if (add && navigator.canShare && location.protocol !== "file:") {
    add.addEventListener("click", function (e) {
      var href = add.getAttribute("href");
      e.preventDefault();
      fetch(href).then(function (res) {
        if (!res.ok) throw new Error("vcf " + res.status);
        return res.blob();
      }).then(function (blob) {
        var file = new File([blob], href.split("/").pop(), { type: "text/vcard" });
        if (!navigator.canShare({ files: [file] })) { location.href = href; return; }
        return navigator.share({ files: [file] }).catch(function (err) {
          if (err && err.name !== "AbortError") location.href = href;
        });
      }).catch(function () { location.href = href; });
    });
  }
})();
