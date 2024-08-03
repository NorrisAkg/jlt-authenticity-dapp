<template>
  <div class="pb-5">
    <Header />
    <mobile-menu />
    <main>
      <slot></slot>
    </main>
    <!-- <Footer :data="$props"/> -->
    <back-to-top @click="scrollTop" />
  </div>
</template>

<script>
import Header from "./header/Header";
import Footer from "./footer/Footer";
import MobileMenu from "./header/MobileMenu";
import BackToTop from "@/components/layouts/footer/BackToTop";

export default {
  name: "Layout",
  components: { BackToTop, MobileMenu, Footer, Header },
  props: {
    showFooterBrand: {
      type: Boolean,
      default: false,
    },
  },

  methods: {
    scrollTop() {
      window.scrollTo(0, 0);
    },
  },
};
</script>
