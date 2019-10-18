class ShadowBitmapMaterial extends BitmapMaterial
    native;

#exec Texture Import file=Textures\BlobTexture.tga Name=BlobTexture Mips=On UCLAMPMODE=CLAMP VCLAMPMODE=CLAMP // DXT=3

var const transient pointer TextureInterfaces[2];

var Actor   ShadowActor;
var vector  LightDirection;
var float   LightDistance,
            LightFOV;
var bool    Dirty,
            Invalid,
            bBlobShadow;
var float   CullDistance;
var byte    ShadowDarkness;

var BitmapMaterial  BlobShadow;

cpptext
{
    virtual void Destroy();

    virtual FBaseTexture* GetRenderInterface();
    virtual UBitmapMaterial* Get(FTime Time,UViewport* Viewport);
}

//
//  Default properties
//

defaultproperties
{
    Format=TEXF_RGBA8
    UClampMode=TC_Clamp
    VClampMode=TC_Clamp

    USize=128
    VSize=128
    UClamp=128
    VClamp=128

//    USize=1024
//    VSize=1024
//    UClamp=1024
//    VClamp=1024

/*  USize=2048
    VSize=2048
    UClamp=2048
    VClamp=2048*/
    UBits=7
    VBits=7
    Dirty=True
    Invalid=False
    BlobShadow=BlobTexture
    ShadowDarkness=255
}