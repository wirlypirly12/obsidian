local Export = {}

function Export:GetCallingScript()
	local Function = Export:GetCallingFunction(2)
	local FuncSourceInst = rawget(getfenv(Function), "script")
	return FuncSourceInst
end

function Export:IsLuaUClosure(Function)
	local Info = debug.info(Function, "s")
	return Info and Info.short_src == "[C]"
end

function Export:GetTime()
	local Time = os.date("*t")
	return string.format("%d:%d:%d", Time.hour, Time.min, Time.sec)
end

function Export:GetCallingFunction(Offset)
	Offset = Offset and Offset + 3 or 3
	return debug.info(Offset, "f")
end

return Export
