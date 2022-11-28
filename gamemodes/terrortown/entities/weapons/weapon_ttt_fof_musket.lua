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

local frametime, ang = engine.TickInterval(), Angle()

-- hacky fix for shooting sound not working properly due to the original weapon being janky, while also adding in the cool smoke effect

function SWEP:PrimaryAttack(worldsnd)
	if self.PumpTime and self:GetNeedPump()
		or (self.GetThrowing and self:GetThrowing() ~= 0)
		or not self:CanPrimaryAttack()
	then
		return
	end

	local owner = self:GetOwner()

	if not IsValid(owner) then
		return
	end

	local curtime = CurTime()
	local curatt = self:GetNextPrimaryFire()
	local diff = curtime - curatt

	if diff > frametime or diff < 0 then
		curatt = curtime
	end

	local fanning = self:IsFanning()

	local nextpf = curatt + (
		fanning and self.Primary.FanDelay or self.Primary.Delay
	) - (self.PumpTime or 0)

	self.fNextPrimaryFire = nextpf

	self:SetNextPrimaryFire(nextpf)

	self:SetQueueReload(false)

	if self.PumpTime then
		self:SetNeedPump(true)
	end

	if worldsnd then
		sound.Play("musket_fire", self:GetShootPos())
	elseif self.IsSilent then
		self:EmitSound("musket_fire")
	elseif CLIENT then
		if not self.Primary.Sound_CL then
			self.Primary.Sound_CL = "musket_fire"
		end

		self:EmitSound("musket_fire")
	else
		self:EmitSound("musket_fire")

		TTT_FOF.ShootSound(owner, "musket_fire")
	end
	
	--cool smoke effect
	
	local effect = EffectData();
	local Forward = self.Owner:GetForward()
	local Right = self.Owner:GetRight()
	effect:SetOrigin(self.Owner:GetShootPos()+(Forward*65)+(Right*5))
	effect:SetNormal( self.Owner:GetAimVector());
	util.Effect( "effect_awoi_smoke", effect );

	if self.DryFireAnim and self:Clip1() == 1 then
		self:SendWeaponAnim(self.DryFireAnim)
	elseif fanning then
		self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
	else
		self:SendWeaponAnim(self.PrimaryAnim)

		if self.ShootSequence then
			local vm = self:GetOwnerViewModel()

			if vm then
				vm:SendViewModelMatchingSequence(self.ShootSequence)
			end
		end
	end

	if self.AttackAnimSpeed then
		self:SetVMSpeed(self.AttackAnimSpeed)
	end

	if self.ThirdPersonSounds then
		self.NextThirdPersonSound = 1
	end

	owner:MuzzleFlash()

	owner:SetAnimation(PLAYER_ATTACK1)

	self:ShootBullet(fanning and self.Primary.FanDamage or self.Primary.Damage)

	self:TakePrimaryAmmo(1)

	if not owner.ViewPunch then
		return
	end

	local recoil = self.AimRecoil
		and TTT_FOF.RemapClamp(
			self:GetAimAmt(), 0, 1, self.Primary.Recoil, self.AimRecoil
		) or self.Primary.Recoil

	if fanning then
		recoil = recoil + 2
	end

	ang:SetUnpacked(
		-recoil,
		util.SharedRandom(self.ClassName, -0.2, 0.2) * recoil,
		0
	)

	owner:ViewPunch(ang)
end

-- have to redo the reload code to make it have sounds aaa

function SWEP:Reload()
	if self:Clip1() == self.Primary.ClipSize then
		return
	end

	local curtime = CurTime()

	local reloading = self:GetReloading()

	if reloading ~= 0
		and curtime <= reloading
	then
		return
	end

	if curtime <= self:GetNextPrimaryFire()
		or self.PumpTime and self:GetNeedPump()
	then
		self:SetQueueReload(true)
		return
	end

self.Weapon:EmitSound( "musket_reload" )

	self:SendWeaponAnim(
		self.ReloadAnim
		or self.ReloadsSingly and ACT_SHOTGUN_RELOAD_START
		or ACT_VM_RELOAD
	)

	if self.ThirdPersonSounds then
		self.NextThirdPersonSound = 1
	end

	local owner = self:GetOwner()

	if IsValid(owner) then
		local vm = self:GetOwnerViewModel(owner)

		if vm then
			if self.ReloadSequence then
				vm:SendViewModelMatchingSequence(self.ReloadSequence)
			end

			if self.ReloadAnimSpeed then
				vm:SetPlaybackRate(self.ReloadAnimSpeed)
			end
		end
	end

	if not self.ReloadTime then
		self.ReloadTime = self:SequenceDuration() / (self.ReloadAnimSpeed or 1)
	end

	local relfin = curtime + self.ReloadTime

	if self.ReloadsSingly then
		self:SetReloading(relfin)

		self:SetNextPrimaryFire(relfin + 0.25)
	else
		self:SetInserting(true)

		self:SetReloading(relfin - 0.25)

		self:SetNextPrimaryFire(relfin)
	end

	self:SetToggleAim(false)

	if self.PreReload then
		self:PreReload()
	end
end

--fix to make reload sounds not stay on drop / weapon swap

local ttt_fof_deathreload = GetConVar("ttt_fof_deathreload")

function SWEP:PreDrop(death)
	if death and ttt_fof_deathreload:GetBool() then
		self:SetClip1(self.Primary.ClipSize)

		if self.PumpTime then
			self:SetNeedPump(false)
		end
		self:StopSound("musket_reload")
	end
end

function SWEP:Holster()
self:StopSound("musket_reload")
return true
end

