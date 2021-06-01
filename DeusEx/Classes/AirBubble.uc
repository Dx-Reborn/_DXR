//=============================================================================
// AirBubble.
//=============================================================================
class AirBubble extends Effects;

var() float RiseRate;
var vector OrigVel;

auto state Flying
{
    event Tick(float deltaTime)
    {
        Velocity.X = OrigVel.X + 8 - FRand() * 17;
        Velocity.Y = OrigVel.Y + 8 - FRand() * 17;
        Velocity.Z = RiseRate * (FRand() * 0.2 + 0.9);

        if (PhysicsVolume.Encompasses(self) == false)
        {
            bHidden = true;
            Destroy();
        }
    }
    event BeginState()
    {
        Super.BeginState();

        OrigVel = Velocity;
        SetDrawScale(DrawScale + FRand() * 0.1);
    }
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