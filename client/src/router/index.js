import { createRouter, createWebHistory } from "vue-router";
import HomePageOne from "../views/home/HomePageOne";
import CreateProduct from "../views/CreateProduct";
import ProductDetails from "../views/ProductDetails";
import Connect from "../views/Connect";
import ExploreOne from "../views/ExploreOne";
import Products from "../views/Products";

const routes = [
  {
    path: "/",
    name: "HomePageOne",
    component: HomePageOne,
    meta: {
      title: "Nuron - NFT Marketplace Template",
    },
  },
  {
    path: "/create",
    name: "CreateProduct",
    component: CreateProduct,
    meta: {
      title: "Create || Nuron - NFT Marketplace Template",
    },
  },
  {
    path: "/product/:id",
    name: "ProductDetails",
    component: ProductDetails,
    meta: {
      title: "Product Details || Nuron - NFT Marketplace Template",
    },
  },
  {
    path: "/connect",
    name: "Connect",
    component: Connect,
    meta: {
      title: "Connect || Nuron - NFT Marketplace Template",
    },
  },

  {
    path: "/explore-01",
    name: "ExploreOne",
    component: ExploreOne,
    meta: {
      title: "Explore Filter || Nuron - NFT Marketplace Template",
    },
  },

  {
    path: "/product",
    name: "Products",
    component: Products,
    meta: {
      title: "Product || Nuron - NFT Marketplace Template",
    },
  },
];

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes,
});

router.beforeEach((to, from, next) => {
  document.title = to.meta.title;
  next();
  window.scrollTo(0, 0);
});

export default router;
