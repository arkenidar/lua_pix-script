
if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
  -- launched through "lldebugger" (ms-vscode)
  require("lldebugger").start()
end

print(1)
print(2)
print(3)
