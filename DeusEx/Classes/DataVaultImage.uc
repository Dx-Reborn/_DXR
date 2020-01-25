//=============================================================================
// DataVaultImage
//=============================================================================
class DataVaultImage extends DeusExPickup
                                 abstract;

#exec obj load file=DXR_DataVaultImages

var Material  imageTexture;
var localized String            imageDescription; // �������� ��������
var localized String            floorDescription; // ���������� ���������, �� ������������� ���� � �����.
var Int             sortKey;

struct sImageNote
{
  var() string TheNote; // ��������� �����, �� ���� ���������� � �������
  var int posX; // ���������������� �������. ������������ ���������� ����������.
  var int posY; // ���������� ����� �� ��������� ���� ����� �� 2, ��������� � ����
};              // ��������� ������� ������� UT2004 �������� � ������ ������ (!)
var() travel array<sImageNote> imgNotes; // ������� � ������� ��������
var travel bool bPlayerViewedImage;

var Color           colNoteTextNormal;
var Color           colNoteTextFocus;
var Color           colNoteBackground;

/*-- ���������� �������� -----------------------------------------*/
function AddImgNote(string id, int newPosX, int newPosY)
{
 local int x;

   if (newPosX < 2.1)
       newPosX = 2.1;
   if (newPosY < 2.1)
       newPosY = 2.1;

   x = imgNotes.Length;
   imgNotes.Length = x + 1; // �������� 1 � ����� �������
   imgNotes[x].TheNote = id; // ��������� ������ � �������� �������
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
