local Vector3 = CS.UnityEngine.Vector3
local TransitionManager = CS.TransitionManager
local UIManager = CS.UIManager
local PlayerUtilities = CS.PlayerUtilities
local GameObject = CS.UnityEngine.GameObject
local Color = CS.UnityEngine.Color
local Random = CS.UnityEngine.Random

---@class SerpentsHand:CS.Akequ.Base.PlayerClass
SerpentsHand = {}

function SerpentsHand:Init()
    self.main.player:InitHealth(CS.Config.GetInt("SH_health", 120), Color(1, 0, 0, 1), "Длань Змея")
    self.main.player:SetHitbox(Vector3(0.8, 1.8, 0.8), Vector3.zero)
    if self.main.player.isLocalPlayer then
        self.main.player:PlayBellSound(1)
        UIManager.SetMobileButtons({ "Move", "Rotate", "Pause", "PlayerList", "Interact", "Jump", "Run",
            "Inventory", "Voice", "Crouch" })
        TransitionManager.ShowClass("#ff0000",
            "Длань Змея",
            "Вы в одной команде с <color=red>SCP</color>.\nУничтожьте весь персонал и посторонних.",
            "SERPENT'S HAND", "EuclidIcon")
        PlayerUtilities.SetVoiceChat(PlayerUtilities.CreateValueTuple("SCP", true), PlayerUtilities.CreateValueTuple("3D", true))
    end
    self.main.playerModel = self.main.player:SpawnHumanoidModel("ply_chaosInsurgency")
    self.main.playerModel.transform.localPosition = Vector3(0, -0.83, 0)
    PlayerUtilities.SpawnHitboxes(self.main.player, self.main.playerModel)

    local renderers = self.main.playerModel:GetComponentsInChildren(typeof(CS.UnityEngine.SkinnedMeshRenderer))
    for i = 0, renderers.Length - 1 do
        local renderer = renderers[i]
        if renderer ~= nil then
            local mats = renderer.materials
            if mats ~= nil then
                for j = 0, mats.Length - 1 do
                    local mat = mats[j]
                    if mat ~= nil and mat.name ~= nil then
                        if mat.name:find("Mask") or mat.name:find("Glove") or mat.name:find("Hat") or mat.name:find("Shoe") or mat.name:find("Bottom") or mat.name:find("Top") then
                            mats[j].color = Color(1, 0, 0, 1)
                        end
                    end
                end
                renderer.materials = mats
            end
        end
    end

    if self.main.player.isServer then
        local AW_status = GameObject.FindObjectOfType(typeof(CS.AlphaWarhead)):GetStatus()
        local rooms = GameObject.FindObjectsOfType(typeof(CS.NetRoom))
        if AW_status == CS.AlphaWarhead.AlphaWarheadStatus.ENABLED or AW_status == CS.AlphaWarhead.AlphaWarheadStatus.DISABLED or AW_status == CS.AlphaWarhead.AlphaWarheadStatus.RESTARTING then
            local room_names = { "Map_EZ_Lift(Clone)", "Map_EZ_Endroom(Clone)" }
            local room_name = room_names[math.random(#room_names)]
            for i = 0, rooms.Length - 1 do
                if rooms[i].roomObj.name == room_name then
                    self.main.player:Teleport(rooms[i].roomObj.transform.position + Vector3(0, 1.25, 0), rooms[i])
                    break
                end
            end
        else
            for i = 0, rooms.Length - 1 do
                if rooms[i].roomObj.name == "Map_Exits(Clone)" then
                    local random = math.random(2)
                    if random-1 == 0 then
                        self.main.player:Teleport(Vector3(37.89, -378.55, 27.16), rooms[i])
                        break                    
                    else
                        self.main.player:Teleport(Vector3(135.6, -378.35, 12.78), rooms[i])
                        break
                    end
                end
            end
        end

        self.main.player:GiveItem("BreakingCard")
        self.main.player:GiveItem("ContainmentSpecialistCard")
        self.main.player:GiveItem("AK12")
        self.main.player:GiveItem("FirstAid")
        self.main.player:GiveItem("FlashGrenade")
        self.main.player:GiveItem("Ammo.A545x39")
        self.main.player:GiveItem("Ammo.A545x39")
        self.main.player:GiveItem("Ammo.A545x39")   
    end
    self.main.player:SetSpeed(2.5, 5, 1.1)
    self.main.player:SetJumpPower(3.5)
end

function SerpentsHand:GetSpectatorBone()
    return "DeathCam"
end
function SerpentsHand:OnStop()
    if self.main.playerModel ~= nil then
        local ragdoll = PlayerUtilities.SpawnRagdoll(self.main.player, self.main.playerModel)
        GameObject.Destroy(self.main.playerModel)
        if ragdoll ~= nil then
            local renderers = ragdoll:GetComponentsInChildren(typeof(CS.UnityEngine.SkinnedMeshRenderer))
            for i = 0, renderers.Length - 1 do
                local renderer = renderers[i]
                if renderer ~= nil then
                    local mats = renderer.materials
                    if mats ~= nil then
                        for j = 0, mats.Length - 1 do
                            local mat = mats[j]
                            if mat ~= nil and mat.name ~= nil then
                                if mat.name:find("Mask") or mat.name:find("Glove") or mat.name:find("Hat") or mat.name:find("Shoe") or mat.name:find("Bottom") or mat.name:find("Top") then
                                    mats[j].color = Color(1, 0, 0, 1)
                                end
                            end
                        end
                        renderer.materials = mats
                    end
                end
            end
        end
    else
        local ragdoll = PlayerUtilities.SpawnRagdoll(self.main.player, "ply_chaosInsurgency_ragdoll")
        if ragdoll ~= nil then
            local renderers = self.main.playerModel:GetComponentsInChildren(typeof(CS.UnityEngine.SkinnedMeshRenderer))
            for i = 0, renderers.Length - 1 do
                local renderer = renderers[i]
                if renderer ~= nil then
                    local mats = renderer.materials
                    if mats ~= nil then
                        for j = 0, mats.Length - 1 do
                            local mat = mats[j]
                            if mat ~= nil and mat.name ~= nil then
                                if mat.name:find("Mask") or mat.name:find("Glove") or mat.name:find("Hat") or mat.name:find("Shoe") or mat.name:find("Bottom") or mat.name:find("Top") then
                                    mats[j].color = Color(1, 0, 0, 1)
                                end
                            end
                        end
                        renderer.materials = mats
                    end
                end
            end
        end
    end
end

function SerpentsHand:OnOpenInventory()
    return true
end

function SerpentsHand:IgnoreSCP()
    return true
end
function SerpentsHand:GetName()
    return "Длань Змея"
end
function SerpentsHand:GetTeamID()
    return "SCP"
end
function SerpentsHand:GetClassColor()
    return "ff0000"
end
return SerpentsHand