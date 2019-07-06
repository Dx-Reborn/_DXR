/* Empty container */

class DXR_HUDColor extends hcObject;

  var() color MessageBG;   // ClientMessage Background
  var() color MessageText; // ClientMessage Text
  var() color MessageFrame; // ClientMessage frame color

  var() color ToolBeltBG; // toolbelt cells
  var() color ToolBeltText; // toolbelt text color
  var() color ToolBeltSpecialText; //... HotKey Numbers (0..9)
  var() color ToolBeltFrame; // frames color
  var() color ToolBeltHighlight; // toolbelt selected item

  var() color AugsBeltBG;
  var() color AugsBeltText;
  var() color AugsBeltFrame;
  var() color AugsBeltActive;
  var() color AugsBeltInActive;

  var() color AmmoDisplayBG;
  var() color AmmoDisplayFrame;

  var() color compassBG;
  var() color compassFrame;

  var() color HealthBG;
  var() color HealthFrame;

  var() color BooksBG; // Background color for InformationDevices contents
  var() color BooksText; // text color 
  var() color BooksFrame; // frame color

  var() color InfoLinkBG; // infolink/first person dialogue/monologue
  var() color InfoLinkText; // Text color
  var() color InfoLinkTitles; // header/bold text
  var() color InfoLinkFrame; // frame color

  var() color AIBarksBG;
  var() color AIBarksText;
  var() color AIBarksHeader;
  var() color AIBarksFrame;

  var() color FrobBoxColor;
  var() color FrobBoxShadow;
  var() color FrobBoxText;

  var() string HUDName; // Theme displayable name

