//=-=-=-=-=-=-=
//  расивый и €ркий огонь!
class DX_FlameA extends belchflames;

#exec OBJ LOAD FILE=effects_EX
#exec OBJ LOAD FILE=EmitterTextures

auto state Ticking
{
	simulated function Tick( float dt )
	{
		if( LifeSpan < 2.0 )
		{
			mRegenRange[0] *= LifeSpan * 0.5;
			mRegenRange[1] = mRegenRange[0];
		}
	}
}


defaultproperties
{
			Skins(0)			 = Texture'EmitterTextures.MultiFrame.LargeFlames-grey'
			mLifeColorMap  = Texture'EmitterTextures.LifeMaps.rainbow1'
			mNumTileColumns= 4
			mNumTileRows   = 4
			mLifeRange(0)	 = 0.5
			mLifeRange(1)	 = 0.3
			ambientsound   = none
			mRandOrient    = true
			mSpawningType  = ST_Explode
			mAttenFunc     = ATF_None
			mAttenuate		 = false
			mDistanceAtten = false
			mMaxParticles  = 45
			lifespan			 = 30
}
