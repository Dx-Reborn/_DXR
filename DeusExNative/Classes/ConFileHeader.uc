class ConFileHeader extends ConBase native transient
		dependson(Times);


var int ConVersion;
var Times.FileTime CreatedOn;
var string CreatedBy;
var Times.FileTime LastModifiedOn;
var string LastModifiedBy;
var string AudioPackageName;
var string Notes;
var() Array<int> MissionList;


