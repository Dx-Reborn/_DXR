//=============================================================================
// Toilet.
//=============================================================================
class Toilet extends DeusExDecoration;

enum ESkinColor
{
    SC_Clean,
    SC_Filthy
};

var() ESkinColor SkinColor;
var bool bUsing;

event BeginPlay()
{
   Super.BeginPlay();

   switch (SkinColor)
   {
       case SC_Clean:  Skins[0] = Material(DynamicLoadObject("DeusExDeco.Skins.ToiletTex1", class'Material', false)); break;
       case SC_Filthy: Skins[0] = Material(DynamicLoadObject("DeusExDeco.Skins.ToiletTex2", class'Material', false)); break;
   }
}

event Timer()
{
    bUsing = False;
}

function Frob(actor Frobber, Inventory frobWith)
{
    Super.Frob(Frobber, frobWith);

    if (bUsing)
        return;

    SetTimer(9.0, False);
    bUsing = True;

    PlaySound(sound'FlushToilet',,,, 256);
    PlayAnim('Flush');
}



defaultproperties
{
     bInvincible=True
     ItemName="Toilet"
     bPushable=False
     Physics=PHYS_None
     mesh=mesh'DeusExDeco.Toilet'
     CollisionRadius=28.000000
     CollisionHeight=28.000000
     Mass=100.000000
     Buoyancy=5.000000
}
