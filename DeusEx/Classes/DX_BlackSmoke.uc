/*
  Черный дым
*/

class DX_BlackSmoke extends GrenadeSmokeTrail;

auto state Ticking
{
    event Tick( float dt )
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
    lifespan=30
}