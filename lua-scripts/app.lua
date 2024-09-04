if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
  -- launched through "lldebugger" (ms-vscode)
  require("lldebugger").start()
end

function Draw()
  -- draw a small Italian flag

  -- Green
  SetDrawColor(0x00, 0xFF, 0x00)
  DrawRectangle(20, 30, 30, 50)

  -- White
  SetDrawColor(0xFF, 0xFF, 0xFF)
  DrawRectangle(50, 30, 30, 50)

  -- Red
  SetDrawColor(0xFF, 0x00, 0x00)
  DrawRectangle(80, 30, 30, 50)

  -- draw a circle
  SetDrawColor(0x00, 0x00, 0xFF)
  DrawCircle(160, 60, 30)
end

function DrawRectangle(x, y, w, h)
  for px = x, x + w - 1 do
    for py = y, y + h - 1 do
      DrawPoint(px, py)
    end
  end
end

function DrawCircle(cx, cy, radius)
  for px = cx - radius, cx + radius do
    for py = cy - radius, cy + radius do
      if (px - cx) * (px - cx) + (py - cy) * (py - cy) <= radius * radius then
        DrawPoint(px, py)
      end
    end
  end
end
