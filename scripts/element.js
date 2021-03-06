// Generated by CoffeeScript 1.10.0
'use strict';
var extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

define([], function() {
  var Element, Node;
  Node = (function() {
    Node.auto_id = 0;

    function Node() {
      this.id = ++Node.auto_id;
      this.parent = void 0;
      this.children = [];
      this._add = [];
      this._remove = [];
    }

    Node.prototype.remove = function() {
      if (this.parent) {
        return this.parent.removeNode(this);
      }
    };

    Node.prototype.addNode = function(node) {
      return this._add.push(node);
    };

    Node.prototype.removeNode = function(node) {
      return this._remove.push(node);
    };

    Node.prototype._update = function(ctx, t, now) {
      var i, j, k, len, len1, len2, node, ref, ref1, ref2;
      ref = this._add;
      for (i = 0, len = ref.length; i < len; i++) {
        node = ref[i];
        console.log("ADD", node.id, node.constructor.name);
        node.parent = this;
        this.children.push(node);
      }
      ref1 = this._remove;
      for (j = 0, len1 = ref1.length; j < len1; j++) {
        node = ref1[j];
        console.log("REMOVE", node.id, node.constructor.name);
        node.parent = void 0;
        this.children.remove(node);
      }
      this._add = [];
      this._remove = [];
      ref2 = this.children;
      for (k = 0, len2 = ref2.length; k < len2; k++) {
        node = ref2[k];
        node._update(ctx, t, now);
      }
      return this.update(ctx, t, now);
    };

    Node.prototype.update = function(ctx, t) {};

    return Node;

  })();
  Element = (function(superClass) {
    extend(Element, superClass);

    function Element(x, y, width, height) {
      this.x = x != null ? x : 0;
      this.y = y != null ? y : 0;
      this.width = width != null ? width : 0;
      this.height = height != null ? height : 0;
      Element.__super__.constructor.call(this);
    }

    Element.prototype._update = function(ctx, t, now) {
      ctx.save();
      ctx.translate(this.x, this.y);
      Element.__super__._update.call(this, ctx, t, now);
      return ctx.restore();
    };

    Element.prototype.rect = function() {
      return {
        x: this.x,
        y: this.y,
        width: this.width,
        height: this.height,
        top: this.y,
        bottom: this.y + this.height,
        left: this.x,
        right: this.x + this.width
      };
    };

    return Element;

  })(Node);
  return {
    Node: Node,
    Element: Element
  };
});
