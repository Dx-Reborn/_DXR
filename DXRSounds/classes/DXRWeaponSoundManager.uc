/*---------------------------------------------------------------
   DXRWeaponSoundManager

   This is collection of predefined weapon sounds.
   You can change them "on the fly" in game settings.

   Presets are stored as objects in defprops block.
   You can add new groups o remove them.
   You can mix sounds from existing groups, just add new and 
   define sounds.

   You must create new .uax package with custom sounds.
---------------------------------------------------------------*/

class DXRWeaponSoundManager extends DXRSoundBase 
                                 DependsOn(Actor);


// All sound sets are stored in this array, in defprops block.
var() array <WeaponSoundSet> Collection;


static function string GetSoundsSetName(int Index)
{return default.Collection[Index].CollectionName;}

static function array<string> GetAllWeaponSoundSets()
{
  local array<string> Sets;
  local int x;

    for (x = 0; x < default.Collection.Length; x++)
        Sets[Sets.Length] = default.Collection[x].CollectionName;

  return Sets;
}

/*---------------------------------------------------------------------------*/
static function Sound GetRifleSelect(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].RifleSelect,class'Sound',true));
}
static function Sound GetRifleFire(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].RifleFire,class'Sound',true));
}
static function Sound GetRifleReloadBegin(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].RifleReloadBegin,class'Sound',true));
}
static function Sound GetRifleReloadEnd(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].RifleReloadEnd,class'Sound',true));
}
static function Sound GetRifleDown(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].RifleDown,class'Sound',true));
}

// Assault Gun
static function Sound GetAssaultGunSelect(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].AssaultGunSelect,class'Sound',true));
}
static function Sound GetAssaultGunFire(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].AssaultGunFire,class'Sound',true));
}
static function Sound GetAssaultGun20mmFire(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].AssaultGun20mmFire,class'Sound',true));
}
static function Sound GetAssaultGunReloadBegin(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].AssaultGunReloadBegin,class'Sound',true));
}
static function Sound GetAssaultGunReloadEnd(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].AssaultGunReloadEnd,class'Sound',true));
}
static function Sound GetAssaultGunDown(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].AssaultGunDown,class'Sound',true));
}

// Автоматический дробовик
static function Sound GetAssaultShotgunSelect(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].AssaultShotgunSelect,class'Sound',true));
}
static function Sound GetAssaultShotgunFire(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].AssaultShotgunFire,class'Sound',true));
}
static function Sound GetAssaultShotgunReloadBegin(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].AssaultShotgunReloadBegin,class'Sound',true));
}
static function Sound GetAssaultShotgunReloadEnd(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].AssaultShotgunReloadEnd,class'Sound',true));
}
static function Sound GetAssaultShotgunDown(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].AssaultShotgunDown,class'Sound',true));
}

// Обрез дробовика
static function Sound GetSawedOffShotgunSelect(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].SawedOffShotgunSelect,class'Sound',true));
}
static function Sound GetSawedOffShotgunFire(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].SawedOffShotgunFire,class'Sound',true));
}
static function Sound GetSawedOffShotgunCock(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].SawedOffShotgunCock,class'Sound',true));
}
static function Sound GetSawedOffShotgunReloadBegin(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].SawedOffShotgunReloadBegin,class'Sound',true));
}
static function Sound GetSawedOffShotgunReloadEnd(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].SawedOffShotgunReloadEnd,class'Sound',true));
}
static function Sound GetSawedOffShotgunDown(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].SawedOffShotgunDown,class'Sound',true));
}

// Перцовка
static function Sound GetPepperGunSelect(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].PepperGunSelect,class'Sound',true));
}
static function Sound GetPepperGunFire(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].PepperGunFire,class'Sound',true));
}
static function Sound GetPepperGunReloadBegin(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].PepperGunReloadBegin,class'Sound',true));
}
static function Sound GetPepperGunReloadEnd(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].PepperGunReloadEnd,class'Sound',true));
}
static function Sound GetPepperGunDown(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].PepperGunDown,class'Sound',true));
}

// Глок
static function Sound GetPistolSelect(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].PistolSelect,class'Sound',true));
}
static function Sound GetPistolFire(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].PistolFire,class'Sound',true));
}
static function Sound GetPistolReloadBegin(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].PistolReloadBegin,class'Sound',true));
}
static function Sound GetPistolReloadEnd(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].PistolReloadEnd,class'Sound',true));
}
static function Sound GetPistolDown(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].PistolDown,class'Sound',true));
}

// Пистолет с глушителем
static function Sound GetStealthPistolSelect(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].StealthPistolSelect,class'Sound',true));
}
static function Sound GetStealthPistolFire(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].StealthPistolFire,class'Sound',true));
}
static function Sound GetStealthPistolReloadBegin(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].StealthPistolReloadBegin,class'Sound',true));
}
static function Sound GetStealthPistolReloadEnd(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].StealthPistolReloadEnd,class'Sound',true));
}
static function Sound GetStealthPistolDown(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].StealthPistolDown,class'Sound',true));
}

// Плазма
static function Sound GetPlasmaRifleSelect(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].PlasmaRifleSelect,class'Sound',true));
}
static function Sound GetPlasmaRifleFire(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].PlasmaRifleFire,class'Sound',true));
}
static function Sound GetPlasmaRifleReloadBegin(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].PlasmaRifleReloadBegin,class'Sound',true));
}
static function Sound GetPlasmaRifleReloadEnd(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].PlasmaRifleReloadEnd,class'Sound',true));
}
static function Sound GetPlasmaRifleDown(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].PlasmaRifleDown,class'Sound',true));
}

// Шокер
static function Sound GetProdSelect(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].ProdSelect,class'Sound',true));
}
static function Sound GetProdFire(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].ProdFire,class'Sound',true));
}
static function Sound GetProdReloadBegin(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].ProdReloadBegin,class'Sound',true));
}
static function Sound GetProdReloadEnd(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].ProdReloadEnd,class'Sound',true));
}
static function Sound GetProdDown(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].ProdDown,class'Sound',true));
}

// Ракетница
static function Sound GetGEPGunSelect(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].GEPGunSelect,class'Sound',true));
}
static function Sound GetGEPGunFire(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].GEPGunFire,class'Sound',true));
}
static function Sound GetGEPGunFireWP(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].GEPGunFireWP,class'Sound',true));
}
static function Sound GetGEPGunReloadBegin(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].GEPGunReloadBegin,class'Sound',true));
}
static function Sound GetGEPGunReloadEnd(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].GEPGunReloadEnd,class'Sound',true));
}
static function Sound GetGEPGunDown(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].GEPGunDown,class'Sound',true));
}

// Арбалет
static function Sound GetMiniCrossbowSelect(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].MiniCrossbowSelect,class'Sound',true));
}
static function Sound GetMiniCrossbowFire(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].MiniCrossbowFire,class'Sound',true));
}
static function Sound GetMiniCrossbowReloadBegin(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].MiniCrossbowReloadBegin,class'Sound',true));
}
static function Sound GetMiniCrossbowReloadEnd(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].MiniCrossbowReloadEnd,class'Sound',true));
}
static function Sound GetMiniCrossbowDown(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].MiniCrossbowDown,class'Sound',true));
}

// Огнемет
static function Sound GetFlamethrowerSelect(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].FlamethrowerSelect,class'Sound',true));
}
static function Sound GetFlamethrowerFire(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].FlamethrowerFire,class'Sound',true));
}
static function Sound GetFlamethrowerFireLoop(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].FlamethrowerFireLoop,class'Sound',true));
}
static function Sound GetFlamethrowerReloadBegin(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].FlamethrowerReloadBegin,class'Sound',true));
}
static function Sound GetFlamethrowerReloadEnd(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].FlamethrowerReloadEnd,class'Sound',true));
}
static function Sound GetFlamethrowerDown(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].FlamethrowerDown,class'Sound',true));
}


// Без перезарядки //
// Меч
static function Sound GetSwordSelect(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].SwordSelect,class'Sound',true));
}
static function Sound GetSwordFire(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].SwordFire,class'Sound',true));
}
static function Sound GetSwordDown(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].SwordDown,class'Sound',true));
}
static function Sound GetSwordHitFlesh(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].SwordHitFlesh,class'Sound',true));
}
static function Sound GetSwordHitSoft(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].SwordHitSoft,class'Sound',true));
}
static function Sound GetSwordHitHard(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].SwordHitHard,class'Sound',true));
}


// Дубинка
static function Sound GetBatonSelect(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].BatonSelect,class'Sound',true));
}
static function Sound GetBatonFire(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].BatonFire,class'Sound',true));
}
static function Sound GetBatonDown(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].BatonDown,class'Sound',true));
}
static function Sound GetBatonHitFlesh(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].BatonHitFlesh,class'Sound',true));
}
static function Sound GetBatonHitSoft(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].BatonHitSoft,class'Sound',true));
}
static function Sound GetBatonHitHard(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].BatonHitHard,class'Sound',true));
}


// Нож
static function Sound GetCombatKnifeSelect(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].CombatKnifeSelect,class'Sound',true));
}
static function Sound GetCombatKnifeFire(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].CombatKnifeFire,class'Sound',true));
}
static function Sound GetCombatKnifeDown(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].CombatKnifeDown,class'Sound',true));
}
static function Sound GetCombatKnifeHitHard(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].CombatKnifeHitHard,class'Sound',true));
}
static function Sound GetCombatKnifeHitFlesh(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].CombatKnifeHitFlesh,class'Sound',true));
}
static function Sound GetCombatKnifeHitSoft(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].CombatKnifeHitSoft,class'Sound',true));
}


// Ломик
static function Sound GetCrowbarSelect(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].CrowbarSelect,class'Sound',true));
}
static function Sound GetCrowbarFire(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].CrowbarFire,class'Sound',true));
}
static function Sound GetCrowbarDown(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].CrowbarDown,class'Sound',true));
}
static function Sound GetCrowbarHitFlesh(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].CrowbarHitFlesh,class'Sound',true));
}
static function Sound GetCrowbarHitHard(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].CrowbarHitHard,class'Sound',true));
}
static function Sound GetCrowbarHitSoft(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].CrowbarHitSoft,class'Sound',true));
}


// Зуб Дракона
static function Sound GetNanoSwordSelect(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].NanoSwordSelect,class'Sound',true));
}
static function Sound GetNanoSwordFire(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].NanoSwordFire,class'Sound',true));
}
static function Sound GetNanoSwordDown(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].NanoSwordDown,class'Sound',true));
}
static function Sound GetNanoSwordHitHard(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].NanoSwordHitHard,class'Sound',true));
}
static function Sound GetNanoSwordHitFlesh(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].NanoSwordHitFlesh,class'Sound',true));
}
static function Sound GetNanoSwordHitSoft(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].NanoSwordHitSoft,class'Sound',true));
}


// PS20
static function Sound GetHideAGunSelect(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].HideAGunSelect,class'Sound',true));
}
static function Sound GetHideAGunFire(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].HideAGunFire,class'Sound',true));
}
static function Sound GetHideAGunDown(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].HideAGunDown,class'Sound',true));
}

// LAW
static function Sound GetLAWSelect(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].LAWSelect,class'Sound',true));
}
static function Sound GetLAWFire(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].LAWFire,class'Sound',true));
}
static function Sound GetLAWDown(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].LAWDown,class'Sound',true));
}

// Throwing knives
static function Sound GetShurikenSelect(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].ShurikenSelect,class'Sound',true));
}
static function Sound GetShurikenFire(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].ShurikenFire,class'Sound',true));
}
static function Sound GetShurikenDown(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].ShurikenDown,class'Sound',true));
}


/*--------------------------------------------------------------------------------------------*/
// EMP Grenade
static function Sound GetEMPGrenadeSelect(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].EMPGrenadeSelect,class'Sound',true));
}
static function Sound GetEMPGrenadeFire(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].EMPGrenadeFire,class'Sound',true));
}
static function Sound GetEMPGrenadeDown(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].EMPGrenadeDown,class'Sound',true));
}
static function Sound GetEMPGrenadeExplosion(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].EMPGrenadeExplosion,class'Sound',true));
}

// Gas Grenade
static function Sound GetGasGrenadeSelect(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].GasGrenadeSelect,class'Sound',true));
}
static function Sound GetGasGrenadeFire(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].GasGrenadeFire,class'Sound',true));
}
static function Sound GetGasGrenadeDown(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].GasGrenadeDown,class'Sound',true));
}
static function Sound GetGasGrenadeExplosion(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].GasGrenadeExplosion,class'Sound',true));
}

// NanoVirus Grenade
static function Sound GetNanoVirusGrenadeSelect(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].NanoVirusGrenadeSelect,class'Sound',true));
}
static function Sound GetNanoVirusGrenadeFire(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].NanoVirusGrenadeFire,class'Sound',true));
}
static function Sound GetNanoVirusGrenadeDown(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].NanoVirusGrenadeDown,class'Sound',true));
}
static function Sound GetNanoVirusGrenadeExplosion(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].NanoVirusGrenadeExplosion,class'Sound',true));
}

// LAM
static function Sound GetLAMSelect(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].LAMSelect,class'Sound',true));
}
static function Sound GetLAMFire(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].LAMFire,class'Sound',true));
}
static function Sound GetLAMDown(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].LAMDown,class'Sound',true));
}
static function Sound GetLAMGrenadeExplosion(int Index)
{
   return Sound(DynamicLoadObject(default.Collection[Index].LAMGrenadeExplosion,class'Sound',true));
}



defaultproperties
{
   Begin Object class=DXRSounds.WeaponSoundSet Name=col00
      CollectionName="DESO by Flam"
     // С перезарядкой //
// Снайперская винтовка
      RifleSelect="DESO_Flam.Weapons.RifleSelect"
      RifleFire="DESO_Flam.Weapons.RifleFire"
      RifleReloadBegin="DESO_Flam.Weapons.RifleReload"
      RifleReloadEnd="DESO_Flam.Weapons.RifleReloadEnd"
      RifleDown="DESO_Flam.Weapons.RifleDown"
// Assault Gun
      AssaultGunSelect="DESO_Flam.Weapons.AssaultGunSelect"
      AssaultGunFire="DESO_Flam.Weapons.AssaultGunFire"
      AssaultGun20mmFire="DeusExSounds.Weapons.AssaultGunFire20mm"
      AssaultGunReloadBegin="DESO_Flam.Weapons.AssaultGunReload"
      AssaultGunReloadEnd="DESO_Flam.Weapons.AssaultGunReloadEnd"
      AssaultGunDown="DESO_Flam.Weapons.AssaultGunDown"
// Автоматический дробовик
      AssaultShotgunSelect="DESO_Flam.Weapons.AssaultShotgunSelect"
      AssaultShotgunFire="DESO_Flam.Weapons.AssaultShotgunFire"
      AssaultShotgunReloadBegin="DESO_Flam.Weapons.AssaultShotgunReload"
      AssaultShotgunReloadEnd="DESO_Flam.Weapons.AssaultShotgunReloadEnd"
      AssaultShotgunDown="DESO_Flam.Weapons.AssaultShotgunDown"
// Обрез дробовика
      SawedOffShotgunSelect="DESO_Flam.Weapons.SawedOffShotgunSelect"
      SawedOffShotgunFire="DESO_Flam.Weapons.SawedOffShotgunFire"
      SawedOffShotgunCock="DESO_Flam.Weapons.SawedOffShotgunSelect"
      SawedOffShotgunReloadBegin="DESO_Flam.Weapons.SawedOffShotgunReload"
      SawedOffShotgunReloadEnd="DESO_Flam.Weapons.SawedOffShotgunReloadEnd"
      SawedOffShotgunDown="DESO_Flam.Weapons.SawedOffShotgunDown"
// Перцовка
      PepperGunSelect="DESO_Flam.Weapons.PepperGunSelect"
      PepperGunFire="DESO_Flam.Weapons.PepperGunFire"
      PepperGunReloadBegin="DESO_Flam.Weapons.PepperGunReload"
      PepperGunReloadEnd="DESO_Flam.Weapons.PepperGunReloadEnd"
      PepperGunDown="DESO_Flam.Weapons.PepperGunDown"
// Глок
      PistolSelect="DESO_Flam.Weapons.PistolSelect"
      PistolFire="DESO_Flam.Weapons.PistolFire"
      PistolReloadBegin="DESO_Flam.Weapons.PistolReload"
      PistolReloadEnd="DESO_Flam.Weapons.PistolReloadEnd"
      PistolDown="DESO_Flam.Weapons.PistolDown"
// Пистолет с глушителем
      StealthPistolSelect="DESO_Flam.Weapons.StealthPistolSelect"
      StealthPistolFire="DESO_Flam.Weapons.StealthPistolFire"
      StealthPistolReloadBegin="DESO_Flam.Weapons.StealthPistolReload"
      StealthPistolReloadEnd="DESO_Flam.Weapons.StealthPistolReload"
      StealthPistolDown="DESO_Flam.Weapons.StealthPistolDown"
// Плазма
      PlasmaRifleSelect="DESO_Flam.Weapons.PlasmaRifleSelect"
      PlasmaRifleFire="DESO_Flam.Weapons.PlasmaRifleFire"
      PlasmaRifleReloadBegin="DESO_Flam.Weapons.PlasmaRifleReload"
      PlasmaRifleReloadEnd="DESO_Flam.Weapons.PlasmaRifleReloadEnd"
      PlasmaRifleDown="DESO_Flam.Weapons.PlasmaRifleDown"
// Шокер
      ProdSelect="DESO_Flam.Weapons.ProdSelect"
      ProdFire="DESO_Flam.Weapons.ProdFire"
      ProdReloadBegin="DESO_Flam.Weapons.ProdReload"
      ProdReloadEnd="DESO_Flam.Weapons.ProdReloadEnd"
      ProdDown="DESO_Flam.Weapons.ProdDown"
// Ракетница
      GEPGunSelect="DESO_Flam.Weapons.GEPGunSelect"
      GEPGunFire="DESO_Flam.Weapons.GEPGunFire"
      GEPGunFireWP="DESO_Flam.Weapons.GEPGunFireWP"
      GEPGunReloadBegin="DESO_Flam.Weapons.GEPGunReload"
      GEPGunReloadEnd="DESO_Flam.Weapons.GEPGunReloadEnd"
      GEPGunDown="DESO_Flam.Weapons.GEPGunDown"
// Арбалет
      MiniCrossbowSelect="DESO_Flam.Weapons.MiniCrossbowSelect"
      MiniCrossbowFire="DESO_Flam.Weapons.MiniCrossbowFire"
      MiniCrossbowReloadBegin="DESO_Flam.Weapons.MiniCrossbowReload"
      MiniCrossbowReloadEnd="DESO_Flam.Weapons.MiniCrossbowReloadEnd"
      MiniCrossbowDown="DESO_Flam.Weapons.MiniCrossbowDown"
// Огнемет
      FlamethrowerSelect="DESO_Flam.Weapons.FlamethrowerSelect"
      FlamethrowerFire="DESO_Flam.Weapons.FlamethrowerFire"
      FlamethrowerFireLoop="DESO_Flam.Weapons.FlamethrowerFireLoop"
      FlamethrowerReloadBegin="DESO_Flam.Weapons.FlamethrowerReload"
      FlamethrowerReloadEnd="DESO_Flam.Weapons.FlamethrowerReloadEnd"
      FlamethrowerDown="DESO_Flam.Weapons.FlamethrowerDown"

// Без перезарядки //
// Меч
      SwordSelect="DESO_Flam.Weapons.SwordSelect"
      SwordFire="DESO_Flam.Weapons.SwordFire"
      SwordHitFlesh="DESO_Flam.Weapons.SwordHitFlesh"
      SwordHitSoft="DESO_Flam.Weapons.SwordHitSoft"
      SwordHitHard="DESO_Flam.Weapons.SwordHitHard"
      SwordDown="DESO_Flam.Weapons.SwordDown"
// Дубинка
      BatonSelect="DESO_Flam.Weapons.BatonSelect"
      BatonFire="DESO_Flam.Weapons.BatonFire"
      BatonHitFlesh="DESO_Flam.Weapons.BatonHitFlesh"
      BatonHitSoft="DESO_Flam.Weapons.BatonHitSoft"
      BatonHitHard="DESO_Flam.Weapons.BatonHitHard"
      BatonDown="DESO_Flam.Weapons.BatonDown"
// Нож
      CombatKnifeSelect="DESO_Flam.Weapons.CombatKnifeSelect"
      CombatKnifeFire="DESO_Flam.Weapons.CombatKnifeFire"
      CombatKnifeHitHard="DESO_Flam.Weapons.CombatKnifeHitHard"
      CombatKnifeHitFlesh="DESO_Flam.Weapons.CombatKnifeHitFlesh"
      CombatKnifeHitSoft="DESO_Flam.Weapons.CombatKnifeHitSoft"
      CombatKnifeDown="DESO_Flam.Weapons.CombatKnifeDown"
// Ломик
      CrowbarSelect="DESO_Flam.Weapons.CrowbarSelect"
      CrowbarFire="DESO_Flam.Weapons.CrowbarFire"
      CrowbarHitFlesh="DESO_Flam.Weapons.CrowbarHitFlesh"
      CrowbarHitHard="DESO_Flam.Weapons.CrowbarHitHard"
      CrowbarHitSoft="DESO_Flam.Weapons.CrowbarHitSoft"
      CrowbarDown="DESO_Flam.Weapons.CrowbarDown"
// Зуб Дракона
      NanoSwordSelect="DESO_Flam.Weapons.NanoSwordSelect"
      NanoSwordFire="DESO_Flam.Weapons.NanoSwordFire"
      NanoSwordHitHard="DESO_Flam.Weapons.NanoSwordHitHard"
      NanoSwordHitFlesh="DESO_Flam.Weapons.NanoSwordHitFlesh"
      NanoSwordHitSoft="DESO_Flam.Weapons.NanoSwordHitSoft"
      NanoSwordDown="DESO_Flam.Weapons.NanoSwordDown"
// PS20
      HideAGunSelect="DESO_Flam.Weapons.HideAGunSelect"
      HideAGunFire="DESO_Flam.Weapons.HideAGunFire"
      HideAGunDown="DESO_Flam.Weapons.HideAGunDown"
// LAW
      LAWSelect="DESO_Flam.Weapons.LAWSelect"
      LAWFire="DESO_Flam.Weapons.LAWFire"
      LAWDown="DESO_Flam.Weapons.LAWDown"
// Throwing knives
      ShurikenSelect="DESO_Flam.Weapons.ShurikenSelect"
      ShurikenFire="DESO_Flam.Weapons.ShurikenFire"
      ShurikenDown="DESO_Flam.Weapons.ShurikenDown"


// EMP Grenade
      EMPGrenadeSelect="DESO_Flam.Weapons.EMPGrenadeSelect"
      EMPGrenadeFire="DESO_Flam.Weapons.EMPGrenadeFire"
      EMPGrenadeDown="DESO_Flam.Weapons.EMPGrenadeDown"
      EMPGrenadeExplosion="DESO_Flam.Weapons.EMPGrenadeExplode"

// Gas Grenade
      GasGrenadeSelect="DESO_Flam.Weapons.GasGrenadeSelect"
      GasGrenadeFire="DESO_Flam.Weapons.GasGrenadeFire"
      GasGrenadeDown="DESO_Flam.Weapons.GasGrenadeDown"
      GasGrenadeExplosion="DESO_Flam.Weapons.GasGrenadeExplode"

// NanoVirus Grenade
      NanoVirusGrenadeSelect="DESO_Flam.Weapons.NanoVirusGrenadeSelect"
      NanoVirusGrenadeFire="DESO_Flam.Weapons.NanoVirusGrenadeFire"
      NanoVirusGrenadeDown="DESO_Flam.Weapons.NanoVirusGrenadeDown"
      NanoVirusGrenadeExplosion="DESO_Flam.Weapons.NanoVirusGrenadeExplode"

// LAM Grenade
      LAMSelect="DESO_Flam.Weapons.LAMSelect"
      LAMFire="DESO_Flam.Weapons.LAMFire"
      LAMDown="DESO_Flam.Weapons.LAMDown"
      LAMGrenadeExplosion="DESO_Flam.Weapons.LAMExplode"

   End object
   Collection(0)=col00
}

