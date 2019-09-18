<template>
  <div class="hello">
    <h1>{{ msg }}</h1>
  </div>
</template>

<script>
import Transfer from '@/utils'
export default {
  name: 'HelloWorld',
  data () {
    return {
      Transfer,
      msg: 'HTDF 转账离线签名Demo'
    }
  },
  async mounted () {
    this.msg = await Transfer()
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
h1, h2 {
  font-weight: normal;
}
ul {
  list-style-type: none;
  padding: 0;
}
li {
  display: inline-block;
  margin: 0 10px;
}
a {
  color: #42b983;
}
</style>
