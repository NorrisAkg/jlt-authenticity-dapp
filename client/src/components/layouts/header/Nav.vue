<template>
  <ul class="mainmenu">
    <li>
      <div class="setting-option d-none d-lg-block">
        <form class="search-form-wrapper" action="#">
          <input type="search" placeholder="Search Here" aria-label="Search" />
          <div class="search-icon">
            <button><i class="feather-search" /></button>
          </div>
        </form>
      </div>
    </li>

    <div class="setting-option rn-icon-list d-block d-lg-none">
      <div class="icon-box search-mobile-icon">
        <button
          @click.prevent="
            AppFunctions.toggleClass('.large-mobile-blog-search', 'active'),
              (isMobileSearchActive = !isMobileSearchActive)
          "
        >
          <i :class="isMobileSearchActive ? 'feather-x' : 'feather-search'" />
        </button>
      </div>
    </div>
  </ul>
</template>

<script>
export default {
  name: "Nav",
  data() {
    return {
      isMobileSearchActive: false,
      navItems: [
        // {
        //   link: "/",
        //   title: "Home",
        //   hasDropdown: false,
        //   megamenu: false,
        // },
        // {
        //   link: "#",
        //   title: "Blog",
        //   hasDropdown: true,
        //   megamenu: false,
        //   dropdownItems: [
        //     {
        //       link: "/blog-single-column",
        //       title: "Blog Single Column",
        //       icon: "fast-forward",
        //     },
        //     {
        //       link: "/blog-col-two",
        //       title: "Blog Two Column",
        //       icon: "fast-forward",
        //     },
        //     {
        //       link: "/blog-col-three",
        //       title: "Blog Three Column",
        //       icon: "fast-forward",
        //     },
        //     { link: "/blog", title: "Blog Four Column", icon: "fast-forward" },
        //     {
        //       link: "/blog-details/1",
        //       title: "Blog Details",
        //       icon: "fast-forward",
        //     },
        //   ],
        // },
      ],
    };
  },
};
</script>
