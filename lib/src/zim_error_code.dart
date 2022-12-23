class ZIMErrorCode {
  static const int success = 0;
  static const int failed = 1;

  static const int commonModuleParamsInvalid = 6000001;
  static const int commonModuleEngineNotInit = 6000002;
  static const int commonModuleInvalidAppID = 6000003;
  static const int commonModuleTriggerSDKFrequencyLimit = 6000004;
  static const int commonModuleTriggerServerFrequencyLimit = 6000005;
  static const int commonModuleSwitchServerError = 6000006;
  static const int commonModuleIMServerError = 6000007;
  static const int commonModuleIMDataBaseError = 6000008;
  static const int commonModuleImServerDisconnect = 6000009;
  static const int commonModuleUploadLogError = 6000010;
  static const int commonModuleUserIsNotExist = 6000011;

  static const int networkModuleCommonError = 6000101;
  static const int networkModuleServerError = 6000102;
  static const int networkModuleTokenInvalid = 6000103;
  static const int networkModuleNetworkError = 6000104;
  static const int networkModuleTokenExpired = 6000106;
  static const int networkModuleTokenVersionError = 6000107;
  static const int networkModuleTokenTimeIsTooShort = 6000108;
  static const int networkModuleUserHasAlreadyLogged = 6000111;
  static const int networkModuleUserIsNotLogged = 6000121;

  static const int messageModuleCommonError = 6000201;
  static const int messageModuleServerError = 6000202;
  static const int messageModuleSendMessageFailed = 6000203;
  static const int messageModuleTargetDoseNotExist = 6000204;
  static const int messageModuleAuditRejected = 6000221;
  static const int messageModuleAuditFailed = 6000222;
  static const int messageModuleCallError = 6000270;
  static const int messageModuleCancelCallError = 6000271;
  static const int messageModuleCallServerError = 6000272;
  static const int messageModuleIsNotInvitor = 6000273;
  static const int messageModuleIsNotInvitee = 6000274;
  static const int messageModuleCallAlreadyExists = 6000275;
  static const int messageModuleCallDoseNotExist = 6000276;
  static const int receiptReadError = 6000277;
  static const int messageExceedsRevokeTime = 6000278;
  static const int messageHasBeenRevoked = 6000279;

  static const int roomModuleCommonError = 6000301;
  static const int roomModuleServerError = 6000302;
  static const int roomModuleCreateRoomError = 6000303;
  static const int roomModuleJoinRoomError = 6000304;
  static const int roomModuleLeaveRoomError = 6000306;
  static const int roomModuleUserIsAlreadyInTheRoom = 6000320;
  static const int roomModuleUserIsNotInTheRoom = 6000321;
  static const int roomModuleTheRoomDoseNotExist = 6000322;
  static const int roomModuleTheRoomAlreadyExists = 6000323;
  static const int roomModuleTheNumberOfExistingRoomsHasReachedLimit = 6000324;
  static const int roomModuleTheNumberOfJoinedRoomsHasReachedLimit = 6000325;
  static const int roomModuleRoomAttributesCommonError = 6000330;
  static const int roomModuleRoomAttributesOperationFailedCompletely = 6000331;
  static const int roomModuleRoomAttributesOperationFailedPartly = 6000332;
  static const int roomModuleRoomAttributesQueryFailed = 6000333;
  static const int roomModuleTheNumberOfRoomAttributesExceedsLimit = 6000334;
  static const int roomModuleTheLengthOfRoomAttributeKeyExceedsLimit = 6000335;
  static const int roomModuleTheLengthOfRoomAttributeValueExceedsLimit =
      6000336;
  static const int roomModuleTheTotalLengthOfRoomAttributesValueExceedsLimit =
      6000337;
  static const int roomModuleRoomMemberAttributesCommonError = 6000350;
  static const int roomModuleRoomMemberAttributesKVExceedsLimit = 6000351;
  static const int roomModuleRoomMemberAttributesKeyExceedsLimit = 6000352;
  static const int roomModuleRoomMemberAttributesValueExceedsLimit = 6000353;
  static const int
      roomModuleRoomMemberAttributesSetRoomUserAttributesCountExceedLimit =
      6000357;
  static const int zpnsModulePushIDInvalid = 6000401;

  static const int groupModuleCommonError = 6000501;
  static const int groupModuleServerError = 6000502;
  static const int groupModuleCreateGroupError = 6000503;
  static const int groupModuleDismissGroupError = 6000504;
  static const int groupModuleJoinGroupError = 6000505;
  static const int groupModuleLeaveGroupError = 6000506;
  static const int groupModuleKickoutGroupMemberError = 6000507;
  static const int groupModuleInviteUserIntoGroupError = 6000508;
  static const int groupModuleTransferOwnerError = 6000509;
  static const int groupModuleUpdateGroupInfoError = 6000510;
  static const int groupModuleQueryGroupInfoError = 6000511;
  static const int groupModuleGroupAttributesOperationFailed = 6000512;
  static const int groupModuleGroupAttributesQueryFailed = 6000513;
  static const int groupModuleUpdateGroupMemberInfoError = 6000514;
  static const int groupModuleQueryGroupMemberInfoError = 6000515;
  static const int groupModuleQueryGroupListError = 6000516;
  static const int groupModuleQueryGroupMemberListError = 6000517;
  static const int groupModuleUserIsNotInTheGroup = 6000521;
  static const int groupModuleMemberIsAlreadyInTheGroup = 6000522;
  static const int groupModuleGroupDoseNotExist = 6000523;
  static const int groupModuleGroupAlreadyExists = 6000524;
  static const int groupModuleGroupMemberHasReachedLimit = 6000525;
  static const int groupModuleGroupAttributeDoseNotExist = 6000526;
  static const int groupModuleTheNumberOfGroupAttributesExceedsLimit = 6000531;
  static const int groupModuleTheLengthOfGroupAttributeKeyExceedsLimit =
      6000532;
  static const int groupModuleTheLengthOfGroupAttributeValueExceedsLimit =
      6000533;
  static const int groupModuleTheTotalLengthOfGroupAttributeValueExceedsLimit =
      6000534;
  static const int groupModuleNoCorrespondingOperationAuthority = 6000541;
  static const int groupModuleGroupDataBaseError = 6000542;

  static const int conversationModuleCommonError = 6000601;
  static const int conversationModuleServerError = 6000602;
  static const int conversationModuleConversationDoseNotExist = 6000603;

  static const int dataBaseModuleOpenDataBaseError = 6000701;
  static const int dataBaseModuleModifyDataBaseError = 6000702;
  static const int dataBaseModuleDeleteDataBaseError = 6000703;
  static const int dataBaseModuleSeleteDataBaseError = 6000704;
}
