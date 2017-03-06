'use strict'

define [], () ->

    # do el1 and el2 collide
    collide = (el1, el2) ->
        rect1 = el1.rect()
        rect2 = el2.rect()

        return !(
            rect1.top > rect2.bottom ||
            rect1.right < rect2.left ||
            rect1.bottom < rect2.top ||
            rect1.left > rect2.right
        )

    # is el1 in el2
    inside = (el1, el2) ->
        rect1 = el1.rect()
        rect2 = el2.rect()

        return (
            ((rect2.top <= rect1.top) && (rect1.top <= rect2.bottom)) &&
            ((rect2.top <= rect1.bottom) && (rect1.bottom <= rect2.bottom)) &&
            ((rect2.left <= rect1.left) && (rect1.left <= rect2.right)) &&
            ((rect2.left <= rect1.right) && (rect1.right <= rect2.right))
        )

    # is point inside element rect
    pointInsideRect = (point, el) ->
        rect = el.rect()

        return (
            ((rect.top <= point.y) && (point.y <= rect.bottom)) &&
            ((rect.left <= point.x) && (point.x <= rect.right))
        )

    collide: collide
    inside: inside
    pointInsideRect: pointInsideRect
