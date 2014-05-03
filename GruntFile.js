module.exports = function (grunt) {
  grunt.loadNpmTasks('grunt-haxe')

  grunt.initConfig({
    haxe: {
      metahub: {
        classpath: ['source/**/*.hx'],
        libs: [ 'nodejs' ],
        flags: [ 'nodejs' ],
        output: 'output/nodejs/metahub.js'
      }
    },
    watch: {
      metahub: {
        files: 'source/**/*.hx',
        tasks: ['default']
      }
    }
  })

  grunt.registerTask('default', 'haxe');
}