// Generated by CoffeeScript 1.10.0
'use strict';
var extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

define(['input', 'element', 'physics', 'random'], function(input, element, physics, random) {
  var AVATAR, Avatar, BadPussyCat, Bullet, CONTEXT, Element, Node, SCENE, Spawn, canvas, context, height, now, resize, time, update, width;
  Node = element.Node;
  Element = element.Element;
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
  CONTEXT = canvas.getContext('2d');
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
      SCENE._update(CONTEXT, difference / 1000.0);
      now = _now;
    }
    return window.requestAnimationFrame(update);
  };
  Avatar = (function(superClass) {
    extend(Avatar, superClass);

    Avatar.width = 100;

    Avatar.height = 100;

    Avatar.speed = 500;

    Avatar.reload = 500;

    function Avatar() {
      Avatar.__super__.constructor.call(this, 100, 100, Avatar.width, Avatar.height);
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

    Avatar.prototype.update = function(ctx, t) {
      var reloading, speed, x, y;
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
        ctx.drawImage(this.image, 0, 0);
      }
      reloading = time() - this.last_shot;
      if (reloading <= 0) {
        reloading = 0;
      } else if (reloading >= this.reload) {
        reloading = 1;
      } else {
        reloading /= this.reload;
      }
      ctx.fillStyle = "#75331F";
      return ctx.fillRect(0, this.height - 10, this.width * (1 - reloading), 10);
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
      return this.parent.addNode(new Bullet(this.x + this.width, this.y + this.height / 2));
    };

    return Avatar;

  })(Element);
  Bullet = (function(superClass) {
    extend(Bullet, superClass);

    Bullet.width = 20;

    Bullet.height = 5;

    Bullet.speed = 1000;

    function Bullet(x, y) {
      Bullet.__super__.constructor.call(this, x, y, Bullet.width, Bullet.height);
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

    Bullet.prototype.update = function(ctx, t) {
      if (!this.ready) {
        this.checkImage();
      }
      this.x += this.speed * t;
      if (!this.ready) {
        this.checkImage();
      }
      if (this.ready) {
        return ctx.drawImage(this.image, 0, 0);
      }
    };

    return Bullet;

  })(Element);
  Spawn = (function(superClass) {
    extend(Spawn, superClass);

    function Spawn() {
      Spawn.__super__.constructor.call(this);
      this.next = time() + random.int(2000, 1000);
    }

    Spawn.prototype.update = function() {
      if (this.next < time()) {
        this.parent.addNode(new BadPussyCat(width(), random.int(50, height() - 50)));
        return this.next = time() + random.int(2000, 1000);
      }
    };

    return Spawn;

  })(Node);
  BadPussyCat = (function(superClass) {
    extend(BadPussyCat, superClass);

    BadPussyCat.width = 50;

    BadPussyCat.height = 50;

    BadPussyCat.speed = 300;

    function BadPussyCat(x, y) {
      BadPussyCat.__super__.constructor.call(this, x, y, BadPussyCat.width, BadPussyCat.height);
      this.ready = false;
      this.image = new Image();
      this.image.onload = function() {
        return console.log("IMAGE LOADED BADPUSSYCAT");
      };
      this.image.src = "http://placekitten.com/g/" + this.width + "/" + this.height;
      this.speed = BadPussyCat.speed;
    }

    BadPussyCat.prototype.checkImage = function() {
      if (!this.image.complete) {
        return;
      }
      if (typeof this.image.naturalWidth !== "undefined" && this.image.naturalWidth === 0) {
        return;
      }
      return this.ready = true;
    };

    BadPussyCat.prototype.update = function(ctx, t) {
      var i, len, node, ref;
      if (!this.ready) {
        this.checkImage();
      }
      this.x -= this.speed * t;
      if (!this.ready) {
        this.checkImage();
      }
      if (this.ready) {
        ctx.drawImage(this.image, 0, 0);
      }
      ref = this.parent.children;
      for (i = 0, len = ref.length; i < len; i++) {
        node = ref[i];
        if (node instanceof Bullet && physics.collide(node, this)) {
          this.remove();
          node.remove();
          return;
        }
        if (node instanceof Avatar && physics.collide(node, this)) {
          this.remove();
          node.remove();
          return;
        }
      }
      if (this.x < -this.width) {
        return this.remove();
      }
    };

    return BadPussyCat;

  })(Element);
  SCENE = new Node();
  AVATAR = new Avatar();
  SCENE.addNode(AVATAR);
  SCENE.addNode(new Spawn());
  update();
  return {
    width: width,
    height: height,
    canvas: canvas,
    context: context
  };
});

//# sourceMappingURL=kitty.js.map
