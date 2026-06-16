local Export = {}
local HookedObjects = {}

function Export:CloneMetatable(Instance)
	local ClonedMetatable = {}
	local CurrentMetatable = getrawmetatable(Instance)

	for Field, Callback in CurrentMetatable do
		if type(Callback) ~= "function" then
			continue
		end

		ClonedMetatable[Field] = clonefunction(Callback)
	end

	return ClonedMetatable, CurrentMetatable
end

function Export:Create(Instance, Method, Callback)
	local FakeMeta, OriginalMeta = Export:CloneMetatable(Instance)
	local TargetFunction = FakeMeta[Method]

	assert(TargetFunction, `TargetFunction is nil, ensure {Method} is actually on the object`)

	local OriginalFunction = hookfunction(TargetFunction, Callback)

	setrawmetatable(Instance, FakeMeta)

	table.insert(HookedObjects, {
		Instance = Instance,
		Original = OriginalMeta,
	})

	return OriginalFunction
end

function Export:Cleanup()
	local Restored = {}

	for Index, Entry in HookedObjects do
		local Instance = Entry.Instance
		local Meta = Entry.Original

		if not Instance or not Meta then
			continue
		end

		setrawmetatable(Instance, Meta)
		table.insert(Restored, Index)
	end

	for Index, HookedObjIndex in Restored do
		HookedObjects[HookedObjIndex] = nil
	end

	return #Restored == #HookedObjects
end

return Export
