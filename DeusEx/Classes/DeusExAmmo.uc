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
