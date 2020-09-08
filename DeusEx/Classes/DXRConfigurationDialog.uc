/*
   Base class for all configuration menus/dialogs (with ok/Cancel/reset to defaults buttons);
*/

class DXRConfigurationDialog extends DXWindowTemplate
                                             Abstract;

var localized string strOk, strDefault, strCancel;

defaultproperties
{
    strOk="OK"
    strDefault="Cancel"
    strCancel="Reset to Defaults"
}