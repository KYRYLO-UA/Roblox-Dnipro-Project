local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

Knit.Shared = require(ReplicatedStorage.Shared)

Knit.AddServices(script)
Knit.Start():catch(warn)

Knit.Loaded = true