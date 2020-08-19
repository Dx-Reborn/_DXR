class DXRLight extends Light
                       abstract;

#exec Texture Import File=Models\LightBulbSprite.tga Name=LightBulbSprite Mips=Off MASKED=true ALPHA=true DXT=5

defaultproperties
{
    Texture=LightBulbSprite
}