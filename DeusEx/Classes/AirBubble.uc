//=============================================================================
// AirBubble.
//=============================================================================
class AirBubble extends Effects;

var() float RiseRate;
var vector OrigVel;

event Tick(float deltaTime)
{
   local WaterVolume wat;

   Velocity.X = OrigVel.X + 8 - FRand() * 17;
   Velocity.Y = OrigVel.Y + 8 - FRand() * 17;
   Velocity.Z = RiseRate * (FRand() * 0.2 + 0.9);

   foreach RadiusActors(class'WaterVolume', wat, 40000) // DXR: Что это такое?
        if (!wat.Encompasses(self))
        {
            bHidden = true;
            Destroy();
        }
}

event BeginPlay()
{
    OrigVel = Velocity;
    SetDrawScale(FRand() * 0.1);
    LifeSpan = 1 + 2 * FRand();
}




defaultproperties
{
     RiseRate=50.000000
     Physics=PHYS_Projectile
     LifeSpan=10.000000
     DrawType=DT_Sprite
     Style=STY_Translucent
     Texture=Texture'DeusExItems.Skins.FlatFXTex45'
     DrawScale=0.050000
}