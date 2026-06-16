local HookObject = require(script.Parent.Object)

local Export = {}
local Information = {
	HookedEvents = 0,
	Specific = {},
}

local function GetDetour(Name)
	return require(script.Parent.Detours:FindFirstChild(Name))
end

local Detours = {
	["RemoteEvent"] = GetDetour("RemoteEvent"),
	["RemoteFunction"] = GetDetour("RemoteEvent"),
}

for Name, Detour in Detours do
	Information.Specific[Name] = 0
end

local WhitelistedCalls = {
	["FireServer"] = true,
	["InvokeServer"] = true,
}

function Export:GetInfo()
	return Information
end

function Export:Setup()
	for Index, Instance in game:GetDescendants() do
		local Class = Instance.ClassName
		local Detour = Detours[Class]

		if Detour == nil then
			continue
		end

		local Original
		Original = HookObject:Create(Instance, "__namecall", function(...)
			if WhitelistedCalls[getnamecallmethod()] ~= true then
				return Original(...)
			end
			return if Detour(...) == true then Original(...) else nil
		end)

		Information.HookedEvents += 1
		Information.Specific[Class] += 1
	end
end

function Export:Cleanup()
	if not HookObject:Cleanup() then
		warn("HookObject had an issue while cleaning up")
	end
end

return Export
