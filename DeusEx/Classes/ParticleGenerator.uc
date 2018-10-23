//=============================================================================
// ParticleGenerator.
// Может Wrapper написать?........
//=============================================================================
class ParticleGenerator extends Effects;

var() float frequency;			// what's the chance of spewing a particle every checkTime seconds
var() float riseRate;			// how fast do the particles rise
var() float ejectSpeed;			// how fast do the particles get ejected
var() texture particleTexture;	// replacement texture to use (default is smoke)
var() float particleLifeSpan;	// how long each particle lives
var() float particleDrawScale;	// draw scale for each particle
var() bool bParticlesUnlit;		// is each particle unlit?
var() bool bScale;				// scale each particle as it rises?
var() bool bFade;				// fade each particle as it rises?
var() bool bTriggered;			// start by triggering?
var() float spewTime;			// how long do I spew after I am triggered?
var() bool bRandomEject;		// random eject velocity vector
var() float checkTime;			// how often should I spit out particles?
var() bool bTranslucent;		// are these particles translucent?
var() bool bGravity;			// are these particles affected by gravity?
var() sound spawnSound;			// sound to play when spawned
var() bool bAmbientSound;		// play the ambient sound?
var() int numPerSpawn;			// number of particles to spawn per puff
//var() name attachTag;			// attach us to this actor
var() bool bInitiallyOn;		// if triggered, start on instead of off
var bool bSpewing;				// am I spewing?
var bool bFrozen;				// are we out of the player's sight?
var float time;
var bool bDying;				// don't spew, but continue to update
var() bool bModulated;			// are these particles modulated?

var vector pLoc;				// Location used for replication, ParticleIterator uses these now
var rotator pRot;				// Rotation used for replication, ParticleIterator uses these now


//var ParticleProxy proxy;





//
// Don't actually destroy the generator until after all of the
// particles have disappeared
//

defaultproperties
{
 		 drawType=DT_None

     Frequency=1.000000
     RiseRate=10.000000
     ejectSpeed=10.000000
     particleLifeSpan=4.000000
     particleDrawScale=0.100000
     bParticlesUnlit=True
     bScale=True
     bFade=True
     checkTime=0.100000
     bTranslucent=True
     numPerSpawn=1
     bInitiallyOn=True
     bSpewing=True
     bDirectional=True
     Texture=Texture'Engine.S_Inventory'
     CollisionRadius=80.000000
     CollisionHeight=80.000000
}
