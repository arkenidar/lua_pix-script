if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
  -- launched through "lldebugger" (ms-vscode)
  require("lldebugger").start()
end

-- This is a simple example of a Pixlet application.
-- It draws a small Italian flag and two circles.
-- The first circle has a checkerboard pattern.
-- The first circle moves to the position of the mouse click.
-- The second circle has a solid color.
-- The second circle moves up and down.

---@diagnostic disable-next-line: deprecated
local spread = unpack and unpack or table.unpack

local pointer = {}
function pointer.input()
  local mx, my, down = InputPoint()
  -- position, x, y
  pointer.position = { mx, my }
  pointer.x = pointer.position[1]
  pointer.y = pointer.position[2]
  -- click and down
  pointer.down_previously = pointer.down
  pointer.down = down
  pointer.click = false
  if pointer.down and not pointer.down_previously then
    pointer.click = true
  end
end

local circle1 = { x = 160, y = 60 }
local circle2 = { x = 160 + 80, y = 60 }
-- example of " basic scene-graph " concept , applied . from immediate mode to retained mode of rendering . of course HTML DOM hierarchy ( "tree" structure ) is a kind of " tree-based scene-graph " applied to its domain . at the moment of writing no hierarchies are involved yet rendering is " retained " , currently only in "rectangles" data table that works as a list .
local rectangles = {}
local viewport_translate = { x = 0, y = 0 }
local initial_click_point = nil
function Draw()
  -- process input
  pointer.input()
  if pointer.click then
    --print("click at", pointer.x, pointer.y)
    circle1.x = pointer.x
    circle1.y = pointer.y
    initial_click_point = { pointer.x, pointer.y }
  end

  if pointer.down and initial_click_point then
    --print("dragging at", pointer.x, pointer.y)
    local dx = pointer.x - initial_click_point[1]
    local dy = pointer.y - initial_click_point[2]
    viewport_translate.x = dx
    viewport_translate.y = dy
  end
  if not pointer.down then
    initial_click_point = nil
  end

  -- clear screen

  -- draw a small Italian flag

  function DrawFlagPart(x, y, w, h)
    local effect = function(px, py) return CheckerBoardPattern(px, py, 3) end
    DrawRectangleEffect(x, y, w, h, effect)
  end

  -- Green
  local green = { 0x00, 0xFF, 0x00 }
  SetDrawColor(spread(green))
  DrawFlagPart(20, 30, 30, 50)

  -- White
  local white = { 0xFF, 0xFF, 0xFF }
  SetDrawColor(spread(white))
  DrawFlagPart(50, 30, 30, 50)

  -- Red
  local red = { 0xFF, 0x00, 0x00 }
  SetDrawColor(spread(red))
  DrawFlagPart(80, 30, 30, 50)

  -- draw a first circle with a checkerboard pattern
  local blue = { 0x00, 0x00, 0xFF }
  SetDrawColor(spread(blue))
  DrawCircleEffect(circle1.x, circle1.y, 30, function(px, py) return CheckerBoardPattern(px, py, 10) end)

  -- draw a second circle with a solid pattern
  -- same color as the first circle
  circle2.y = circle2.y + 40 * DeltaTime()
  if circle2.y > 150 then
    circle2.y = 60
  end
  DrawCircle(circle2.x, circle2.y, 30)

  -- InputPoint() tests
  -- draw a rectangle for mouse position
  local yellow = { 0xFF, 0xFF, 0x00 }
  SetDrawColor(spread(yellow))
  local w, h = 30, 30
  if pointer.down then
    SetDrawColor(spread(red))
    DrawRectangle(pointer.x - w / 2, pointer.y - h / 2, w, h)
  end

  -- draw a rectangle for mouse click
  -- example of " basic scene-graph " concept , applied . from immediate mode to retained mode of rendering . of course HTML DOM hierarchy ( "tree" structure ) is a kind of " tree-based scene-graph " applied to its domain . at the moment of writing no hierarchies are involved yet rendering is " retained " , currently only in "rectangles" data table that works as a list .
  if pointer.click then
    --SetDrawColor(spread(green))
    --DrawRectangle(pointer.x - w / 2, pointer.y - h / 2, w, h)

    -- add a rectangle to the list
    local rectangle = { x = pointer.x - w / 2, y = pointer.y - h / 2, w = w, h = h, color = green }
    table.insert(rectangles, rectangle)
  end

  -- draw rectangles from list
  -- example of " basic scene-graph " concept , applied . from immediate mode to retained mode of rendering . of course HTML DOM hierarchy ( "tree" structure ) is a kind of " tree-based scene-graph " applied to its domain . at the moment of writing no hierarchies are involved yet rendering is " retained " , currently only in "rectangles" data table that works as a list .
  for i, r in ipairs(rectangles) do
    SetDrawColor(spread(r.color))
    DrawRectangle(r.x + viewport_translate.x, r.y + viewport_translate.y, r.w, r.h)
  end
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

local time_ticks = GetTicks()
function DeltaTime()
  local dt -- elapsed time in fractions of seconds
  local delta_ticks = GetTicks() - time_ticks
  time_ticks = GetTicks()
  dt = delta_ticks / 1000 -- milliseconds to seconds
  return dt
end
