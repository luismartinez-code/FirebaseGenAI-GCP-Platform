const environmentElement = document.getElementById('environment');
const recommendationCountElement = document.getElementById('recommendationCount');
const lookerStateElement = document.getElementById('lookerState');
const outputElement = document.getElementById('output');

const firebaseConfig = {
  apiKey: "demo-api-key",
  authDomain: "genai-platform-dev.firebaseapp.com",
  projectId: "genai-platform-dev",
  storageBucket: "genai-platform-dev.appspot.com",
  messagingSenderId: "000000000000",
  appId: "1:000000000000:web:demo"
};

const defaultConfig = {
  genai_mode: 'secure-generation',
  dashboard_experience: 'balanced',
  reco_limit: '5',
  looker_enabled: 'true'
};

function applyConfig(config) {
  environmentElement.textContent = 'dev';
  recommendationCountElement.textContent = config.reco_limit || defaultConfig.reco_limit;
  lookerStateElement.textContent = config.looker_enabled === 'true' ? 'on' : 'off';
  outputElement.textContent = JSON.stringify({
    genai_mode: config.genai_mode || defaultConfig.genai_mode,
    dashboard_experience: config.dashboard_experience || defaultConfig.dashboard_experience,
    looker_enabled: config.looker_enabled || defaultConfig.looker_enabled
  }, null, 2);
}

document.getElementById('syncButton').addEventListener('click', () => {
  applyConfig(defaultConfig);
  outputElement.textContent = 'Remote Config synced successfully (demo mode).';
});

applyConfig(defaultConfig);
