class xRain_a extends xWeatherEffect;

// ѕримечание: ≈сли добавить Volume, и присвоить ему Tag == NoRain, то частиц этого дожд€ в нем не будет.
// Note: To exclude particles from particular area, add a volume and use 'NoRain' as tag of that volume.

defaultproperties
{
    WeatherType=WT_Rain
    numParticles=5000
    maxPclEyeDist=2000.000000
    numCols=2.000000
    numRows=2.000000
    spawnVecU=(X=280.000000)
    spawnVecV=(Z=280.000000)
    spawnVel=(X=0.050000,Y=0.100000)
    Position=(X=(Min=-1500.000000,Max=1500.000000),Y=(Min=-1500.000000,Max=1500.000000),Z=(Min=-500.000000,Max=750.000000))
    Speed=(Min=900.000000,Max=1000.000000)
    Life=(Min=0.300000,Max=0.500000)
    Size=(Min=0.800000,Max=1.100000)
    Tag=NoRain
    Skins(0)=FinalBlend'EmitterTextures.MultiFrame.RainFB'
    Style=STY_Additive
    SoundVolume=76
}