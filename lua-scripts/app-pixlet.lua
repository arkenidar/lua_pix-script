if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
  -- launched through "lldebugger" (ms-vscode)
  require("lldebugger").start()
end

local time_ticks = GetTicks()
function DeltaTime()
  local dt -- elapsed time in fractions of seconds
  local delta_ticks = GetTicks() - time_ticks
  time_ticks = GetTicks()
  dt = delta_ticks / 1000 -- milliseconds to seconds
  return dt
end

require("common")

---@diagnostic disable-next-line: lowercase-global
function draw_pixel(rgb, xy)
  SetDrawColor(rgb[1] * 255, rgb[2] * 255, rgb[3] * 255)

  DrawPoint(xy[1], xy[2])
end

function Draw()
  --print("Draw")
  --print(DeltaTime())
  update(DeltaTime()) -- dt is DeltaTime()
  draw()
end
