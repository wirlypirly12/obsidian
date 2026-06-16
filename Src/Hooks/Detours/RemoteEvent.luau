local Log = wax.shared.Log
local Inspect = wax.shared.Inspect

return function(...)
	local self = ...

	local CallingFunction = Inspect:GetCallingFunction()
	local CallingLine = debug.info(CallingFunction, "l")
	local CallingScript = Inspect:GetCallingScript()

	local EventInfo = Log:Get(self)
	if EventInfo and EventInfo.Blocked then
		return false
	end

	local Args = { select(2, ...) }
	Log:Push({
		Args = Args,
		Nils = (select("#", ...) - 1) - #Args,
		CallingFunction = CallingFunction,
		CallingLine = CallingLine,
		CallingScript = CallingScript,
		IsLuaUClosure = Inspect:IsLuaUClosure(CallingFunction),
		CalledAt = Inspect:GetTime(),
		Remote = self,
		NamecallMethod = getnamecallmethod(),
	})

	return true
end
