/*------------------------------------------------------------------
  Parent class for HUD and Menu color themes.

  To find a theme, i use int value. To get color from part of theme,
  i use static function, which returns required color. Current 
  color (number) is stored in DeusExGlobals object. DeusExGlobals
  stores that value in .ini file. See other classes in this package
  and DeusExGlobals.uc in DeusEx\ package for more information.
------------------------------------------------------------------*/
class hcObject extends Object abstract;