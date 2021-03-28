//=============================================================================
// Toilet2.
//=============================================================================
class Toilet2a extends DeusExDecoration;

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
       case SC_Clean:  Skins[0] = Material(DynamicLoadObject("DeusExDeco.Skins.Toilet2Tex1", class'Material', false)); break;
       case SC_Filthy: Skins[0] = Material(DynamicLoadObject("DeusExDeco.Skins.Toilet2Tex2", class'Material', false)); break;
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

   SetTimer(2.0, False);
   bUsing = true;

   PlaySound(sound'FlushUrinal',,,, 256);
   PlayAnim('Flush');
}


defaultproperties
{
     bInvincible=True
     ItemName="Urinal"
     bPushable=False
     Physics=PHYS_None
     mesh=mesh'DeusExDeco.Toilet2'
     CollisionRadius=18.000000
     CollisionHeight=31.000000
     Mass=100.000000
     Buoyancy=5.000000
}
