local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

local SecurityService = Knit.CreateService({ Name = "SecurityService", Client = {} })

local AdminLevelsSettings = require(script.AdminLevels)

SecurityService.AdminLevels = {}
SecurityService.Logs = require(script.Logs)

SecurityService.ServerLocked = true

function SecurityService:RegisterUser(player:Player, adminLevel:number)
     local realAdminLevel = adminLevel

     if typeof(adminLevel) == "number" then
          realAdminLevel = adminLevel
     elseif typeof(adminLevel) == "string" then
          for i, l in AdminLevelsSettings do
               if l.Name == adminLevel then
                    realAdminLevel = i
               end
          end
     end

     SecurityService.AdminLevels[player] = realAdminLevel

     return AdminLevelsSettings[realAdminLevel]
end

function SecurityService:CheckPermissionTemplate(Player:Player, Permissions:any)
     local Users = Permissions.Users
     local Tools = Permissions.Tools
     local Teams = Permissions.Teams
     local Groups = Permissions.Groups

     local Backpack = Player.Backpack
     local Character = Player.Character
     
     if Users ~= nil then
          for _, user in Users do
               if user == Player.Name or user == Player.UserId then
                    return true
               end
          end
     end

     if Tools ~= nil then
          for _, tool in Tools do
               local checkInBackpack = function()
                    for _, realTool in Backpack:GetChildren() do
                         if realTool:IsA("Tool") and realTool.Name == tool[1] then
                              return true
                         end
                    end
                    return false
               end
               local checkInCharacter = function()
                    for _, realTool in Character:GetChildren() do
                         if realTool:IsA("Tool") and realTool.Name == tool[1] then
                              return true
                         end
                    end
                    return false
               end
               if tool[2] == true then
                    return checkInBackpack()
               elseif tool[2] == false then
                    return checkInCharacter()
               else
                    return (checkInBackpack() and checkInCharacter())
               end
          end
     end

     if Teams ~= nil then
          for _, team in Teams do
               if team == Player.Team.Name or team == Player.TeamColor then
                    return true
               end
          end
     end

     if Groups ~= nil then
          for _, group in Groups do
               for _, rank in group[2] do
                    if Player:GetRankInGroup(group[1]) == rank then
                         return true
                    end
               end
          end
     end

     return false
end

function SecurityService:ChangeServerLocked(State)
     if State ~= nil then
          if typeof(State) == "boolean" then
               SecurityService.ServerLocked = State
          elseif State == "auto" then
               SecurityService.ServerLocked = not SecurityService.ServerLocked
          end
     end
end

function SecurityService:KnitInit()

end

function SecurityService:KnitStart()

     local getAvailableAdminLevel = function(player:Player)
          if player then
               return "Admin"
          end
          return "User"
     end

     local OnPlayerAdded = function(player:Player, isSeparated)
          local AdminLevelInfo = self:RegisterUser(player, getAvailableAdminLevel(player))

          if (not isSeparated) and (self.ServerLocked) and (not AdminLevelInfo.ServerLockImmune) then
               player:Kick("Server Locked")
               return
          end
     end

     for _, player in Players:GetPlayers() do
          OnPlayerAdded(player, true)
     end

     Players.PlayerAdded:Connect(OnPlayerAdded)
end

return SecurityService