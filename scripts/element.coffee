'use strict'

define [], () ->

    class Element
        @auto_id = 0

        constructor: (@x=0, @y=0, @width=0, @height=0) ->
            @_id = ++Element.auto_id

            @parent = undefined
            @children = []

            @_add = []
            @_remove = []

        remove: () ->
            if @parent
                @parent.removeElement @

        addElement: (element) ->
            @_add.push element

        removeElement: (element) ->
            @_remove.push element

        _update: (t) ->
            # add and remove elements
            for element in @_add
                console.log "ADD", element._id, element.constructor.name
                element.parent = @
                @elements.push element
            for element in @_remove
                console.log "REMOVE", element._id, element.constructor.name
                element.parent = undefined
                @elements.remove element
            @_add = []
            @_remove = []

            # update all elements
            for element in @elements
                element._update(t)

            # update self
            element.update(t)

        update: (t) -> console.warn "Not implemented" # interface

    Element: Element

