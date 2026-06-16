local Events = {}
print("RE Test Init")
for i = 1, 10 do
	local Remote = Instance.new("RemoteEvent", game:GetService("ReplicatedStorage"))
	Remote.Name = game:GetService("HttpService"):GenerateGUID(false):gsub("-", "")

	table.insert(Events, Remote)
end
local function Num()
	return math.random(1, 250)
end
local Types = {
	function()
		return Vector3.new(Num(), Num())
	end,
	function()
		return Vector2.new(Num(), Num())
	end,
	function()
		return "Its a string!"
	end,
	function()
		return Num()
	end,
	function()
		return Events[math.random(1, 10)]
	end,
	function()
		return newproxy(true)
	end,
	function()
		return game.Players.LocalPlayer.Character.Head.CFrame
	end,
	function()
		return buffer.create(30)
	end,
}

local function GetArgs(Length)
	local Args = {}

	for i = 1, Length do
		local Type = Types[math.random(1, #Types)]()
		table.insert(Args, Type)
	end

	return unpack(Args)
end

task.spawn(function()
	local Idx = 1
	while task.wait(1) do
		local Remote = Events[Idx]
		if not Remote then
			continue
		end

		Remote:FireServer(GetArgs(3))

		Idx += 1
		if Idx > 10 then
			Idx = 1
		end
	end
end)
