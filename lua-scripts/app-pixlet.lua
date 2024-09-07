if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
  -- launched through "lldebugger" (ms-vscode)
  require("lldebugger").start()
end

require("common")

function draw_pixel(rgb, xy)
	SetDrawColor(rgb[1]*255, rgb[2]*255, rgb[3]*255)

	DrawPoint(xy[1], xy[2])
end

function Draw()
	update(0.3)
	draw()
end