/*
   A container for toolbelt items.
*/
class HUDObjectBelt extends GUIPanel;

const AMOUNT_OF_TOOLBELT_SLOTS = 10;

var GUIPanel winSlots;                // Window containing slots
var HUDObjectSlot objects[AMOUNT_OF_TOOLBELT_SLOTS];

var int KeyRingSlot;
var bool bInteractive;

