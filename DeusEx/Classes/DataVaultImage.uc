//=============================================================================
// DataVaultImage
//=============================================================================
class DataVaultImage extends DeusExPickup
                                 abstract;

#exec obj load file=DXR_DataVaultImages

var Material  imageTexture;
var localized String            imageDescription; // Ќазвание картинки
var localized String            floorDescription; // Ќазначение непон€тно, не задействовано даже в модах.
var Int             sortKey;

struct sImageNote
{
  var() string TheNote; // ¬веденный текст, по нему обращаемс€ к заметке
  var int posX; // ѕозиционирование заметки. ќтносительно внутренних кооррдинат.
  var int posY; // Ќеобходимо будет не допускать ввод чисел до 2, поскольку в этом
};              // диапазоне оконна€ система UT2004 работает в другом режиме (!)
var() travel array<sImageNote> imgNotes; // заметки в массиве структур
var travel bool bPlayerViewedImage;

var Color           colNoteTextNormal;
var Color           colNoteTextFocus;
var Color           colNoteBackground;

/*-- ”правление массивом -----------------------------------------*/
function AddImgNote(string id, int newPosX, int newPosY)
{
 local int x;

   if (newPosX < 2.1)
       newPosX = 2.1;
   if (newPosY < 2.1)
       newPosY = 2.1;

   x = imgNotes.Length;
   imgNotes.Length = x + 1; // добавить 1 к длине массива
   imgNotes[x].TheNote = id; // присвоить данные к элементу массива
   imgNotes[x].posX = newPosX;
   imgNotes[x].posY = newPosY;
}

function DeleteImgNote(string id)
{
 local int x;

 for (x=0; x<imgNotes.Length; x++)
 { 
    if (imgNotes[x].TheNote ~= id)
        imgNotes.Remove(x,1);
 }
}
/*----------------------------------------------------------------*/



function string GetDescription()
{
  return imageDescription;
}

defaultproperties
{
     beltDescription="IMAGE"
     colNoteTextNormal=(R=200,G=200)
     colNoteTextFocus=(R=255,G=255)
     PickupMessage="Image added to DataVault"
     Icon=Texture'DeusExUI.Icons.BeltIconDataImage'
     Mesh=Mesh'DeusExItems.TestBox'
     PickupViewMesh=Mesh'DeusExItems.TestBox'
     FirstPersonViewMesh=Mesh'DeusExItems.TestBox'

     CollisionRadius=15.000000
     CollisionHeight=1.420000
     bCollideActors=False
     Mass=10.000000
     Buoyancy=11.000000
     bDisplayableinv=false
}
