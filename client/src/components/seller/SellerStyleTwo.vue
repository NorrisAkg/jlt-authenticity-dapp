<template>
    
</template>

<script>
    import NiceSelect from '@/components/select/NiceSelect'
    import Seller from '@/components/seller/Seller'
    import AuthorMixin from '@/mixins/AuthorMixin'
    import AppFunctions from '@/helpers/AppFunctions'

    export default {
        name: 'SellerStyleTwo',
        components: {Seller, NiceSelect},
        mixins: [AuthorMixin],
        data() {
            return {
                sortByStatusSeller: '',
                sortStatus: 'top rated'
            }
        },
        watch: {
            'sortStatus': function (val) {
                this.getSellerByStatus(val)
            }
        },
        methods: {
            changeHandler(item) {
                this.sortStatus = item.value;
            },
            getSellerByStatus(type) {
                this.sortByStatusSeller = this.authors.filter(seller =>  AppFunctions.slugify(seller.status) === AppFunctions.slugify(type));
            }
        },
        mounted() {
            this.getSellerByStatus(this.sortStatus);
        }
    }
</script>