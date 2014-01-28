
class RequestPanel extends require "luminary.panels.base"
  title: "Request"

  content: =>
    for k,v in pairs @req
      @render_section k,v
      --@safe_h1 k
      --@table_contents v

--      ngx = require "ngx"
--      ngx_info = {
--        ["Request Stats"]: {
--          ["Request Time"]: "#{(ngx.now! * 1000) - (ngx.req.start_time! * 1000)} ms"
--          ["HTTP Version"]: ngx.req.http_version!
--          ["Status"]: ngx.status
--        }
--      }
--
--      @render_section(t,d) for t,d in pairs ngx_info
