CreateConVar( "ttt_fof_flintlock_blunderbuss_smoke", 0 ,{ FCVAR_ARCHIVE, FCVAR_NOTIFY }, "whether or not the blunderbuss emits smoke upon firing (0 by default)" )

SWEP.Base = "weapon_ttt_fof_base"

SWEP.PrintName = "Blunderbuss"

--SWEP.HoldType					= "ar2"

SWEP.Icon = "vgui/tttfof/weapons/blunderbuss"
SWEP.IconLetter = "a"

SWEP.Primary.Damage = 80
SWEP.Primary.HeadshotDamage = 100
--SWEP.Primary.HullDamage = 2
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.8
SWEP.Primary.Cone = 0.1
SWEP.Primary.Recoil = 10
SWEP.Primary.ClipSize = 1

SWEP.Primary.Sound = "blunderbuss_fire"
SWEP.Primary.Sound_CL = "blunderbuss_fire"

SWEP.FalloffDisabled = true
SWEP.IsTwoHandedGun = true

SWEP.DryFireSound = "TTTFOF_Coachgun.Empty"

SWEP.UseHands = true
SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 70
SWEP.ViewModel				= "models/weapons/blunderbus.mdl"	-- Weapon view model
SWEP.WorldModel				= "models/weapons/w_blunderbus.mdl"	-- Weapon world model
SWEP.LimbshotMultiplier = 1

--SWEP.ShotgunHullDist = 180

SWEP.FalloffStart = 125
SWEP.FalloffHalf = 500
SWEP.FalloffEnd = 900

SWEP.CSMuzzleFlashes = true

SWEP.IsSilent = false

SWEP.IronSightsPos = Vector(-2.55, 0.55, 0.319)	
SWEP.IronSightsAng = Vector(0, -2.201, 0)	


SWEP.ShootSequence = 1

SWEP.ReloadTime = 5
SWEP.InsertTime = 4
SWEP.ReloadAnimSpeed = 0.7

SWEP.DeployTime = 1

SWEP.ConeAim = 0.07
SWEP.ConeRun = 0.075
SWEP.ConeJump = 0.15

SWEP.ConeTimeRun = 0.1
SWEP.ConeTimeJump = 0.35

SWEP.AimTime = 0.5

SWEP.ConeTimeRun = 0.4
SWEP.ConeTimeJump = 0.65

SWEP.AimTime = 0.5

SWEP.spawnType = WEAPON_TYPE_SHOTGUN

SWEP.UseRifleAim = true

SWEP.AutoSpawnable = true
-- name of the cvar used to toggle whether it should spawn or not
SWEP.AutoSpawnableConVar = "ttt_fof_spawnwep_blunderbuss"

SWEP.DeadEyeCone = 0.025
SWEP.DeadEyeShootSequence = 1
SWEP.DeadEyeAttackDelay = 0.8
SWEP.DeadEyeAttackAnimSpeed = 1.5
SWEP.DeadEyeDeployTime = 0.66
SWEP.DeadEyeDeployAnimSpeed = 1.8

SWEP.SilencerModelPath = "models/ttt_fof/silencer_detached_tmp.mdl"
SWEP.SilencerOffsetPos = Vector(-12, 4.8, -1.5)
SWEP.SilencerOffsetAng = Angle(0, -5, 0)

SWEP.HolsteredOffsetPos = Vector(-5, 0.3, 0)

--SWEP.SilencerOffsetPos = Vector(-0.3, 0, -20)
--SWEP.SilencerOffsetAng = Angle(0, -5, 0)

--SWEP.SilencerOffsetPos = Vector(0.014, -6.128, -1.609)
--SWEP.SilencerOffsetAng = Angle(-0, -90, 90)

--SWEP.SilencerOffsetPos = false
--SWEP.SilencerOffsetAng = false

--SWEP.SilencerOffsetPos = false
--SWEP.SilencerOffsetAng = false
--SWEP.SilencerVMBone = false
--SWEP.SilencerVMOffsetPos = false
--SWEP.SilencerVMOffsetAng = false



--cool smoke effect

function SWEP:ShootBullet(dmg)

if GetConVar("ttt_fof_flintlock_blunderbuss_smoke"):GetBool() then
local effect = EffectData();
	local Forward = self.Owner:GetForward()
	local Right = self.Owner:GetRight()
	effect:SetOrigin(self.Owner:GetShootPos()+(Forward*65)+(Right*5))
	effect:SetNormal( self.Owner:GetAimVector());
	util.Effect( "effect_awoi_smoke", effect );
	end

    return self.BaseClass.ShootBullet(self, dmg)
end

-- emit reload sound

function SWEP:PreReload()
self.Weapon:EmitSound( "blunderbuss_reload" )

end

function SWEP:PreDrop(death)
    self:EmitSound("blunderbuss_reload")
end

function SWEP:PreDrop(death)
    self:StopSound("blunderbuss_reload")

    return self.BaseClass.PreDrop(self, death)
end

function SWEP:Holster()
self:StopSound("blunderbuss_reload")
return true
end

SWEP.NewRightHandPos = Vector(2.4, -0.5, -3.5)
SWEP.NewRightHandAng = Angle(0, -6, 177)

if SERVER then
	return
end

function SWEP:GetViewModelPosition(pos, ang)
	pos:Sub(ang:Up())

	return self.BaseClass.GetViewModelPosition(self, pos, ang)
end
