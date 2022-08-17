#include "ZIMPluginMethodHandler.h"
#include "ZIMPluginEventHandler.h"

#include <variant>
#include <functional>
#include <flutter/encodable_value.h>

#include "ZIMPluginConverter.h"

void ZIMPluginMethodHandler::getVersion(flutter::EncodableMap& argument,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result)
{
    result->Success(ZIM::getVersion());
}

void ZIMPluginMethodHandler::create(flutter::EncodableMap& argument,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result)
{
    unsigned int appID = 0;
    if (std::holds_alternative<int32_t>(argument[FTValue("appID")])) {
        appID = (unsigned int)std::get<int32_t>(argument[FTValue("appID")]);
    }
    else {
        appID = (unsigned int)std::get<int64_t>(argument[FTValue("appID")]);
    }

    this->zim = ZIM::create(appID);
    this->zim->setEventHandler(ZIMPluginEventHandler::getInstance());

    result->Success();
}

void ZIMPluginMethodHandler::destroy(flutter::EncodableMap& argument,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result)
{
    this->zim->destroy();
    this->zim = nullptr;

    result->Success();
}

void ZIMPluginMethodHandler::setLogConfig(flutter::EncodableMap& argument,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
    
    ZIMLogConfig logConfig;
    logConfig.logPath = std::get<std::string>(argument[FTValue("logPath")]);
    logConfig.logSize = std::get<int32_t>(argument[FTValue("logSize")]);

    ZIM::setLogConfig(logConfig);

    result->Success();

}

void ZIMPluginMethodHandler::setCacheConfig(flutter::EncodableMap& argument,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

    ZIMCacheConfig cacheConfig;
    cacheConfig.cachePath = std::get<std::string>(argument[FTValue("cachePath")]);

    ZIM::setCacheConfig(cacheConfig);

    result->Success();
}

void ZIMPluginMethodHandler::login(flutter::EncodableMap& argument,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

    ZIMUserInfo userInfo;
    userInfo.userID = std::get<std::string>(argument[FTValue("userID")]);
    userInfo.userName = std::get<std::string>(argument[FTValue("userName")]);
    auto token = std::get<std::string>(argument[FTValue("token")]);

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    this->zim->login(userInfo, token, [=](const ZIMError& errorInfo) {
        if (errorInfo.code == 0) {
            sharedPtrResult->Success();
        }
        else {
            sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}

void ZIMPluginMethodHandler::logout(flutter::EncodableMap& argument,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

    this->zim->logout();

    result->Success();
}

void ZIMPluginMethodHandler::uploadLog(flutter::EncodableMap& argument,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    this->zim->uploadLog([=](const ZIMError& errorInfo) {
        if (errorInfo.code == 0) {
            sharedPtrResult->Success();
        }
        else {
            sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}

void ZIMPluginMethodHandler::renewToken(flutter::EncodableMap& argument,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

    auto token = std::get<std::string>(argument[FTValue("token")]);
    
    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    this->zim->renewToken(token, [=](const std::string& token, const ZIMError& errorInfo) {
        if (errorInfo.code == 0) {
            FTMap retMap;
            retMap[FTValue("token")] = FTValue(token);

            sharedPtrResult->Success(retMap);
        }
        else {
            sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}

void ZIMPluginMethodHandler::updateUserName(flutter::EncodableMap& argument,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

    auto userName = std::get<std::string>(argument[FTValue("userName")]);

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    this->zim->updateUserName(userName, [=](const std::string& userName, const ZIMError& errorInfo) {
        if (errorInfo.code == 0) {
            FTMap retMap;
            retMap[FTValue("userName")] = FTValue(userName);

            sharedPtrResult->Success(retMap);
        }
        else {
            sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}

void ZIMPluginMethodHandler::updateUserExtendedData(flutter::EncodableMap& argument,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

    auto userExtendedData = std::get<std::string>(argument[FTValue("extendedData")]);

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    this->zim->updateUserExtendedData(userExtendedData, [=](const std::string& userExtendedData, const ZIMError& errorInfo) {
        if (errorInfo.code == 0) {
            FTMap retMap;
            retMap[FTValue("extendedData")] = FTValue(userExtendedData);
            sharedPtrResult->Success(retMap);
        }
        else {
            sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}

void ZIMPluginMethodHandler::queryUsersInfo(flutter::EncodableMap& argument,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

    auto userIDs = std::get<FTArray>(argument[FTValue("userIDs")]);
    std::vector<std::string> userIDsVec;
    for (auto& userIDValue : userIDs) {
        auto userID = std::get<std::string>(userIDValue);
        userIDsVec.emplace_back(userID);
    }

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    this->zim->queryUsersInfo(userIDsVec, [=](const std::vector<ZIMUserFullInfo>& userList,
        const std::vector<ZIMErrorUserInfo>& errorUserList, const ZIMError& errorInfo) {
        if (errorInfo.code == 0) {
            FTArray userFullInfoArray;
            for (auto& userFullInfo : userList) {
                auto userFullInfoMap = ZIMPluginConverter::cnvZIMUserFullInfoObjectToMap(userFullInfo);
                userFullInfoArray.emplace_back(userFullInfoMap);
            }

            FTArray errorUserInfoArray;
            for (auto& errorUserInfo : errorUserList) {
                auto errorUserInfoMap = ZIMPluginConverter::cnvZIMErrorUserInfoToMap(errorUserInfo);
                errorUserInfoArray.emplace_back(errorUserInfoArray);
            }

            FTMap retMap;
            retMap[FTValue("userList")] = userFullInfoArray;
            retMap[FTValue("errorUserList")] = errorUserInfoArray;

            sharedPtrResult->Success(retMap);
        }
        else {
            sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });

}

void ZIMPluginMethodHandler::queryConversationList(flutter::EncodableMap& argument,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

    FTMap configMap = std::get<FTMap>(argument[FTValue("config")]);
    ZIMConversationQueryConfig queryConfig;
    queryConfig.count = std::get<int32_t>(configMap[FTValue("count")]);
    queryConfig.nextConversation = nullptr;

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    this->zim->queryConversationList(queryConfig, [=](const std::vector<std::shared_ptr<ZIMConversation>>& conversationList,
        const ZIMError& errorInfo) {
        if (errorInfo.code == 0) {
            FTMap retMap;
            retMap[FTValue("conversationList")] = ZIMPluginConverter::cnvZIMConversationListToArray(conversationList);
            
            sharedPtrResult->Success(retMap);
        }
        else {
            sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
        }

    });
}

void ZIMPluginMethodHandler::deleteConversation(flutter::EncodableMap& argument,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

    auto conversationID = std::get<std::string>(argument[FTValue("conversationID")]);
    int conversationType = std::get<int32_t>(argument[FTValue("conversationType")]);
    auto configMap = std::get<FTMap>(argument[FTValue("config")]);

    ZIMConversationDeleteConfig deleteConfig = ZIMPluginConverter::cnvZIMConversationDeleteConfigToObject(configMap);
    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    this->zim->deleteConversation(conversationID, (ZIMConversationType)conversationType, deleteConfig, [=](const std::string& conversationID, ZIMConversationType conversationType,
        const ZIMError& errorInfo) {
        if (errorInfo.code == 0) {
            FTMap retMap;
            retMap[FTValue("conversationID")] = FTValue(conversationID);
            retMap[FTValue("conversationType")] = FTValue(conversationType);

            sharedPtrResult->Success(retMap);
        }
        else {
            sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}

void ZIMPluginMethodHandler::clearConversationUnreadMessageCount(flutter::EncodableMap& argument,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

    auto conversationID = std::get<std::string>(argument[FTValue("conversationID")]);
    int conversationType = std::get<int32_t>(argument[FTValue("conversationType")]);

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    this->zim->clearConversationUnreadMessageCount(conversationID, (ZIMConversationType)conversationType, [=](const std::string& conversationID, ZIMConversationType conversationType,
        const ZIMError& errorInfo) {
        if (errorInfo.code == 0) {
            FTMap retMap;
            retMap[FTValue("conversationID")] = FTValue(conversationID);
            retMap[FTValue("conversationType")] = FTValue(conversationType);

            sharedPtrResult->Success(retMap);
        }
        else {
            sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    
    });

}

void ZIMPluginMethodHandler::setConversationNotificationStatus(flutter::EncodableMap& argument,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

    auto conversationID = std::get<std::string>(argument[FTValue("conversationID")]);
    int conversationType = std::get<int32_t>(argument[FTValue("conversationType")]);

    int status = std::get<int32_t>(argument[FTValue("status")]);

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    this->zim->setConversationNotificationStatus((ZIMConversationNotificationStatus)status, conversationID, (ZIMConversationType)conversationType, [=](const std::string& conversationID, ZIMConversationType conversationType,
        const ZIMError& errorInfo) {
        if (errorInfo.code == 0) {
            FTMap retMap;
            retMap[FTValue("conversationID")] = FTValue(conversationID);
            retMap[FTValue("conversationType")] = FTValue(conversationType);

            sharedPtrResult->Success(retMap);
        }
        else {
            sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    
    });
}

void ZIMPluginMethodHandler::sendPeerMessage(flutter::EncodableMap& argument,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

    auto messagePtr = ZIMPluginConverter::cnvZIMMessageToObject(std::get<FTMap>(argument[FTValue("message")]));
    auto toUserID = std::get<std::string>(argument[FTValue("toUserID")]);

    FTMap configMap = std::get<FTMap>(argument[FTValue("config")]);
    ZIMMessageSendConfig config;
    std::shared_ptr<ZIMPushConfig> pushConfigPtr = nullptr;
    config.priority = (ZIMMessagePriority)std::get<int32_t>(configMap[FTValue("priority")]);
    if (std::holds_alternative<std::monostate>(configMap[FTValue("pushConfig")])) {
        config.pushConfig = nullptr;
    }
    else {
        pushConfigPtr = ZIMPluginConverter::cnvZIMPushConfigToObject(std::get<FTMap>(configMap[FTValue("pushConfig")]));
        config.pushConfig = pushConfigPtr.get();
    }

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    this->zim->sendPeerMessage(messagePtr.get(), toUserID, config, [=](const std::shared_ptr<ZIMMessage>& message, const ZIMError& errorInfo) {
        if (errorInfo.code == 0) {
            FTMap retMap;
            auto messageMap = ZIMPluginConverter::cnvZIMMessageObjectToMap(message.get());
            retMap[FTValue("message")] = messageMap;

            sharedPtrResult->Success(retMap);
        }
        else {
            sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}

void ZIMPluginMethodHandler::sendRoomMessage(flutter::EncodableMap& argument,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

    auto messagePtr = ZIMPluginConverter::cnvZIMMessageToObject(std::get<FTMap>(argument[FTValue("message")]));
    auto toRoomID = std::get<std::string>(argument[FTValue("toRoomID")]);

    FTMap configMap = std::get<FTMap>(argument[FTValue("config")]);
    ZIMMessageSendConfig config;
    std::shared_ptr<ZIMPushConfig> pushConfigPtr = nullptr;
    config.priority = (ZIMMessagePriority)std::get<int32_t>(configMap[FTValue("priority")]);
    if (std::holds_alternative<std::monostate>(configMap[FTValue("pushConfig")])) {
        config.pushConfig = nullptr;
    }
    else {
        pushConfigPtr = ZIMPluginConverter::cnvZIMPushConfigToObject(std::get<FTMap>(configMap[FTValue("pushConfig")]));
        config.pushConfig = pushConfigPtr.get();
    }

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    this->zim->sendRoomMessage(messagePtr.get(), toRoomID, config, [=](const std::shared_ptr<ZIMMessage>& message, const ZIMError& errorInfo) {
        if (errorInfo.code == 0) {
            FTMap retMap;
            auto messageMap = ZIMPluginConverter::cnvZIMMessageObjectToMap(message.get());
            retMap[FTValue("message")] = messageMap;

            sharedPtrResult->Success(retMap);
        }
        else {
            sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}

void ZIMPluginMethodHandler::sendGroupMessage(flutter::EncodableMap& argument,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

    auto messagePtr = ZIMPluginConverter::cnvZIMMessageToObject(std::get<FTMap>(argument[FTValue("message")]));
    auto toGroupID = std::get<std::string>(argument[FTValue("toGroupID")]);

    FTMap configMap = std::get<FTMap>(argument[FTValue("config")]);
    ZIMMessageSendConfig config;
    std::shared_ptr<ZIMPushConfig> pushConfigPtr = nullptr;
    config.priority = (ZIMMessagePriority)std::get<int32_t>(configMap[FTValue("priority")]);
    if (std::holds_alternative<std::monostate>(configMap[FTValue("pushConfig")])) {
        config.pushConfig = nullptr;
    }
    else {
        pushConfigPtr = ZIMPluginConverter::cnvZIMPushConfigToObject(std::get<FTMap>(configMap[FTValue("pushConfig")]));
        config.pushConfig = pushConfigPtr.get();
    }

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    this->zim->sendGroupMessage(messagePtr.get(), toGroupID, config, [=](const std::shared_ptr<ZIMMessage>& message, const ZIMError& errorInfo) {
        if (errorInfo.code == 0) {
            FTMap retMap;
            auto messageMap = ZIMPluginConverter::cnvZIMMessageObjectToMap(message.get());
            retMap[FTValue("message")] = messageMap;

            sharedPtrResult->Success(retMap);
        }
        else {
            sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}

void ZIMPluginMethodHandler::sendMediaMessage(flutter::EncodableMap& argument,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

    auto messagePtr = ZIMPluginConverter::cnvZIMMessageToObject(std::get<FTMap>(argument[FTValue("message")]));
    auto toConversationID = std::get<std::string>(argument[FTValue("toConversationID")]);
    auto conversationType = std::get<int32_t>(argument[FTValue("conversationType")]);

    FTMap configMap = std::get<FTMap>(argument[FTValue("config")]);
    ZIMMessageSendConfig config;
    std::shared_ptr<ZIMPushConfig> pushConfigPtr = nullptr;
    config.priority = (ZIMMessagePriority)std::get<int32_t>(configMap[FTValue("priority")]);
    if (std::holds_alternative<std::monostate>(configMap[FTValue("pushConfig")])) {
        config.pushConfig = nullptr;
    }
    else {
        pushConfigPtr = ZIMPluginConverter::cnvZIMPushConfigToObject(std::get<FTMap>(configMap[FTValue("pushConfig")]));
        config.pushConfig = pushConfigPtr.get();
    }

    auto mediaMessagePtr = std::static_pointer_cast<ZIMMediaMessage>(messagePtr);
    auto progressID = std::get<int32_t>(argument[FTValue("progressID")]);

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    this->zim->sendMediaMessage(mediaMessagePtr.get(), toConversationID, (ZIMConversationType)conversationType, config, [=](const std::shared_ptr<ZIMMediaMessage>& message, long long currentFileSize,
        long long totalFileSize) {

        FTMap progressRetMap;
        progressRetMap[FTValue("method")] = FTValue("uploadMediaProgress");
        progressRetMap[FTValue("progressID")] = FTValue(progressID);
        progressRetMap[FTValue("message")] = ZIMPluginConverter::cnvZIMMessageObjectToMap(message.get());
        progressRetMap[FTValue("currentFileSize")] = FTValue((int64_t)currentFileSize);
        progressRetMap[FTValue("totalFileSize")] = FTValue((int64_t)totalFileSize);
        ZIMPluginEventHandler::getInstance()->sendEvent(progressRetMap);

    }, [=](const std::shared_ptr<ZIMMessage>& message, const ZIMError& errorInfo) {
        if (errorInfo.code == 0) {
            FTMap retMap;
            auto messageMap = ZIMPluginConverter::cnvZIMMessageObjectToMap(message.get());
            retMap[FTValue("message")] = messageMap;

            sharedPtrResult->Success(retMap);
        }
        else {
            sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}

void ZIMPluginMethodHandler::downloadMediaFile(flutter::EncodableMap& argument,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

    auto fileType = std::get<int32_t>(argument[FTValue("fileType")]);
    auto messagePtr = ZIMPluginConverter::cnvZIMMessageToObject(std::get<FTMap>(argument[FTValue("message")]));
    
    auto mediaMessagePtr = std::static_pointer_cast<ZIMMediaMessage>(messagePtr);
    auto progressID = std::get<int32_t>(argument[FTValue("progressID")]);

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    this->zim->downloadMediaFile(mediaMessagePtr.get(), (ZIMMediaFileType)fileType, [=](const std::shared_ptr<ZIMMediaMessage>& message,
        unsigned int currentFileSize, unsigned int totalFileSize) {

        FTMap progressRetMap;
        progressRetMap[FTValue("method")] = FTValue("downloadMediaFileProgress");
        progressRetMap[FTValue("progressID")] = FTValue(progressID);
        progressRetMap[FTValue("message")] = ZIMPluginConverter::cnvZIMMessageObjectToMap(message.get());
        progressRetMap[FTValue("currentFileSize")] = FTValue((int64_t)currentFileSize);
        progressRetMap[FTValue("totalFileSize")] = FTValue((int64_t)totalFileSize);
        ZIMPluginEventHandler::getInstance()->sendEvent(progressRetMap);

    }, [=](const std::shared_ptr<ZIMMediaMessage>& message, const ZIMError& errorInfo) {
        if (errorInfo.code == 0) {
            FTMap retMap;
            auto messageMap = ZIMPluginConverter::cnvZIMMessageObjectToMap(message.get());
            retMap[FTValue("message")] = messageMap;

            sharedPtrResult->Success(retMap);
        }
        else {
            sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });

}

void ZIMPluginMethodHandler::queryHistoryMessage(flutter::EncodableMap& argument,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

    auto conversationID = std::get<std::string>(argument[FTValue("conversationID")]);
    int conversationType = std::get<int32_t>(argument[FTValue("conversationType")]);

    FTMap configMap = std::get<FTMap>(argument[FTValue("config")]);
    ZIMMessageQueryConfig config;
    config.count = std::get<int32_t>(configMap[FTValue("count")]);
    config.reverse = std::get<bool>(configMap[FTValue("reverse")]);
    
    std::shared_ptr<ZIMMessage> nextMessagePtr = nullptr;
    if (std::holds_alternative<std::monostate>(configMap[FTValue("nextMessage")])) {
        config.nextMessage = nullptr;
    }
    else {
        auto nextMessageMap = std::get<FTMap>(configMap[FTValue("nextMessage")]);
        nextMessagePtr = ZIMPluginConverter::cnvZIMMessageToObject(nextMessageMap);
        config.nextMessage = nextMessagePtr;
    }

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    this->zim->queryHistoryMessage(conversationID, (ZIMConversationType)conversationType, config, [=](const std::string& conversationID, ZIMConversationType conversationType,
        const std::vector<std::shared_ptr<ZIMMessage>>& messageList, const ZIMError& errorInfo) {
        if (errorInfo.code == 0) {
            FTMap retMap;
            auto messageArray = ZIMPluginConverter::cnvZIMMessageListToArray(messageList);
            retMap[FTValue("messageList")] = messageArray;
            retMap[FTValue("conversationID")] = FTValue(conversationID);
            retMap[FTValue("conversationType")] = FTValue(conversationType);

            sharedPtrResult->Success(retMap);
        }
        else {
            sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
    
}

void ZIMPluginMethodHandler::deleteAllMessage(flutter::EncodableMap& argument,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

    auto conversationID = std::get<std::string>(argument[FTValue("conversationID")]);
    int conversationType = std::get<int32_t>(argument[FTValue("conversationType")]);

    FTMap configMap = std::get<FTMap>(argument[FTValue("config")]);
    ZIMMessageDeleteConfig config;
    config.isAlsoDeleteServerMessage = std::get<bool>(configMap[FTValue("isAlsoDeleteServerMessage")]);

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    this->zim->deleteAllMessage(conversationID, (ZIMConversationType)conversationType, config, [=](const std::string& conversationID, ZIMConversationType conversationType,
        const ZIMError& errorInfo) {
        if (errorInfo.code == 0) {
            FTMap retMap;
            retMap[FTValue("conversationID")] = FTValue(conversationID);
            retMap[FTValue("conversationType")] = FTValue(conversationType);

            sharedPtrResult->Success(retMap);
        }
        else {
            sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });

}

void ZIMPluginMethodHandler::deleteMessages(flutter::EncodableMap& argument,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

    auto messageArray = std::get<FTArray>(argument[(FTValue("messageList"))]);
    auto messageObjectList = ZIMPluginConverter::cnvZIMMessageArrayToObjectList(messageArray);
    auto conversationID = std::get<std::string>(argument[FTValue("conversationID")]);
    int conversationType = std::get<int32_t>(argument[FTValue("conversationType")]);

    FTMap configMap = std::get<FTMap>(argument[FTValue("config")]);
    ZIMMessageDeleteConfig config;
    config.isAlsoDeleteServerMessage = std::get<bool>(configMap[FTValue("isAlsoDeleteServerMessage")]);

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    this->zim->deleteMessages(messageObjectList, conversationID, (ZIMConversationType)conversationType, config, [=](const std::string& conversationID, ZIMConversationType conversationType,
        const ZIMError& errorInfo) {
        if (errorInfo.code == 0) {
            FTMap retMap;
            retMap[FTValue("conversationID")] = FTValue(conversationID);
            retMap[FTValue("conversationType")] = FTValue(conversationType);

            sharedPtrResult->Success(retMap);
        }
        else {
            sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });

}

void ZIMPluginMethodHandler::createRoom(flutter::EncodableMap& argument,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

    auto roomInfo = ZIMPluginConverter::cnvZIMRoomInfoToObject(std::get<FTMap>(argument[FTValue("roomInfo")]));

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    this->zim->createRoom(roomInfo, [=](const ZIMRoomFullInfo& roomInfo, const ZIMError& errorInfo) {
        if (errorInfo.code == 0) {
            FTMap retMap;
            auto roomFullInfoMap = ZIMPluginConverter::cnvZIMRoomFullInfoToMap(roomInfo);
            retMap[FTValue("roomInfo")] = roomFullInfoMap;

            sharedPtrResult->Success(retMap);
        }
        else {
            sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}

void ZIMPluginMethodHandler::createRoomWithConfig(flutter::EncodableMap& argument,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

    auto roomInfo = ZIMPluginConverter::cnvZIMRoomInfoToObject(std::get<FTMap>(argument[FTValue("roomInfo")]));
    auto roomAdvancedConfig = ZIMPluginConverter::cnvZIMRoomAdvancedConfigToObject(std::get<FTMap>(argument[FTValue("config")]));

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    this->zim->createRoom(roomInfo, roomAdvancedConfig, [=](const ZIMRoomFullInfo& roomInfo, const ZIMError& errorInfo) {
        if (errorInfo.code == 0) {
            FTMap retMap;
            auto roomFullInfoMap = ZIMPluginConverter::cnvZIMRoomFullInfoToMap(roomInfo);
            retMap[FTValue("roomInfo")] = roomFullInfoMap;

            sharedPtrResult->Success(retMap);
        }
        else {
            sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}

void ZIMPluginMethodHandler::enterRoom(flutter::EncodableMap& argument,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

    auto roomInfo = ZIMPluginConverter::cnvZIMRoomInfoToObject(std::get<FTMap>(argument[FTValue("roomInfo")]));
    auto roomAdvancedConfig = ZIMPluginConverter::cnvZIMRoomAdvancedConfigToObject(std::get<FTMap>(argument[FTValue("config")]));

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    this->zim->enterRoom(roomInfo, roomAdvancedConfig, [=](const ZIMRoomFullInfo& roomInfo, const ZIMError& errorInfo) {
        if (errorInfo.code == 0) {
            FTMap retMap;
            auto roomFullInfoMap = ZIMPluginConverter::cnvZIMRoomFullInfoToMap(roomInfo);
            retMap[FTValue("roomInfo")] = roomFullInfoMap;

            sharedPtrResult->Success(retMap);
        }
        else {
            sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}

void ZIMPluginMethodHandler::joinRoom(flutter::EncodableMap& argument,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

    auto roomID = std::get<std::string>(argument[FTValue("roomID")]);

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    this->zim->joinRoom(roomID, [=](const ZIMRoomFullInfo& roomInfo, const ZIMError& errorInfo) {
        if (errorInfo.code == 0) {
            FTMap retMap;
            auto roomFullInfoMap = ZIMPluginConverter::cnvZIMRoomFullInfoToMap(roomInfo);
            retMap[FTValue("roomInfo")] = roomFullInfoMap;

            sharedPtrResult->Success(retMap);
        }
        else {
            sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}

void ZIMPluginMethodHandler::leaveRoom(flutter::EncodableMap& argument,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

    auto roomID = std::get<std::string>(argument[FTValue("roomID")]);

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    this->zim->leaveRoom(roomID, [=](const std::string& roomID, const ZIMError& errorInfo) {
        if (errorInfo.code == 0) {
            FTMap retMap;
            retMap[FTValue("roomID")] = FTValue(roomID);

            sharedPtrResult->Success(retMap);
        }
        else {
            sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}

void ZIMPluginMethodHandler::queryRoomMemberList(flutter::EncodableMap& argument,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

    auto roomID = std::get<std::string>(argument[FTValue("roomID")]);
    auto queryConfig = ZIMPluginConverter::cnvZIMRoomMemberQueryConfigToObject(std::get<FTMap>(argument[FTValue("config")]));

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    this->zim->queryRoomMemberList(roomID, queryConfig, [=](const std::string& roomID, const std::vector<ZIMUserInfo>& memberList,
        const std::string& nextFlag, const ZIMError& errorInfo) {
        if (errorInfo.code == 0) {
            FTMap retMap;
            retMap[FTValue("memberList")] = ZIMPluginConverter::cnvZIMUserListToArray(memberList);
            retMap[FTValue("roomID")] = FTValue(roomID);
            retMap[FTValue("nextFlag")] = FTValue(nextFlag);

            sharedPtrResult->Success(retMap);
        }
        else {
            sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}

void ZIMPluginMethodHandler::queryRoomOnlineMemberCount(flutter::EncodableMap& argument,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

    auto roomID = std::get<std::string>(argument[FTValue("roomID")]);

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    this->zim->queryRoomOnlineMemberCount(roomID, [=](const std::string& roomID, unsigned int count, const ZIMError& errorInfo) {
        if (errorInfo.code == 0) {
            FTMap retMap;
            retMap[FTValue("roomID")] = FTValue(roomID);
            retMap[FTValue("count")] = FTValue((int32_t)count);

            sharedPtrResult->Success(retMap);
        }
        else {
            sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}

void ZIMPluginMethodHandler::setRoomAttributes(flutter::EncodableMap& argument,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

    auto roomID = std::get<std::string>(argument[FTValue("roomID")]);
    auto roomAttributes = ZIMPluginConverter::cnvFTMapToSTLMap(std::get<FTMap>(argument[FTValue("roomAttributes")]));
    auto roomAttributesSetConfig = ZIMPluginConverter::cnvZIMRoomAttributesSetConfigToObject(std::get<FTMap>(argument[FTValue("config")]));

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    this->zim->setRoomAttributes(roomAttributes, roomID, &roomAttributesSetConfig, [=](const std::string& roomID, const std::vector<std::string>& errorKeyList,
        const ZIMError& errorInfo) {
        if (errorInfo.code == 0) {
            FTMap retMap;
            retMap[FTValue("roomID")] = FTValue(roomID);
            retMap[FTValue("errorKeys")] = ZIMPluginConverter::cnvStlVectorToFTArray(errorKeyList);

            sharedPtrResult->Success(retMap);
        }
        else {
            sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}

void ZIMPluginMethodHandler::deleteRoomAttributes(flutter::EncodableMap& argument,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

    auto roomID = std::get<std::string>(argument[FTValue("roomID")]);
    auto keys = ZIMPluginConverter::cnvFTArrayToStlVector(std::get<FTArray>(argument[FTValue("keys")]));
    auto roomAttributesDeleteConfig = ZIMPluginConverter::cnvZIMRoomAttributesDeleteConfigToObject(std::get<FTMap>(argument[FTValue("config")]));

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    this->zim->deleteRoomAttributes(keys, roomID, &roomAttributesDeleteConfig, [=](const std::string& roomID, const std::vector<std::string>& errorKeyList,
        const ZIMError& errorInfo) {
        if (errorInfo.code == 0) {
            FTMap retMap;
            retMap[FTValue("roomID")] = FTValue(roomID);
            retMap[FTValue("errorKeys")] = ZIMPluginConverter::cnvStlVectorToFTArray(errorKeyList);

            sharedPtrResult->Success(retMap);
        }
        else {
            sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });

}

void ZIMPluginMethodHandler::beginRoomAttributesBatchOperation(flutter::EncodableMap& argument,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

    auto roomID = std::get<std::string>(argument[FTValue("roomID")]);
    auto config = ZIMPluginConverter::cnvZIMRoomAttributesBatchOperationConfigToObject(std::get<FTMap>(argument[FTValue("config")]));

    this->zim->beginRoomAttributesBatchOperation(roomID, &config);
    result->Success();
}

void ZIMPluginMethodHandler::endRoomAttributesBatchOperation(flutter::EncodableMap& argument,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

    auto roomID = std::get<std::string>(argument[FTValue("roomID")]);
    
    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    this->zim->endRoomAttributesBatchOperation(roomID, [=](const std::string& roomID, const ZIMError& errorInfo) {
        if (errorInfo.code == 0) {
            FTMap retMap;
            retMap[FTValue("roomID")] = FTValue(roomID);

            sharedPtrResult->Success(retMap);
        }
        else {
            sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}

void ZIMPluginMethodHandler::queryRoomAllAttributes(flutter::EncodableMap& argument,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

    auto roomID = std::get<std::string>(argument[FTValue("roomID")]);

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    this->zim->queryRoomAllAttributes(roomID, [=](const std::string& roomID, const std::unordered_map<std::string, std::string>& roomAttributes,
        const ZIMError& errorInfo) {
        if (errorInfo.code == 0) {
            FTMap retMap;
            retMap[FTValue("roomID")] = FTValue(roomID);
            retMap[FTValue("roomAttributes")] = ZIMPluginConverter::cnvSTLMapToFTMap(roomAttributes);

            sharedPtrResult->Success(retMap);
        }
        else {
            sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}

void ZIMPluginMethodHandler::createGroup(flutter::EncodableMap& argument,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

    auto groupInfo = ZIMPluginConverter::cnvZIMGroupInfoToObject(std::get<FTMap>(argument[FTValue("groupInfo")]));
    auto userIDs = ZIMPluginConverter::cnvFTArrayToStlVector(std::get<FTArray>(argument[FTValue("userIDs")]));

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    this->zim->createGroup(groupInfo, userIDs, [=](const ZIMGroupFullInfo& groupInfo, const std::vector<ZIMGroupMemberInfo>& userList,
        const std::vector<ZIMErrorUserInfo>& errorUserList, const ZIMError& errorInfo) {
        if (errorInfo.code == 0) {
            FTMap retMap;
            retMap[FTValue("groupInfo")] = ZIMPluginConverter::cnvZIMGroupFullInfoToMap(groupInfo);
            retMap[FTValue("userList")] = ZIMPluginConverter::cnvZIMGroupMemberInfoListToArray(userList);
            retMap[FTValue("errorUserList")] = ZIMPluginConverter::cnvZIMErrorUserListToArray(errorUserList);

            sharedPtrResult->Success(retMap);
        }
        else {
            sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}

void ZIMPluginMethodHandler::createGroupWithConfig(flutter::EncodableMap& argument,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

    auto groupInfo = ZIMPluginConverter::cnvZIMGroupInfoToObject(std::get<FTMap>(argument[FTValue("groupInfo")]));
    auto userIDs = ZIMPluginConverter::cnvFTArrayToStlVector(std::get<FTArray>(argument[FTValue("userIDs")]));
    auto config = ZIMPluginConverter::cnvZIMGroupAdvancedConfigToObject(std::get<FTMap>(argument[FTValue("config")]));

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    this->zim->createGroup(groupInfo, userIDs, config, [=](const ZIMGroupFullInfo& groupInfo, const std::vector<ZIMGroupMemberInfo>& userList,
        const std::vector<ZIMErrorUserInfo>& errorUserList, const ZIMError& errorInfo) {
        if (errorInfo.code == 0) {
            FTMap retMap;
            retMap[FTValue("groupInfo")] = ZIMPluginConverter::cnvZIMGroupFullInfoToMap(groupInfo);
            retMap[FTValue("userList")] = ZIMPluginConverter::cnvZIMGroupMemberInfoListToArray(userList);
            retMap[FTValue("errorUserList")] = ZIMPluginConverter::cnvZIMErrorUserListToArray(errorUserList);

            sharedPtrResult->Success(retMap);
        }
        else {
            sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}

void ZIMPluginMethodHandler::joinGroup(flutter::EncodableMap& argument,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

    auto groupID = std::get<std::string>(argument[FTValue("groupID")]);

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    this->zim->joinGroup(groupID, [=](const ZIMGroupFullInfo& groupInfo, const ZIMError& errorInfo) {
        if (errorInfo.code == 0) {
            FTMap retMap;
            retMap[FTValue("groupInfo")] = ZIMPluginConverter::cnvZIMGroupFullInfoToMap(groupInfo);

            sharedPtrResult->Success(retMap);
        }
        else {
            sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}

void ZIMPluginMethodHandler::dismissGroup(flutter::EncodableMap& argument,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

    auto groupID = std::get<std::string>(argument[FTValue("groupID")]);

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    this->zim->dismissGroup(groupID, [=](const std::string& groupID, const ZIMError& errorInfo) {
        if (errorInfo.code == 0) {
            FTMap retMap;
            retMap[FTValue("groupID")] = FTValue(groupID);

            sharedPtrResult->Success(retMap);
        }
        else {
            sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}

void ZIMPluginMethodHandler::leaveGroup(flutter::EncodableMap& argument,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

    auto groupID = std::get<std::string>(argument[FTValue("groupID")]);

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    this->zim->leaveGroup(groupID, [=](const std::string& groupID, const ZIMError& errorInfo) {
        if (errorInfo.code == 0) {
            FTMap retMap;
            retMap[FTValue("groupID")] = FTValue(groupID);

            sharedPtrResult->Success(retMap);
        }
        else {
            sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}

void ZIMPluginMethodHandler::inviteUsersIntoGroup(flutter::EncodableMap& argument,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

    auto groupID = std::get<std::string>(argument[FTValue("groupID")]);
    auto userIDs = ZIMPluginConverter::cnvFTArrayToStlVector(std::get<FTArray>(argument[FTValue("userIDs")]));

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    this->zim->inviteUsersIntoGroup(userIDs, groupID, [=](const std::string& groupID, const std::vector<ZIMGroupMemberInfo>& userList,
        const std::vector<ZIMErrorUserInfo>& errorUserList, const ZIMError& errorInfo) {
        if (errorInfo.code == 0) {
            FTMap retMap;
            retMap[FTValue("groupID")] = FTValue(groupID);
            retMap[FTValue("userList")] = ZIMPluginConverter::cnvZIMGroupMemberInfoListToArray(userList);
            retMap[FTValue("errorUserList")] = ZIMPluginConverter::cnvZIMErrorUserListToArray(errorUserList);

            sharedPtrResult->Success(retMap);
        }
        else {
            sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}

void ZIMPluginMethodHandler::kickGroupMembers(flutter::EncodableMap& argument,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

    auto groupID = std::get<std::string>(argument[FTValue("groupID")]);
    auto userIDs = ZIMPluginConverter::cnvFTArrayToStlVector(std::get<FTArray>(argument[FTValue("userIDs")]));

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    this->zim->kickGroupMembers(userIDs, groupID, [=](const std::string& groupID, const std::vector<std::string>& kickedUserIDList,
        const std::vector<ZIMErrorUserInfo>& errorUserList, const ZIMError& errorInfo) {
        if (errorInfo.code == 0) {
            FTMap retMap;
            retMap[FTValue("groupID")] = FTValue(groupID);
            retMap[FTValue("kickedUserIDList")] = ZIMPluginConverter::cnvStlVectorToFTArray(kickedUserIDList);
            retMap[FTValue("errorUserList")] = ZIMPluginConverter::cnvZIMErrorUserListToArray(errorUserList);

            sharedPtrResult->Success(retMap);
        }
        else {
            sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}

void ZIMPluginMethodHandler::transferGroupOwner(flutter::EncodableMap& argument,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

    auto groupID = std::get<std::string>(argument[FTValue("groupID")]);
    auto toUserID = std::get<std::string>(argument[FTValue("toUserID")]);

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    this->zim->transferGroupOwner(toUserID, groupID, [=](const std::string& groupID, const std::string& toUserID, const ZIMError& errorInfo) {
        if (errorInfo.code == 0) {
            FTMap retMap;
            retMap[FTValue("groupID")] = FTValue(groupID);
            retMap[FTValue("toUserID")] = FTValue(toUserID);

            sharedPtrResult->Success(retMap);
        }
        else {
            sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}

void ZIMPluginMethodHandler::updateGroupName(flutter::EncodableMap& argument,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

    auto groupID = std::get<std::string>(argument[FTValue("groupID")]);
    auto groupName = std::get<std::string>(argument[FTValue("groupName")]);

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    this->zim->updateGroupName(groupName, groupID, [=](const std::string& groupID, const std::string& groupName, const ZIMError& errorInfo) {
        if (errorInfo.code == 0) {
            FTMap retMap;
            retMap[FTValue("groupID")] = FTValue(groupID);
            retMap[FTValue("groupName")] = FTValue(groupName);

            sharedPtrResult->Success(retMap);
        }
        else {
            sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}

void ZIMPluginMethodHandler::updateGroupNotice(flutter::EncodableMap& argument,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

    auto groupID = std::get<std::string>(argument[FTValue("groupID")]);
    auto groupNotice = std::get<std::string>(argument[FTValue("groupNotice")]);

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    this->zim->updateGroupNotice(groupNotice, groupID, [=](const std::string& groupID, const std::string& groupNotice, const ZIMError& errorInfo) {
        if (errorInfo.code == 0) {
            FTMap retMap;
            retMap[FTValue("groupID")] = FTValue(groupID);
            retMap[FTValue("groupNotice")] = FTValue(groupNotice);

            sharedPtrResult->Success(retMap);
        }
        else {
            sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}

void ZIMPluginMethodHandler::queryGroupInfo(flutter::EncodableMap& argument,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

    auto groupID = std::get<std::string>(argument[FTValue("groupID")]);

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    this->zim->queryGroupInfo(groupID, [=](const ZIMGroupFullInfo& groupInfo, const ZIMError& errorInfo) {
        if (errorInfo.code == 0) {
            FTMap retMap;
            retMap[FTValue("groupInfo")] = ZIMPluginConverter::cnvZIMGroupFullInfoToMap(groupInfo);

            sharedPtrResult->Success(retMap);
        }
        else {
            sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}

void ZIMPluginMethodHandler::setGroupAttributes(flutter::EncodableMap& argument,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

    auto groupID = std::get<std::string>(argument[FTValue("groupID")]);
    auto groupAttributes = ZIMPluginConverter::cnvFTMapToSTLMap(std::get<FTMap>(argument[FTValue("groupAttributes")]));

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    this->zim->setGroupAttributes(groupAttributes, groupID, [=](const std::string& groupID, const std::vector<std::string>& errorKeys,
        const ZIMError& errorInfo) {
        if (errorInfo.code == 0) {
            FTMap retMap;
            retMap[FTValue("groupID")] = FTValue(groupID);
            retMap[FTValue("errorKeys")] = ZIMPluginConverter::cnvStlVectorToFTArray(errorKeys);

            sharedPtrResult->Success(retMap);
        }
        else {
            sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}

void ZIMPluginMethodHandler::deleteGroupAttributes(flutter::EncodableMap& argument,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

    auto groupID = std::get<std::string>(argument[FTValue("groupID")]);
    auto keys = ZIMPluginConverter::cnvFTArrayToStlVector(std::get<FTArray>(argument[FTValue("keys")]));

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    this->zim->deleteGroupAttributes(keys, groupID, [=](const std::string& groupID, const std::vector<std::string>& errorKeys,
        const ZIMError& errorInfo) {
        if (errorInfo.code == 0) {
            FTMap retMap;
            retMap[FTValue("groupID")] = FTValue(groupID);
            retMap[FTValue("errorKeys")] = ZIMPluginConverter::cnvStlVectorToFTArray(errorKeys);

            sharedPtrResult->Success(retMap);
        }
        else {
            sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}

void ZIMPluginMethodHandler::queryGroupAttributes(flutter::EncodableMap& argument,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

    auto groupID = std::get<std::string>(argument[FTValue("groupID")]);
    auto keys = ZIMPluginConverter::cnvFTArrayToStlVector(std::get<FTArray>(argument[FTValue("keys")]));

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    this->zim->queryGroupAttributes(keys, groupID, [=](const std::string& groupID, const std::unordered_map<std::string, std::string>& groupAttributes,
        const ZIMError& errorInfo) {
        if (errorInfo.code == 0) {
            FTMap retMap;
            retMap[FTValue("groupID")] = FTValue(groupID);
            retMap[FTValue("groupAttributes")] = ZIMPluginConverter::cnvSTLMapToFTMap(groupAttributes);

            sharedPtrResult->Success(retMap);
        }
        else {
            sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}

void ZIMPluginMethodHandler::queryGroupAllAttributes(flutter::EncodableMap& argument,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

    auto groupID = std::get<std::string>(argument[FTValue("groupID")]);

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    this->zim->queryGroupAllAttributes(groupID, [=](const std::string& groupID, const std::unordered_map<std::string, std::string>& groupAttributes,
        const ZIMError& errorInfo) {
        if (errorInfo.code == 0) {
            FTMap retMap;
            retMap[FTValue("groupID")] = FTValue(groupID);
            retMap[FTValue("groupAttributes")] = ZIMPluginConverter::cnvSTLMapToFTMap(groupAttributes);

            sharedPtrResult->Success(retMap);
        }
        else {
            sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}

void ZIMPluginMethodHandler::setGroupMemberRole(flutter::EncodableMap& argument,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

    auto groupID = std::get<std::string>(argument[FTValue("groupID")]);
    int role = std::get<int32_t>(argument[FTValue("role")]);
    auto forUserID = std::get<std::string>(argument[FTValue("forUserID")]);

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    this->zim->setGroupMemberRole(role, forUserID, groupID, [=](const std::string& groupID, const std::string& forUserID,
        ZIMGroupMemberRole role, const ZIMError& errorInfo) {
        if (errorInfo.code == 0) {
            FTMap retMap;
            retMap[FTValue("groupID")] = FTValue(groupID);
            retMap[FTValue("forUserID")] = FTValue(forUserID);
            retMap[FTValue("role")] = FTValue((int32_t)role);

            sharedPtrResult->Success(retMap);
        }
        else {
            sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}

void ZIMPluginMethodHandler::setGroupMemberNickname(flutter::EncodableMap& argument,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

    auto groupID = std::get<std::string>(argument[FTValue("groupID")]);
    auto nickname = std::get<std::string>(argument[FTValue("nickname")]);
    auto forUserID = std::get<std::string>(argument[FTValue("forUserID")]);

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    this->zim->setGroupMemberNickname(nickname, forUserID, groupID, [=](const std::string& groupID, const std::string& forUserID,
        const std::string& nickname, const ZIMError& errorInfo) {
        if (errorInfo.code == 0) {
            FTMap retMap;
            retMap[FTValue("groupID")] = FTValue(groupID);
            retMap[FTValue("forUserID")] = FTValue(forUserID);
            retMap[FTValue("nickname")] = FTValue(nickname);

            sharedPtrResult->Success(retMap);
        }
        else {
            sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}

void ZIMPluginMethodHandler::queryGroupMemberInfo(flutter::EncodableMap& argument,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

    auto groupID = std::get<std::string>(argument[FTValue("groupID")]);
    auto userID = std::get<std::string>(argument[FTValue("userID")]);

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    this->zim->queryGroupMemberInfo(userID, groupID, [=](const std::string& groupID, const ZIMGroupMemberInfo& userInfo, const ZIMError& errorInfo) {
        if (errorInfo.code == 0) {
            FTMap retMap;
            retMap[FTValue("groupID")] = FTValue(groupID);
            retMap[FTValue("userInfo")] = ZIMPluginConverter::cnvZIMGroupMemberInfoToMap(userInfo);

            sharedPtrResult->Success(retMap);
        }
        else {
            sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}

void ZIMPluginMethodHandler::queryGroupList(flutter::EncodableMap& argument,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    this->zim->queryGroupList([=](const std::vector<ZIMGroup>& groupList, const ZIMError& errorInfo) {
        if (errorInfo.code == 0) {
            FTMap retMap;
            retMap[FTValue("groupList")] = ZIMPluginConverter::cnvZIMGroupListToArray(groupList);

            sharedPtrResult->Success(retMap);
        }
        else {
            sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}

void ZIMPluginMethodHandler::queryGroupMemberList(flutter::EncodableMap& argument,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

    auto groupID = std::get<std::string>(argument[FTValue("groupID")]);
    auto config = ZIMPluginConverter::cnvZIMGroupMemberQueryConfigToObject(std::get<FTMap>(argument[FTValue("config")]));

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    this->zim->queryGroupMemberList(groupID, config, [=](const std::string& groupID, const std::vector<ZIMGroupMemberInfo>& userList,
        unsigned int nextFlag, const ZIMError& errorInfo) {
        if (errorInfo.code == 0) {
            FTMap retMap;
            retMap[FTValue("groupID")] = FTValue(groupID);
            retMap[FTValue("userList")] = ZIMPluginConverter::cnvZIMGroupMemberInfoListToArray(userList);
            retMap[FTValue("nextFlag")] = FTValue((int32_t)nextFlag);

            sharedPtrResult->Success(retMap);
        }
        else {
            sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}

void ZIMPluginMethodHandler::queryGroupMemberCount(flutter::EncodableMap& argument,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

    auto groupID = std::get<std::string>(argument[FTValue("groupID")]);

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    this->zim->queryGroupMemberCount(groupID, [=](const std::string& groupID, unsigned int count, const ZIMError& errorInfo) {
        if (errorInfo.code == 0) {
            FTMap retMap;
            retMap[FTValue("groupID")] = FTValue(groupID);
            retMap[FTValue("count")] = FTValue((int32_t)count);

            sharedPtrResult->Success(retMap);
        }
        else {
            sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}

void ZIMPluginMethodHandler::callInvite(flutter::EncodableMap& argument,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

    auto invitees = ZIMPluginConverter::cnvFTArrayToStlVector(std::get<FTArray>(argument[FTValue("invitees")]));
    auto configMap = std::get<FTMap>(argument[FTValue("config")]);

    ZIMCallInviteConfig config;
    config.timeout = std::get<int32_t>(configMap[FTValue("timeout")]);
    config.extendedData = std::get<std::string>(configMap[FTValue("extendedData")]);

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    this->zim->callInvite(invitees, config, [=](const std::string& callID, const ZIMCallInvitationSentInfo& info, const ZIMError& errorInfo) {
        if (errorInfo.code == 0) {
            FTMap retMap;
            retMap[FTValue("callID")] = FTValue(callID);
            retMap[FTValue("info")] = ZIMPluginConverter::cnvZIMCallInvitationSentInfoToMap(info);

            sharedPtrResult->Success(retMap);
        }
        else {
            sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}

void ZIMPluginMethodHandler::callCancel(flutter::EncodableMap& argument,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

    auto invitees = ZIMPluginConverter::cnvFTArrayToStlVector(std::get<FTArray>(argument[FTValue("invitees")]));
    auto callID = std::get<std::string>(argument[FTValue("callID")]);
    auto configMap = std::get<FTMap>(argument[FTValue("config")]);

    ZIMCallCancelConfig config;
    config.extendedData = std::get<std::string>(configMap[FTValue("extendedData")]);

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    this->zim->callCancel(invitees, callID, config, [=](const std::string& callID, const std::vector<std::string>& errorInvitees,
        const ZIMError& errorInfo) {
        if (errorInfo.code == 0) {
            FTMap retMap;
            retMap[FTValue("callID")] = FTValue(callID);
            retMap[FTValue("errorInvitees")] = ZIMPluginConverter::cnvStlVectorToFTArray(errorInvitees);

            sharedPtrResult->Success(retMap);
        }
        else {
            sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}

void ZIMPluginMethodHandler::callAccept(flutter::EncodableMap& argument,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

    auto callID = std::get<std::string>(argument[FTValue("callID")]);
    auto configMap = std::get<FTMap>(argument[FTValue("config")]);

    ZIMCallAcceptConfig config;
    config.extendedData = std::get<std::string>(configMap[FTValue("extendedData")]);

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    this->zim->callAccept(callID, config, [=](const std::string& callID, const ZIMError& errorInfo) {
        if (errorInfo.code == 0) {
            FTMap retMap;
            retMap[FTValue("callID")] = FTValue(callID);

            sharedPtrResult->Success(retMap);
        }
        else {
            sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}

void ZIMPluginMethodHandler::callReject(flutter::EncodableMap& argument,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

    auto callID = std::get<std::string>(argument[FTValue("callID")]);
    auto configMap = std::get<FTMap>(argument[FTValue("config")]);

    ZIMCallRejectConfig config;
    config.extendedData = std::get<std::string>(configMap[FTValue("extendedData")]);

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    this->zim->callReject(callID, config, [=](const std::string& callID, const ZIMError& errorInfo) {
        if (errorInfo.code == 0) {
            FTMap retMap;
            retMap[FTValue("callID")] = FTValue(callID);

            sharedPtrResult->Success(retMap);
        }
        else {
            sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}


