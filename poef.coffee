
update = () ->
    window.requestAnimationFrame update




canvas = document.createElement 'canvas'
canvas.width = 512
canvas.height = 512

context = canvas.getContext '2d'

document.body.appendChild canvas













Array.prototype.remove = (element) ->

    index = @indexOf(element)
    if index != -1
        @splice index, 1

class Scene

    constructor: () ->
        @elements = []
        @_add = []
        @_remove = []

    update: () ->
        for element in @_add
            console.log "ADD", element._id, element.constructor.name
            element._scene = @
            element.show()
            @elements.push element
        for element in @_remove
            console.log "REMOVE", element._id, element.constructor.name
            element._scene = undefined
            element.hide()
            @elements.remove element
        @_add = []
        @_remove = []

        for element in @elements
            element.update()

    addElement: (element) ->
        @_add.push element

    removeElement: (element) ->
        @_remove.push element

class Element
    @auto_id = 0

    constructor: (x=undefined, y=undefined, width=undefined, height=undefined) ->
        @_id = ++Element.auto_id
        @_scene = undefined

        @element = document.createElement "div"
        @hide()

        @element.style.position = "absolute"
        @element.style.backgroundColor = "black"
        document.body.appendChild @element

        @keepInScreen = true
        @removeOnEdge = false

        @setPosition x or 0, y or 0
        @setDimension width or 0, height or 0

    setPosition: (x, y) ->
        @x = x
        @y = y

        if @keepInScreen
            if @x < 0
                @x = 0
            if @x + @width > WIDTH()
                @x = WIDTH() - @width
            if @y < 0
                @y = 0
            if @y + @height > HEIGHT()
                @y = HEIGHT() - @height

        if @removeOnEdge
            if @x + @width < 0 or @x > WIDTH() or
                @y + @height < 0 or @y > HEIGHT()
                    @delete()

        @_position()

    setDimension: (width, height) ->
        @width = width
        @height = height
        @_dimension()

    show: () ->
        @element.style.display = "block"

    hide: () ->
        @element.style.display = "none"

    _position: () ->
        @element.style.left = @x + "px"
        @element.style.top = @y + "px"

    _dimension: () ->
        @element.style.width = @width + "px"
        @element.style.height = @height + "px"

    delete: () ->
        @_scene.removeElement @

    update: () -> console.warn "Not implemented" # interface

class Avatar extends Element
    @width = 100
    @height = 100
    @speed = 2
    @reload = 100

    constructor: () ->
        super(100, 100, Avatar.width, Avatar.height)
        @element.style.backgroundImage = "url('http://placekitten.com/g/"+@width+"/"+@height+"')"

        @speed = Avatar.speed
        @reload = Avatar.reload

        @last_shot = 0

    update: () ->
        x = @x
        y = @y

        if KB_UP then y -= @speed
        if KB_DOWN then y += @speed
        if KB_LEFT then x -= @speed
        if KB_RIGHT then x += @speed
        if BK_SHOOT and @last_shot + @reload < TIME() then @shoot()

        @setPosition x, y

    shoot: () ->
        @last_shot = TIME()
        @_scene.addElement new Bullet @x + @width, @y + @height/2

class Bullet extends Element
    @width = 20
    @height = 5
    @speed = 5

    constructor: (x, y) ->
        super(x, y, Bullet.width, Bullet.height)
        @element.style.backgroundImage = "url('http://placekitten.com/g/"+@width+"/"+@height+"')"

        @keepInScreen = false
        @removeOnEdge = true

    update: () ->
        @setPosition @x + Bullet.speed, @y

class PowerUp extends Element
    @width = 50
    @height = 50
    @speed = 1

    constructor: (x, y) ->
        super(x, y, PowerUp.width, PowerUp.height)
        @element.style.backgroundImage = "url('http://placekitten.com/g/"+@width+"/"+@height+"')"
        @element.style.backgroundColor = "#4FCC2F"
        @element.style.backgroundBlendMode = "screen"

        @keepInScreen = false
        @removeOnEdge = true

    update: () ->
        @setPosition @x - PowerUp.speed, @y

        if collide @element, AVATAR.element
            AVATAR.speed += 5
            @delete()

class SpeedUp extends Element
    @width = 50
    @height = 50
    @speed = 1

    constructor: (x, y) ->
        super(x, y, PowerUp.width, PowerUp.height)
        @element.style.backgroundImage = "url('http://placekitten.com/g/"+@width+"/"+@height+"')"
        @element.style.backgroundColor = "#4C78F5"
        @element.style.backgroundBlendMode = "screen"

        @keepInScreen = false
        @removeOnEdge = true

    update: () ->
        @setPosition @x - SpeedUp   .speed, @y

        if collide @element, AVATAR.element
            AVATAR.speed += 5
            @delete()

class Spawn extends Element

    constructor: (x, y) ->
        super()
        @element.style.backgroundImage = "url('http://placekitten.com/g/"+@width+"/"+@height+"')"

        @keepInScreen = false
        @removeOnEdge = false

        @next = TIME() + rand(3000, 1000)

    update: () ->
        if @next < TIME()

            @_scene.addElement new BadPussyCat WIDTH(), rand(50, HEIGHT()-50  )

            @next = TIME() + rand(2000, 1000)


class BadPussyCat extends Element
    @width = 75
    @height = 75
    @speed = 3

    constructor: (x, y) ->
        super(x, y, BadPussyCat.width, BadPussyCat.height)
        @element.style.backgroundImage = "url('http://placekitten.com/g/"+@width+"/"+@height+"')"
        @element.style.backgroundColor = "#F54C4C"
        @element.style.backgroundBlendMode = "screen"

        @keepInScreen = false
        @removeOnEdge = true

    update: () ->
        @setPosition @x - BadPussyCat.speed, @y

        for i in @_scene.elements
            if i instanceof Bullet and collide i.element, @element
                if chance 20
                    @_scene.addElement new PowerUp @x, @y

                @delete()
                i.delete()

        if collide @element, AVATAR.element
            SCENE.update = () -> return


"""
FUNCTIONS
"""

TIME = () ->
    return (new Date()).getTime()

WIDTH = () ->
    return window.innerWidth

HEIGHT = () ->
    return window.innerHeight

# random functions
rand = (max=1, min=0) ->
    return Math.floor(min + Math.random()*(max+1 - min))

chance = (percentage) ->
    return Math.random()*100 < percentage

pick = (list) ->
    return list[ randint list.length-1 ]

# do el1 and el2 collide
collide = (el1, el2) ->
    rect1 = el1.getBoundingClientRect()
    rect2 = el2.getBoundingClientRect()

    return !(
      rect1.top > rect2.bottom ||
      rect1.right < rect2.left ||
      rect1.bottom < rect2.top ||
      rect1.left > rect2.right
    )

# is el1 in el2
inside = (el1, el2) ->
    rect1 = el1.getBoundingClientRect()
    rect2 = el2.getBoundingClientRect()

    return (
      ((rect2.top <= rect1.top) && (rect1.top <= rect2.bottom)) &&
      ((rect2.top <= rect1.bottom) && (rect1.bottom <= rect2.bottom)) &&
      ((rect2.left <= rect1.left) && (rect1.left <= rect2.right)) &&
      ((rect2.left <= rect1.right) && (rect1.right <= rect2.right))
    )

"""
CONTROLS
"""

# Keyboard state
KB_LEFT = false
KB_RIGHT = false
KB_UP = false
KB_DOWN = false
BK_SHOOT = false

document.addEventListener 'keydown', (event) ->
    char = (String.fromCharCode event.keyCode).toLowerCase()

    if char == "w"
        KB_UP = true
    else if char == "s"
        KB_DOWN = true
    else if char == "a"
        KB_LEFT = true
    else if char == "d"
        KB_RIGHT = true
    else if char == " "
        BK_SHOOT = true

document.addEventListener 'keyup', (event) ->
    char = (String.fromCharCode event.keyCode).toLowerCase()

    if char == "w"
        KB_UP = false
    else if char == "s"
        KB_DOWN = false
    else if char == "a"
        KB_LEFT = false
    else if char == "d"
        KB_RIGHT = false
    else if char == " "
        BK_SHOOT = false

"""
INIT SCENE
"""
SCENE = new Scene()
AVATAR = new Avatar()
SCENE.addElement AVATAR
SCENE.addElement new Spawn()

_loop = () ->
    if SCENE
        SCENE.update()

setInterval _loop, 20

