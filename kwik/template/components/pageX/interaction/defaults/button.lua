local M = {
  name = "button0",
  class="button",
  properties = {
    target = NIL,
    isActive = true,
    type   = NIL,
    eventType  = "tap", -- tap, touch
    over = NIL,
    btaps = 1,
    mask = NIL,
  },
  actions = {onTap = ""}
}

return M