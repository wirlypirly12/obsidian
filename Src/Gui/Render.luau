-- // I have the memory of a hamster
type InfoEntry = {
	Function: (any) -> any,
	Script: Script,
	Line: number,
	IsLuaUClosure: boolean,
	CalledAt: string,
	Method: string,
}

type CallEntry = {
	Args: { [number]: any },
	Caller: InfoEntry,
	Nils: number,
	Time: number,
}

type LogEntry = {
	Name: string,
	Blocked: boolean,
	Instance: Instance,
	Calls: { [number]: CallEntry },
}

local Iris = require(script.Parent.Parent.Extern.Iris)
local CodeGen = require(script.Parent.Parent.Misc.Codegen)
local GuiUtil = require(script.Parent.Util)
local Logs: { [number]: LogEntry } = wax.shared.Log.Data

local Export = {}

local function OnRender()
	Iris.Window({ "Obsidian" })
	local EventState = Iris.State(1)
	local CallState = Iris.State(1)
	do
		Iris.Table({ 2, false, false, false, true })
		do
			for Index, Entry in Logs do
				Iris.Selectable({ `{Entry.Instance:GetFullName()} - (x{#Entry.Calls})`, Index }, { index = EventState })
			end
			local Event = Logs[EventState.value]
			if Event then
				Iris.NextColumn()

				table.sort(Event.Calls, function(T1, T2)
					return T1.Time > T2.Time
				end)

				local Original = CallState.value
				CallState:set(1)
				for Index, Entry in Event.Calls do
					Iris.Selectable({ `({Index}) - {Entry.Caller.CalledAt}`, Index }, { index = CallState })
				end
				CallState:set(Original)

				local Call: CallEntry = Event.Calls[CallState.value]
				if Call then
					Iris.Window(
						{ `{Event.Instance.Name} - {CallState.value}` },
						{ size = Iris.State(Vector2.new(100, 150)) }
					)
					do
						Iris.PushConfig({
							TextColor = Color3.fromRGB(220, 220, 220),

							FrameBg = Color3.fromRGB(37, 37, 38),
							WindowBg = Color3.fromRGB(30, 30, 30),

							TableBorderStrong = Color3.fromRGB(60, 60, 60),

							TableRowBg = Color3.fromRGB(37, 37, 38),
							TableRowBgAlt = Color3.fromRGB(30, 30, 30),

							Header = Color3.fromRGB(45, 45, 48),
							HeaderHovered = Color3.fromRGB(62, 62, 64),

							Button = Color3.fromRGB(45, 45, 48),
							ButtonHovered = Color3.fromRGB(62, 62, 64),

							TextFont = Font.fromEnum(Enum.Font.RobotoMono),
						})
						do
							Iris.Table({ 1, false, true })
							do
								local Code = CodeGen:Generate(Event, CallState.value)
								Iris.Text({ GuiUtil:SyntaxHighlight(Code), true, nil, true })
							end
							Iris.End()
						end
						Iris.PopConfig()

						Iris.SameLine()
						do
							local BlockEvent = Iris.Checkbox({ "Block Event" })
							if Event.Blocked ~= BlockEvent.state.isChecked.value then
								Event.Blocked = BlockEvent.state.isChecked.value
							end

							if Iris.Button({ "Replay Event" }).clicked() then
								local Code = CodeGen:Generate(Event, CallState.value)
								loadstring(Code)()
							end

							if Iris.Button({ "Copy Code" }).clicked() then
								local Code = CodeGen:Generate(Event, CallState.value)
								setclipboard(Code)
							end

							if Iris.Button({ "Decompile Script" }).clicked() then
								task.spawn(function()
									local Script = Call.Caller.Script
									if Script ~= nil then
										print("Decompiled")
										setclipboard(decompile(Script))
									end
								end)
							end
						end
						Iris.End()
					end
					Iris.End()
				end
			end
		end
		Iris.End()
	end
	Iris.End()
end

function Export:Setup()
	Iris.Init()
	Iris:Connect(OnRender)
end

return Export
