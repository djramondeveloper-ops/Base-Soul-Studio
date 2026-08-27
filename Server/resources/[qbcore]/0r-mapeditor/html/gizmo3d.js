(function () {
  var renderer, scene, camera, gizmo, arrowsG, ringsG, heightLine;
  var parts = {};
  var ready = false, initFailed = false;

  var AX = [
    { k: 'x', col: 0xEC4848, orient: function (m) { m.rotation.z = -Math.PI / 2; }, ringRot: function (m) { m.rotation.y = Math.PI / 2; } },
    { k: 'y', col: 0x56D068, orient: function (m) {}, ringRot: function (m) { m.rotation.x = Math.PI / 2; } },
    { k: 'z', col: 0x5C9CFF, orient: function (m) { m.rotation.x = Math.PI / 2; }, ringRot: function (m) {} },
  ];

  function init() {
    if (ready || initFailed || !window.THREE) return;
    var canvas = null;
    try {
    canvas = document.createElement('canvas');
    canvas.id = 'gizmo3d';
    canvas.style.cssText = 'position:fixed;left:0;top:0;width:100%;height:100%;pointer-events:none;z-index:0;';
    document.body.appendChild(canvas);

    renderer = new THREE.WebGLRenderer({ canvas: canvas, alpha: true, antialias: true });
    renderer.setPixelRatio(window.devicePixelRatio || 1);
    renderer.setClearColor(0x000000, 0);

    scene = new THREE.Scene();
    camera = new THREE.PerspectiveCamera(50, 1, 0.01, 6000);
    camera.up.set(0, 0, 1);

    gizmo = new THREE.Group();
    arrowsG = new THREE.Group();
    ringsG = new THREE.Group();
    gizmo.add(arrowsG, ringsG);
    scene.add(gizmo);

    AX.forEach(function (a) {
      var mMat = new THREE.MeshBasicMaterial({ color: a.col, transparent: true, opacity: 0.9, depthWrite: false });
      var rMat = new THREE.MeshBasicMaterial({ color: a.col, transparent: true, opacity: 0.55, depthWrite: false });

      var shaft = new THREE.Mesh(new THREE.CylinderGeometry(0.006, 0.006, 0.86, 6), mMat);
      shaft.position.y = 0.43;
      var head = new THREE.Mesh(new THREE.ConeGeometry(0.03, 0.14, 16), mMat);
      head.position.y = 0.93;
      var arm = new THREE.Group();
      arm.add(shaft, head);
      a.orient(arm);
      arrowsG.add(arm);

      var ring = new THREE.Mesh(new THREE.TorusGeometry(1, 0.006, 8, 96), rMat);
      a.ringRot(ring);
      ringsG.add(ring);

      parts[a.k] = { arm: arm, ring: ring, mMat: mMat, rMat: rMat };
    });

    var pivot = new THREE.Mesh(new THREE.OctahedronGeometry(0.05), new THREE.MeshBasicMaterial({ color: 0xEAEAF0, transparent: true, opacity: 0.95, depthWrite: false }));
    arrowsG.add(pivot);

    var lineGeo = new THREE.BufferGeometry();
    lineGeo.setAttribute('position', new THREE.BufferAttribute(new Float32Array(6), 3));
    heightLine = new THREE.Line(lineGeo, new THREE.LineBasicMaterial({ color: 0x78C8FF, transparent: true, opacity: 0.35, depthWrite: false }));
    heightLine.visible = false;
    heightLine.frustumCulled = false;
    scene.add(heightLine);

    resize();
    window.addEventListener('resize', resize);
    ready = true;
    } catch (e) {
      ready = false; initFailed = true;
      if (canvas && canvas.parentNode) canvas.parentNode.removeChild(canvas);
    }
  }

  function resize() {
    if (!renderer) return;
    var w = window.innerWidth, h = window.innerHeight;
    renderer.setSize(w, h, false);
    camera.aspect = w / h;
    camera.updateProjectionMatrix();
  }

  function setFrame(d) {
    if (!ready) { init(); if (!ready) return; }
    if (!d || !d.on) {
      gizmo.visible = false;
      renderer.render(scene, camera);
      return;
    }
    var c = d.cam, o = d.obj;
    camera.position.set(c.x, c.y, c.z);
    camera.up.set(0, 0, 1);
    camera.lookAt(c.x + c.fx, c.y + c.fy, c.z + c.fz);
    if (Math.abs(camera.fov - c.fov) > 0.01) { camera.fov = c.fov; camera.updateProjectionMatrix(); }

    gizmo.visible = true;
    gizmo.position.set(o.x, o.y, o.z);
    arrowsG.scale.setScalar(d.len || 1);
    ringsG.scale.setScalar(d.ringR || 1);

    AX.forEach(function (a) {
      var p = parts[a.k];
      var mh = d.hotMove === a.k, rh = d.hotRot === a.k;
      p.mMat.opacity = mh ? 1.0 : 0.88;
      p.arm.scale.setScalar(mh ? 1.1 : 1.0);
      p.rMat.opacity = rh ? 1.0 : 0.5;
      p.ring.scale.setScalar(rh ? 1.03 : 1.0);
    });

    renderer.render(scene, camera);
  }

  function setLine(d) {
    if (!ready) { init(); if (!ready) return; }
    if (!d || !d.on) {
      if (heightLine) heightLine.visible = false;
      if (renderer) renderer.render(scene, camera);
      return;
    }
    var c = d.cam;
    camera.position.set(c.x, c.y, c.z);
    camera.up.set(0, 0, 1);
    camera.lookAt(c.x + c.fx, c.y + c.fy, c.z + c.fz);
    if (Math.abs(camera.fov - c.fov) > 0.01) { camera.fov = c.fov; camera.updateProjectionMatrix(); }
    var pos = heightLine.geometry.attributes.position;
    pos.setXYZ(0, d.a.x, d.a.y, d.a.z);
    pos.setXYZ(1, d.b.x, d.b.y, d.b.z);
    pos.needsUpdate = true;
    heightLine.visible = true;
    renderer.render(scene, camera);
  }

  window.Gizmo3D = { setFrame: setFrame, setLine: setLine, init: init };
})();
