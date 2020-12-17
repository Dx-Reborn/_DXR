/*
   Base class for context menus, used in DXR.
*/
class DXRContextMenu extends GUIContextMenu;


/* Copy-paste brom base class.
var localized array<string>   ContextItems;                   // List of menu items
var int             ItemIndex;              // Selected item
var string          SelectionStyleName;     // Name of the Style to use
var GUIStyles       SelectionStyle;         // Holds the style
var int             ItemHeight;

delegate bool OnOpen(GUIContextMenu Sender);  // Return false to prevent menu from appearing
delegate bool OnClose(GUIContextMenu Sender);      // Return false to prevent menu from closing
delegate OnSelect(GUIContextMenu Sender, int ClickIndex);
*/

defaultproperties
{
   ContextItems(0)="Test item"
   StyleName="MouseOver"
   SelectionStyle"STY_DXR_ListSelection"
}