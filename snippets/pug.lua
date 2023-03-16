return {
  s("jt", f(function(args, snip)
    local t = table.concat(snip.env.TM_SELECTED_TEXT, "")
    return "t`" .. t:sub(2, -2) .. "`"
  end, {})),
  s("=t", f(function(args, snip)
    local t = table.concat(snip.env.TM_SELECTED_TEXT, "")
    return "= t`" .. t:sub(2, -1) .. "`"
  end, {}))
}
