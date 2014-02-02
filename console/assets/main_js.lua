return [==[
// Generated by CoffeeScript 1.6.3
(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  window.Lapis || (window.Lapis = {});

  Lapis.Editor = (function() {
    Editor.prototype.run_code = function(code, fn) {
      var opts,
        _this = this;
      if (this.last_line_handle) {
        this.editor.removeLineClass(this.last_line_handle, "background", "has_error");
      }
      opts = $.param({
        lang: "moonscript"
      });
      this.set_status("loading", "Loading...");
      return $.post("/luminary/console?" + opts, {
        code: code
      }, function(res) {
        var line_no, m;
        if (res.error) {
          _this.set_status("error", res.error);
          if (m = res.error.match(/\[(\d+)\]/)) {
            line_no = parseInt(m[1], 10);
            return _this.last_line_handle = _this.editor.addLineClass(line_no - 1, "background", "has_error");
          }
        } else {
          _this.set_status("ready", "Ready");
          return typeof fn === "function" ? fn(res) : void 0;
        }
      });
    };

    Editor.prototype.set_status = function(name, msg) {
      return (this._status || (this._status = this.el.find(".status"))).removeClass("error ready loading").addClass(name).text(msg);
    };

    Editor.prototype.expand_object = function(el) {
      var k, tuples, v, _i, _len, _ref;
      tuples = el.data("tuples");
      el.empty().removeClass("expandable").addClass("expanded");
      el.append("<div class='closable'>{</div>");
      for (_i = 0, _len = tuples.length; _i < _len; _i++) {
        _ref = tuples[_i], k = _ref[0], v = _ref[1];
        $('<div class="tuple"></div>').append(this.render_value(k).addClass("key")).append(this.render_value(v)).appendTo(el);
      }
      return el.append("<div class='closable'>}</div>");
    };

    Editor.prototype.close_object = function(el) {
      return el.text("{ ... }").removeClass("expanded").addClass("expandable");
    };

    Editor.prototype.render_value = function(val) {
      var content, has_content, type, val_el;
      val_el = $('<pre class="value"></pre>');
      type = val[0], content = val[1];
      if (type === "table") {
        has_content = content.length > 0;
        val_el.text("{ " + (has_content && "..." || "") + " }").addClass("object expandable").toggleClass("expandable", has_content).data("tuples", content);
      } else {
        val_el.addClass(type).text(content);
      }
      val_el.attr("title", type);
      return val_el;
    };

    Editor.prototype.render_result = function(res) {
      var line, line_el, lines_el, q, queries_el, row, value, _i, _j, _k, _len, _len1, _len2, _ref, _ref1;
      row = $("<div class=\"result\">\n  <div class=\"lines\"></div>\n  <div class=\"queries\"></div>\n</div>");
      lines_el = row.find(".lines");
      queries_el = row.find(".queries");
      _ref = res.lines;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        line = _ref[_i];
        line_el = $('<div class="line"></div>');
        for (_j = 0, _len1 = line.length; _j < _len1; _j++) {
          value = line[_j];
          this.render_value(value).appendTo(line_el);
        }
        line_el.appendTo(lines_el);
      }
      _ref1 = res.queries;
      for (_k = 0, _len2 = _ref1.length; _k < _len2; _k++) {
        q = _ref1[_k];
        $("<div class='query'></div>").text(q).appendTo(queries_el);
      }
      if (!res.queries[0]) {
        queries_el.remove();
      }
      if (!res.queries[0] && !res.lines[0]) {
        row.addClass("no_output").text("No output");
      }
      return this.log.prepend(row);
    };

    function Editor(el) {
      this.render_result = __bind(this.render_result, this);
      this.render_value = __bind(this.render_value, this);
      this.close_object = __bind(this.close_object, this);
      this.expand_object = __bind(this.expand_object, this);
      var clear_handler, run_handler,
        _this = this;
      this.el = $(el);
      this.log = this.el.find(".log");
      this.textarea = this.el.find("textarea");
      this.editor = CodeMirror.fromTextArea(this.textarea[0], {
        mode: "moonscript",
        lineNumbers: true,
        tabSize: 2,
        theme: "moon",
        viewportMargin: Infinity
      });
      run_handler = function() {
        _this.run_code(_this.editor.getValue(), function(res) {
          return _this.render_result(res);
        });
        return false;
      };
      clear_handler = function() {
        _this.editor.setValue("");
        delete _this.last_line_handle;
        return false;
      };
      this.editor.addKeyMap({
        "Ctrl-Enter": run_handler,
        "Ctrl-K": clear_handler
      });
      this.el.on("click", ".run_btn", run_handler);
      this.el.on("click", ".clear_btn", clear_handler);
      $(function() {
        return _this.editor.focus();
      });
      this.log.on("click", ".expandable", function(e) {
        return _this.expand_object($(e.currentTarget));
      });
      this.log.on("click", ".closable", function(e) {
        return _this.close_object($(e.currentTarget).closest(".object"));
      });
    }

    return Editor;

  })();

}).call(this);
]==]
