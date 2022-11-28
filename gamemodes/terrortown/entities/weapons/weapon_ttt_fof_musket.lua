SWEP.Base = "weapon_ttt_fof_base"

SWEP.PrintName = "Musket"
SWEP.Slot = 6

SWEP.EquipMenuData = {
	type = "item_weapon",
	desc = "Musket rifle that has 1-shot capability, \ndealing 200 damage on hit. \nCreates a large smoke cloud when fired. \nIgnores limb damage penalty and damage fall-off. \nHas high accuracy when aiming and standing still."
}

--SWEP.HoldType					= "ar2"

SWEP.Icon = "vgui/tttfof/weapons/musket"
SWEP.IconLetter = "a"

SWEP.Primary.Damage = 200
SWEP.Primary.HeadshotDamage = 400
SWEP.Primary.Delay = 0.8
SWEP.Primary.Cone = 0
SWEP.Primary.Recoil = 12
SWEP.Primary.ClipSize = 1

SWEP.Primary.Sound = "musket_fire"
SWEP.Primary.Sound_CL = "musket_fire"

SWEP.FalloffDisabled = true
SWEP.IsTwoHandedGun = true

SWEP.DryFireSound = "TTTFOF_Carbine.Empty"

SWEP.Kind = WEAPON_EQUIP
SWEP.CanBuy = {ROLE_TRAITOR}

SWEP.UseHands = true
SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 50
SWEP.WorldModel					= "models/weapons/awoi/w_long_land_pattern.mdl"
SWEP.ViewModel					= "models/weapons/awoi/v_long_land_pattern.mdl"
SWEP.LimbshotMultiplier = 2

SWEP.CSMuzzleFlashes = true

SWEP.IsSilent = false


SWEP.ShootSequence = 1

SWEP.ReloadTime = 8
SWEP.InsertTime = 7
SWEP.ReloadAnimSpeed = 1

SWEP.DeployTime = 1

SWEP.ConeAim = 0.025
SWEP.ConeAimRun = 1
SWEP.ConeAimJump = 0.2
SWEP.ConeHip = 0.25
SWEP.ConeRun = 0.35
SWEP.ConeJump = 0.5

SWEP.ConeTimeRun = 0.4
SWEP.ConeTimeJump = 0.65

SWEP.AimTime = 0.66
SWEP.AimMinAmt = 0.75
SWEP.AimRecoil = 20

SWEP.spawnType = WEAPON_TYPE_SPECIAL

SWEP.UseRifleAim = true

SWEP.AutoSpawnable = false

--cool smoke effect

function SWEP:ShootBullet(dmg)

local effect = EffectData();
	local Forward = self.Owner:GetForward()
	local Right = self.Owner:GetRight()
	effect:SetOrigin(self.Owner:GetShootPos()+(Forward*65)+(Right*5))
	effect:SetNormal( self.Owner:GetAimVector());
	util.Effect( "effect_awoi_smoke", effect );

    return self.BaseClass.ShootBullet(self, dmg)
end

-- emit reload sound

function SWEP:PreReload()
self.Weapon:EmitSound( "musket_reload" )

end

function SWEP:PreDrop(death)
    self:EmitSound("musket_reload")
end

function SWEP:PreDrop(death)
    self:StopSound("musket_reload")

    return self.BaseClass.PreDrop(self, death)
end

