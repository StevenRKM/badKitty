// Generated by CoffeeScript 1.10.0
'use strict';
var extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

define(['input'], function(input) {
  var AVATAR, Avatar, Bullet, Element, SCENE, Scene, canvas, context, height, now, resize, time, update, width;
  console.log("da kitty has started");
  Array.prototype.remove = function(element) {
    var index;
    index = this.indexOf(element);
    if (index !== -1) {
      return this.splice(index, 1);
    }
  };
  canvas = document.createElement('canvas');
  context = canvas.getContext('2d');
  width = function() {
    return window.innerWidth;
  };
  height = function() {
    return window.innerHeight;
  };
  time = function() {
    return (new Date()).getTime();
  };
  now = time();
  canvas.width = width();
  canvas.height = height();
  document.body.appendChild(canvas);
  resize = function() {
    canvas.width = width();
    return canvas.height = height();
  };
  window.addEventListener('resize', resize, false);
  update = function() {
    var _now, difference;
    _now = time();
    difference = _now - now;
    if (difference) {
      context.clearRect(0, 0, canvas.width, canvas.height);
      SCENE.update(difference / 1000.0);
      now = _now;
    }
    return window.requestAnimationFrame(update);
  };
  Scene = (function() {
    function Scene() {
      this.elements = [];
      this._add = [];
      this._remove = [];
    }

    Scene.prototype.update = function(t) {
      var element, i, j, k, len, len1, len2, ref, ref1, ref2, results;
      ref = this._add;
      for (i = 0, len = ref.length; i < len; i++) {
        element = ref[i];
        console.log("ADD", element._id, element.constructor.name);
        element._scene = this;
        this.elements.push(element);
      }
      ref1 = this._remove;
      for (j = 0, len1 = ref1.length; j < len1; j++) {
        element = ref1[j];
        console.log("REMOVE", element._id, element.constructor.name);
        element._scene = void 0;
        this.elements.remove(element);
      }
      this._add = [];
      this._remove = [];
      ref2 = this.elements;
      results = [];
      for (k = 0, len2 = ref2.length; k < len2; k++) {
        element = ref2[k];
        results.push(element.update(t));
      }
      return results;
    };

    Scene.prototype.addElement = function(element) {
      return this._add.push(element);
    };

    Scene.prototype.removeElement = function(element) {
      return this._remove.push(element);
    };

    return Scene;

  })();
  Element = (function() {
    Element.auto_id = 0;

    function Element(x, y, width, height) {
      if (x == null) {
        x = void 0;
      }
      if (y == null) {
        y = void 0;
      }
      if (width == null) {
        width = void 0;
      }
      if (height == null) {
        height = void 0;
      }
      this._id = ++Element.auto_id;
      this._scene = void 0;
    }

    Element.prototype["delete"] = function() {
      return this._scene.removeElement(this);
    };

    Element.prototype.update = function(t) {
      return console.warn("Not implemented");
    };

    return Element;

  })();
  Avatar = (function(superClass) {
    extend(Avatar, superClass);

    Avatar.width = 100;

    Avatar.height = 100;

    Avatar.speed = 500;

    Avatar.reload = 100;

    function Avatar() {
      Avatar.__super__.constructor.call(this, 100, 100, Avatar.width, Avatar.height);
      this.x = 100;
      this.y = 100;
      this.width = Avatar.width;
      this.height = Avatar.height;
      this.ready = false;
      this.image = new Image();
      this.image.onload = function() {
        return console.log("IMAGE LOADED");
      };
      this.image.src = "http://placekitten.com/g/" + this.width + "/" + this.height;
      this.speed = Avatar.speed;
      this.reload = Avatar.reload;
      this.last_shot = 0;
    }

    Avatar.prototype.update = function(t) {
      var speed, x, y;
      x = this.x;
      y = this.y;
      speed = this.speed * t;
      if (input.state.UP) {
        y -= speed;
      }
      if (input.state.DOWN) {
        y += speed;
      }
      if (input.state.LEFT) {
        x -= speed;
      }
      if (input.state.RIGHT) {
        x += speed;
      }
      if (input.state.SHOOT && this.last_shot + this.reload < time()) {
        this.shoot();
      }
      this.x = x;
      this.y = y;
      if (!this.ready) {
        this.checkImage();
      }
      if (this.ready) {
        return context.drawImage(this.image, this.x, this.y);
      }
    };

    Avatar.prototype.checkImage = function() {
      if (!this.image.complete) {
        return;
      }
      if (typeof this.image.naturalWidth !== "undefined" && this.image.naturalWidth === 0) {
        return;
      }
      return this.ready = true;
    };

    Avatar.prototype.shoot = function() {
      this.last_shot = time();
      return this._scene.addElement(new Bullet(this.x + this.width, this.y + this.height / 2));
    };

    return Avatar;

  })(Element);
  Bullet = (function(superClass) {
    extend(Bullet, superClass);

    Bullet.width = 20;

    Bullet.height = 5;

    Bullet.speed = 1000;

    function Bullet(x, y) {
      this.x = x;
      this.y = y;
      this.width = Bullet.width;
      this.height = Bullet.height;
      this.ready = false;
      this.image = new Image();
      this.image.onload = function() {
        return console.log("IMAGE LOADED BULLET");
      };
      this.image.src = "http://placekitten.com/g/" + this.width + "/" + this.height;
      this.speed = Bullet.speed;
    }

    Bullet.prototype.checkImage = function() {
      if (!this.image.complete) {
        return;
      }
      if (typeof this.image.naturalWidth !== "undefined" && this.image.naturalWidth === 0) {
        return;
      }
      return this.ready = true;
    };

    Bullet.prototype.update = function(t) {
      if (!this.ready) {
        this.checkImage();
      }
      this.x += this.speed * t;
      if (!this.ready) {
        this.checkImage();
      }
      if (this.ready) {
        return context.drawImage(this.image, this.x, this.y);
      }
    };

    return Bullet;

  })(Element);
  SCENE = new Scene();
  AVATAR = new Avatar();
  SCENE.addElement(AVATAR);
  update();
  return {
    width: width,
    height: height,
    canvas: canvas,
    context: context
  };
});
