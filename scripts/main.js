// Generated by CoffeeScript 1.10.0
'use strict';
require.config({
  paths: {
    'kitty': 'kitty',
    'input': 'input',
    'wad': 'lib/wad.min'
  },
  shim: {
    'wad': {
      exports: 'wad'
    },
    'input': {
      exports: 'input'
    },
    'kitty': {
      deps: ['input', 'wad'],
      exports: 'kitty'
    }
  }
});

require(['kitty'], function() {});
