return {
  s("jt", f(function(args, snip)
    local t = table.concat(snip.env.TM_SELECTED_TEXT, "")
    return "t`" .. t:sub(2, -2) .. "`"
  end, {})),
  s("tt", f(function(args, snip)
    local t = table.concat(snip.env.TM_SELECTED_TEXT, "")
    return "#{t`" .. t .. "`}"
  end, {})),
  s("=t", f(function(args, snip)
    local t = table.concat(snip.env.TM_SELECTED_TEXT, "")
    return "= t`" .. t:sub(1, -1) .. "`"
  end, {})),
  s("t", f(function(args, snip)
    local t = table.concat(snip.env.TM_SELECTED_TEXT, "")
    return "t`" .. t .. "`"
  end, {}))
}
