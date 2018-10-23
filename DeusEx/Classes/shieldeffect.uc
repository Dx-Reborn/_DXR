//=============================================================================
// ShieldEffect.
//=============================================================================
class ShieldEffect extends Effects;

// Player shield effect
var float TimeSinceStrong;
var DeusExPlayer AttachedPlayer;

/*simulated function Tick(float deltaTime)
{
   if (AttachedPlayer == None)
   {
      Destroy();
      return;
   }

   if (AttachedPlayer.ShieldStatus == SS_Strong)
      TimeSinceStrong = 1.0;
   else
      TimeSinceStrong = TimeSinceStrong - deltaTime;

   if (TimeSinceStrong < 0)
      TimeSinceStrong = 0;

   ScaleGlow = 0.5 * (TimeSinceStrong / 1.0);

   SetLocation(AttachedPlayer.Location);
}*/


defaultproperties
{
     Style=STY_Translucent
     Mesh=Mesh'DeusExItems.EllipseEffect'
     bUnlit=True
}
