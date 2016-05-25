'use strict'

define [], () ->

    # a node on the scenegraph, nothing more
    class Node
        @auto_id = 0

        constructor: () ->
            @id = ++Node.auto_id

            @parent = undefined
            @children = []

            @_add = []
            @_remove = []

        remove: () ->
            if @parent
                @parent.removeNode @

        addNode: (node) ->
            @_add.push node

        removeNode: (node) ->
            @_remove.push node

        _update: (ctx, t) ->
            # add and remove nodes
            for node in @_add
                console.log "ADD", node.id, node.constructor.name
                node.parent = @
                @children.push node
            for node in @_remove
                console.log "REMOVE", node.id, node.constructor.name
                node.parent = undefined
                @children.remove node
            @_add = []
            @_remove = []

            # update all nodes
            for node in @children
                node._update ctx, t

            # update self
            @update ctx, t

        update: (ctx, t) -> return

    # a physical element on the scene, with a position and a volume
    class Element extends Node

        constructor: (@x=0, @y=0, @width=0, @height=0) ->
            super()
            
        _update: (ctx, t) ->
            ctx.save()
            ctx.translate @x, @y

            super ctx, t

            ctx.restore()

        rect: () ->
            return {
                x: @x
                y: @y
                width: @width
                height: @height

                top: @y
                bottom: @y + @height
                left: @x
                right: @x + @width
            }

    Node: Node
    Element: Element

