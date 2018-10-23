//=============================================================================
// AnimatedSprite from GMDX mod
//=============================================================================
class AnimatedSprite extends Effects
	abstract;

var float animSpeed;
var int numFrames;
var int nextFrame;
var texture frames[16];
var float time, totalTime, duration;

simulated function Tick(float deltaTime)
{
	time += deltaTime;
	totalTime += deltaTime;

	SetDrawScale(0.9 + (6.0 * totalTime / duration)); //CyberP: 0.9 was 0.5 & 6.0 was 3.0
	ScaleGlow = (duration - totalTime) / duration;

	if (time >= animSpeed)
	{
		Texture = frames[nextFrame++];
		if (nextFrame >= numFrames)
			Destroy();

		time -= animSpeed;
	}
}

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	// calculate length of animation
	duration = animSpeed * numFrames;
}


defaultproperties
{
     animSpeed=0.075000
     nextFrame=1
     Style=STY_Translucent
     bUnlit=True
}