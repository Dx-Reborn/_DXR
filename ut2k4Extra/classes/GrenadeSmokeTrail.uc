
class GrenadeSmokeTrail extends xEmitter;

#exec TEXTURE IMPORT NAME=Smoke FILE=Textures\smoke.tga LODSET=1 NormalLOD=1 DXT=5 ALPHA=1 Mips=1

defaultproperties
{
	Skins(0)=Texture'Smoke'
	Style=STY_Alpha
	DrawScale=1.000000
	ScaleGlow=2.000000
    Physics=PHYS_Trailer

    mParticleType=PCL_Burst
    mDirDev=(X=0.200000,Y=0.200000,Z=0.200000)
	mPosDev=(X=0.00000,Y=0.00000,Z=0.00000)
	mDelayRange(0)=0.000000
	mDelayRange(1)=0.000000
	mLifeRange(0)=1.300000
	mLifeRange(1)=1.50000
	mSpeedRange(0)=2.000000
	mSpeedRange(1)=15.000000
	mSizeRange(0)=15.000000 
	mSizeRange(1)=25.000000
    mGrowthRate=10
	mMassRange(0)=-0.010000
	mMassRange(1)=-0.080000
	mRegenRange(0)=30.000000
	mRegenRange(1)=30.000000
	mRegen=True
	mRandOrient=True
	mRandTextures=True
	mAttenuate=True
	mStartParticles=1
	mMaxParticles=50
	mColorRange(0)=(R=35,G=45,B=45,A=255)
	mColorRange(1)=(R=50,G=65,B=65,A=255)
	mNumTileColumns=4
	mNumTileRows=4
}
