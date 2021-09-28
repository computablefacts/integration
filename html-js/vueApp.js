const vm = new Vue({
  el: '#app',
  data: function () {
    return {
      inputToken: '',
      inputBaseUrl: '',
      query: 'SELECT * \nFROM materialized_facts_properties\nORDER BY namespace_name, class_name, property_name',
      format: 'arrays_with_header',
      useCatalog: true,
      loading: false,
      hasError: false,
      error: null,
      results: [],
      cfApiAutodetect: null,
      cfApiToken: null,
      cfApiUrl: null,
    }
  },
  computed: {
    header() {
      return this.results.length ? this.results[0] : []
    },
    data() {
      return this.results.length ? this.results.slice(1) : []
    },
  },
  mounted() {
    cf.httpClient.init()
    this.cfApiAutodetect = cf.httpClient.hasAutodetect()
    this.cfApiToken = cf.httpClient.getToken()
    this.cfApiUrl = cf.httpClient.getBaseUrl()
  },
  methods: {
    loadResults() {

      this.loading = true
      this.hasError = false
      this.error = null
      this.results = []

      cf.httpClient.queryMaterializedConcepts({
        query: this.query,
        format: this.format,
        catalog: this.useCatalog ? '1' : '0',
      }).then(response => {
        //console.log('queryMaterializedConcepts response=', response)
        this.results = response && response.data ? response.data : []
        if (response.meta && response.meta.errors && response.meta.count <= 0) {
          this.hasError = true;
          this.error = response.meta.errors + "\n";
        }
      }).catch(error => {
        //console.error('queryMaterializedConcepts error=', error)
        this.hasError = true;
        this.error = error + "\n";
      }).finally(() => {
        this.loading = false;
      })
    },

    onInputBaseUrl(newValue) {
      //console.log('onInputBaseUrl newValue=', newValue)
      cf.httpClient.setBaseUrl(newValue)
      this.cfApiUrl = cf.httpClient.getBaseUrl()
    },

    onInputToken(newValue) {
      //console.log('onInputToken newValue=', newValue)
      cf.httpClient.setToken(newValue)
      this.cfApiToken = cf.httpClient.getToken()
    },
  },
});