//=============================================================================
// PaulDenton.
//=============================================================================
class PaulDenton extends HumanMilitary;

//
// Damage type table for Paul Denton:
//
// Shot         - 100%
// Sabot        - 100%
// Exploded     - 100%
// TearGas      - 10%
// PoisonGas    - 10%
// Poison       - 10%
// PoisonEffect - 10%
// HalonGas     - 10%
// Radiation    - 10%
// Shocked      - 10%
// Stunned      - 0%
// KnockedOut   - 0%
// Flamed       - 0%
// Burned       - 0%
// NanoVirus    - 0%
// EMP          - 0%
//



// ----------------------------------------------------------------------
// SetSkin()
// ----------------------------------------------------------------------
function SetSkin(DeusExPlayer player)
{
    if (player != None)
    {
        switch(player.PlayerSkin)
        {
            case 0: Skins[0] = Texture'PaulDentonTex0';
                    Skins[3] = Texture'PaulDentonTex0';
                    break;
            case 1: Skins[0] = Texture'PaulDentonTex4';
                    Skins[3] = Texture'PaulDentonTex4';
                    break;
            case 2: Skins[0] = Texture'PaulDentonTex5';
                    Skins[3] = Texture'PaulDentonTex5';
                    break;
            case 3: Skins[0] = Texture'PaulDentonTex6';
                    Skins[3] = Texture'PaulDentonTex6';
                    break;
            case 4: Skins[0] = Texture'PaulDentonTex7';
                    Skins[3] = Texture'PaulDentonTex7';
                    break;
        }
    }
}



// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     HealthHead=200
     HealthTorso=200
     HealthLegLeft=200
     HealthLegRight=200
     HealthArmLeft=200
     HealthArmRight=200
     BindName="PaulDenton"
     FamiliarName="Paul Denton"
     UnfamiliarName="Paul Denton"
     CarcassType=Class'DeusEx.PaulDentonCarcass'
     WalkingSpeed=0.120000
     bImportant=True
     bInvincible=True
     BaseAssHeight=-23.000000
     InitialInventory(0)=(Inventory=Class'DeusEx.WeaponAssaultGun')
     InitialInventory(1)=(Inventory=Class'DeusEx.Ammo762mm',Count=12)
     InitialInventory(2)=(Inventory=Class'DeusEx.WeaponPlasmaRifle')
     InitialInventory(3)=(Inventory=Class'DeusEx.AmmoPlasma')
     InitialInventory(4)=(Inventory=Class'DeusEx.WeaponSword')
     BurnPeriod=0.000000
     bHasCloak=True
     CloakThreshold=100
     Health=200
     Mesh=mesh'DeusExCharacters.GM_Trench'
     skins(0)=Texture'DeusExCharacters.Skins.PaulDentonTex0'
     skins(1)=Texture'DeusExCharacters.Skins.PaulDentonTex2'
     skins(2)=Texture'DeusExCharacters.Skins.PantsTex8'
     skins(3)=Texture'DeusExCharacters.Skins.PaulDentonTex0'
     skins(4)=Texture'DeusExCharacters.Skins.PaulDentonTex1'
     skins(5)=Texture'DeusExCharacters.Skins.PaulDentonTex2'
     skins(6)=Texture'DeusExItems.Skins.GrayMaskTex'
     skins(7)=Texture'DeusExItems.Skins.BlackMaskTex'
     CollisionRadius=20.000000
     CollisionHeight=43.000000
//     CollisionHeight=47.500000
}