
CreateConVar( "ttt_fof_flintlock_pistol_smoke", 1 ,{ FCVAR_ARCHIVE, FCVAR_NOTIFY }, "whether or not the flintlock pistol emits smoke upon firing (1 by default)" )

SWEP.Base = "weapon_ttt_fof_base"

SWEP.PrintName = "Flintlock Pistol"
SWEP.Slot = 6

SWEP.EquipMenuData = {
	type = "item_weapon",
	desc = "Flintlock pistol that has 1-shot capability, \ndealing 200 damage on hit. \nCreates a small smoke cloud upon being fired. \nIgnores limb damage penalty and damage fall-off. \nLow accuracy with no aim penalty while moving."
}

--SWEP.HoldType					= "revolver"

SWEP.Icon = "vgui/tttfof/weapons/flintlock"
SWEP.IconLetter = "a"

SWEP.Primary.Damage = 200
SWEP.Primary.HeadshotDamage = 400
SWEP.Primary.Delay = 0.8
SWEP.Primary.Cone = 0
SWEP.Primary.Recoil = 12
SWEP.Primary.ClipSize = 1

SWEP.Primary.Sound = "flintlock_fire"
SWEP.Primary.Sound_CL = "flintlock_fire"

SWEP.FalloffDisabled = true
SWEP.LimbshotMultiplier = 2

SWEP.MaxGunThrowDamage = 60
SWEP.MinGunThrowDamage = 39

SWEP.DryFireSound = "TTTFOF_Pistol.Empty"

SWEP.Kind = WEAPON_EQUIP
SWEP.CanBuy = CreateConVar(
	"ttt_fof_flintlock_pistol_enabled", "1", FCVAR_ARCHIVE + FCVAR_NOTIFY + FCVAR_REPLICATED,
	"server needs a map change to apply new value"
):GetBool() and {ROLE_DETECTIVE} or {}

SWEP.UseHands = true
SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 50
SWEP.WorldModel					= "models/weapons/awoi/w_french_1766_cavalry_pistol.mdl"
SWEP.ViewModel					= "models/weapons/awoi/v_french_1766_cavalry_pistol.mdl"

SWEP.CSMuzzleFlashes = true

SWEP.IsSilent = false

SWEP.IronSightsPos 				= Vector (-7.6, -3, 4)
SWEP.IronSightsAng 				= Vector (-7, -10.5, 0)


SWEP.ShootSequence = 1

SWEP.ReloadTime = 6
SWEP.InsertTime = 5
SWEP.ReloadAnimSpeed = 0.93

SWEP.DeployTime = 1

SWEP.ConeAim = 0.075
SWEP.ConeHip = 0.25
SWEP.ConeRun = 0.1
SWEP.ConeJump = 0.15

SWEP.ConeTimeRun = 0.15
SWEP.ConeTimeJump = 0.25

SWEP.AimTime = 0.4
SWEP.AimRecoil = 10

SWEP.spawnType = WEAPON_TYPE_SPECIAL


SWEP.AutoSpawnable = false

function SWEP:ShootBullet(dmg)

if GetConVar("ttt_fof_flintlock_pistol_smoke"):GetBool() then
local effect = EffectData();
	local Forward = self.Owner:GetForward()
	local Right = self.Owner:GetRight()
	effect:SetOrigin(self.Owner:GetShootPos()+(Forward*65)+(Right*5))
	effect:SetNormal( self.Owner:GetAimVector());
	util.Effect( "effect_awoi_smoke_pistol", effect );
	end

    return self.BaseClass.ShootBullet(self, dmg)
end

-- emit reload sound

function SWEP:PreReload()
self.Weapon:EmitSound( "flintlock_reload" )

end

function SWEP:PreDrop(death)
    self:EmitSound("flintlock_reload")
end

function SWEP:PreDrop(death)
    self:StopSound("flintlock_reload")

    return self.BaseClass.PreDrop(self, death)
end

function SWEP:Holster()
self:StopSound("flintlock_reload")
return true
end


