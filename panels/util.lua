local label_wrap
label_wrap = function(s)
  return "<span class=\"label label-default\" style=\"float:left;\">" .. tostring(s) .. "</span>"
end
local float_wrap
float_wrap = function(s)
  return "<span style=\"float:left;\">" .. tostring(s) .. "</span>"
end
return {
  label_wrap = label_wrap,
  float_wrap = float_wrap
}
