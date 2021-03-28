//=============================================================================
// Liquor40oz.
//=============================================================================
class Liquor40oz extends DeusExPickup;

enum ESkinColor
{
    SC_Super45,
    SC_Bottle2,
    SC_Bottle3,
    SC_Bottle4
};

var() ESkinColor SkinColor;

event BeginPlay()
{
   Super.BeginPlay();

   switch (SkinColor)
   {
       case SC_Super45: Skins[0] = Material(DynamicLoadObject("DeusExItems.Skins.Liquor40ozTex1", class'Material', false)); break;
       case SC_Bottle2: Skins[0] = Material(DynamicLoadObject("DeusExItems.Skins.Liquor40ozTex2", class'Material', false)); break;
       case SC_Bottle3: Skins[0] = Material(DynamicLoadObject("DeusExItems.Skins.Liquor40ozTex3", class'Material', false)); break;
       case SC_Bottle4: Skins[0] = Material(DynamicLoadObject("DeusExItems.Skins.Liquor40ozTex4", class'Material', false)); break;
   }
}

state Activated
{
    function Activate()
    {
        // can't turn it off
    }

    function BeginState()
    {
        local DeusExPlayer player;
        
        Super.BeginState();

        player = DeusExPlayer(Owner);
        if (player != None)
        {
            player.HealPlayer(2, False);
            player.drugEffectTimer += 10.0;
        }

        UseOnce();
    }
Begin:
}

defaultproperties
{
    bBreakable=True
    maxCopies=10
    bCanHaveMultipleCopies=True
    bActivatable=True

    PlayerViewOffset=(X=30.00,Y=0.00,Z=-12.00)
    Description="'COLD SWEAT forty ounce malt liquor. Never let 'em see your COLD SWEAT.'"
    ItemName="Forty"
    beltDescription="FORTY"
    Icon=Texture'DeusExUI.Icons.BeltIconBeerBottle'
    largeIcon=Texture'DeusExUI.Icons.LargeIconBeerBottle'
    largeIconWidth=14
    largeIconHeight=47

    LandSound=Sound'DeusExSounds.Generic.GlassHit1'

    Mesh=Mesh'DeusExItems.Liquor40oz'
    PickupViewMesh=Mesh'DeusExItems.Liquor40oz'
    FirstPersonViewMesh=Mesh'DeusExItems.Liquor40oz'

    CollisionRadius=3.000000
    CollisionHeight=9.140000
    Mass=10.000000
    Buoyancy=8.000000
}
