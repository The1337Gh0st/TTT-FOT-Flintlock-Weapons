SWEP.Base = "weapon_ttt_fof_base"

SWEP.PrintName = "Blunderbuss"

--SWEP.HoldType					= "ar2"

SWEP.Icon = "vgui/tttfof/weapons/blunderbuss"
SWEP.IconLetter = "a"

SWEP.Primary.Damage = 8
SWEP.Primary.HeadshotDamage = 11
SWEP.Primary.HullDamage = 2
SWEP.Primary.NumShots = 10
SWEP.Primary.Delay = 0.8
SWEP.Primary.Cone = 0.1
SWEP.Primary.Recoil = 10
SWEP.Primary.ClipSize = 1

SWEP.Primary.Sound = "blunderbuss_fire"
SWEP.Primary.Sound_CL = "blunderbuss_fire"

SWEP.FalloffDisabled = false
SWEP.IsTwoHandedGun = true

SWEP.DryFireSound = "TTTFOF_Coachgun.Empty"

SWEP.UseHands = true
SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 70
SWEP.ViewModel				= "models/weapons/blunderbus.mdl"	-- Weapon view model
SWEP.WorldModel				= "models/weapons/w_blunderbus.mdl"	-- Weapon world model
SWEP.LimbshotMultiplier = 1

SWEP.ShotgunHullDist = 180

SWEP.FalloffStart = 75
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

SWEP.ConeAim = 0.08
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



--cool smoke effect

--function SWEP:ShootBullet(dmg)

--local effect = EffectData();
--	local Forward = self.Owner:GetForward()
--	local Right = self.Owner:GetRight()
--	effect:SetOrigin(self.Owner:GetShootPos()+(Forward*65)+(Right*5))
--	effect:SetNormal( self.Owner:GetAimVector());
--	util.Effect( "effect_awoi_smoke", effect );

  --  return self.BaseClass.ShootBullet(self, dmg)
--end

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

-- code to make weapon not go into the crotch when held

SWEP.Offset = {
Pos = {
Up = -2.5,
Right = 1.5,
Forward = 4,
},
Ang = {
Up = 0,
Right = -7,
Forward = 180,
}
}

function SWEP:DrawWorldModel( )
        local hand, offset, rotate

        local pl = self:GetOwner()

        if IsValid( pl ) then
                        local boneIndex = pl:LookupBone( "ValveBiped.Bip01_R_Hand" )
                        if boneIndex then
                                local pos, ang = pl:GetBonePosition( boneIndex )
                                pos = pos + ang:Forward() * self.Offset.Pos.Forward + ang:Right() * self.Offset.Pos.Right + ang:Up() * self.Offset.Pos.Up

                                ang:RotateAroundAxis( ang:Up(), self.Offset.Ang.Up)
                                ang:RotateAroundAxis( ang:Right(), self.Offset.Ang.Right )
                                ang:RotateAroundAxis( ang:Forward(),  self.Offset.Ang.Forward )

                                self:SetRenderOrigin( pos )
                                self:SetRenderAngles( ang )
                                self:DrawModel()
                        end
        else
                self:SetRenderOrigin( nil )
                self:SetRenderAngles( nil )
                self:DrawModel()
        end
end
