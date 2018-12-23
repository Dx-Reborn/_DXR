class ConFileHeader extends ConBase native transient
		dependson(Times);


var int ConVersion;
var Times.OleTime CreatedOn;
var string CreatedBy;
var Times.OleTime LastModifiedOn;
var string LastModifiedBy;
var string AudioPackageName;
var string Notes;
var Array<int> MissionList;
