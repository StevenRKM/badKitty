'use strict'

require.config
    paths:
        'kitty': 'kitty'
        'input': 'input'

    shim:
        'input':
            exports: 'input'

        'kitty':
            deps: ['input']
            exports: 'kitty'


require ['kitty'], -> return