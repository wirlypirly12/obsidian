local EventLogs = {}
local Lookup = {}
local Export = {}

local function SetupEntry(Remote)
	local Entry = {
		Name = Remote.Name,
		Instance = Remote,
		Blocked = false,
		Calls = {},
	}

	table.insert(EventLogs, Entry)
	Lookup[Remote] = #EventLogs

	return #EventLogs
end

function Export:Push(Entry)
	local EventIndex = Lookup[Entry.Remote]
	if EventIndex == nil then
		EventIndex = SetupEntry(Entry.Remote)
	end

	local EventData = EventLogs[EventIndex]
	table.insert(EventData.Calls, {
		Args = Entry.Args,
		Nils = Entry.Nils,
		Caller = {
			Function = Entry.CallingFunction,
			Script = Entry.CallingScript,
			Line = Entry.CallingLine,
			IsLuaUClosure = Entry.IsLuaUClosure,
			CalledAt = Entry.CalledAt,
			Method = Entry.NamecallMethod,
		},
		Time = tick(),
	})
end

function Export:Get(Remote)
	return EventLogs[Lookup[Remote]]
end

Export.Data = EventLogs

return Export
