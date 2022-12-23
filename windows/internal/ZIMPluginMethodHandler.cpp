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
    ZIM* oldZIM = ZIM::getInstance();
    if (oldZIM) {
        oldZIM->destroy();
    }

    auto handle = std::get<std::string>(argument[FTValue("handle")]);

    auto configMap = std::get<FTMap>(argument[FTValue("config")]);

    unsigned int appID = 0;
    if (std::holds_alternative<int32_t>(configMap[FTValue("appID")])) {
        appID = (unsigned int)std::get<int32_t>(configMap[FTValue("appID")]);
    }
    else {
        appID = (unsigned int)std::get<int64_t>(configMap[FTValue("appID")]);
    }
    auto appSign = std::get<std::string>(configMap[FTValue("appSign")]);

    ZIMAppConfig appConfig;
    appConfig.appID = appID;
    appConfig.appSign = appSign;

    auto zim = ZIM::create(appConfig);
    if (zim) {
        this->engineMap[handle] = zim;
        ZIMPluginEventHandler::getInstance()->engineEventMap[zim] = handle;
        zim->setEventHandler(ZIMPluginEventHandler::getInstance());
    }
    
    result->Success();
}

void ZIMPluginMethodHandler::destroy(flutter::EncodableMap& argument,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result)
{
    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (zim) {
        zim->destroy();

        this->engineMap.erase(handle);
        ZIMPluginEventHandler::getInstance()->engineEventMap.erase(zim);
    }

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

    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }

    ZIMUserInfo userInfo;
    userInfo.userID = std::get<std::string>(argument[FTValue("userID")]);
    userInfo.userName = std::get<std::string>(argument[FTValue("userName")]);
    std::string token;
    if (std::holds_alternative<std::string>(argument[FTValue("token")])) {
        token = std::get<std::string>(argument[FTValue("token")]);
    }

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    zim->login(userInfo, token, [=](const ZIMError& errorInfo) {
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

    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }

    zim->logout();

    result->Success();
}

void ZIMPluginMethodHandler::uploadLog(flutter::EncodableMap& argument,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    zim->uploadLog([=](const ZIMError& errorInfo) {
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

    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }

    auto token = std::get<std::string>(argument[FTValue("token")]);
    
    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    zim->renewToken(token, [=](const std::string& token, const ZIMError& errorInfo) {
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

    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }

    auto userName = std::get<std::string>(argument[FTValue("userName")]);

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    zim->updateUserName(userName, [=](const std::string& userName, const ZIMError& errorInfo) {
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

void ZIMPluginMethodHandler::updateUserAvatarUrl(flutter::EncodableMap& argument,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }

    auto userAvatarUrl = std::get<std::string>(argument[FTValue("userAvatarUrl")]);

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    zim->updateUserAvatarUrl(userAvatarUrl, [=](const std::string& userAvatarUrl, const ZIMError& errorInfo) {
        if (errorInfo.code == 0) {
            FTMap retMap;
            retMap[FTValue("userAvatarUrl")] = FTValue(userAvatarUrl);

            sharedPtrResult->Success(retMap);
        }
        else {
            sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}

void ZIMPluginMethodHandler::updateUserExtendedData(flutter::EncodableMap& argument,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }

    auto userExtendedData = std::get<std::string>(argument[FTValue("extendedData")]);

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    zim->updateUserExtendedData(userExtendedData, [=](const std::string& userExtendedData, const ZIMError& errorInfo) {
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
    
    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }

    auto userIDs = std::get<FTArray>(argument[FTValue("userIDs")]);
    std::vector<std::string> userIDsVec;
    for (auto& userIDValue : userIDs) {
        auto userID = std::get<std::string>(userIDValue);
        userIDsVec.emplace_back(userID);
    }

    auto configMap = std::get<FTMap>(argument[FTValue("config")]);
    ZIMUsersInfoQueryConfig config;
    config.isQueryFromServer = std::get<bool>(configMap[FTValue("isQueryFromServer")]);

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    zim->queryUsersInfo(userIDsVec, config, [=](const std::vector<ZIMUserFullInfo>& userList,
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

    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }

    FTMap configMap = std::get<FTMap>(argument[FTValue("config")]);
    ZIMConversationQueryConfig queryConfig;
    queryConfig.count = std::get<int32_t>(configMap[FTValue("count")]);
    queryConfig.nextConversation = nullptr;

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    zim->queryConversationList(queryConfig, [=](const std::vector<std::shared_ptr<ZIMConversation>>& conversationList,
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

    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }

    auto conversationID = std::get<std::string>(argument[FTValue("conversationID")]);
    int conversationType = std::get<int32_t>(argument[FTValue("conversationType")]);
    auto configMap = std::get<FTMap>(argument[FTValue("config")]);

    ZIMConversationDeleteConfig deleteConfig = ZIMPluginConverter::cnvZIMConversationDeleteConfigToObject(configMap);
    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    zim->deleteConversation(conversationID, (ZIMConversationType)conversationType, deleteConfig, [=](const std::string& conversationID, ZIMConversationType conversationType,
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

    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }

    auto conversationID = std::get<std::string>(argument[FTValue("conversationID")]);
    int conversationType = std::get<int32_t>(argument[FTValue("conversationType")]);

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    zim->clearConversationUnreadMessageCount(conversationID, (ZIMConversationType)conversationType, [=](const std::string& conversationID, ZIMConversationType conversationType,
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

    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }

    auto conversationID = std::get<std::string>(argument[FTValue("conversationID")]);
    int conversationType = std::get<int32_t>(argument[FTValue("conversationType")]);

    int status = std::get<int32_t>(argument[FTValue("status")]);

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    zim->setConversationNotificationStatus((ZIMConversationNotificationStatus)status, conversationID, (ZIMConversationType)conversationType, [=](const std::string& conversationID, ZIMConversationType conversationType,
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

void ZIMPluginMethodHandler::sendConversationMessageReceiptRead(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result){

    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }
    auto conversationID = std::get<std::string>(argument[FTValue("conversationID")]);
    int conversationType = std::get<int32_t>(argument[FTValue("conversationType")]);
    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    zim->sendConversationMessageReceiptRead(conversationID, (ZIMConversationType)conversationType, [=](const std::string &conversationID, ZIMConversationType conversationType,const ZIMError &errorInfo) {
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

void ZIMPluginMethodHandler::revokeMessage(flutter::EncodableMap& argument,std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result){
    
    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }
    auto messagePtr = ZIMPluginConverter::cnvZIMMessageToObject(std::get<FTMap>(argument[FTValue("message")]));

    FTMap configMap = std::get<FTMap>(argument[FTValue("config")]);
    ZIMMessageRevokeConfig config;
    std::shared_ptr<ZIMPushConfig> pushConfigPtr = nullptr;
    if (std::holds_alternative<std::monostate>(configMap[FTValue("pushConfig")])) {
        config.config = nullptr;
    }
    else {
        pushConfigPtr = ZIMPluginConverter::cnvZIMPushConfigToObject(std::get<FTMap>(configMap[FTValue("pushConfig")]));
        config.config = pushConfigPtr.get();
    }
    auto revokeExtendedData = std::get<std::string>(configMap[FTValue("revokeExtendedData")]);
    config.revokeExtendedData = revokeExtendedData;
    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    zim->revokeMessage(messagePtr, config, [=](const std::shared_ptr<ZIMMessage> &message, const ZIMError &errorInfo){
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

void ZIMPluginMethodHandler::insertMessageToLocalDB(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result){
    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }
    auto messagePtr = ZIMPluginConverter::cnvZIMMessageToObject(std::get<FTMap>(argument[FTValue("message")]));
    auto messageID = std::get<int32_t>(argument[FTValue("messageID")]);
    auto conversationID = std::get<std::string>(argument[FTValue("conversationID")]);
    int conversationType = std::get<int32_t>(argument[FTValue("conversationType")]);
    auto senderUserID = std::get<std::string>(argument[FTValue("senderUserID")]);
    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    zim->insertMessageToLocalDB(std::static_pointer_cast<zim::ZIMMessage>(messagePtr),conversationID, (ZIMConversationType)conversationType, senderUserID,[=](const std::shared_ptr<zim::ZIMMessage> &message,const zim::ZIMError &errorInfo) {
        FTMap retMap;
        auto messageMap = ZIMPluginConverter::cnvZIMMessageObjectToMap(message.get());
        retMap[FTValue("message")] = messageMap;
        retMap[FTValue("messageID")] = FTValue(messageID);
        if (errorInfo.code == 0) {
            sharedPtrResult->Success(retMap);
        }
        else {
            sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message,retMap);
        }
    });
}
void ZIMPluginMethodHandler::sendMessage(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result){
    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }

    auto messagePtr = ZIMPluginConverter::cnvZIMMessageToObject(std::get<FTMap>(argument[FTValue("message")]));
    auto toConversationID = std::get<std::string>(argument[FTValue("toConversationID")]);
    int conversationType = std::get<int32_t>(argument[FTValue("conversationType")]);
    auto messageID = std::get<int32_t>(argument[FTValue("messageID")]);
    
    int32_t messageAttachedCallbackID = 0;
    if (!std::holds_alternative<std::monostate>(argument[FTValue("messageAttachedCallbackID")])) {
        messageAttachedCallbackID = std::get<int32_t>(argument[FTValue("messageAttachedCallbackID")]);
    }
    FTMap configMap = std::get<FTMap>(argument[FTValue("config")]);
    ZIMMessageSendConfig config;
    std::shared_ptr<ZIMPushConfig> pushConfigPtr = nullptr;
    config.priority = (ZIMMessagePriority)std::get<int32_t>(configMap[FTValue("priority")]);
    config.hasReceipt = std::get<bool>(configMap[FTValue("hasReceipt")]);
    if (std::holds_alternative<std::monostate>(configMap[FTValue("pushConfig")])) {
        config.pushConfig = nullptr;
    }
    else {
        pushConfigPtr = ZIMPluginConverter::cnvZIMPushConfigToObject(std::get<FTMap>(configMap[FTValue("pushConfig")]));
        config.pushConfig = pushConfigPtr.get();
    }
    
    auto notification = std::make_shared<zim::ZIMMessageSendNotification>(
            [=](const std::shared_ptr<zim::ZIMMessage> &message) {
        if(messageAttachedCallbackID == 0){
            return;
        }
        FTMap onMessageAttachedMap;
        onMessageAttachedMap[FTValue("method")] = FTValue("onMessageAttached");
        onMessageAttachedMap[FTValue("messageAttachedCallbackID")] = FTValue(messageAttachedCallbackID);
        onMessageAttachedMap[FTValue("messageID")] = FTValue(messageID);
        onMessageAttachedMap[FTValue("message")] = ZIMPluginConverter::cnvZIMMessageObjectToMap(message.get());
        ZIMPluginEventHandler::getInstance()->sendEvent(onMessageAttachedMap);
    });
    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    zim->sendMessage(messagePtr, toConversationID, (ZIMConversationType)conversationType, config, notification,
                    [=](const std::shared_ptr<zim::ZIMMessage> &message,
                              const zim::ZIMError &errorInfo) {
        FTMap retMap;
        auto messageMap = ZIMPluginConverter::cnvZIMMessageObjectToMap(message.get());
        retMap[FTValue("message")] = messageMap;
        retMap[FTValue("messageID")] = FTValue(messageID);
        if (errorInfo.code == 0) {
            sharedPtrResult->Success(retMap);
        }
        else {
            sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message,retMap);
        }
    });
}

void ZIMPluginMethodHandler::sendPeerMessage(flutter::EncodableMap& argument,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }

    auto messagePtr = ZIMPluginConverter::cnvZIMMessageToObject(std::get<FTMap>(argument[FTValue("message")]));
    auto toUserID = std::get<std::string>(argument[FTValue("toUserID")]);

    FTMap configMap = std::get<FTMap>(argument[FTValue("config")]);
    ZIMMessageSendConfig config;
    std::shared_ptr<ZIMPushConfig> pushConfigPtr = nullptr;
    config.priority = (ZIMMessagePriority)std::get<int32_t>(configMap[FTValue("priority")]);
    config.hasReceipt = std::get<bool>(configMap[FTValue("hasReceipt")]);
    if (std::holds_alternative<std::monostate>(configMap[FTValue("pushConfig")])) {
        config.pushConfig = nullptr;
    }
    else {
        pushConfigPtr = ZIMPluginConverter::cnvZIMPushConfigToObject(std::get<FTMap>(configMap[FTValue("pushConfig")]));
        config.pushConfig = pushConfigPtr.get();
    }

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    zim->sendPeerMessage(messagePtr.get(), toUserID, config, [=](const std::shared_ptr<ZIMMessage>& message, const ZIMError& errorInfo) {
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

    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }

    auto messagePtr = ZIMPluginConverter::cnvZIMMessageToObject(std::get<FTMap>(argument[FTValue("message")]));
    auto toRoomID = std::get<std::string>(argument[FTValue("toRoomID")]);

    FTMap configMap = std::get<FTMap>(argument[FTValue("config")]);
    ZIMMessageSendConfig config;
    std::shared_ptr<ZIMPushConfig> pushConfigPtr = nullptr;
    config.priority = (ZIMMessagePriority)std::get<int32_t>(configMap[FTValue("priority")]);
    config.hasReceipt = std::get<bool>(configMap[FTValue("hasReceipt")]);
    if (std::holds_alternative<std::monostate>(configMap[FTValue("pushConfig")])) {
        config.pushConfig = nullptr;
    }
    else {
        pushConfigPtr = ZIMPluginConverter::cnvZIMPushConfigToObject(std::get<FTMap>(configMap[FTValue("pushConfig")]));
        config.pushConfig = pushConfigPtr.get();
    }

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    zim->sendRoomMessage(messagePtr.get(), toRoomID, config, [=](const std::shared_ptr<ZIMMessage>& message, const ZIMError& errorInfo) {
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

    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }

    auto messagePtr = ZIMPluginConverter::cnvZIMMessageToObject(std::get<FTMap>(argument[FTValue("message")]));
    auto toGroupID = std::get<std::string>(argument[FTValue("toGroupID")]);

    FTMap configMap = std::get<FTMap>(argument[FTValue("config")]);
    ZIMMessageSendConfig config;
    std::shared_ptr<ZIMPushConfig> pushConfigPtr = nullptr;
    config.priority = (ZIMMessagePriority)std::get<int32_t>(configMap[FTValue("priority")]);
    config.hasReceipt = std::get<bool>(configMap[FTValue("hasReceipt")]);
    if (std::holds_alternative<std::monostate>(configMap[FTValue("pushConfig")])) {
        config.pushConfig = nullptr;
    }
    else {
        pushConfigPtr = ZIMPluginConverter::cnvZIMPushConfigToObject(std::get<FTMap>(configMap[FTValue("pushConfig")]));
        config.pushConfig = pushConfigPtr.get();
    }

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    zim->sendGroupMessage(messagePtr.get(), toGroupID, config, [=](const std::shared_ptr<ZIMMessage>& message, const ZIMError& errorInfo) {
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

    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }

    auto messagePtr = ZIMPluginConverter::cnvZIMMessageToObject(std::get<FTMap>(argument[FTValue("message")]));
    auto toConversationID = std::get<std::string>(argument[FTValue("toConversationID")]);
    auto conversationType = std::get<int32_t>(argument[FTValue("conversationType")]);

    FTMap configMap = std::get<FTMap>(argument[FTValue("config")]);
    ZIMMessageSendConfig config;
    std::shared_ptr<ZIMPushConfig> pushConfigPtr = nullptr;
    config.priority = (ZIMMessagePriority)std::get<int32_t>(configMap[FTValue("priority")]);
    config.hasReceipt = std::get<bool>(configMap[FTValue("hasReceipt")]);
    if (std::holds_alternative<std::monostate>(configMap[FTValue("pushConfig")])) {
        config.pushConfig = nullptr;
    }
    else {
        pushConfigPtr = ZIMPluginConverter::cnvZIMPushConfigToObject(std::get<FTMap>(configMap[FTValue("pushConfig")]));
        config.pushConfig = pushConfigPtr.get();
    }

    auto mediaMessagePtr = std::static_pointer_cast<ZIMMediaMessage>(messagePtr);
    int32_t progressID = std::get<int32_t>(argument[FTValue("progressID")]);
    auto messageID = std::get<int32_t>(argument[FTValue("messageID")]);
    
    int32_t messageAttachedCallbackID = 0;
    if (!std::holds_alternative<std::monostate>(argument[FTValue("messageAttachedCallbackID")])) {
        messageAttachedCallbackID = std::get<int32_t>(argument[FTValue("messageAttachedCallbackID")]);
    }
    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));


    auto notification = std::make_shared<zim::ZIMMediaMessageSendNotification>(
            [=](const std::shared_ptr<zim::ZIMMessage> &message) {
                if(messageAttachedCallbackID == 0){
                    return;
                }
                FTMap onMessageAttachedMap;
                onMessageAttachedMap[FTValue("method")] = FTValue("onMessageAttached");
                onMessageAttachedMap[FTValue("messageAttachedCallbackID")] = FTValue(messageAttachedCallbackID);
                onMessageAttachedMap[FTValue("messageID")] = FTValue(messageID);
                onMessageAttachedMap[FTValue("message")] = ZIMPluginConverter::cnvZIMMessageObjectToMap(message.get());
                ZIMPluginEventHandler::getInstance()->sendEvent(onMessageAttachedMap);
            },
            [=](const std::shared_ptr<zim::ZIMMediaMessage> &message,
                unsigned long long currentFileSize,
                unsigned long long totalFileSize) {
                FTMap progressRetMap;
                progressRetMap[FTValue("method")] = FTValue("uploadMediaProgress");
                progressRetMap[FTValue("progressID")] = FTValue(progressID);
                progressRetMap[FTValue("message")] = ZIMPluginConverter::cnvZIMMessageObjectToMap(message.get());
                progressRetMap[FTValue("currentFileSize")] = FTValue((int64_t)currentFileSize);
                progressRetMap[FTValue("totalFileSize")] = FTValue((int64_t)totalFileSize);
                ZIMPluginEventHandler::getInstance()->sendEvent(progressRetMap);
            }
    );

    zim->sendMediaMessage(mediaMessagePtr, toConversationID, (ZIMConversationType)conversationType,
    config,notification,[=](const std::shared_ptr<zim::ZIMMessage> &message, const zim::ZIMError &errorInfo) {
        FTMap retMap;
        auto messageMap = ZIMPluginConverter::cnvZIMMessageObjectToMap(message.get());
        retMap[FTValue("message")] = messageMap;
        retMap[FTValue("messageID")] = FTValue(messageID);
        if (errorInfo.code == 0) {
            sharedPtrResult->Success(retMap);
        }
        else {
            sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message,retMap);
        }
    });
}

void ZIMPluginMethodHandler::downloadMediaFile(flutter::EncodableMap& argument,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }

    auto fileType = std::get<int32_t>(argument[FTValue("fileType")]);
    auto messagePtr = ZIMPluginConverter::cnvZIMMessageToObject(std::get<FTMap>(argument[FTValue("message")]));
    
    auto mediaMessagePtr = std::static_pointer_cast<ZIMMediaMessage>(messagePtr);
    auto progressID = std::get<int32_t>(argument[FTValue("progressID")]);

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    zim->downloadMediaFile(mediaMessagePtr.get(), (ZIMMediaFileType)fileType, [=](const std::shared_ptr<ZIMMediaMessage>& message,
        unsigned long long currentFileSize, unsigned long long totalFileSize) {

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


    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }

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
    zim->queryHistoryMessage(conversationID, (ZIMConversationType)conversationType, config, [=](const std::string& conversationID, ZIMConversationType conversationType,
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

    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }

    auto conversationID = std::get<std::string>(argument[FTValue("conversationID")]);
    int conversationType = std::get<int32_t>(argument[FTValue("conversationType")]);

    FTMap configMap = std::get<FTMap>(argument[FTValue("config")]);
    ZIMMessageDeleteConfig config;
    config.isAlsoDeleteServerMessage = std::get<bool>(configMap[FTValue("isAlsoDeleteServerMessage")]);

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    zim->deleteAllMessage(conversationID, (ZIMConversationType)conversationType, config, [=](const std::string& conversationID, ZIMConversationType conversationType,
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

    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }

    auto messageArray = std::get<FTArray>(argument[(FTValue("messageList"))]);
    auto messageObjectList = ZIMPluginConverter::cnvZIMMessageArrayToObjectList(messageArray);
    auto conversationID = std::get<std::string>(argument[FTValue("conversationID")]);
    int conversationType = std::get<int32_t>(argument[FTValue("conversationType")]);

    FTMap configMap = std::get<FTMap>(argument[FTValue("config")]);
    ZIMMessageDeleteConfig config;
    config.isAlsoDeleteServerMessage = std::get<bool>(configMap[FTValue("isAlsoDeleteServerMessage")]);

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    zim->deleteMessages(messageObjectList, conversationID, (ZIMConversationType)conversationType, config, [=](const std::string& conversationID, ZIMConversationType conversationType,
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


void ZIMPluginMethodHandler::sendMessageReceiptsRead(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }
    auto messageArray = std::get<FTArray>(argument[(FTValue("messageList"))]);
    auto messageObjectList = ZIMPluginConverter::cnvZIMMessageArrayToObjectList(messageArray);
    auto conversationID = std::get<std::string>(argument[FTValue("conversationID")]);
    int conversationType = std::get<int32_t>(argument[FTValue("conversationType")]);
    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    zim->sendMessageReceiptsRead(messageObjectList, conversationID, (ZIMConversationType)conversationType, [=](const std::string &conversationID, ZIMConversationType conversationType,const std::vector<long long> &errorMessageIDs, const ZIMError &errorInfo){
        if (errorInfo.code == 0) {
            FTMap retMap;
            retMap[FTValue("conversationID")] = FTValue(conversationID);
            retMap[FTValue("conversationType")] = FTValue(conversationType);

            retMap[FTValue("errorMessageIDs")] = ZIMPluginConverter::cnvStlVectorToFTArray(errorMessageIDs);
            sharedPtrResult->Success(retMap);
        }
        else {
            sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}

void ZIMPluginMethodHandler::queryMessageReceiptsInfo(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result){
    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }
    auto messageArray = std::get<FTArray>(argument[(FTValue("messageList"))]);
    auto messageObjectList = ZIMPluginConverter::cnvZIMMessageArrayToObjectList(messageArray);
    auto conversationID = std::get<std::string>(argument[FTValue("conversationID")]);
    int conversationType = std::get<int32_t>(argument[FTValue("conversationType")]);
    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    zim->queryMessageReceiptsInfo(messageObjectList, conversationID, (ZIMConversationType)conversationType, [=](const std::vector<ZIMMessageReceiptInfo> &infos, std::vector<long long> errorMessageIDs,const ZIMError &errorInfo){
        if (errorInfo.code == 0) {
            FTMap retMap;
            retMap[FTValue("infos")] = ZIMPluginConverter::cnvZIMMessageReceiptInfoListToArray(infos);
            retMap[FTValue("errorMessageIDs")] = ZIMPluginConverter::cnvStlVectorToFTArray(errorMessageIDs);
            sharedPtrResult->Success(retMap);
        }
        else {
            sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}

void ZIMPluginMethodHandler::queryGroupMessageReceiptReadMemberList(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result){
    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }
    auto messagePtr = ZIMPluginConverter::cnvZIMMessageToObject(std::get<FTMap>(argument[FTValue("message")]));
    auto groupID = std::get<std::string>(argument[FTValue("groupID")]);
    auto config = ZIMPluginConverter::cnvZIMGroupMessageReceiptMemberQueryConfigMapToObject(std::get<FTMap>(argument[FTValue("config")]));
    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    zim->queryGroupMessageReceiptReadMemberList(messagePtr, groupID, config, [=](const std::string &groupID, const std::vector<ZIMGroupMemberInfo> &userList, unsigned int nextFlag, const ZIMError &errorInfo){
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

void ZIMPluginMethodHandler::queryGroupMessageReceiptUnreadMemberList(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }
    auto messagePtr = ZIMPluginConverter::cnvZIMMessageToObject(std::get<FTMap>(argument[FTValue("message")]));
    auto groupID = std::get<std::string>(argument[FTValue("groupID")]);
    auto config = ZIMPluginConverter::cnvZIMGroupMessageReceiptMemberQueryConfigMapToObject(std::get<FTMap>(argument[FTValue("config")]));
    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    zim->queryGroupMessageReceiptUnreadMemberList(messagePtr, groupID, config, [=](const std::string &groupID, const std::vector<ZIMGroupMemberInfo> &userList,unsigned int nextFlag, const ZIMError &errorInfo){
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

void ZIMPluginMethodHandler::createRoom(flutter::EncodableMap& argument,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }

    auto roomInfo = ZIMPluginConverter::cnvZIMRoomInfoToObject(std::get<FTMap>(argument[FTValue("roomInfo")]));

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    zim->createRoom(roomInfo, [=](const ZIMRoomFullInfo& roomInfo, const ZIMError& errorInfo) {
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

    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }

    auto roomInfo = ZIMPluginConverter::cnvZIMRoomInfoToObject(std::get<FTMap>(argument[FTValue("roomInfo")]));
    auto roomAdvancedConfig = ZIMPluginConverter::cnvZIMRoomAdvancedConfigToObject(std::get<FTMap>(argument[FTValue("config")]));

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    zim->createRoom(roomInfo, roomAdvancedConfig, [=](const ZIMRoomFullInfo& roomInfo, const ZIMError& errorInfo) {
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

    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }

    auto roomInfo = ZIMPluginConverter::cnvZIMRoomInfoToObject(std::get<FTMap>(argument[FTValue("roomInfo")]));
    auto roomAdvancedConfig = ZIMPluginConverter::cnvZIMRoomAdvancedConfigToObject(std::get<FTMap>(argument[FTValue("config")]));

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    zim->enterRoom(roomInfo, roomAdvancedConfig, [=](const ZIMRoomFullInfo& roomInfo, const ZIMError& errorInfo) {
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

    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }

    auto roomID = std::get<std::string>(argument[FTValue("roomID")]);

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    zim->joinRoom(roomID, [=](const ZIMRoomFullInfo& roomInfo, const ZIMError& errorInfo) {
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

    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }

    auto roomID = std::get<std::string>(argument[FTValue("roomID")]);

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    zim->leaveRoom(roomID, [=](const std::string& roomID, const ZIMError& errorInfo) {
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

    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }

    auto roomID = std::get<std::string>(argument[FTValue("roomID")]);
    auto queryConfig = ZIMPluginConverter::cnvZIMRoomMemberQueryConfigToObject(std::get<FTMap>(argument[FTValue("config")]));

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    zim->queryRoomMemberList(roomID, queryConfig, [=](const std::string& roomID, const std::vector<ZIMUserInfo>& memberList,
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

    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }

    auto roomID = std::get<std::string>(argument[FTValue("roomID")]);

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    zim->queryRoomOnlineMemberCount(roomID, [=](const std::string& roomID, unsigned int count, const ZIMError& errorInfo) {
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

    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }

    auto roomID = std::get<std::string>(argument[FTValue("roomID")]);
    auto roomAttributes = ZIMPluginConverter::cnvFTMapToSTLMap(std::get<FTMap>(argument[FTValue("roomAttributes")]));
    auto roomAttributesSetConfig = ZIMPluginConverter::cnvZIMRoomAttributesSetConfigToObject(std::get<FTMap>(argument[FTValue("config")]));

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    zim->setRoomAttributes(roomAttributes, roomID, &roomAttributesSetConfig, [=](const std::string& roomID, const std::vector<std::string>& errorKeyList,
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

    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }

    auto roomID = std::get<std::string>(argument[FTValue("roomID")]);
    auto keys = ZIMPluginConverter::cnvFTArrayToStlVector(std::get<FTArray>(argument[FTValue("keys")]));
    auto roomAttributesDeleteConfig = ZIMPluginConverter::cnvZIMRoomAttributesDeleteConfigToObject(std::get<FTMap>(argument[FTValue("config")]));

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    zim->deleteRoomAttributes(keys, roomID, &roomAttributesDeleteConfig, [=](const std::string& roomID, const std::vector<std::string>& errorKeyList,
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

    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }

    auto roomID = std::get<std::string>(argument[FTValue("roomID")]);
    auto config = ZIMPluginConverter::cnvZIMRoomAttributesBatchOperationConfigToObject(std::get<FTMap>(argument[FTValue("config")]));

    zim->beginRoomAttributesBatchOperation(roomID, &config);
    result->Success();
}

void ZIMPluginMethodHandler::endRoomAttributesBatchOperation(flutter::EncodableMap& argument,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }

    auto roomID = std::get<std::string>(argument[FTValue("roomID")]);
    
    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    zim->endRoomAttributesBatchOperation(roomID, [=](const std::string& roomID, const ZIMError& errorInfo) {
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

    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }

    auto roomID = std::get<std::string>(argument[FTValue("roomID")]);

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    zim->queryRoomAllAttributes(roomID, [=](const std::string& roomID, const std::unordered_map<std::string, std::string>& roomAttributes,
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

void ZIMPluginMethodHandler::setRoomMembersAttributes(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }
    auto roomID = std::get<std::string>(argument[FTValue("roomID")]);
    auto attributes = ZIMPluginConverter::cnvFTMapToSTLMap(std::get<FTMap>(argument[FTValue("attributes")]));
    auto userIDs = ZIMPluginConverter::cnvFTArrayToStlVector(std::get<FTArray>(argument[FTValue("userIDs")]));
    auto config = ZIMPluginConverter::cnvZIMRoomMemberAttributesSetConfigToObject(std::get<FTMap>(argument[FTValue("config")]));
    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    zim->setRoomMembersAttributes(attributes, userIDs, roomID, config, [=](const std::string &roomID, const std::vector<ZIMRoomMemberAttributesOperatedInfo> &infos,const std::vector<std::string> &errorUserList, const ZIMError &errorInfo){
         if (errorInfo.code == 0) {
            FTMap retMap;
            retMap[FTValue("roomID")] = FTValue(roomID);
            FTArray infosModel;
            for(ZIMRoomMemberAttributesOperatedInfo info :infos){
                FTMap infoModel = ZIMPluginConverter::cnvZIMRoomMemberAttributesOperatedInfoToMap(info);
                infosModel.emplace_back(infoModel);
            }
            retMap[FTValue("infos")] = infosModel;
            retMap[FTValue("errorUserList")] =  ZIMPluginConverter::cnvStlVectorToFTArray(errorUserList);
            sharedPtrResult->Success(retMap);
        }
        else {
            sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}
void ZIMPluginMethodHandler::queryRoomMembersAttributes(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }
    auto roomID = std::get<std::string>(argument[FTValue("roomID")]);
    auto userIDs = ZIMPluginConverter::cnvFTArrayToStlVector(std::get<FTArray>(argument[FTValue("userIDs")]));
    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    zim->queryRoomMembersAttributes(userIDs, roomID, [=](const std::string &roomID, const std::vector<ZIMRoomMemberAttributesInfo> &infos,const ZIMError &errorInfo){
        if (errorInfo.code == 0) {
            FTMap retMap;
            retMap[FTValue("roomID")] = FTValue(roomID);
            FTArray infosModel;
            for(ZIMRoomMemberAttributesInfo info :infos){
                FTMap infoModel = ZIMPluginConverter::cnvZIMRoomMemberAttributesInfoToMap(info);
                infosModel.emplace_back(infoModel);
            }
            retMap[FTValue("infos")] = infosModel;
            sharedPtrResult->Success(retMap);
        }
        else {
            sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}
void  ZIMPluginMethodHandler::queryRoomMemberAttributesList(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }
    auto config = ZIMPluginConverter::cnvZIMRoomMemberAttributesQueryConfigToObject(std::get<FTMap>(argument[FTValue("config")]));
    auto roomID = std::get<std::string>(argument[FTValue("roomID")]);
    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    zim->queryRoomMemberAttributesList(roomID, config, [=](const std::string &roomID, const std::vector<ZIMRoomMemberAttributesInfo> &infos,const std::string &nextFlag, const ZIMError &errorInfo){
        if (errorInfo.code == 0) {
            FTMap retMap;
            retMap[FTValue("roomID")] = FTValue(roomID);
            FTArray infosModel;
            for(ZIMRoomMemberAttributesInfo info :infos){
                FTMap infoModel = ZIMPluginConverter::cnvZIMRoomMemberAttributesInfoToMap(info);
                infosModel.emplace_back(infoModel);
            }
            retMap[FTValue("infos")] = infosModel;
            retMap[FTValue("nextFlag")] = nextFlag;
            sharedPtrResult->Success(retMap);
        }
        else {
            sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
});
}

void ZIMPluginMethodHandler::createGroup(flutter::EncodableMap& argument,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }

    auto groupInfo = ZIMPluginConverter::cnvZIMGroupInfoToObject(std::get<FTMap>(argument[FTValue("groupInfo")]));
    auto userIDs = ZIMPluginConverter::cnvFTArrayToStlVector(std::get<FTArray>(argument[FTValue("userIDs")]));

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    zim->createGroup(groupInfo, userIDs, [=](const ZIMGroupFullInfo& groupInfo, const std::vector<ZIMGroupMemberInfo>& userList,
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

    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }

    auto groupInfo = ZIMPluginConverter::cnvZIMGroupInfoToObject(std::get<FTMap>(argument[FTValue("groupInfo")]));
    auto userIDs = ZIMPluginConverter::cnvFTArrayToStlVector(std::get<FTArray>(argument[FTValue("userIDs")]));
    auto config = ZIMPluginConverter::cnvZIMGroupAdvancedConfigToObject(std::get<FTMap>(argument[FTValue("config")]));

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    zim->createGroup(groupInfo, userIDs, config, [=](const ZIMGroupFullInfo& groupInfo, const std::vector<ZIMGroupMemberInfo>& userList,
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

    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }

    auto groupID = std::get<std::string>(argument[FTValue("groupID")]);

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    zim->joinGroup(groupID, [=](const ZIMGroupFullInfo& groupInfo, const ZIMError& errorInfo) {
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

    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }

    auto groupID = std::get<std::string>(argument[FTValue("groupID")]);

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    zim->dismissGroup(groupID, [=](const std::string& groupID, const ZIMError& errorInfo) {
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

    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }

    auto groupID = std::get<std::string>(argument[FTValue("groupID")]);

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    zim->leaveGroup(groupID, [=](const std::string& groupID, const ZIMError& errorInfo) {
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

    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }

    auto groupID = std::get<std::string>(argument[FTValue("groupID")]);
    auto userIDs = ZIMPluginConverter::cnvFTArrayToStlVector(std::get<FTArray>(argument[FTValue("userIDs")]));

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    zim->inviteUsersIntoGroup(userIDs, groupID, [=](const std::string& groupID, const std::vector<ZIMGroupMemberInfo>& userList,
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
    
    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }

    auto groupID = std::get<std::string>(argument[FTValue("groupID")]);
    auto userIDs = ZIMPluginConverter::cnvFTArrayToStlVector(std::get<FTArray>(argument[FTValue("userIDs")]));

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    zim->kickGroupMembers(userIDs, groupID, [=](const std::string& groupID, const std::vector<std::string>& kickedUserIDList,
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

    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }

    auto groupID = std::get<std::string>(argument[FTValue("groupID")]);
    auto toUserID = std::get<std::string>(argument[FTValue("toUserID")]);

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    zim->transferGroupOwner(toUserID, groupID, [=](const std::string& groupID, const std::string& toUserID, const ZIMError& errorInfo) {
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

    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }

    auto groupID = std::get<std::string>(argument[FTValue("groupID")]);
    auto groupName = std::get<std::string>(argument[FTValue("groupName")]);

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    zim->updateGroupName(groupName, groupID, [=](const std::string& groupID, const std::string& groupName, const ZIMError& errorInfo) {
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

void ZIMPluginMethodHandler::updateGroupAvatarUrl(flutter::EncodableMap& argument,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }

    auto groupID = std::get<std::string>(argument[FTValue("groupID")]);
    auto groupAvatarUrl = std::get<std::string>(argument[FTValue("groupAvatarUrl")]);

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    zim->updateGroupAvatarUrl(groupAvatarUrl, groupID, [=](const std::string& groupID, const std::string& groupAvatarUrl, const ZIMError& errorInfo) {
        if (errorInfo.code == 0) {
            FTMap retMap;
            retMap[FTValue("groupID")] = FTValue(groupID);
            retMap[FTValue("groupAvatarUrl")] = FTValue(groupAvatarUrl);

            sharedPtrResult->Success(retMap);
        }
        else {
            sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}

void ZIMPluginMethodHandler::updateGroupNotice(flutter::EncodableMap& argument,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }

    auto groupID = std::get<std::string>(argument[FTValue("groupID")]);
    auto groupNotice = std::get<std::string>(argument[FTValue("groupNotice")]);

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    zim->updateGroupNotice(groupNotice, groupID, [=](const std::string& groupID, const std::string& groupNotice, const ZIMError& errorInfo) {
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

    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }

    auto groupID = std::get<std::string>(argument[FTValue("groupID")]);

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    zim->queryGroupInfo(groupID, [=](const ZIMGroupFullInfo& groupInfo, const ZIMError& errorInfo) {
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

    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }

    auto groupID = std::get<std::string>(argument[FTValue("groupID")]);
    auto groupAttributes = ZIMPluginConverter::cnvFTMapToSTLMap(std::get<FTMap>(argument[FTValue("groupAttributes")]));

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    zim->setGroupAttributes(groupAttributes, groupID, [=](const std::string& groupID, const std::vector<std::string>& errorKeys,
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

    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }

    auto groupID = std::get<std::string>(argument[FTValue("groupID")]);
    auto keys = ZIMPluginConverter::cnvFTArrayToStlVector(std::get<FTArray>(argument[FTValue("keys")]));

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    zim->deleteGroupAttributes(keys, groupID, [=](const std::string& groupID, const std::vector<std::string>& errorKeys,
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

    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }

    auto groupID = std::get<std::string>(argument[FTValue("groupID")]);
    auto keys = ZIMPluginConverter::cnvFTArrayToStlVector(std::get<FTArray>(argument[FTValue("keys")]));

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    zim->queryGroupAttributes(keys, groupID, [=](const std::string& groupID, const std::unordered_map<std::string, std::string>& groupAttributes,
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

    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }

    auto groupID = std::get<std::string>(argument[FTValue("groupID")]);

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    zim->queryGroupAllAttributes(groupID, [=](const std::string& groupID, const std::unordered_map<std::string, std::string>& groupAttributes,
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

    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }

    auto groupID = std::get<std::string>(argument[FTValue("groupID")]);
    int role = std::get<int32_t>(argument[FTValue("role")]);
    auto forUserID = std::get<std::string>(argument[FTValue("forUserID")]);

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    zim->setGroupMemberRole(role, forUserID, groupID, [=](const std::string& groupID, const std::string& forUserID,
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

    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }

    auto groupID = std::get<std::string>(argument[FTValue("groupID")]);
    auto nickname = std::get<std::string>(argument[FTValue("nickname")]);
    auto forUserID = std::get<std::string>(argument[FTValue("forUserID")]);

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    zim->setGroupMemberNickname(nickname, forUserID, groupID, [=](const std::string& groupID, const std::string& forUserID,
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

    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }

    auto groupID = std::get<std::string>(argument[FTValue("groupID")]);
    auto userID = std::get<std::string>(argument[FTValue("userID")]);

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    zim->queryGroupMemberInfo(userID, groupID, [=](const std::string& groupID, const ZIMGroupMemberInfo& userInfo, const ZIMError& errorInfo) {
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

    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    zim->queryGroupList([=](const std::vector<ZIMGroup>& groupList, const ZIMError& errorInfo) {
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
    
    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }

    auto groupID = std::get<std::string>(argument[FTValue("groupID")]);
    auto config = ZIMPluginConverter::cnvZIMGroupMemberQueryConfigToObject(std::get<FTMap>(argument[FTValue("config")]));

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    zim->queryGroupMemberList(groupID, config, [=](const std::string& groupID, const std::vector<ZIMGroupMemberInfo>& userList,
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

    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }

    auto groupID = std::get<std::string>(argument[FTValue("groupID")]);

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    zim->queryGroupMemberCount(groupID, [=](const std::string& groupID, unsigned int count, const ZIMError& errorInfo) {
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

    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }

    auto invitees = ZIMPluginConverter::cnvFTArrayToStlVector(std::get<FTArray>(argument[FTValue("invitees")]));
    auto configMap = std::get<FTMap>(argument[FTValue("config")]);

    ZIMCallInviteConfig config;
    config.timeout = std::get<int32_t>(configMap[FTValue("timeout")]);
    config.extendedData = std::get<std::string>(configMap[FTValue("extendedData")]);
    std::shared_ptr<ZIMPushConfig> pushConfigPtr = nullptr;
    if (std::holds_alternative<std::monostate>(configMap[FTValue("pushConfig")])) {
        config.pushConfig = nullptr;
    }
    else {
        pushConfigPtr = ZIMPluginConverter::cnvZIMPushConfigToObject(std::get<FTMap>(configMap[FTValue("pushConfig")]));
        config.pushConfig = pushConfigPtr.get();
    }
    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    zim->callInvite(invitees, config, [=](const std::string& callID, const ZIMCallInvitationSentInfo& info, const ZIMError& errorInfo) {
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

    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }

    auto invitees = ZIMPluginConverter::cnvFTArrayToStlVector(std::get<FTArray>(argument[FTValue("invitees")]));
    auto callID = std::get<std::string>(argument[FTValue("callID")]);
    auto configMap = std::get<FTMap>(argument[FTValue("config")]);

    ZIMCallCancelConfig config;
    config.extendedData = std::get<std::string>(configMap[FTValue("extendedData")]);

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    zim->callCancel(invitees, callID, config, [=](const std::string& callID, const std::vector<std::string>& errorInvitees,
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

    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }

    auto callID = std::get<std::string>(argument[FTValue("callID")]);
    auto configMap = std::get<FTMap>(argument[FTValue("config")]);

    ZIMCallAcceptConfig config;
    config.extendedData = std::get<std::string>(configMap[FTValue("extendedData")]);

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    zim->callAccept(callID, config, [=](const std::string& callID, const ZIMError& errorInfo) {
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

    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }

    auto callID = std::get<std::string>(argument[FTValue("callID")]);
    auto configMap = std::get<FTMap>(argument[FTValue("config")]);

    ZIMCallRejectConfig config;
    config.extendedData = std::get<std::string>(configMap[FTValue("extendedData")]);

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    zim->callReject(callID, config, [=](const std::string& callID, const ZIMError& errorInfo) {
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


