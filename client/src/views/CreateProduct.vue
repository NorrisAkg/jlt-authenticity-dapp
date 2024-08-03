<template>
  <layout>
    <div class="create-area rn-section-gapTop">
      <div class="container">
        <div class="row g-5">
          <div class="col-lg-3 offset-1 ml_md--0 ml_sm--0">
            <!-- Start file Upload Area -->
            <div class="upload-area">
              <div class="upload-formate mb--30">
                <h6 class="title">Upload file</h6>
                <p class="formate">Drag or choose your file to upload</p>
              </div>
              <div class="brows-file-wrapper">
                <input
                  id="file"
                  type="file"
                  class="inputfile"
                  multiple
                  @change="imageChange"
                />
                <img
                  v-if="selectedImage"
                  id="createfileImage"
                  :src="selectedImage"
                  alt=""
                  data-black-overlay="6"
                />
                <label for="file" title="No File Choosen">
                  <i class="feather-upload" />
                  <span class="text-center">Choose a File</span>
                  <p class="text-center mt--10">
                    PNG, GIF, WEBP, MP4 or MP3.{" "} <br />
                    Max 1Gb.
                  </p>
                </label>
              </div>
            </div>
            <!-- End File Upload Area -->
          </div>

          <div class="col-lg-7">
            <div class="form-wrapper-one">
              <form class="row" action="#">
                <div class="col-md-12">
                  <div class="input-box pb--20">
                    <label for="name" class="form-label">Product Name</label>
                    <input
                      v-model="product.name"
                      id="name"
                      placeholder="e. g. `Digital Awesome Game`"
                    />
                  </div>
                </div>
                <div class="col-md-12">
                  <div class="input-box pb--20">
                    <label for="Description" class="form-label"
                      >Description</label
                    >
                    <textarea
                      id="Description"
                      v-model="product.description"
                      rows="3"
                      placeholder="e. g. “After purchasing the product you can get item...”"
                    >
                    </textarea>
                  </div>
                </div>
                <div class="col-md-6">
                  <div class="input-box pb--20">
                    <label for="Size" class="form-label">Serial number</label>
                    <input
                      v-model="product.serialNumber"
                      id="Size"
                      placeholder="e. g. `Size`"
                    />
                  </div>
                </div>
                <div class="col-md-6">
                  <div class="input-box pb--20">
                    <label for="dollerValue" class="form-label"
                      >Item Price in $</label
                    >
                    <input
                      v-model="product.price"
                      id="dollerValue"
                      placeholder="e. g. `20$`"
                    />
                  </div>
                </div>

                <div class="col-md-12 col-xl-8 mt_lg--15 mt_md--15 mt_sm--15">
                  <div class="input-box">
                    <button
                      @click="addProduct()"
                      class="btn btn-primary btn-large w-100"
                    >
                      Submit Item
                    </button>
                  </div>
                </div>
              </form>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Modal -->
    <div
      class="rn-popup-modal upload-modal-wrapper modal fade"
      id="uploadModal"
      tabindex="-1"
      aria-hidden="true"
    >
      <button
        type="button"
        class="btn-close"
        data-bs-dismiss="modal"
        aria-label="Close"
      >
        <i class="feather-x" />
      </button>
      <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable">
        <div class="modal-content share-wrapper">
          <div class="modal-body">
            <product-card
              :product-date="product"
              product-style-class="no-overlay"
            />
          </div>
        </div>
      </div>
    </div>

    <share-modal />

    <report-modal />
  </layout>
</template>

<script>
import Layout from "@/components/layouts/Layout";
import ProductCard from "@/components/product/ProductCard";
import ShareModal from "@/components/modal/ShareModal";
import ReportModal from "@/components/modal/ReportModal";
import { createProduct } from "./../web3/index.js";

export default {
  name: "CreateProduct",
  components: { ReportModal, ShareModal, ProductCard, Layout },
  data() {
    return {
      selectedImage: null,
      product: {
        serialNumber: null,
        name: null,
        description: null,
        price: null,
        picture: null,
      },
    };
  },
  methods: {
    imageChange(e) {
      if (e.target.files && e.target.files.length > 0) {
        const file = e.target.files[0];
        this.selectedImage = URL.createObjectURL(file);
      }
    },

    addProduct: () => {
      console.log("first");
      console.log(this.product);
      //   this.product.picture = this.selectedImage;
      //   createProduct(this.product);
    },
  },
};
</script>
