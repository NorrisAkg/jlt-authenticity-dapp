<template>
  <layout>
    <explore-filter />
  </layout>
</template>

<script>
import Layout from "@/components/layouts/Layout";

import ExploreFilter from "@/components/explore/ExploreFilter";
import SalScrollAnimationMixin from "@/mixins/SalScrollAnimationMixin";

export default {
  name: "ExploreOne",
  components: { ExploreFilter, Layout },
  mixins: [SalScrollAnimationMixin],
};
</script>
