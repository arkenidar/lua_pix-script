if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
  -- launched through "lldebugger" (ms-vscode)
  require("lldebugger").start()
end

function Draw()
  -- draw a small Italian flag

  function DrawFlagPart(x, y, w, h)
    local effect = function(px, py) return CheckerBoardPattern(px, py, 3) end
    DrawRectangleEffect(x, y, w, h, effect)
  end

  -- Green
  SetDrawColor(0x00, 0xFF, 0x00)
  DrawFlagPart(20, 30, 30, 50)

  -- White
  SetDrawColor(0xFF, 0xFF, 0xFF)
  DrawFlagPart(50, 30, 30, 50)

  -- Red
  SetDrawColor(0xFF, 0x00, 0x00)
  DrawFlagPart(80, 30, 30, 50)

  -- draw a first circle with a checkerboard pattern
  SetDrawColor(0x00, 0x00, 0xFF)
  DrawCircleEffect(160, 60, 30, function(px, py) return CheckerBoardPattern(px, py, 10) end)

  -- draw a second circle with a solid pattern
  -- same color as the first circle
  DrawCircle(160 + 80, 60, 30)
end

function DrawRectangle(x, y, w, h)
  for px = x, x + w - 1 do
    for py = y, y + h - 1 do
      DrawPoint(px, py)
    end
  end
end

function CheckerBoardPattern(px, py, size)
  return (math.floor(px / size) + math.floor(py / size)) % 2 == 0
end

function DrawRectangleEffect(x, y, w, h, effect)
  for px = x, x + w - 1 do
    for py = y, y + h - 1 do
      if effect(px, py) then
        DrawPoint(px, py)
      end
    end
  end
end

function DrawCircleEffect(cx, cy, radius, effect)
  for px = cx - radius, cx + radius do
    for py = cy - radius, cy + radius do
      if (px - cx) * (px - cx) + (py - cy) * (py - cy) <= radius * radius then
        if effect(px, py) then
          DrawPoint(px, py)
        end
      end
    end
  end
end

function DrawCircle(cx, cy, radius)
  DrawCircleEffect(cx, cy, radius, function(px, py) return true end)
end
