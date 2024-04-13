local Shared = {}

for _, Module in script:GetChildren() do
	if Module:IsA("ModuleScript") then
		if Module:GetAttribute("Disabled") ~= true then
			local r = require(Module)
			Shared[Module.Name] = r
		end
	end
end

return Shared