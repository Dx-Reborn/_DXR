class BelchFlames extends xEmitter;

defaultproperties
{
    LifeSpan=10.0
	mStartParticles=0
	mNumTileColumns=4
	mNumTileRows=4
	mLifeRange(0)=0.150000
	mLifeRange(1)=0.200000
	mRegenRange(0)=300.000000
	mRegenRange(1)=300.000000   
	mSpeedRange(0)=0.000000
	mSpeedRange(1)=0.000000
	mMassRange(0)=-1.000000
	mMassRange(1)=-1.200000
	mSizeRange(0)=25.000000
    mSizeRange(1)=30.000000
	mGrowthRate=-16.000000
	mAttenKa=0.500000
	mPosDev=(X=3.000000,Y=3.000000,Z=3.000000)
	mAttenFunc=ATF_LerpInOut
	Texture=S_Emitter
//	Skins(0)=Texture'EmitterTextures.MultiFrame.LargeFlames'
	Style=STY_Translucent
	bDynamicLight=false
//    AmbientSound=Sound'GeneralAmbience.firefx11'
    SoundRadius=32
    SoundVolume=190
    SoundPitch=64
    Physics=PHYS_Trailer
}
