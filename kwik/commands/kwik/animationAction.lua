local M = {}
--
function M:pause(anim)
  anim:pause()
end
--
function M:resume(anim)
  if anim.type == "transition" then
    anim:resume()
  else
    anim:play()
  end
end
--
function M:play(anim)
  if anim.type == "transition" then
    anim:resume()
  else
    if anim.from then
      anim.from:toBeginning()
      anim.from:play()
    elseif anim.to then
      anim.to:toBeginning()
      anim.to:play()
    end
  end
end
--
return M