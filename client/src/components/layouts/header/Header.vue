<template>
  <header class="rn-header haeder-default header--sticky">
    <div class="container">
      <div class="header-inner">
        <div class="header-left">
          <logo />
          <div class="mainmenu-wrapper">
            <nav class="mainmenu-nav d-none d-xl-block">
              <Nav />
            </nav>
          </div>
        </div>
        <div class="header-right">
          <div class="setting-option rn-icon-list d-block d-lg-none">
            <div class="icon-box search-mobile-icon">
              <button
                @click.prevent="
                  AppFunctions.toggleClass(
                    '.large-mobile-blog-search',
                    'active'
                  ),
                    (isMobileSearchActive = !isMobileSearchActive)
                "
              >
                <i
                  :class="isMobileSearchActive ? 'feather-x' : 'feather-search'"
                />
              </button>
            </div>
          </div>
          <div
            class="setting-option header-btn rbt-site-header flex-shrink-0"
            id="rbt-site-header"
          >
            <div class="icon-box">
              <button
                v-if="!account"
                id="connectbtn"
                class="btn btn-primary-alta btn-small"
                @click="connect"
              >
                Connect wallet
              </button>

              <button
                v-else
                id="connectbtn"
                class="btn btn-primary-alta btn-small"
                @click="this.$router.push('/new-product')"
              >
                Add product
              </button>
            </div>
          </div>

          <div class="header_admin">
            <div class="setting-option rn-icon-list user-account">
              <div class="icon-box">
                <router-link to="/">
                  <img
                    :src="require(`@/assets/images/icons/boy-avater.png`)"
                    alt="Images"
                  />
                </router-link>
                <div class="rn-dropdown">
                  <div class="rn-inner-top">
                    <h4 class="title">
                      <router-link to="/">Christopher William</router-link>
                    </h4>
                    <span>
                      <router-link to="#">Set Display Name</router-link>
                    </span>
                  </div>
                  <div class="rn-product-inner">
                    <ul class="product-list">
                      <li class="single-product-list">
                        <div class="thumbnail">
                          <router-link to="/">
                            <img
                              :src="
                                require(`@/assets/images/portfolio/portfolio-07.jpg`)
                              "
                              alt="Nft Product Images"
                            />
                          </router-link>
                        </div>
                        <div class="content">
                          <h6 class="title">
                            <router-link to="/">Balance</router-link>
                          </h6>
                          <span class="price">25 ETH</span>
                        </div>
                        <div class="button"></div>
                      </li>
                      <li class="single-product-list">
                        <div class="thumbnail">
                          <router-link to="/">
                            <img
                              :src="
                                require(`@/assets/images/portfolio/portfolio-01.jpg`)
                              "
                              alt="Nft Product Images"
                            />
                          </router-link>
                        </div>
                        <div class="content">
                          <h6 class="title">
                            <router-link to="/">Balance</router-link>
                          </h6>
                          <span class="price">25 ETH</span>
                        </div>
                        <div class="button"></div>
                      </li>
                    </ul>
                  </div>
                  <div class="add-fund-button mt--20 pb--20">
                    <router-link class="btn btn-primary-alta w-100" to="/"
                      >Add Your More Funds
                    </router-link>
                  </div>
                  <ul class="list-inner">
                    <li>
                      <router-link to="/">My Profile</router-link>
                    </li>
                    <li>
                      <router-link to="/">Edit Profile</router-link>
                    </li>
                    <li>
                      <router-link to="/">Manage funds</router-link>
                    </li>
                    <li>
                      <router-link to="/">Sign Out</router-link>
                    </li>
                  </ul>
                </div>
              </div>
            </div>
          </div>
          <div class="setting-option mobile-menu-bar d-block d-xl-none">
            <div class="hamberger">
              <button
                class="hamberger-button"
                @click="AppFunctions.addClass('.popup-mobile-menu', 'active')"
              >
                <i class="feather-menu" />
              </button>
            </div>
          </div>
          <div class="my_switcher setting-option">
            <ul>
              <li>
                <a
                  href="#"
                  data-theme="light"
                  class="setColor light"
                  @click.prevent="
                    AppFunctions.addClass('body', 'active-light-mode'),
                      AppFunctions.removeClass('body', 'active-dark-mode')
                  "
                >
                  <img
                    class="sun-image"
                    :src="require(`@/assets/images/icons/sun-01.svg`)"
                    alt="Sun images"
                  />
                </a>
              </li>
              <li>
                <a
                  href="#"
                  data-theme="dark"
                  class="setColor dark"
                  @click.prevent="
                    AppFunctions.addClass('body', 'active-dark-mode'),
                      AppFunctions.removeClass('body', 'active-light-mode')
                  "
                >
                  <img
                    class="Victor Image"
                    :src="require(`@/assets/images/icons/vector.svg`)"
                    alt="Vector Images"
                  />
                </a>
              </li>
            </ul>
          </div>
        </div>
      </div>
    </div>
  </header>
</template>

<script>
import Nav from "./Nav";
import AppFunctions from "../../../helpers/AppFunctions";
import Logo from "@/components/logo/Logo";
import { ethers } from "ethers";
import { useRouter } from "vue-router";

export default {
  router: useRouter(),
  name: "Header",
  components: { Logo, Nav },
  data() {
    return {
      AppFunctions,
      isMobileSearchActive: false,
      ethereum: window.ethereum,
      account: null,
    };
  },

  async created() {
    await this.checkConnection();
    this.setupEventListeners();
  },

  methods: {
    connect: async () => {
      if (window.ethereum) {
        try {
          // Demandez la connexion au portefeuille (si ce n'est pas déjà fait)
          await window.ethereum.request({ method: "eth_requestAccounts" });

          // Créez un fournisseur avec `window.ethereum`
          const provider = new ethers.providers.Web3Provider(window.ethereum);

          // Obtenez un signer pour signer les transactions
          const signer = provider.getSigner();

          // Obtenez l'adresse du compte
          const address = await signer.getAddress();
          console.log("Connected address:", address);

          // Optionnel : obtenir la chaîne actuelle
          const network = await provider.getNetwork();
          console.log("Network:", network.name);
        } catch (error) {
          console.error("Error connecting to wallet:", error);
        }
      } else {
        console.error("No Ethereum provider found");
      }
    },

    async checkConnection() {
      if (window.ethereum) {
        const provider = new ethers.providers.Web3Provider(window.ethereum);
        const accounts = await provider.listAccounts();
        if (accounts.length > 0) {
          this.account = accounts[0];
        }
      }
    },

    setupEventListeners() {
      // Écoute les changements de compte
      window.ethereum.on("accountsChanged", (accounts) => {
        if (accounts.length > 0) {
          this.account = accounts[0];
        } else {
          this.account = null;
        }
      });

      // Écoute les changements de réseau
      window.ethereum.on("networkChanged", (networkId) => {
        console.log("Network changed:", networkId);
        // Vous pouvez également ajouter la logique pour gérer les changements de réseau ici
      });

      // Écoute les événements de déconnexion
      window.ethereum.on("disconnect", () => {
        this.account = null;
      });
    },
  },

  mounted() {
    const header = document.querySelector(".header--sticky");
    const setStickyHeader = () => {
      const scrollPos = window.scrollY;
      if (scrollPos > 50) {
        header.classList.add("sticky");
      } else {
        header.classList.remove("sticky");
      }
    };
    window.addEventListener("scroll", setStickyHeader);

    if (window.ethereum) {
      const provider = new ethers.providers.Web3Provider(window.ethereum);

      // Exemple : obtenir le compte actuel
      provider.listAccounts().then((accounts) => {
        console.log("Accounts:", accounts);
      });
    } else {
      console.error("Ethereum provider not found");
    }
  },
};
</script>
