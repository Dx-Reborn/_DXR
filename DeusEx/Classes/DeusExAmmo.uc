// Боеприпасы для инвентаря
class DeusExAmmo extends RuntimeAmmunition;

//
// DEUS_EX AJY - additions (from old DeusExPickup)
//
var bool          bCanUseObjectBelt; // Can this object be placed on the object belt?
var texture         largeIcon;         // Larger-than-usual icon for the inventory window
var texture         Icon;
var int           largeIconWidth;    // Width of graphic in texture
var int           largeIconHeight;   // Height of graphic in texture
var() localized String    description;       // Description
var localized String    beltDescription;   // Description used on the object belt

var localized String msgInfoRounds;

// True if this ammo can be displayed in the Inventory screen
// by clicking on the "Ammo" button.
var bool bShowInfo;

/*
   Note for mod authors: now ammo are saved differently, so you have to add own classes here and
   in function below (RestoreAmmoAmount());
*/
function SaveAmmoAmount()
{
  local DeusExGlobals gl;

  gl = class'DeusExGlobals'.static.GetGlobals();

  if (self.IsA('Ammo10mmInv') && Owner.IsA('DeusExPlayer')) gl.Ammo10mmInv = AmmoAmount; else

  if (self.IsA('Ammo762mmInv') && Owner.IsA('DeusExPlayer')) gl.Ammo762mmInv = AmmoAmount; else
  if (self.IsA('Ammo20mmInv') && Owner.IsA('DeusExPlayer')) gl.Ammo20mmInv = AmmoAmount; else

  if (self.IsA('Ammo3006Inv') && Owner.IsA('DeusExPlayer')) gl.Ammo3006Inv = AmmoAmount; else

  if (self.IsA('AmmoBatteryInv') && Owner.IsA('DeusExPlayer')) gl.AmmoBatteryInv = AmmoAmount; else

  if (self.IsA('AmmoDartFlareInv') && Owner.IsA('DeusExPlayer')) gl.AmmoDartFlareInv = AmmoAmount; else
  if (self.IsA('AmmoDartInv') && Owner.IsA('DeusExPlayer')) gl.AmmoDartInv = AmmoAmount; else
  if (self.IsA('AmmoDartPoisonInv') && Owner.IsA('DeusExPlayer')) gl.AmmoDartPoisonInv = AmmoAmount; else

  if (self.IsA('AmmoEMPGrenadeInv') && Owner.IsA('DeusExPlayer')) gl.AmmoEMPGrenadeInv = AmmoAmount; else
  if (self.IsA('AmmoGasGrenadeInv') && Owner.IsA('DeusExPlayer')) gl.AmmoGasGrenadeInv = AmmoAmount; else
  if (self.IsA('AmmoLAMInv') && Owner.IsA('DeusExPlayer')) gl.AmmoLAMInv = AmmoAmount; else
  if (self.IsA('AmmoNanoVirusGrenadeInv') && Owner.IsA('DeusExPlayer')) gl.AmmoNanoVirusGrenadeInv = AmmoAmount; else

  if (self.IsA('AmmoNapalmInv') && Owner.IsA('DeusExPlayer')) gl.AmmoNapalmInv = AmmoAmount; else
  if (self.IsA('AmmoPlasmaInv') && Owner.IsA('DeusExPlayer')) gl.AmmoPlasmaInv = AmmoAmount; else

  if (self.IsA('AmmoRocketInv') && Owner.IsA('DeusExPlayer')) gl.AmmoRocketInv = AmmoAmount; else
  if (self.IsA('AmmoRocketWPInv') && Owner.IsA('DeusExPlayer')) gl.AmmoRocketWPInv = AmmoAmount; else
  if (self.IsA('AmmoRocketMiniInv') && Owner.IsA('DeusExPlayer')) gl.AmmoRocketMiniInv = AmmoAmount; else

  if (self.IsA('AmmoSabotInv') && Owner.IsA('DeusExPlayer')) gl.AmmoSabotInv = AmmoAmount; else
  if (self.IsA('AmmoShellInv') && Owner.IsA('DeusExPlayer')) gl.AmmoShellInv = AmmoAmount; else

  if (self.IsA('AmmoShurikenInv') && Owner.IsA('DeusExPlayer')) gl.AmmoShurikenInv = AmmoAmount; else
  if (self.IsA('AmmoNoneInv') && Owner.IsA('DeusExPlayer')) gl.AmmoNoneInv = AmmoAmount;
}

function RestoreAmmoAmount()
{
  local DeusExGlobals gl;

  gl = class'DeusExGlobals'.static.GetGlobals();

  if (self.IsA('Ammo10mmInv') && Owner.IsA('DeusExPlayer')) AmmoAmount = gl.Ammo10mmInv; else

  if (self.IsA('Ammo762mmInv') && Owner.IsA('DeusExPlayer')) AmmoAmount = gl.Ammo762mmInv; else
  if (self.IsA('Ammo20mmInv') && Owner.IsA('DeusExPlayer')) AmmoAmount = gl.Ammo20mmInv; else

  if (self.IsA('Ammo3006Inv') && Owner.IsA('DeusExPlayer')) AmmoAmount = gl.Ammo3006Inv; else

  if (self.IsA('AmmoBatteryInv') && Owner.IsA('DeusExPlayer')) AmmoAmount = gl.AmmoBatteryInv; else

  if (self.IsA('AmmoDartFlareInv') && Owner.IsA('DeusExPlayer')) AmmoAmount = gl.AmmoDartFlareInv; else
  if (self.IsA('AmmoDartInv') && Owner.IsA('DeusExPlayer')) AmmoAmount = gl.AmmoDartInv; else
  if (self.IsA('AmmoDartPoisonInv') && Owner.IsA('DeusExPlayer')) AmmoAmount = gl.AmmoDartPoisonInv; else

  if (self.IsA('AmmoEMPGrenadeInv') && Owner.IsA('DeusExPlayer')) AmmoAmount = gl.AmmoEMPGrenadeInv; else
  if (self.IsA('AmmoGasGrenadeInv') && Owner.IsA('DeusExPlayer')) AmmoAmount = gl.AmmoGasGrenadeInv; else
  if (self.IsA('AmmoLAMInv') && Owner.IsA('DeusExPlayer')) AmmoAmount = gl.AmmoLAMInv; else
  if (self.IsA('AmmoNanoVirusGrenadeInv') && Owner.IsA('DeusExPlayer')) AmmoAmount = gl.AmmoNanoVirusGrenadeInv; else

  if (self.IsA('AmmoNapalmInv') && Owner.IsA('DeusExPlayer')) AmmoAmount = gl.AmmoNapalmInv; else
  if (self.IsA('AmmoPlasmaInv') && Owner.IsA('DeusExPlayer')) AmmoAmount = gl.AmmoPlasmaInv; else

  if (self.IsA('AmmoRocketInv') && Owner.IsA('DeusExPlayer')) AmmoAmount = gl.AmmoRocketInv; else
  if (self.IsA('AmmoRocketWPInv') && Owner.IsA('DeusExPlayer')) AmmoAmount = gl.AmmoRocketWPInv; else
  if (self.IsA('AmmoRocketMiniInv') && Owner.IsA('DeusExPlayer')) AmmoAmount = gl.AmmoRocketMiniInv; else

  if (self.IsA('AmmoSabotInv') && Owner.IsA('DeusExPlayer')) AmmoAmount = gl.AmmoSabotInv; else
  if (self.IsA('AmmoShellInv') && Owner.IsA('DeusExPlayer')) AmmoAmount = gl.AmmoShellInv; else

  if (self.IsA('AmmoShurikenInv') && Owner.IsA('DeusExPlayer')) AmmoAmount = gl.AmmoShurikenInv; else
  if (self.IsA('AmmoNoneInv') && Owner.IsA('DeusExPlayer')) AmmoAmount = gl.AmmoNoneInv;
}

function string GetDescription()
{return description;}

function string GetbeltDescription()  // Description used on the object belt
{return beltdescription;}





defaultproperties
{
  Lifespan=0.0
  DrawType=dt_mesh
  Physics=PHYS_FALLING
}
