const events = require('events');
const util = require("util");
const fs = require("fs");

function Tail(filename) {
  this.filename = filename;
  this.separator=/[\r]{0,1}\n/;
  this.pos = 0;

}

util.inherits(Tail, events.EventEmitter);

Tail.prototype.watch = function() {
  var that = this;

  this.watcher = fs.watch(this.filename);

  this.watcher.on('change', function(event) {
    stats = fs.statSync(that.filename);
    if(stats.size < that.pos) {
      that.pos = stats.size;
    }
    if(stats.size > that.pos) {
    }
  }


};

Tail.prototype.read_block = function() {
};

module.exports = Tail;
