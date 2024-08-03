import { createApp } from "vue";
import 'core-js/stable';
import 'regenerator-runtime/runtime';
import App from "./App.vue";
import router from "./router";
import "animate.css";
import "./assets/css/feature.css";
import "./assets/scss/style.scss";
import "bootstrap";

createApp(App).use(router).mount("#app");
