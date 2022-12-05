#include "ZIMPluginConverter.h"

ZIMMessageType ZIMMessage::* get(ZIM_FriendlyGet_msgType);
template struct Rob<ZIM_FriendlyGet_msgType, &ZIMMessage::type>;

long long ZIMMessage::* get(ZIM_FriendlyGet_messageID);
template struct Rob<ZIM_FriendlyGet_messageID, &ZIMMessage::messageID>;

long long ZIMMessage::* get(ZIM_FriendlyGet_localMessageID);
template struct Rob<ZIM_FriendlyGet_localMessageID, &ZIMMessage::localMessageID>;

std::string ZIMMessage::* get(ZIM_FriendlyGet_senderUserID);
template struct Rob<ZIM_FriendlyGet_senderUserID, &ZIMMessage::senderUserID>;

std::string ZIMMessage::* get(ZIM_FriendlyGet_conversationID);
template struct Rob<ZIM_FriendlyGet_conversationID, &ZIMMessage::conversationID>;

ZIMConversationType ZIMMessage::* get(ZIM_FriendlyGet_conversationType);
template struct Rob<ZIM_FriendlyGet_conversationType, &ZIMMessage::conversationType>;

long long ZIMMessage::* get(ZIM_FriendlyGet_conversationSeq);
template struct Rob<ZIM_FriendlyGet_conversationSeq, &ZIMMessage::conversationSeq>;

ZIMMessageDirection ZIMMessage::* get(ZIM_FriendlyGet_direction);
template struct Rob<ZIM_FriendlyGet_direction, &ZIMMessage::direction>;

ZIMMessageSentStatus ZIMMessage::* get(ZIM_FriendlyGet_sentStatus);
template struct Rob<ZIM_FriendlyGet_sentStatus, &ZIMMessage::sentStatus>;

unsigned long long ZIMMessage::* get(ZIM_FriendlyGet_timestamp);
template struct Rob<ZIM_FriendlyGet_timestamp, &ZIMMessage::timestamp>;

long long ZIMMessage::* get(ZIM_FriendlyGet_orderKey);
template struct Rob<ZIM_FriendlyGet_orderKey, &ZIMMessage::orderKey>;

bool ZIMMessage::* get(ZIM_FriendlyGet_isUserInserted);
template struct Rob<ZIM_FriendlyGet_isUserInserted, &ZIMMessage::userInserted>;

std::string ZIMMediaMessage::* get(ZIM_FriendlyGet_fileUID);
template struct Rob<ZIM_FriendlyGet_fileUID, &ZIMMediaMessage::fileUID>;

std::string ZIMMediaMessage::* get(ZIM_FriendlyGet_fileName);
template struct Rob<ZIM_FriendlyGet_fileName, &ZIMMediaMessage::fileName>;

long long ZIMMediaMessage::* get(ZIM_FriendlyGet_fileSize);
template struct Rob<ZIM_FriendlyGet_fileSize, &ZIMMediaMessage::fileSize>;

std::string ZIMImageMessage::* get(ZIM_FriendlyGet_largeImageLocalPath);
template struct Rob<ZIM_FriendlyGet_largeImageLocalPath, &ZIMImageMessage::largeImageLocalPath>;

std::string ZIMImageMessage::* get(ZIM_FriendlyGet_thumbnailLocalPath);
template struct Rob<ZIM_FriendlyGet_thumbnailLocalPath, &ZIMImageMessage::thumbnailLocalPath>;

std::string ZIMVideoMessage::* get(ZIM_FriendlyGet_videoFirstFrameLocalPath);
template struct Rob<ZIM_FriendlyGet_videoFirstFrameLocalPath, &ZIMVideoMessage::videoFirstFrameLocalPath>;

unsigned int ZIMImageMessage::* get(ZIM_FriendlyGet_originalImageWidth);
template struct Rob<ZIM_FriendlyGet_originalImageWidth, &ZIMImageMessage::originalImageWidth>;

unsigned int ZIMImageMessage::* get(ZIM_FriendlyGet_originalImageHeight);
template struct Rob<ZIM_FriendlyGet_originalImageHeight, &ZIMImageMessage::originalImageHeight>;

unsigned int ZIMImageMessage::* get(ZIM_FriendlyGet_largeImageWidth);
template struct Rob<ZIM_FriendlyGet_largeImageWidth, &ZIMImageMessage::largeImageWidth>;

unsigned int ZIMImageMessage::* get(ZIM_FriendlyGet_largeImageHeight);
template struct Rob<ZIM_FriendlyGet_largeImageHeight, &ZIMImageMessage::largeImageHeight>;

unsigned int ZIMImageMessage::* get(ZIM_FriendlyGet_thumbnailWidth);
template struct Rob<ZIM_FriendlyGet_thumbnailWidth, &ZIMImageMessage::thumbnailWidth>;

unsigned int ZIMImageMessage::* get(ZIM_FriendlyGet_thumbnailHeight);
template struct Rob<ZIM_FriendlyGet_thumbnailHeight, &ZIMImageMessage::thumbnailHeight>;

unsigned int ZIMVideoMessage::* get(ZIM_FriendlyGet_videoFirstFrameWidth);
template struct Rob<ZIM_FriendlyGet_videoFirstFrameWidth, &ZIMVideoMessage::videoFirstFrameWidth>;

unsigned int ZIMVideoMessage::* get(ZIM_FriendlyGet_videoFirstFrameHeight);
template struct Rob<ZIM_FriendlyGet_videoFirstFrameHeight, &ZIMVideoMessage::videoFirstFrameHeight>;

ZIMRevokeType ZIMRevokeMessage::* get(ZIM_FriendlyGet_revokeType);
template struct Rob<ZIM_FriendlyGet_revokeType, &ZIMRevokeMessage::revokeType>;

unsigned long long ZIMRevokeMessage::* get(ZIM_FriendlyGet_revokeTimestamp);
template struct Rob<ZIM_FriendlyGet_revokeTimestamp, &ZIMRevokeMessage::revokeTimestamp>;

ZIMMessageType ZIMRevokeMessage::* get(ZIM_FriendlyGet_originalMessageType);
template struct Rob<ZIM_FriendlyGet_originalMessageType, &ZIMRevokeMessage::originalMessageType>;

ZIMMessageRevokeStatus ZIMRevokeMessage::* get(ZIM_FriendlyGet_revokeStatus);
template struct Rob<ZIM_FriendlyGet_revokeStatus, &ZIMRevokeMessage::revokeStatus>;

std::string ZIMRevokeMessage::* get(ZIM_FriendlyGet_operatedUserID);
template struct Rob<ZIM_FriendlyGet_operatedUserID, &ZIMRevokeMessage::operatedUserID>;

std::string ZIMRevokeMessage::* get(ZIM_FriendlyGet_originalTextMessageContent);
template struct Rob<ZIM_FriendlyGet_originalTextMessageContent, &ZIMRevokeMessage::originalTextMessageContent>;

std::string ZIMRevokeMessage::* get(ZIM_FriendlyGet_revokeExtendedData);
template struct Rob<ZIM_FriendlyGet_revokeExtendedData, &ZIMRevokeMessage::revokeExtendedData>;

ZIMMessageReceiptStatus ZIMMessage::* get(ZIM_FriendlyGet_receiptStatus);
template struct Rob<ZIM_FriendlyGet_receiptStatus, &ZIMMessage::receiptStatus>;

std::unordered_map<std::string, std::string> ZIMPluginConverter::cnvFTMapToSTLMap(FTMap ftMap) {
	std::unordered_map<std::string, std::string> stlMap;
	for (auto& ftObj : ftMap) {
		auto key = std::get<std::string>(ftObj.first);
		auto value = std::get<std::string>(ftObj.second);

		stlMap[key] = value;
	}

	return stlMap;
}

FTMap ZIMPluginConverter::cnvSTLMapToFTMap(const std::unordered_map<std::string, std::string>& map) {
	FTMap ftMap;
	for (auto& obj : map) {
		auto key = FTValue(obj.first);
		auto value = FTValue(obj.second);

		ftMap[key] = value;
	}

	return ftMap;
}

FTArray ZIMPluginConverter::cnvStlVectorToFTArray(const std::vector<long long>& vec) {
	FTArray ftArray;
	for (auto& value : vec) {
		ftArray.emplace_back(FTValue(value));
	}

	return ftArray;
}

FTArray ZIMPluginConverter::cnvStlVectorToFTArray(const std::vector<std::string>& vec) {
	FTArray ftArray;
	for (auto& str : vec) {
		ftArray.emplace_back(FTValue(str));
	}

	return ftArray;
}

std::vector<std::string> ZIMPluginConverter::cnvFTArrayToStlVector(FTArray ftArray) {
	std::vector<std::string> vec;
	for (auto& strObj : ftArray) {
		auto str = std::get<std::string>(strObj);
		vec.emplace_back(str);
	}

	return vec;
}

FTMap ZIMPluginConverter::cnvZIMUserInfoObjectToMap(const ZIMUserInfo& userInfo) {
	FTMap userInfoMap;
	userInfoMap[FTValue("userID")] = FTValue(userInfo.userID);
	userInfoMap[FTValue("userName")] = FTValue(userInfo.userName);

	return userInfoMap;

}

FTMap ZIMPluginConverter::cnvZIMUserFullInfoObjectToMap(const ZIMUserFullInfo& userFullInfo) {
	FTMap userFullInfoMap;
	userFullInfoMap[FTValue("baseInfo")] = cnvZIMUserInfoObjectToMap(userFullInfo.baseInfo);
	userFullInfoMap[FTValue("userAvatarUrl")] = FTValue(userFullInfo.userAvatarUrl);
	userFullInfoMap[FTValue("extendedData")] = FTValue(userFullInfo.extendedData);

	return userFullInfoMap;
}

FTMap ZIMPluginConverter::cnvZIMErrorUserInfoToMap(const ZIMErrorUserInfo& errorUserInfo) {
	FTMap errorUserInfoMap;
	errorUserInfoMap[FTValue("userID")] = FTValue(errorUserInfo.userID);
	errorUserInfoMap[FTValue("reason")] = FTValue((int32_t)errorUserInfo.reason);

	return errorUserInfoMap;
}

FTMap ZIMPluginConverter::cnvZIMErrorObjectToMap(const ZIMError& errorInfo) {
	FTMap errorInfoMap;
	errorInfoMap[FTValue("code")] = FTValue(errorInfo.code);
	errorInfoMap[FTValue("message")] = FTValue(errorInfo.message);

	return errorInfoMap;
}

FTArray ZIMPluginConverter::cnvZIMUserListToArray(const std::vector<ZIMUserInfo>& userInfoList) {
	FTArray userInfoListArray;
	for (auto& userInfo : userInfoList) {
		FTMap userInfoMap = cnvZIMUserInfoObjectToMap(userInfo);
		userInfoListArray.emplace_back(userInfoMap);
	}

	return userInfoListArray;
}

FTArray ZIMPluginConverter::cnvZIMErrorUserListToArray(const std::vector<ZIMErrorUserInfo>& errorUserList) {
	FTArray errorUserListArray;
	for (auto& errorUserInfo : errorUserList) {
		FTMap errorInfoMap = cnvZIMErrorUserInfoToMap(errorUserInfo);
		errorUserListArray.emplace_back(errorInfoMap);
	}

	return errorUserListArray;
}

FTArray ZIMPluginConverter::cnvZIMConversationListToArray(const std::vector<std::shared_ptr<ZIMConversation>>& converationList) {
	FTArray conversationListArray;
	for (auto& conversation : converationList) {
		FTMap convMap = cnvZIMConversationToMap(conversation);
		conversationListArray.emplace_back(convMap);
	}

	return conversationListArray;
}

FTMap ZIMPluginConverter::cnvZIMConversationToMap(const std::shared_ptr<ZIMConversation>& conversation) {
	FTMap conversationMap;
	conversationMap[FTValue("conversationID")] = FTValue(conversation->conversationID);
	conversationMap[FTValue("conversationName")] = FTValue(conversation->conversationName);
	conversationMap[FTValue("conversationAvatarUrl")] = FTValue(conversation->conversationAvatarUrl);
	conversationMap[FTValue("type")] = FTValue(conversation->type);
	conversationMap[FTValue("notificationStatus")] = FTValue(conversation->notificationStatus);
	conversationMap[FTValue("unreadMessageCount")] = FTValue((int32_t)conversation->unreadMessageCount);
	conversationMap[FTValue("orderKey")] = FTValue(conversation->orderKey);
	conversationMap[FTValue("lastMessage")] = cnvZIMMessageObjectToMap(conversation->lastMessage.get());

	return conversationMap;
}

FTArray ZIMPluginConverter::cnvZIMConversationChangeInfoListToArray(const std::vector<ZIMConversationChangeInfo>& convInfoList) {
	FTArray convInfoArray;
	for (auto& convInfo : convInfoList) {
		FTMap convInfoMap;
		convInfoMap[FTValue("event")] = FTValue(convInfo.event);
		if (convInfo.conversation) {
			convInfoMap[FTValue("conversation")] = ZIMPluginConverter::cnvZIMConversationToMap(convInfo.conversation);
		}
		else {
			convInfoMap[FTValue("conversation")] = FTValue(std::monostate());
		}

		convInfoArray.emplace_back(convInfoMap);
	}

	return convInfoArray;
}

flutter::EncodableValue ZIMPluginConverter::cnvZIMMessageObjectToMap(ZIMMessage* message) {
	FTMap messageMap;
	if (!message) {
		return FTValue(std::monostate());
	}

	messageMap[FTValue("type")] = FTValue(message->getType());
	messageMap[FTValue("messageID")] = FTValue(message->getMessageID());
	messageMap[FTValue("localMessageID")] = FTValue(message->getLocalMessageID());
	messageMap[FTValue("senderUserID")] = FTValue(message->getSenderUserID());
	messageMap[FTValue("conversationID")] = FTValue(message->getConversationID());
	messageMap[FTValue("direction")] = FTValue(message->getDirection());
	messageMap[FTValue("sentStatus")] = FTValue(message->getSentStatus());
	messageMap[FTValue("conversationType")] = FTValue(message->getConversationType());
	messageMap[FTValue("timestamp")] = FTValue((int64_t)message->getTimestamp());
	messageMap[FTValue("conversationSeq")] = FTValue(message->getConversationSeq());
	messageMap[FTValue("orderKey")] = FTValue(message->getOrderKey());
	messageMap[FTValue("isUserInserted")] = FTValue(message->isUserInserted());
	messageMap[FTValue("receiptStatus")] = FTValue(message->getReceiptStatus());
	if (message->getType() >= ZIM_MESSAGE_TYPE_IMAGE && message->getType() <= ZIM_MESSAGE_TYPE_VIDEO) {
		auto mediaMessage = (ZIMMediaMessage*)message;
		messageMap[FTValue("fileLocalPath")] = FTValue(mediaMessage->fileLocalPath);
		messageMap[FTValue("fileDownloadUrl")] = FTValue(mediaMessage->fileDownloadUrl);
		messageMap[FTValue("fileUID")] = FTValue(mediaMessage->getFileUID());
		messageMap[FTValue("fileName")] = FTValue(mediaMessage->getFileName());
		messageMap[FTValue("fileSize")] = FTValue(mediaMessage->getFileSize());
	}

	switch (message->getType())
	{
	case ZIM_MESSAGE_TYPE_TEXT: {
		auto textMessage = (ZIMTextMessage*)message;
		messageMap[FTValue("message")] = FTValue(textMessage->message);
		break;
	}
	case ZIM_MESSAGE_TYPE_COMMAND: {
		auto commandMessage = (ZIMCommandMessage*)message;
		messageMap[FTValue("message")] = FTValue(commandMessage->message);
		break;
	}
	case ZIM_MESSAGE_TYPE_BARRAGE: {
		auto barrageMessage = (ZIMBarrageMessage*)message;
		messageMap[FTValue("message")] = FTValue(barrageMessage->message);
		break;
	}
	case ZIM_MESSAGE_TYPE_FILE:
		break;
	case ZIM_MESSAGE_TYPE_IMAGE: {
		auto imageMessage = (ZIMImageMessage*)message;
		messageMap[FTValue("thumbnailDownloadUrl")] = FTValue(imageMessage->thumbnailDownloadUrl);
		messageMap[FTValue("thumbnailLocalPath")] = FTValue(imageMessage->getThumbnailLocalPath());
		messageMap[FTValue("largeImageDownloadUrl")] = FTValue(imageMessage->largeImageDownloadUrl);
		messageMap[FTValue("largeImageLocalPath")] = FTValue(imageMessage->getLargeImageLocalPath());
		messageMap[FTValue("originalImageWidth")] = FTValue((int32_t)imageMessage->getOriginalImageWidth());
		messageMap[FTValue("originalImageHeight")] = FTValue((int32_t)imageMessage->getOriginalImageHeight());
		messageMap[FTValue("largeImageWidth")] = FTValue((int32_t)imageMessage->getLargeImageWidth());
		messageMap[FTValue("largeImageHeight")] = FTValue((int32_t)imageMessage->getLargeImageHeight());
		messageMap[FTValue("thumbnailWidth")] = FTValue((int32_t)imageMessage->getThumbnailImageWidth());
		messageMap[FTValue("thumbnailHeight")] = FTValue((int32_t)imageMessage->getThumbnailImageHeight());
		break;
	}	
	case ZIM_MESSAGE_TYPE_AUDIO: {
		auto audioMessage = (ZIMAudioMessage*)message;
		messageMap[FTValue("audioDuration")] = FTValue((int64_t)audioMessage->audioDuration);
		break;
	}	
	case ZIM_MESSAGE_TYPE_VIDEO: {
		auto videoMessage = (ZIMVideoMessage*)message;
		messageMap[FTValue("videoDuration")] = FTValue((int64_t)videoMessage->videoDuration);
		messageMap[FTValue("videoFirstFrameDownloadUrl")] = FTValue(videoMessage->videoFirstFrameDownloadUrl);
		messageMap[FTValue("videoFirstFrameLocalPath")] = FTValue(videoMessage->getVideoFirstFrameLocalPath());
		messageMap[FTValue("videoFirstFrameWidth")] = FTValue((int32_t)videoMessage->getVideoFirstFrameWidth());
		messageMap[FTValue("videoFirstFrameHeight")] = FTValue((int32_t)videoMessage->getVideoFirstFrameHeight());
		break;
	}
	case ZIM_MESSAGE_TYPE_SYSTEM:{
		auto systemMessage = (ZIMSystemMessage*)message;
		messageMap[FTValue("message")] = FTValue(systemMessage->message);
		break;
	}
	case ZIM_MESSAGE_TYPE_REVOKE:{
		auto revokeMessage = (ZIMRevokeMessage*)message;
		messageMap[FTValue("revokeType")] = FTValue(revokeMessage->getRevokeType());
		messageMap[FTValue("revokeStatus")] = FTValue(revokeMessage->getRevokeStatus());
		messageMap[FTValue("originalMessageType")] = FTValue(revokeMessage->getOriginalMessageType());
		messageMap[FTValue("revokeTimestamp")] = FTValue((int64_t)revokeMessage->getRevokeTimestamp());
		messageMap[FTValue("operatedUserID")] = FTValue(revokeMessage->getOperatedUserID());
		messageMap[FTValue("originalTextMessageContent")] = FTValue(revokeMessage->getOriginalTextMessageContent());
		messageMap[FTValue("revokeExtendedData")] = FTValue(revokeMessage->getRevokeExtendedData());
		break;
	}
	case ZIM_MESSAGE_TYPE_UNKNOWN:
	default:
		break;
	}

	return messageMap;
}

ZIMConversationDeleteConfig ZIMPluginConverter::cnvZIMConversationDeleteConfigToObject(FTMap configMap) {
	ZIMConversationDeleteConfig config;
	config.isAlsoDeleteServerConversation = std::get<bool>(configMap[FTValue("isAlsoDeleteServerConversation")]);

	return config;
}

std::shared_ptr<ZIMMessage> ZIMPluginConverter::cnvZIMMessageToObject(FTMap messageMap) {
	std::shared_ptr<ZIMMessage> messagePtr = nullptr;

	ZIMMessageType msgType = (ZIMMessageType)std::get<int32_t>(messageMap[FTValue("type")]);
	switch (msgType)
	{
	case zim::ZIM_MESSAGE_TYPE_UNKNOWN: {
		messagePtr = std::make_shared<ZIMMessage>();
		break;
	}
	case zim::ZIM_MESSAGE_TYPE_TEXT: {
		messagePtr = std::make_shared<ZIMTextMessage>();
		auto textMessagePtr = std::static_pointer_cast<ZIMTextMessage>(messagePtr);
		textMessagePtr->message = std::get<std::string>(messageMap[FTValue("message")]);
		break;
	}
	case zim::ZIM_MESSAGE_TYPE_COMMAND: {
		messagePtr = std::make_shared<ZIMCommandMessage>();
		auto commandMessage = std::static_pointer_cast<ZIMCommandMessage>(messagePtr);
		commandMessage->message = std::get<std::vector<uint8_t>>(messageMap[FTValue("message")]);
		break;
	}
	case zim::ZIM_MESSAGE_TYPE_IMAGE: {
		messagePtr = std::make_shared<ZIMImageMessage>(std::get<std::string>(messageMap[FTValue("fileLocalPath")]));
		auto imageMessagePtr = std::static_pointer_cast<ZIMImageMessage>(messagePtr);
		(*imageMessagePtr.get()).*get(ZIM_FriendlyGet_largeImageLocalPath()) = std::get<std::string>(messageMap[FTValue("largeImageLocalPath")]);
		(*imageMessagePtr.get()).*get(ZIM_FriendlyGet_thumbnailLocalPath()) = std::get<std::string>(messageMap[FTValue("thumbnailLocalPath")]);
		(*imageMessagePtr.get()).*get(ZIM_FriendlyGet_originalImageWidth()) = (unsigned int)std::get<int32_t>(messageMap[FTValue("originalImageWidth")]);
		(*imageMessagePtr.get()).*get(ZIM_FriendlyGet_originalImageHeight()) = (unsigned int)std::get<int32_t>(messageMap[FTValue("originalImageHeight")]);
		(*imageMessagePtr.get()).*get(ZIM_FriendlyGet_largeImageWidth()) = (unsigned int)std::get<int32_t>(messageMap[FTValue("largeImageWidth")]);
		(*imageMessagePtr.get()).*get(ZIM_FriendlyGet_largeImageHeight()) = (unsigned int)std::get<int32_t>(messageMap[FTValue("largeImageHeight")]);
		(*imageMessagePtr.get()).*get(ZIM_FriendlyGet_thumbnailWidth()) = (unsigned int)std::get<int32_t>(messageMap[FTValue("thumbnailWidth")]);
		(*imageMessagePtr.get()).*get(ZIM_FriendlyGet_thumbnailHeight()) = (unsigned int)std::get<int32_t>(messageMap[FTValue("thumbnailHeight")]);
		break;
	}
	case zim::ZIM_MESSAGE_TYPE_FILE: {
		messagePtr = std::make_shared<ZIMFileMessage>(std::get<std::string>(messageMap[FTValue("fileLocalPath")]));
		break;
	}
	case zim::ZIM_MESSAGE_TYPE_AUDIO: {
		messagePtr = std::make_shared<ZIMAudioMessage>(std::get<std::string>(messageMap[FTValue("fileLocalPath")]), (unsigned int)std::get<int32_t>(messageMap[FTValue("audioDuration")]));
		break;
	}
		
	case zim::ZIM_MESSAGE_TYPE_VIDEO: {
		messagePtr = std::make_shared<ZIMVideoMessage>(std::get<std::string>(messageMap[FTValue("fileLocalPath")]), (unsigned int)std::get<int32_t>(messageMap[FTValue("videoDuration")]));
		auto videoMessagePtr = std::static_pointer_cast<ZIMVideoMessage>(messagePtr);
		(*videoMessagePtr.get()).*get(ZIM_FriendlyGet_videoFirstFrameLocalPath()) = std::get<std::string>(messageMap[FTValue("videoFirstFrameLocalPath")]);
		(*videoMessagePtr.get()).*get(ZIM_FriendlyGet_videoFirstFrameWidth()) = std::get<int32_t>(messageMap[FTValue("videoFirstFrameWidth")]);
		(*videoMessagePtr.get()).*get(ZIM_FriendlyGet_videoFirstFrameHeight()) = std::get<int32_t>(messageMap[FTValue("videoFirstFrameHeight")]);
		break;
	}
	case zim::ZIM_MESSAGE_TYPE_BARRAGE: {
		messagePtr = std::make_shared<ZIMBarrageMessage>();
		auto barrageMessage = std::static_pointer_cast<ZIMBarrageMessage>(messagePtr);
		barrageMessage->message = std::get<std::string>(messageMap[FTValue("message")]);
		break;
	}
	case zim::ZIM_MESSAGE_TYPE_SYSTEM:{
		messagePtr = std::make_shared<ZIMSystemMessage>();
		auto systemMessage = std::static_pointer_cast<ZIMSystemMessage>(messagePtr);
		systemMessage->message = std::get<std::string>(messageMap[FTValue("message")]);
		break;
	}
	case zim::ZIM_MESSAGE_TYPE_REVOKE:{
		messagePtr = std::make_shared<ZIMRevokeMessage>();
		auto revokeMessagePtr = std::static_pointer_cast<ZIMRevokeMessage>(messagePtr);
		if (std::holds_alternative<int32_t>(messageMap[FTValue("revokeType")])) {
			(*revokeMessagePtr.get()).*get(ZIM_FriendlyGet_revokeType()) = (ZIMRevokeType)std::get<int32_t>(messageMap[FTValue("revokeType")]);
		}else{
			(*revokeMessagePtr.get()).*get(ZIM_FriendlyGet_revokeType()) = (ZIMRevokeType)std::get<int64_t>(messageMap[FTValue("revokeType")]);
		}
		if (std::holds_alternative<int32_t>(messageMap[FTValue("revokeTimestamp")])) {
			(*revokeMessagePtr.get()).*get(ZIM_FriendlyGet_revokeTimestamp()) = (unsigned long long)std::get<int32_t>(messageMap[FTValue("revokeTimestamp")]);
		}else{
			(*revokeMessagePtr.get()).*get(ZIM_FriendlyGet_revokeTimestamp()) = (unsigned long long)std::get<int64_t>(messageMap[FTValue("revokeTimestamp")]);
		}
		if (std::holds_alternative<int32_t>(messageMap[FTValue("originalMessageType")])) {
			(*revokeMessagePtr.get()).*get(ZIM_FriendlyGet_originalMessageType()) = (ZIMMessageType)std::get<int32_t>(messageMap[FTValue("originalMessageType")]);
		}else{
			(*revokeMessagePtr.get()).*get(ZIM_FriendlyGet_originalMessageType()) = (ZIMMessageType)std::get<int64_t>(messageMap[FTValue("originalMessageType")]);
		}
		if (std::holds_alternative<int32_t>(messageMap[FTValue("revokeStatus")])) {
			(*revokeMessagePtr.get()).*get(ZIM_FriendlyGet_revokeStatus()) = (ZIMMessageRevokeStatus)std::get<int32_t>(messageMap[FTValue("revokeStatus")]);
		}else{
			(*revokeMessagePtr.get()).*get(ZIM_FriendlyGet_revokeStatus()) = (ZIMMessageRevokeStatus)std::get<int64_t>(messageMap[FTValue("revokeStatus")]);
		}
		(*revokeMessagePtr.get()).*get(ZIM_FriendlyGet_operatedUserID()) = std::get<std::string>(messageMap[FTValue("operatedUserID")]);
		(*revokeMessagePtr.get()).*get(ZIM_FriendlyGet_originalTextMessageContent()) = std::get<std::string>(messageMap[FTValue("originalTextMessageContent")]);
		(*revokeMessagePtr.get()).*get(ZIM_FriendlyGet_revokeExtendedData()) = std::get<std::string>(messageMap[FTValue("revokeExtendedData")]);
		break;
	}
	default:
		break;
	}

	(*messagePtr.get()).*get(ZIM_FriendlyGet_msgType()) = msgType;
	(*messagePtr.get()).*get(ZIM_FriendlyGet_senderUserID()) = std::get<std::string>(messageMap[FTValue("senderUserID")]);
	(*messagePtr.get()).*get(ZIM_FriendlyGet_conversationID()) = std::get<std::string>(messageMap[FTValue("conversationID")]);
	(*messagePtr.get()).*get(ZIM_FriendlyGet_direction()) = (ZIMMessageDirection)std::get<int32_t>(messageMap[FTValue("direction")]);
	(*messagePtr.get()).*get(ZIM_FriendlyGet_sentStatus()) = (ZIMMessageSentStatus)std::get<int32_t>(messageMap[FTValue("sentStatus")]);
	(*messagePtr.get()).*get(ZIM_FriendlyGet_conversationType()) = (ZIMConversationType)std::get<int32_t>(messageMap[FTValue("conversationType")]);
	(*messagePtr.get()).*get(ZIM_FriendlyGet_isUserInserted()) = (bool)std::get<bool>(messageMap[FTValue("isUserInserted")]);

	if (std::holds_alternative<int32_t>(messageMap[FTValue("messageID")])) {
		(*messagePtr.get()).*get(ZIM_FriendlyGet_messageID()) = (long long)std::get<int32_t>(messageMap[FTValue("messageID")]);
	}
	else {
		(*messagePtr.get()).*get(ZIM_FriendlyGet_messageID()) = (long long)std::get<int64_t>(messageMap[FTValue("messageID")]);
	}

	if (std::holds_alternative<int32_t>(messageMap[FTValue("localMessageID")])) {
		(*messagePtr.get()).*get(ZIM_FriendlyGet_localMessageID()) = (long long)std::get<int32_t>(messageMap[FTValue("localMessageID")]);
	}
	else {
		(*messagePtr.get()).*get(ZIM_FriendlyGet_localMessageID()) = (long long)std::get<int64_t>(messageMap[FTValue("localMessageID")]);
	}

	if (std::holds_alternative<int32_t>(messageMap[FTValue("conversationSeq")])) {
		(*messagePtr.get()).*get(ZIM_FriendlyGet_conversationSeq()) = (long long)std::get<int32_t>(messageMap[FTValue("conversationSeq")]);
	}
	else {
		(*messagePtr.get()).*get(ZIM_FriendlyGet_conversationSeq()) = (long long)std::get<int64_t>(messageMap[FTValue("conversationSeq")]);
	}
	
	if (std::holds_alternative<int32_t>(messageMap[FTValue("timestamp")])) {
		(*messagePtr.get()).*get(ZIM_FriendlyGet_timestamp()) = (unsigned long long)std::get<int32_t>(messageMap[FTValue("timestamp")]);
	}
	else {
		(*messagePtr.get()).*get(ZIM_FriendlyGet_timestamp()) = (unsigned long long)std::get<int64_t>(messageMap[FTValue("timestamp")]);
	}
	

	if (std::holds_alternative<int32_t>(messageMap[FTValue("orderKey")])) {
		(*messagePtr.get()).*get(ZIM_FriendlyGet_orderKey()) = (long long)std::get<int32_t>(messageMap[FTValue("orderKey")]);
	}
	else {
		(*messagePtr.get()).*get(ZIM_FriendlyGet_orderKey()) = (long long)std::get<int64_t>(messageMap[FTValue("orderKey")]);
	}

	if (std::holds_alternative<int32_t>(messageMap[FTValue("receiptStatus")])) {
		(*messagePtr.get()).*get(ZIM_FriendlyGet_receiptStatus()) = (ZIMMessageReceiptStatus)std::get<int32_t>(messageMap[FTValue("receiptStatus")]);
	}
	else {
		(*messagePtr.get()).*get(ZIM_FriendlyGet_receiptStatus()) = (ZIMMessageReceiptStatus)std::get<int64_t>(messageMap[FTValue("receiptStatus")]);
	}

	if (msgType >= ZIM_MESSAGE_TYPE_IMAGE && msgType <= ZIM_MESSAGE_TYPE_VIDEO) {
		auto mediaMessagePtr = std::static_pointer_cast<ZIMMediaMessage>(messagePtr);
		mediaMessagePtr->fileDownloadUrl = std::get<std::string>(messageMap[FTValue("fileDownloadUrl")]);
		(*mediaMessagePtr.get()).*get(ZIM_FriendlyGet_fileUID()) = std::get<std::string>(messageMap[FTValue("fileUID")]);
		(*mediaMessagePtr.get()).*get(ZIM_FriendlyGet_fileName()) = std::get<std::string>(messageMap[FTValue("fileName")]);

		if (std::holds_alternative<int32_t>(messageMap[FTValue("fileSize")])) {
			(*mediaMessagePtr.get()).*get(ZIM_FriendlyGet_fileSize()) = (long long)std::get<int32_t>(messageMap[FTValue("fileSize")]);
		}
		else {
			(*mediaMessagePtr.get()).*get(ZIM_FriendlyGet_fileSize()) = (long long)std::get<int64_t>(messageMap[FTValue("fileSize")]);
		}
	}

	return messagePtr;
}

std::shared_ptr<ZIMPushConfig> ZIMPluginConverter::cnvZIMPushConfigToObject(FTMap configMap) {
	auto config = std::make_shared<ZIMPushConfig>();
	config->title = std::get<std::string>(configMap[FTValue("title")]);
	config->content = std::get<std::string>(configMap[FTValue("content")]);
	config->payload = std::get<std::string>(configMap[FTValue("payload")]);
	config->resourcesID = std::get<std::string>(configMap[FTValue("resourcesID")]);
	return config;
}

FTArray ZIMPluginConverter::cnvZIMMessageListToArray(const std::vector<std::shared_ptr<ZIMMessage>>& messageList) {
	FTArray messageArray;
	for (auto& message : messageList) {
		auto messageMap = cnvZIMMessageObjectToMap(message.get());
		if (std::holds_alternative<FTMap>(messageMap)) {
			messageArray.emplace_back(messageMap);
		}
	}

	return messageArray;
}

FTMap ZIMPluginConverter::cnvZIMMessageReceiptInfoToMap(const ZIMMessageReceiptInfo& messageReceiptInfo) {
	FTMap infoMap;

	infoMap[FTValue("conversationType")] = FTValue(messageReceiptInfo.conversationType);
	infoMap[FTValue("conversationID")] = FTValue(messageReceiptInfo.conversationID);
	infoMap[FTValue("messageID")] = FTValue((int64_t)messageReceiptInfo.messageID);
	infoMap[FTValue("status")] = FTValue(messageReceiptInfo.status);
	infoMap[FTValue("readMemberCount")] = FTValue((int32_t)messageReceiptInfo.readMemberCount);
	infoMap[FTValue("unreadMemberCount")] = FTValue((int32_t)messageReceiptInfo.unreadMemberCount);
	return infoMap;
}

FTArray ZIMPluginConverter::cnvZIMMessageReceiptInfoListToArray(const std::vector<ZIMMessageReceiptInfo>& infos) {
	FTArray infosArray;
	for (auto& info : infos) {
		auto infoMap = cnvZIMMessageReceiptInfoToMap(info);
		infosArray.emplace_back(infoMap);
	}
	return infosArray;
}

std::vector<std::shared_ptr<ZIMMessage>> ZIMPluginConverter::cnvZIMMessageArrayToObjectList(FTArray messageArray) {
	std::vector<std::shared_ptr<ZIMMessage>> messageList;

	for (auto& messageMap : messageArray) {
		if (std::holds_alternative<FTMap>(messageMap)) {
			auto messagePtr = ZIMPluginConverter::cnvZIMMessageToObject(std::get<FTMap>(messageMap));
			messageList.emplace_back(messagePtr);
		}
	}

	return messageList;
}

ZIMRoomInfo ZIMPluginConverter::cnvZIMRoomInfoToObject(FTMap infoMap) {
	ZIMRoomInfo roomInfo;
	roomInfo.roomID = std::get<std::string>(infoMap[FTValue("roomID")]);
	roomInfo.roomName = std::get<std::string>(infoMap[FTValue("roomName")]);

	return roomInfo;
}

FTMap ZIMPluginConverter::cnvZIMRoomInfoToMap(const ZIMRoomInfo& roomInfo) {
	FTMap roomInfoMap;
	roomInfoMap[FTValue("roomID")] = FTValue(roomInfo.roomID);
	roomInfoMap[FTValue("roomName")] = FTValue(roomInfo.roomName);

	return roomInfoMap;
}

FTMap ZIMPluginConverter::cnvZIMRoomFullInfoToMap(const ZIMRoomFullInfo& roomInfo) {
	FTMap roomFullInfoMap;

	auto roomInfoMap = cnvZIMRoomInfoToMap(roomInfo.baseInfo);
	roomFullInfoMap[FTValue("baseInfo")] = roomInfoMap;

	return roomFullInfoMap;
}

FTMap ZIMPluginConverter::cnvZIMRoomAttributesUpdateInfoToMap(const ZIMRoomAttributesUpdateInfo& updateInfo) {
	FTMap roomAttrInfoMap;
	roomAttrInfoMap[FTValue("action")] = FTValue((int32_t)updateInfo.action);
	roomAttrInfoMap[FTValue("roomAttributes")] = cnvSTLMapToFTMap(updateInfo.roomAttributes);

	return roomAttrInfoMap;
}

FTArray ZIMPluginConverter::cnvZIMRoomAttributesUpdateInfoListToArray(const std::vector<ZIMRoomAttributesUpdateInfo>& updateInfoList) {
	FTArray roomAttrInfoArray;
	for (auto& updateInfo : updateInfoList) {
		FTMap updateInfoMap = cnvZIMRoomAttributesUpdateInfoToMap(updateInfo);
		roomAttrInfoArray.emplace_back(updateInfoMap);
	}

	return roomAttrInfoArray;
}

ZIMRoomMemberAttributesSetConfig ZIMPluginConverter::cnvZIMRoomMemberAttributesSetConfigToObject(FTMap configMap){
	ZIMRoomMemberAttributesSetConfig config;
	config.isDeleteAfterOwnerLeft = std::get<bool>(configMap[FTValue("isDeleteAfterOwnerLeft")]);
	return config;
}

ZIMRoomMemberAttributesQueryConfig ZIMPluginConverter::cnvZIMRoomMemberAttributesQueryConfigToObject(FTMap configMap){
	ZIMRoomMemberAttributesQueryConfig config;
	config.nextFlag = std::get<std::string>(configMap[FTValue("nextFlag")]);
	config.count = std::get<int32_t>(configMap[FTValue("count")]);
	return config;
}

FTMap ZIMPluginConverter::cnvZIMRoomMemberAttributesInfoToMap(const ZIMRoomMemberAttributesInfo& info){
	FTMap infoMap;
	infoMap[FTValue("userID")] = info.userID;
	infoMap[FTValue("attributes")] = cnvSTLMapToFTMap(info.attributes);
	return infoMap;
}

FTMap ZIMPluginConverter::cnvZIMRoomMemberAttributesOperatedInfoToMap(const ZIMRoomMemberAttributesOperatedInfo& info){
	FTMap infoMap;
	infoMap[FTValue("attributesInfo")] = ZIMPluginConverter::cnvZIMRoomMemberAttributesInfoToMap(info.attributesInfo);
	infoMap[FTValue("errorKeys")] = ZIMPluginConverter::cnvStlVectorToFTArray(info.errorKeys);
	return infoMap;
}


FTMap ZIMPluginConverter::cnvZIMRoomMemberAttributesUpdateInfoToMap(const ZIMRoomMemberAttributesUpdateInfo& info){
	FTMap infoMap;
	infoMap[FTValue("attributesInfo")] = ZIMPluginConverter::cnvZIMRoomMemberAttributesInfoToMap(info.attributesInfo);
	return infoMap;
}

FTMap ZIMPluginConverter::cnvZIMRoomOperatedInfoToMap(const ZIMRoomOperatedInfo& info){
    FTMap infoMap;
	infoMap[FTValue("userID")] = info.userID;
    return infoMap;
}

FTMap ZIMPluginConverter::cnvZIMGroupInfoToMap(const ZIMGroupInfo& groupInfo) {
	FTMap groupInfoMap;
	groupInfoMap[FTValue("groupID")] = groupInfo.groupID;
	groupInfoMap[FTValue("groupName")] = groupInfo.groupName;
	groupInfoMap[FTValue("groupAvatarUrl")] = groupInfo.groupAvatarUrl;

	return groupInfoMap;
}

FTArray ZIMPluginConverter::cnvZIMGroupListToArray(const std::vector<ZIMGroup>& groupList) {
	FTArray groupArray;
	for (auto& group : groupList) {
		FTMap groupMap;
		groupMap[FTValue("baseInfo")] = cnvZIMGroupInfoToMap(group.baseInfo);
		groupMap[FTValue("notificationStatus")] = FTValue((int32_t)group.notificationStatus);

		groupArray.emplace_back(groupMap);
	}

	return groupArray;
}

FTMap ZIMPluginConverter::cnvZIMGroupOperatedInfoToMap(const ZIMGroupOperatedInfo& info) {
	FTMap infoMap;
	infoMap[FTValue("operatedUserInfo")] = ZIMPluginConverter::cnvZIMGroupMemberInfoToMap(info.operatedUserInfo);
	infoMap[FTValue("userID")] = FTValue(info.userID);
	infoMap[FTValue("userName")] = FTValue(info.userName);
	infoMap[FTValue("memberNickname")] = FTValue(info.memberNickname);
	infoMap[FTValue("memberRole")] = FTValue((int32_t)info.memberRole);

	return infoMap;
}

FTMap ZIMPluginConverter::cnvZIMGroupAttributesUpdateInfoToMap(const ZIMGroupAttributesUpdateInfo& updateInfo) {
	FTMap updateInfoMap;
	updateInfoMap[FTValue("action")] = FTValue(updateInfo.action);
	updateInfoMap[FTValue("groupAttributes")] = cnvSTLMapToFTMap(updateInfo.groupAttributes);

	return updateInfoMap;
}

FTArray ZIMPluginConverter::cnvZIMGroupAttributesUpdateInfoListToArray(const std::vector<ZIMGroupAttributesUpdateInfo>& updateInfoList) {
	FTArray updateInfoArray;
	for (auto& updateInfo : updateInfoList) {
		FTMap updateInfoMap = cnvZIMGroupAttributesUpdateInfoToMap(updateInfo);
		updateInfoArray.emplace_back(updateInfoMap);
	}

	return updateInfoArray;
}

FTMap ZIMPluginConverter::cnvZIMGroupMemberInfoToMap(const ZIMGroupMemberInfo& memberInfo) {
	FTMap groupMemberInfoMap;

	groupMemberInfoMap[FTValue("userID")] = FTValue(memberInfo.userID);
	groupMemberInfoMap[FTValue("userName")] = FTValue(memberInfo.userName);
	groupMemberInfoMap[FTValue("memberNickname")] = FTValue(memberInfo.memberNickname);
	groupMemberInfoMap[FTValue("memberRole")] = FTValue((int32_t)memberInfo.memberRole);
	groupMemberInfoMap[FTValue("memberAvatarUrl")] = FTValue(memberInfo.memberAvatarUrl);

	return groupMemberInfoMap;
}

FTArray ZIMPluginConverter::cnvZIMGroupMemberInfoListToArray(const std::vector<ZIMGroupMemberInfo>& memberList) {
	FTArray groupMemberArray;

	for (auto& groupMemberInfo : memberList) {
		FTMap groupMemberMap = cnvZIMGroupMemberInfoToMap(groupMemberInfo);
		groupMemberArray.emplace_back(groupMemberMap);
	}

	return groupMemberArray;

}

FTMap ZIMPluginConverter::cnvZIMGroupFullInfoToMap(const ZIMGroupFullInfo& groupInfo) {
	FTMap groupFullInfoMap;

	groupFullInfoMap[FTValue("baseInfo")] = cnvZIMGroupInfoToMap(groupInfo.baseInfo);
	groupFullInfoMap[FTValue("groupNotice")] = FTValue(groupInfo.groupNotice);
	groupFullInfoMap[FTValue("groupAttributes")] = cnvSTLMapToFTMap(groupInfo.groupAttributes);
	groupFullInfoMap[FTValue("notificationStatus")] = FTValue((int32_t)groupInfo.notificationStatus);

	return groupFullInfoMap;
}

FTMap ZIMPluginConverter::cnvZIMCallUserInfoToMap(const ZIMCallUserInfo& userInfo) {
	FTMap userInfoMap;
	userInfoMap[FTValue("userID")] = FTValue(userInfo.userID);
	userInfoMap[FTValue("state")] = FTValue((int32_t)userInfo.userState);

	return userInfoMap;
}

FTArray ZIMPluginConverter::cnvZIMCallUserListToArray(const std::vector<ZIMCallUserInfo>& callUserList) {
	FTArray callUserArray;
	for (auto& user : callUserList) {
		FTMap userMap = cnvZIMCallUserInfoToMap(user);
		callUserArray.emplace_back(userMap);
	}

	return callUserArray;
}

FTMap ZIMPluginConverter::cnvZIMCallInvitationSentInfoToMap(const ZIMCallInvitationSentInfo& info) {
	FTMap sentInfoMap;
	sentInfoMap[FTValue("timeout")] = FTValue((int32_t)info.timeout);
	sentInfoMap[FTValue("errorInvitees")] = cnvZIMCallUserListToArray(info.errorInvitees);

	return sentInfoMap;
}

ZIMRoomAdvancedConfig ZIMPluginConverter::cnvZIMRoomAdvancedConfigToObject(FTMap configMap) {
	ZIMRoomAdvancedConfig config;
	config.roomDestroyDelayTime = std::get<int32_t>(configMap[FTValue("roomDestroyDelayTime")]);
	
	auto roomAttrsMap = std::get<FTMap>(configMap[FTValue("roomAttributes")]);
	for (auto& roomAttr : roomAttrsMap) {
		auto key = std::get<std::string>(roomAttr.first);
		auto value = std::get<std::string>(roomAttr.second);
		config.roomAttributes[key] = value;
	}

	return config;
}

ZIMRoomMemberQueryConfig ZIMPluginConverter::cnvZIMRoomMemberQueryConfigToObject(FTMap configMap) {
	ZIMRoomMemberQueryConfig config;
	config.count = std::get<int32_t>(configMap[FTValue("count")]);
	config.nextFlag = std::get<std::string>(configMap[FTValue("nextFlag")]);

	return config;
}

ZIMRoomAttributesSetConfig ZIMPluginConverter::cnvZIMRoomAttributesSetConfigToObject(FTMap configMap) {
	ZIMRoomAttributesSetConfig config;
	config.isDeleteAfterOwnerLeft = std::get<bool>(configMap[FTValue("isDeleteAfterOwnerLeft")]);
	config.isForce = std::get<bool>(configMap[FTValue("isForce")]);
	config.isUpdateOwner = std::get<bool>(configMap[FTValue("isUpdateOwner")]);

	return config;
}

ZIMRoomAttributesDeleteConfig ZIMPluginConverter::cnvZIMRoomAttributesDeleteConfigToObject(FTMap configMap) {
	ZIMRoomAttributesDeleteConfig config;
	config.isForce = std::get<bool>(configMap[FTValue("isForce")]);

	return config;
}

ZIMRoomAttributesBatchOperationConfig ZIMPluginConverter::cnvZIMRoomAttributesBatchOperationConfigToObject(FTMap configMap) {
	ZIMRoomAttributesBatchOperationConfig config;
	config.isDeleteAfterOwnerLeft = std::get<bool>(configMap[FTValue("isDeleteAfterOwnerLeft")]);
	config.isForce = std::get<bool>(configMap[FTValue("isForce")]);
	config.isUpdateOwner = std::get<bool>(configMap[FTValue("isUpdateOwner")]);

	return config;
}

ZIMGroupInfo ZIMPluginConverter::cnvZIMGroupInfoToObject(FTMap infoMap) {
	ZIMGroupInfo info;
	info.groupID = std::get<std::string>(infoMap[FTValue("groupID")]);
	info.groupName = std::get<std::string>(infoMap[FTValue("groupName")]);
	info.groupAvatarUrl = std::get<std::string>(infoMap[FTValue("groupAvatarUrl")]);

	return info;
}

ZIMGroupAdvancedConfig ZIMPluginConverter::cnvZIMGroupAdvancedConfigToObject(FTMap configMap) {
	ZIMGroupAdvancedConfig config;
	config.groupNotice = std::get<std::string>(configMap[FTValue("groupNotice")]);
	if (std::holds_alternative<std::monostate>(configMap[FTValue("groupAttributes")])) {
        config.groupAttributes = std::unordered_map<std::string, std::string>();
    }else{
		config.groupAttributes = cnvFTMapToSTLMap(std::get<FTMap>(configMap[FTValue("groupAttributes")]));
	}
	return config;
}

ZIMGroupMemberQueryConfig ZIMPluginConverter::cnvZIMGroupMemberQueryConfigToObject(FTMap configMap) {
	ZIMGroupMemberQueryConfig config;
	config.count = (unsigned int)std::get<int32_t>(configMap[FTValue("count")]);
	config.nextFlag = (unsigned int)std::get<int32_t>(configMap[FTValue("nextFlag")]);

	return config;
}

ZIMGroupMessageReceiptMemberQueryConfig ZIMPluginConverter::cnvZIMGroupMessageReceiptMemberQueryConfigMapToObject(FTMap configMap){
	ZIMGroupMessageReceiptMemberQueryConfig config;
	config.count = std::get<int32_t>(configMap[FTValue("count")]);
	config.nextFlag = std::get<int32_t>(configMap[FTValue("nextFlag")]);
	return config;
}
