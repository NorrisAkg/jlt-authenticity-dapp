import { createRouter, createWebHistory } from "vue-router";
import HomePageOne from "../views/home/HomePageOne";
import CreateProduct from "../views/CreateProduct";
import ProductDetails from "../views/ProductDetails";
import ExploreOne from "../views/ExploreOne";
import Products from "./../views/Products.vue";

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
    path: "/new-product",
    name: "CreateProduct",
    component: CreateProduct,
    meta: {
      title: "New product || Nuron - NFT Marketplace Template",
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
    path: "/explore-01",
    name: "ExploreOne",
    component: ExploreOne,
    meta: {
      title: "Explore Filter || Nuron - NFT Marketplace Template",
    },
  },

  {
    path: "/products",
    name: "Products",
    component: Products,
    meta: {
      title: "Products || Nuron - NFT Marketplace Template",
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
