//
// Изменены некоторые параметры для удобства
//
// Перемещение по лестнице влево-вправо.
// Нет автогенерации путей
// Предполагается наличие лестницы (из брашей или статикмеш)
//


Class DeusExLadderVolume extends LadderVolume
                         hideCategories(Actor,Advanced,Brush,Collision,Display,Force,Karma,LightColor,Lighting,Movement,Trailer,VolumeFog);

var(LadderVolume) bool bIsWoodLadder; // Признак замены звука на "деревянный". Условие учитывается через DeusExPlayer/Controller.



defaultproperties
{
    bAllowLadderStrafing=true
    bAutoPath=false
    bNoPhysicalLadder=false
    bIsWoodLadder=false
}