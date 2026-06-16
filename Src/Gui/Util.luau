local Export = {}
local Keywords = {
	[" function "] = true,
	[" local "] = true,
	[" if "] = true,
	[" then "] = true,
	[" else "] = true,
	[" elseif "] = true,
	[" end "] = true,
	[" for "] = true,
	[" while "] = true,
	[" repeat "] = true,
	[" until "] = true,
	[" do "] = true,
	[" break "] = true,
	[" continue "] = true,
	[" return "] = true,
	[" and "] = true,
	[" or "] = true,
	[" not "] = true,
	[" nil "] = true,
	[" true "] = true,
	[" false "] = true,
	[" in "] = true,
}
local Globals = {
	["game"] = true,
	["workspace"] = true,
	["Vector2.new"] = true,
	["Vector3.new"] = true,
	["CFrame"] = true,
	["Instance"] = true,
	["Enum"] = true,
}

local Functions = {
	["GetService"] = true,
	["FireServer"] = true,
	["InvokeServer"] = true,
	["newproxy"] = true,
	["buffer.create"] = true,
	["math.rad"] = true,
	["CFrame.new"] = true,
	["CFrame.Angles"] = true,
}

local Colors = {
	Number = { 200, 255, 200 },
	String = { 0, 165, 255 },
	Keyword = { 255, 50, 100 },
	Global = { 255, 200, 255 },
	Functions = { 160, 215, 220 },
}

local function Color(ColorString, String)
	return `<font color="rgb({ColorString})">{String}</font>`
end

function Export:SyntaxHighlight(CodeBlock)
	for Global, Value in Globals do
		CodeBlock = CodeBlock:gsub(Global, Color(table.concat(Colors.Global, ","), Global))
	end
	for Keyword, Value in Keywords do
		CodeBlock = CodeBlock:gsub(Keyword, Color(table.concat(Colors.Keyword, ","), Keyword))
	end
	for Function, Value in Functions do
		CodeBlock = CodeBlock:gsub(Function, Color(table.concat(Colors.Functions, ","), Function))
	end
	local Expected = nil
	local Strings = {}

	local Str = ""
	for i = 1, #CodeBlock do
		local Character = CodeBlock:sub(i, i)
		if Character == '"' or Character == "'" or Character == "`" then
			if Expected == Character then
				Expected = nil
				table.insert(Strings, Str)
				Str = ""
				continue
			end
			Expected = Character
			continue
		end

		if Expected then
			Str ..= Character
		end
	end
	Str = ""

	for Index, String in Strings do
		CodeBlock = CodeBlock:gsub(String, Color(table.concat(Colors.String, ","), String))
	end

	-- local Number = ""
	-- local Numbers = {}

	-- for i = 1, #CodeBlock do
	-- 	local Character = CodeBlock:sub(i, i)
	-- 	local Num = tonumber(Character)

	-- 	if not Num then
	-- 		if Number ~= "" then
	-- 			table.insert(Numbers, Number)
	-- 			Number = ""
	-- 		end

	-- 		continue
	-- 	end

	-- 	local PreviousCharacter = CodeBlock:sub(i - 1, i - 1)
	-- 	if
	-- 		PreviousCharacter == " "
	-- 		or PreviousCharacter == ","
	-- 		or PreviousCharacter ~= "("
	-- 		or tonumber(PreviousCharacter) ~= nil
	-- 	then
	-- 		Number ..= Character
	-- 	end
	-- end

	-- if Number ~= "" then
	-- 	table.insert(Numbers, Number)
	-- 	Number = ""
	-- end

	-- for Index, CurrentNumber in Numbers do
	-- 	CodeBlock = CodeBlock:gsub(CurrentNumber, Color(table.concat(Colors.Number, ","), CurrentNumber))
	-- end

	return CodeBlock
end

return Export
