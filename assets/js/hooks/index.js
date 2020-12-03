export default {
  autofocus: {
    mounted() {
      this.el.focus()
    }
  },
  js: {
    mounted() {
      const code = this.el.getAttribute('data-hook-init')
      code && eval(code)
    },
    beforeDestroy() {
      const code = this.el.getAttribute('data-hook-destroy')
      code && eval(code)
    }
  }
}