//
// �������� ��������� ��������� ��� ��������
//
// ����������� �� �������� �����-������.
// ��� ������������� �����
// �������������� ������� �������� (�� ������ ��� ���������)
//


Class DeusExLadderVolume extends LadderVolume
                         hideCategories(Actor,Advanced,Brush,Collision,Display,Force,Karma,LightColor,Lighting,Movement,Trailer,VolumeFog);

var(LadderVolume) bool bIsWoodLadder; // ������� ������ ����� �� "����������". ������� ����������� ����� DeusExPlayer/Controller.



defaultproperties
{
    bAllowLadderStrafing=true
    bAutoPath=false
    bNoPhysicalLadder=false
    bIsWoodLadder=false
}