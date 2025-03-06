-- Code created by Kwik - Copyright: kwiksher.com {{year}}
-- Version: {{vers}}
-- Project: {{ProjName}}
--
local _M = {}
_M.x9 = {}
--
local _K = require(kwikGlobal.ROOT.."controller.Application")
--
local allAudios = {}

function _M:recordAudio(duration, mmFile, malfa, sceneGroup, allAudios)
  allAudios.playback  = nil
  local filePath = system.pathForFile(mmFile, _K.DocumentsDir )
  local r = media.newRecording(filePath)
  sceneGroup.alpha = malfa
  r:startRecording( )
  local audioClosure = function(event )
    r:stopRecording()
    sceneGroup.alpha = 1
    local file = io.open(filePath, "r")
    if file then
       io.close(file)
       allAudios.playback = audio.loadStream( mmFile, _K.DocumentsDir )
       audio.play(allAudios.playback, {channel=31})
    end
   end
   _K.timerStash.recTimer = timer.performWithDelay(duration, audioClosure )
   -- audio.stop(31)
   -- audio.dispose(allAudios.playback)
   -- allAudios.playback = nil
end
--
function _M:muteUnmute(videos)
  if (audio.getVolume() == 0.0) then
     audio.setVolume(1.0)
  else
     audio.setVolume(0.0)
  end
  if videos then
      for i=1, #videos do
        if videos[i].isMuted then
          videos[i].isMuted = false
        else
          videos[i].isMuted = true
        end
      end
  end
end
--
function _M:playAudio(vaudio, vchan, vrepeat, vdelay, vloop, toFade, vvol, tm, trigger, params)
  local listener = nil
  if trigger and string.len(trigger) > 0 then
    listener = function()
      Runtime:dispatchEvent({name=trigger, event=params.event, UI=params.UI})
    end
  end

  local myClosure = function()
    if not vrepeat then
      audio.setVolume(vvol, {channel=vchan} )
      if toFade > 0 then
        audio.play( vaudio, {channel=vchan, loops = vloop, fadein = toFade, onComplete = listener } )
      else
        audio.play( vaudio, {channel=vchan, loops = vloop,  onComplete = listener } )
      end
    else
      if toFade  > 0 then
        _M.x9[vaudio] = audio.play( vaudio, {channel=vchan, loops = vloop, fadein = toFade, onComplete = listener } )
      else
        _M.x9[vaudio] = audio.play( vaudio, {channel=vchan, loops = vloop, onComplete = listener } )
      end
      audio.setVolume(vvol, {channel=_M.x9[vaudio]} )
    end
  end
  if vdelay == 0 then
    myClosure()
  else
    _K.timerStash[tm] = timer.performWithDelay(vdelay,
      myClosure, 1)
  end
end
--
function _M:rewindAudio( vaudio, vchan, vrepeat)
  if not vrepeat then
    audio.rewind( vchan )
  else
    if _M.x9[vaudio] then
      audio.rewind( _M.x9[vaudio] )
    else
      audio.rewind( vchan )
    end
  end
end
--
function _M:pauseAudio(vaduio, vchan, vrepeat)
  timer.performWithDelay(0, function()
    if not vrepeat then
      audio.pause( vchan )
    else
      if _M.x9[vaudio] then
        audio.pause( _M.x9[vaudio] )
      else
        audio.pause( vchan )
      end
    end
  end )
end
--
function _M:stopAudio(vaduio, vchan, vrepeat)
  if not vrepeat then
    audio.rewind( vchan )
    audio.stop( vchan )
  else
    if _M.x9[vaudio] then
      audio.rewind( _M.x9[vaudio])
      audio.stop( _M.x9[vaudio] )
    else
      audio.rewind( vchan )
      audio.stop( vchan )
    end
  end
end
--
function _M:resumeAudio(vaduio, vchan, vrepeat)
  if not vrepeat then
    audio.resume( vchan )
  else
    if _M.x9[vaudio] then
      audio.resume( _M.x9[vaudio] )
    else
      audio.resume( vchan )
    end
  end
end
--
function _M:setVolume(vvol, vchan)
  audio.setVolume(vvol, {channel=vchan} )
end
--
return _M