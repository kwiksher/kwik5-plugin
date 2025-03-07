local M = {
  -- name        = {{aname}},
  -- type        = {{atype}},
  -- language    = nil  -- or {"en", "jp"},
  -- filename    = "{{fileName}}",
  -- allowRepeat = false,
  -- autoPlay    = {{aplay}},
  -- deplay      = {{adelay}},
  -- volume      = {{avol}},
  -- channel     = {{achannel}}
  -- loops       = {{aloop}},
  -- fadein      = {{tofade}},
  -- retain      = {{akeep}}
  -- audioChannel   = nil ,
  -- repeatableChannel = nil, -- for allowRepeat
  -- loader      = nil -- audio.{{loadType}},
}

local App = require("Application")
--
-- local allAudios = {}
--
function M:init(UI)
end

function M:create(UI)
  -- print("create page audio", self.properties.filename)
  local props = self.properties
  local filename
    --
    --
    if self.audioObj == nil then
    if props.folder then
       filename = props.folder.."/"..props.filename
    end
    if self.language then
      filename = App.getProps().lang.."/"..props.filename
    end
    --

    if props.type == "long" then
      self.loader = audio.loadStream
      filename = "long/"..props.filename
    else
      self.loader = audio.loadSound
      filename = "short/"..props.filename
    end

    local path =  App.getProps().audioDir..filename

    self.audioObj =  self.loader(path , App.getProps().systemDir)

    UI.audios[self.name] = self
    -- TODO autoPlay pages
    -- local a = audio.getDuration( self.audioObj );
    -- if a > UI.allAudios.kAutoPlay  then
    --   UI.allAudios.kAutoPlay = a
    -- end
  end
  --
  self.repeatableChannel = nil
end

function M:play()
  local props = self.properties
  audio.setVolume(props.volume or 8, { channel=props.channel });
  if props.allowRepeat then
      props.repeatableChannel = audio.play(props.audioObj, {  channel=props.channel, loops=props.loops, fadein = props.fadein } )
  else
    audio.play(props.audioObj, {channel=props.channel, loops=props.loops, fadein = props.fadein } )
  end
end

function M:didShow(UI)
  local props = self.properties
  if self.audioObj == nil then return end
  --
   if props.autoPlay then
    if props.delay then
       self.timerStash = timer.performWithDelay(props.delay, function() self:play() end, 1)
    else
      self:play()
    end
  end
end

function M:didHide(UI)
  local props = self.properties
  if self.audioObj == nil then return end
  if not props.retain then
    if audio.isChannelActive ( props.channel ) then
      audio.stop(props.channel)
    end
  end
  if self.timerStash then
    timer.cancel(self.timerStash )
    self.timerStash = nil
  end
end
--
function M:destroy(UI)
  local props = self.properties
  if self.audioObj == nil then return end
  if not props.retain then
      if props.allowRepeat then
        if props.repeatableChannel then
          audio.dispose(self.audioObj)
        end
      else
        if self.audioObj then
          audio.dispose(self.audioObj)
        end
      end
      self.audioObj = nil
      props.repeatableChannel = nil
   end
end

function M:getAudio(UI)
  local props = self.properties
  local filename
  if self.audioObj == nil then
    if self.language then
      filename = App.getProps().lang .."/"..props.filename
    end

    local path =  App.getProps().audioDir..props.filename
    if props.folder then
      path = App.getProps().audioDir..props.folder.."/"..props.filename
    end

    self.audioObj =  self.loader(path , App.getProps().systemDir)
  end
  --
  return self.type
end

function M:rewind()
  local props = self.properties
  if not props.repeatable then
    audio.rewind( self.channel )
  else
    if props.repeatableChannel then
      audio.rewind(props.repeatableChannel)
    else
      audio.rewind(self.audioObj )
    end
  end
end
--
function M:pause()
  local props = self.properties
  if not props.repeatable then
    audio.pause(props.channel )
  else
    if props.repeatableChannel then
      audio.pause(props.repeatableChannel)
    else
      audio.pause(self.audioObj )
    end
  end
end
--
function M:stop()
  local props = self.properties
  if not props.repeatable then
    audio.rewind( self.audioObj )
    audio.stop( self.audioObj )
  else
    if props.repeatableChannel  then
      audio.rewind(props.repeatableChannel )
      audio.stop(props.repeatableChannel  )
    else
      audio.rewind(self.audioObj )
      audio.stop(self.audioObj )
    end
  end
end
--
function M:resume()
  local props = self.properties
  if not props.repeatable then
    audio.resume( self.audioObj )
  else
    if props.repeatableChannel  then
      audio.resume(props.repeatableChannel  )
    else
      audio.resume( props.audioChannel )
    end
  end
end
--
function M:setVolume(vvol)
  local props = self.properties
  audio.setVolume(vvol, {channel=props.audioChannel} )
end

function M:muteUnmute()
  local props = self.properties
  if (audio.getVolume() == 0.0) then
     audio.setVolume(props.volume, {channel=props.audioChannel})
  else
     audio.setVolume(0.0,  {channel=props.audioChannel})
  end
end

M.set = function(instance)
  if type(instance.properties.channel) ~= "number" then
    instance.properties.channel = 1
  end
	return setmetatable(instance, {__index=M})
end

return M