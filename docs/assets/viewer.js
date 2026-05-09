import * as THREE from 'three';
import { OrbitControls } from 'three/addons/controls/OrbitControls.js';
import { STLLoader } from 'three/addons/loaders/STLLoader.js';

const canvas = document.querySelector('#fielddeck-viewer');
const loading = document.querySelector('#loading-state');

const scene = new THREE.Scene();
scene.background = new THREE.Color(0x141410);

const renderer = new THREE.WebGLRenderer({
  canvas,
  antialias: true,
  alpha: false
});
renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2));
renderer.outputColorSpace = THREE.SRGBColorSpace;
renderer.shadowMap.enabled = true;
renderer.shadowMap.type = THREE.PCFSoftShadowMap;

const camera = new THREE.PerspectiveCamera(34, 1, 0.1, 5000);
camera.position.set(260, -360, 230);

const controls = new OrbitControls(camera, renderer.domElement);
controls.enableDamping = true;
controls.dampingFactor = 0.08;
controls.screenSpacePanning = true;
controls.minDistance = 130;
controls.maxDistance = 950;

const keyLight = new THREE.DirectionalLight(0xffffff, 3.0);
keyLight.position.set(-260, -280, 380);
keyLight.castShadow = true;
scene.add(keyLight);

const fillLight = new THREE.DirectionalLight(0xc9d5ff, 0.75);
fillLight.position.set(260, 180, 220);
scene.add(fillLight);

scene.add(new THREE.HemisphereLight(0xf3eddc, 0x242420, 1.35));

const floor = new THREE.Mesh(
  new THREE.PlaneGeometry(900, 700),
  new THREE.ShadowMaterial({ opacity: 0.28 })
);
floor.rotation.x = -Math.PI / 2;
floor.position.z = -18;
floor.receiveShadow = true;
scene.add(floor);

const materials = {
  shellWarm: new THREE.MeshStandardMaterial({
    color: 0xb9b6ad,
    roughness: 0.74,
    metalness: 0.04
  }),
  shellGraphite: new THREE.MeshStandardMaterial({
    color: 0x2b2b27,
    roughness: 0.68,
    metalness: 0.08
  }),
  shellXray: new THREE.MeshStandardMaterial({
    color: 0xd8cfb8,
    roughness: 0.45,
    metalness: 0.02,
    transparent: true,
    opacity: 0.32,
    depthWrite: false
  }),
  shellWire: new THREE.MeshStandardMaterial({
    color: 0xd8cfb8,
    roughness: 0.65,
    metalness: 0.02,
    wireframe: true
  }),
  tablet: new THREE.MeshStandardMaterial({
    color: 0x050708,
    roughness: 0.52,
    metalness: 0.06
  }),
  keycaps: new THREE.MeshStandardMaterial({
    color: 0xe8dfcc,
    roughness: 0.82,
    metalness: 0.01
  }),
  components: new THREE.MeshStandardMaterial({
    color: 0x263d34,
    roughness: 0.58,
    metalness: 0.08
  }),
  componentsBright: new THREE.MeshStandardMaterial({
    color: 0x6fb08d,
    roughness: 0.5,
    metalness: 0.05
  })
};

const modelDefs = [
  { key: 'shell', url: './assets/models/fielddeck_shell.stl', material: materials.shellWarm },
  { key: 'tablet', url: './assets/models/fielddeck_tablet.stl', material: materials.tablet },
  { key: 'keycaps', url: './assets/models/fielddeck_keycaps.stl', material: materials.keycaps },
  { key: 'components', url: './assets/models/fielddeck_components.stl', material: materials.components }
];

const modelGroup = new THREE.Group();
scene.add(modelGroup);
const meshes = {};
let loadedModels = 0;
const loader = new STLLoader();

for (const def of modelDefs) {
  loader.load(def.url, (geometry) => {
    geometry.computeVertexNormals();

    const mesh = new THREE.Mesh(geometry, def.material);
    mesh.rotation.x = -Math.PI / 2;
    mesh.castShadow = true;
    mesh.receiveShadow = true;
    mesh.userData.key = def.key;
    meshes[def.key] = mesh;
    modelGroup.add(mesh);

    loadedModels += 1;
    if (loadedModels === modelDefs.length) {
      centerModel();
      setMode('warm');
      loading.classList.add('is-hidden');
      resize();
    }
  }, undefined, (error) => {
    loading.textContent = '3D model failed to load.';
    console.error(error);
  });
}

function centerModel() {
  const box = new THREE.Box3().setFromObject(modelGroup);
  const center = box.getCenter(new THREE.Vector3());
  modelGroup.position.sub(center);
  controls.target.set(0, 0, 35);
  controls.update();
}

function setMode(mode) {
  if (!meshes.shell) return;

  meshes.components.visible = mode === 'internals' || mode === 'xray' || mode === 'wire';
  meshes.tablet.visible = true;
  meshes.keycaps.visible = true;

  if (mode === 'warm') {
    meshes.shell.material = materials.shellWarm;
    meshes.components.visible = false;
  } else if (mode === 'graphite') {
    meshes.shell.material = materials.shellGraphite;
    meshes.components.visible = false;
  } else if (mode === 'internals') {
    meshes.shell.material = materials.shellXray;
    meshes.components.material = materials.componentsBright;
  } else if (mode === 'wire') {
    meshes.shell.material = materials.shellWire;
    meshes.components.material = materials.componentsBright;
  }

  document.querySelectorAll('.mode-button').forEach((button) => {
    button.classList.toggle('is-active', button.dataset.mode === mode);
  });
}

function setView(view) {
  const target = new THREE.Vector3(0, 0, 35);
  const views = {
    iso: new THREE.Vector3(260, -360, 230),
    front: new THREE.Vector3(0, -520, 115),
    side: new THREE.Vector3(520, -20, 135),
    top: new THREE.Vector3(0, 0, 620)
  };

  camera.position.copy(views[view] || views.iso);
  controls.target.copy(target);
  controls.update();
}

document.querySelectorAll('.mode-button').forEach((button) => {
  button.addEventListener('click', () => setMode(button.dataset.mode));
});

document.querySelectorAll('.view-button').forEach((button) => {
  button.addEventListener('click', () => setView(button.dataset.view));
});

function resize() {
  const rect = canvas.parentElement.getBoundingClientRect();
  const width = Math.max(320, rect.width);
  const height = Math.max(520, rect.height);
  renderer.setSize(width, height, false);
  camera.aspect = width / height;
  camera.updateProjectionMatrix();
}

window.addEventListener('resize', resize);
resize();

function animate() {
  controls.update();
  renderer.render(scene, camera);
  requestAnimationFrame(animate);
}

animate();
