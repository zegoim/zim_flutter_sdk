﻿#include "ZIMPluginMethodHandler.h"
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

    unsigned int appID = (unsigned int)ZIMPluginConverter::cnvFTMapToInt64(configMap[FTValue("appID")]);
    auto appSign = std::get<std::string>(configMap[FTValue("appSign")]);

    ZIMAppConfig appConfig;
    appConfig.appID = appID;
    appConfig.appSign = appSign;
    ZIM::setAdvancedConfig("zim_cross_platform","flutter");
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
    logConfig.logSize = ZIMPluginConverter::cnvFTMapToInt32(argument[FTValue("logSize")]);

    ZIM::setLogConfig(logConfig);

    result->Success();

}

void ZIMPluginMethodHandler::setAdvancedConfig(flutter::EncodableMap& argument,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

    std::string key = std::get<std::string>(argument[FTValue("key")]);
    std::string value = std::get<std::string>(argument[FTValue("value")]);

    ZIM::setAdvancedConfig(key,value);

    result->Success();

}

void ZIMPluginMethodHandler::setCacheConfig(flutter::EncodableMap& argument,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

    ZIMCacheConfig cacheConfig;
    cacheConfig.cachePath = std::get<std::string>(argument[FTValue("cachePath")]);

    ZIM::setCacheConfig(cacheConfig);

    result->Success();
}

void ZIMPluginMethodHandler::setGeofencingConfig(flutter::EncodableMap& argument,
     std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result){

    int geofencingType = ZIMPluginConverter::cnvFTMapToInt32(argument[FTValue("type")]);

    auto areaList = std::get<FTArray>(argument[FTValue("areaList")]);
    std::vector<int> areaListVec;
    for (auto& areaValue : areaList) {
        auto area = ZIMPluginConverter::cnvFTMapToInt32(areaValue);
        areaListVec.emplace_back(area);
    }
    bool operatorResult = ZIM::setGeofencingConfig(areaListVec, (ZIMGeofencingType)geofencingType);
    result->Success(operatorResult);
}

void ZIMPluginMethodHandler::login(flutter::EncodableMap& argument,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }
    std::string userID = std::get<std::string>(argument[FTValue("userID")]);
    ZIMLoginConfig loginConfig = ZIMPluginConverter::cnvZIMLoginConfigToObject(std::get<FTMap>(argument[FTValue("config")]));

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    zim->login(userID, loginConfig, [=](const ZIMError& errorInfo) {
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

void ZIMPluginMethodHandler::updateUserOfflinePushRule(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
        auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }
    ZIMUserOfflinePushRule rule = ZIMPluginConverter::cnvZIMUserOfflinePushRuleToObject(std::get<FTMap>(argument[FTValue("offlinePushRule")]));
    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));

    zim->updateUserOfflinePushRule(rule, [=](const ZIMUserOfflinePushRule &offlinePushRule, const ZIMError &errorInfo) {
        if (errorInfo.code == 0) {
            FTMap retMap;
            retMap[FTValue("offlinePushRule")] = ZIMPluginConverter::cnvZIMUserOfflinePushRuleToMap(offlinePushRule);
            sharedPtrResult->Success(retMap);
        }
        else {
            sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}

void ZIMPluginMethodHandler::querySelfUserInfo(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }
    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));

    zim->querySelfUserInfo([=](const ZIMSelfUserInfo &selfUserInfo, const ZIMError &errorInfo){
        if (errorInfo.code == 0) {
            FTMap retMap;
            retMap[FTValue("selfUserInfo")] = ZIMPluginConverter::cnvZIMSelfUserInfoToMap(selfUserInfo);
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
                errorUserInfoArray.emplace_back(errorUserInfoMap);
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
    queryConfig.count = ZIMPluginConverter::cnvFTMapToInt32(configMap[FTValue("count")]);

    if (std::holds_alternative<std::monostate>(configMap[FTValue("nextConversation")])) {
        queryConfig.nextConversation = nullptr;
    }
    else {
        auto nextConversation = std::get<FTMap>(configMap[FTValue("nextConversation")]);
        queryConfig.nextConversation = ZIMPluginConverter::cnvZIMConversationToObject(nextConversation);
    }
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

void ZIMPluginMethodHandler::queryConversation(flutter::EncodableMap& argument,
	std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

	auto handle = std::get<std::string>(argument[FTValue("handle")]);
	auto zim = this->engineMap[handle];
	if (!zim) {
		result->Error("-1", "no native instance");
		return;
	}

	auto conversationID = std::get<std::string>(argument[FTValue("conversationID")]);
	int conversationType = ZIMPluginConverter::cnvFTMapToInt32(argument[FTValue("conversationType")]);

	auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
	zim->queryConversation(conversationID, (ZIMConversationType)conversationType, [=](const std::shared_ptr<ZIMConversation>& conversation, const ZIMError& errorInfo) {
			if (errorInfo.code == 0) {
				FTMap retMap;
				retMap[FTValue("conversation")] = ZIMPluginConverter::cnvZIMConversationToMap(conversation);
                
				sharedPtrResult->Success(retMap);
			}
			else {
				sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
			}
		});
}

void ZIMPluginMethodHandler::queryConversationPinnedList(flutter::EncodableMap& argument,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }

    FTMap configMap = std::get<FTMap>(argument[FTValue("config")]);
    ZIMConversationQueryConfig queryConfig;
    queryConfig.count = ZIMPluginConverter::cnvFTMapToInt32(configMap[FTValue("count")]);

    if (std::holds_alternative<std::monostate>(configMap[FTValue("nextConversation")])) {
        queryConfig.nextConversation = nullptr;
    }
    else {
        auto nextConversation = std::get<FTMap>(configMap[FTValue("nextConversation")]);
        queryConfig.nextConversation = ZIMPluginConverter::cnvZIMConversationToObject(nextConversation);
    }
    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    zim->queryConversationPinnedList(queryConfig, [=](const std::vector<std::shared_ptr<ZIMConversation>>& conversationList,
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

void ZIMPluginMethodHandler::updateConversationPinnedState(flutter::EncodableMap& argument,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }

    bool isPinned = std::get<bool>(argument[FTValue("isPinned")]);
    auto conversationID = std::get<std::string>(argument[FTValue("conversationID")]);
    int conversationType = ZIMPluginConverter::cnvFTMapToInt32(argument[FTValue("conversationType")]);

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    zim->updateConversationPinnedState(isPinned, conversationID, (ZIMConversationType)conversationType, [=](const std::string& conversationID, ZIMConversationType conversationType,
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

void ZIMPluginMethodHandler::deleteConversation(flutter::EncodableMap& argument,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }

    auto conversationID = std::get<std::string>(argument[FTValue("conversationID")]);
    int conversationType = ZIMPluginConverter::cnvFTMapToInt32(argument[FTValue("conversationType")]);
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

void ZIMPluginMethodHandler::deleteAllConversations(flutter::EncodableMap& argument,
	std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

	auto handle = std::get<std::string>(argument[FTValue("handle")]);
	auto zim = this->engineMap[handle];
	if (!zim) {
		result->Error("-1", "no native instance");
		return;
	}

	auto configMap = std::get<FTMap>(argument[FTValue("config")]);

    ZIMConversationDeleteConfig deleteConfig = ZIMPluginConverter::cnvZIMConversationDeleteConfigToObject(configMap);
	auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
	zim->deleteAllConversations(deleteConfig, [=](const ZIMError& errorInfo) {
			if (errorInfo.code == 0) {
				sharedPtrResult->Success();
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
    int conversationType = ZIMPluginConverter::cnvFTMapToInt32(argument[FTValue("conversationType")]);

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

void ZIMPluginMethodHandler::clearConversationTotalUnreadMessageCount(flutter::EncodableMap& argument,
	std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

	auto handle = std::get<std::string>(argument[FTValue("handle")]);
	auto zim = this->engineMap[handle];
	if (!zim) {
		result->Error("-1", "no native instance");
		return;
	}

	auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
	zim->clearConversationTotalUnreadMessageCount([=](const ZIMError& errorInfo) {
			if (errorInfo.code == 0) {
				sharedPtrResult->Success();
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
    int conversationType = ZIMPluginConverter::cnvFTMapToInt32(argument[FTValue("conversationType")]);

    int status = ZIMPluginConverter::cnvFTMapToInt32(argument[FTValue("status")]);

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
    int conversationType = ZIMPluginConverter::cnvFTMapToInt32(argument[FTValue("conversationType")]);
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

void ZIMPluginMethodHandler::setConversationDraft(flutter::EncodableMap& argument,
	std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

	auto handle = std::get<std::string>(argument[FTValue("handle")]);
	auto zim = this->engineMap[handle];
	if (!zim) {
		result->Error("-1", "no native instance");
		return;
	}
    auto draft = std::get<std::string>(argument[FTValue("draft")]);
	auto conversationID = std::get<std::string>(argument[FTValue("conversationID")]);
	int conversationType = ZIMPluginConverter::cnvFTMapToInt32(argument[FTValue("conversationType")]);
	auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
	zim->setConversationDraft(draft, conversationID, (ZIMConversationType)conversationType, [=](const std::string &conversationID, ZIMConversationType conversationType,const ZIMError &errorInfo) {
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
    std::shared_ptr<ZIMVoIPConfig> voIPConfigPtr = nullptr;
    if (std::holds_alternative<std::monostate>(configMap[FTValue("pushConfig")])) {
        config.config = nullptr;
    }
    else {
        pushConfigPtr = ZIMPluginConverter::cnvZIMPushConfigToObject(std::get<FTMap>(configMap[FTValue("pushConfig")]),voIPConfigPtr);
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
	auto messageID = ZIMPluginConverter::cnvFTMapToInt32(argument[FTValue("messageID")]);
    auto conversationID = std::get<std::string>(argument[FTValue("conversationID")]);
    int conversationType = ZIMPluginConverter::cnvFTMapToInt32(argument[FTValue("conversationType")]);
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

void ZIMPluginMethodHandler::updateMessageLocalExtendedData(flutter::EncodableMap& argument,
	std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
	auto handle = std::get<std::string>(argument[FTValue("handle")]);
	auto zim = this->engineMap[handle];
	if (!zim) {
		result->Error("-1", "no native instance");
		return;
	}
	auto messagePtr = ZIMPluginConverter::cnvZIMMessageToObject(std::get<FTMap>(argument[FTValue("message")]));
	auto localExtendedData = std::get<std::string>(argument[FTValue("localExtendedData")]);
	auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
	zim->updateMessageLocalExtendedData(localExtendedData, std::static_pointer_cast<zim::ZIMMessage>(messagePtr), [=](const std::shared_ptr<zim::ZIMMessage>& message, const zim::ZIMError& errorInfo) {
		FTMap retMap;
		auto messageMap = ZIMPluginConverter::cnvZIMMessageObjectToMap(message.get());
		retMap[FTValue("message")] = messageMap;
		if (errorInfo.code == 0) {
			sharedPtrResult->Success(retMap);
		}
		else {
			sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message, retMap);
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
    int conversationType = ZIMPluginConverter::cnvFTMapToInt32(argument[FTValue("conversationType")]);
	auto messageID = ZIMPluginConverter::cnvFTMapToInt32(argument[FTValue("messageID")]);
    
	int32_t messageAttachedCallbackID = ZIMPluginConverter::cnvFTMapToInt32(argument[FTValue("messageAttachedCallbackID")]);
    FTMap configMap = std::get<FTMap>(argument[FTValue("config")]);
    ZIMMessageSendConfig config;
    std::shared_ptr<ZIMPushConfig> pushConfigPtr = nullptr;
    std::shared_ptr<ZIMVoIPConfig> voIPConfigPtr = nullptr;
    config.priority = (ZIMMessagePriority)ZIMPluginConverter::cnvFTMapToInt32(configMap[FTValue("priority")]);
    config.hasReceipt = std::get<bool>(configMap[FTValue("hasReceipt")]);
    if (std::holds_alternative<std::monostate>(configMap[FTValue("pushConfig")])) {
        config.pushConfig = nullptr;
    }
    else {
        pushConfigPtr = ZIMPluginConverter::cnvZIMPushConfigToObject(std::get<FTMap>(configMap[FTValue("pushConfig")]),voIPConfigPtr);
        config.pushConfig = pushConfigPtr.get();
    }
    
    auto notification = std::make_shared<zim::ZIMMessageSendNotification>(
            [=](const std::shared_ptr<zim::ZIMMessage> &message) {
        if(messageAttachedCallbackID == 0){
            return;
        }
        FTMap onMessageAttachedMap;
        onMessageAttachedMap[FTValue("handle")] = FTValue(handle);
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
    std::shared_ptr<ZIMVoIPConfig> voIPConfigPtr = nullptr;
    config.priority = (ZIMMessagePriority)ZIMPluginConverter::cnvFTMapToInt32(configMap[FTValue("priority")]);
    config.hasReceipt = std::get<bool>(configMap[FTValue("hasReceipt")]);
    if (std::holds_alternative<std::monostate>(configMap[FTValue("pushConfig")])) {
        config.pushConfig = nullptr;
    }
    else {
        pushConfigPtr = ZIMPluginConverter::cnvZIMPushConfigToObject(std::get<FTMap>(configMap[FTValue("pushConfig")]),voIPConfigPtr);
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
    std::shared_ptr<ZIMVoIPConfig> voIPConfigPtr = nullptr;
    config.priority = (ZIMMessagePriority)ZIMPluginConverter::cnvFTMapToInt32(configMap[FTValue("priority")]);
    config.hasReceipt = std::get<bool>(configMap[FTValue("hasReceipt")]);
    if (std::holds_alternative<std::monostate>(configMap[FTValue("pushConfig")])) {
        config.pushConfig = nullptr;
    }
    else {
        pushConfigPtr = ZIMPluginConverter::cnvZIMPushConfigToObject(std::get<FTMap>(configMap[FTValue("pushConfig")]),voIPConfigPtr);
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
    std::shared_ptr<ZIMVoIPConfig> voIPConfigPtr = nullptr;
    config.priority = (ZIMMessagePriority)ZIMPluginConverter::cnvFTMapToInt32(configMap[FTValue("priority")]);
    config.hasReceipt = std::get<bool>(configMap[FTValue("hasReceipt")]);
    if (std::holds_alternative<std::monostate>(configMap[FTValue("pushConfig")])) {
        config.pushConfig = nullptr;
    }
    else {
        pushConfigPtr = ZIMPluginConverter::cnvZIMPushConfigToObject(std::get<FTMap>(configMap[FTValue("pushConfig")]),voIPConfigPtr);
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
    auto conversationType = ZIMPluginConverter::cnvFTMapToInt32(argument[FTValue("conversationType")]);

    FTMap configMap = std::get<FTMap>(argument[FTValue("config")]);
    ZIMMessageSendConfig config;
    std::shared_ptr<ZIMPushConfig> pushConfigPtr = nullptr;
    std::shared_ptr<ZIMVoIPConfig> voIPConfigPtr = nullptr;
    config.priority = (ZIMMessagePriority)ZIMPluginConverter::cnvFTMapToInt32(configMap[FTValue("priority")]);
    config.hasReceipt = std::get<bool>(configMap[FTValue("hasReceipt")]);
    if (std::holds_alternative<std::monostate>(configMap[FTValue("pushConfig")])) {
        config.pushConfig = nullptr;
    }
    else {
        pushConfigPtr = ZIMPluginConverter::cnvZIMPushConfigToObject(std::get<FTMap>(configMap[FTValue("pushConfig")]),voIPConfigPtr);
        config.pushConfig = pushConfigPtr.get();
    }

    auto mediaMessagePtr = std::static_pointer_cast<ZIMMediaMessage>(messagePtr);
    int32_t progressID = ZIMPluginConverter::cnvFTMapToInt32(argument[FTValue("progressID")]);
    auto messageID = ZIMPluginConverter::cnvFTMapToInt32(argument[FTValue("messageID")]);
    int32_t messageAttachedCallbackID = ZIMPluginConverter::cnvFTMapToInt32(argument[FTValue("messageAttachedCallbackID")]);

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));


    auto notification = std::make_shared<zim::ZIMMediaMessageSendNotification>(
            [=](const std::shared_ptr<zim::ZIMMessage> &message) {
                if(messageAttachedCallbackID == 0){
                    return;
                }
                FTMap onMessageAttachedMap;
                onMessageAttachedMap[FTValue("handle")] = FTValue(handle);
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
                progressRetMap[FTValue("handle")] = FTValue(handle);
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

    auto fileType = ZIMPluginConverter::cnvFTMapToInt32(argument[FTValue("fileType")]);
    auto messagePtr = ZIMPluginConverter::cnvZIMMessageToObject(std::get<FTMap>(argument[FTValue("message")]));
    
    auto mediaMessagePtr = std::static_pointer_cast<ZIMMediaMessage>(messagePtr);
    auto progressID = ZIMPluginConverter::cnvFTMapToInt32(argument[FTValue("progressID")]);
    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    zim->downloadMediaFile(mediaMessagePtr.get(), (ZIMMediaFileType)fileType, [=](const std::shared_ptr<ZIMMediaMessage>& message,
        unsigned long long currentFileSize, unsigned long long totalFileSize) {

        FTMap progressRetMap;
        progressRetMap[FTValue("handle")] = FTValue(handle);
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
    int conversationType = ZIMPluginConverter::cnvFTMapToInt32(argument[FTValue("conversationType")]);

    FTMap configMap = std::get<FTMap>(argument[FTValue("config")]);
    ZIMMessageQueryConfig config;
    config.count = ZIMPluginConverter::cnvFTMapToInt32(configMap[FTValue("count")]);
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
	int conversationType = ZIMPluginConverter::cnvFTMapToInt32(argument[FTValue("conversationType")]);

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
    int conversationType = ZIMPluginConverter::cnvFTMapToInt32(argument[FTValue("conversationType")]);
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

void ZIMPluginMethodHandler::deleteAllConversationMessages(flutter::EncodableMap& argument,
	std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

	auto handle = std::get<std::string>(argument[FTValue("handle")]);
	auto zim = this->engineMap[handle];
	if (!zim) {
		result->Error("-1", "no native instance");
		return;
	}

	FTMap configMap = std::get<FTMap>(argument[FTValue("config")]);
	ZIMMessageDeleteConfig config;
	config.isAlsoDeleteServerMessage = std::get<bool>(configMap[FTValue("isAlsoDeleteServerMessage")]);

	auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
	zim->deleteAllConversationMessages(config, [=](const ZIMError& errorInfo) {
		if (errorInfo.code == 0) {
			sharedPtrResult->Success();
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
    int conversationType = ZIMPluginConverter::cnvFTMapToInt32(argument[FTValue("conversationType")]);
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
    int conversationType = ZIMPluginConverter::cnvFTMapToInt32(argument[FTValue("conversationType")]);
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

void ZIMPluginMethodHandler::searchLocalMessages(flutter::EncodableMap& argument,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
    
    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }

    auto conversationID = std::get<std::string>(argument[FTValue("conversationID")]);
    int conversationType = std::get<int32_t>(argument[FTValue("conversationType")]);
    auto config = ZIMPluginConverter::cnvZIMMessageSearchConfigMapToObject(std::get<FTMap>(argument[FTValue("config")]));
    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    zim->searchLocalMessages(conversationID, (ZIMConversationType)conversationType, config, [=](const std::string &conversationID, ZIMConversationType conversationType, const std::vector<std::shared_ptr<ZIMMessage>> &messageList, const std::shared_ptr<ZIMMessage> &nextMessage, const ZIMError &errorInfo) {
        if (errorInfo.code == 0) {
            FTMap retMap;
            retMap[FTValue("conversationID")] = FTValue(conversationID);
            retMap[FTValue("conversationType")] = FTValue(conversationType);
            retMap[FTValue("messageList")] = ZIMPluginConverter::cnvZIMMessageListToArray(messageList);
            retMap[FTValue("nextMessage")] = ZIMPluginConverter::cnvZIMMessageObjectToMap(nextMessage.get());
            sharedPtrResult->Success(retMap);
        }
        else {
            sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}

void ZIMPluginMethodHandler::searchGlobalLocalMessages(flutter::EncodableMap& argument,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }

    auto config = ZIMPluginConverter::cnvZIMMessageSearchConfigMapToObject(std::get<FTMap>(argument[FTValue("config")]));
    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    zim->searchGlobalLocalMessages(config, [=](const std::vector<std::shared_ptr<ZIMMessage>> &messageList, const std::shared_ptr<ZIMMessage> &nextMessage, const ZIMError &errorInfo) {
        if (errorInfo.code == 0) {
            FTMap retMap;
            retMap[FTValue("messageList")] = ZIMPluginConverter::cnvZIMMessageListToArray(messageList);
            retMap[FTValue("nextMessage")] = ZIMPluginConverter::cnvZIMMessageObjectToMap(nextMessage.get());
            sharedPtrResult->Success(retMap);
        }
        else {
            sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}

void ZIMPluginMethodHandler::searchLocalConversations(flutter::EncodableMap& argument,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }

    auto config = ZIMPluginConverter::cnvZIMConversationSearchConfigMapToObject(std::get<FTMap>(argument[FTValue("config")]));
    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    zim->searchLocalConversations(config, [=](const std::vector<ZIMConversationSearchInfo> &conversationSearchInfoList, unsigned int nextFlag, const ZIMError &errorInfo) {
        if (errorInfo.code == 0) {
            FTMap retMap;
            retMap[FTValue("conversationSearchInfoList")] = ZIMPluginConverter::cnvZIMConversationSearchInfoListToArray(conversationSearchInfoList);
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

void ZIMPluginMethodHandler::leaveAllRoom(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result){
    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }
    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    zim->leaveAllRoom([=](const std::vector<std::string> &roomIDList, const ZIMError &errorInfo) {
        if (errorInfo.code == 0) {
            FTMap retMap;
            retMap[FTValue("roomIDList")] = ZIMPluginConverter::cnvStlVectorToFTArray(roomIDList);
            sharedPtrResult->Success(retMap);
        } else {
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

void ZIMPluginMethodHandler::queryRoomMembers(flutter::EncodableMap& argument,
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
	zim->queryRoomMembers(userIDs, roomID, [=](
		const std::string& roomID, const std::vector<ZIMRoomMemberInfo>& memberList,
		const std::vector<ZIMErrorUserInfo>& errorUserList, const ZIMError& errorInfo) {
			if (errorInfo.code == 0) {
				FTMap retMap;
				retMap[FTValue("memberList")] = ZIMPluginConverter::cnvZIMRoomMemberInfoListToArray(memberList);
				retMap[FTValue("roomID")] = FTValue(roomID);
                retMap[FTValue("errorUserList")] = ZIMPluginConverter::cnvZIMErrorUserListToArray(errorUserList);
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


void ZIMPluginMethodHandler::updateGroupJoinMode(flutter::EncodableMap& argument,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }

    auto groupID = std::get<std::string>(argument[FTValue("groupID")]);
    auto mode =  (ZIMGroupJoinMode)std::get<int32_t>(argument[FTValue("mode")]);
    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    zim->updateGroupJoinMode(mode, groupID, [=](const std::string &groupID, ZIMGroupJoinMode mode, const ZIMError &errorInfo) {
        if (errorInfo.code == 0) {
            FTMap retMap;
            retMap[FTValue("groupID")] = FTValue(groupID);
            retMap[FTValue("mode")] = FTValue((int32_t)mode);
            sharedPtrResult->Success(retMap);
        }
        else {
            sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}

void ZIMPluginMethodHandler::updateGroupInviteMode(flutter::EncodableMap& argument,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }

    auto groupID = std::get<std::string>(argument[FTValue("groupID")]);
  
    int mode = ZIMPluginConverter::cnvFTMapToInt32(argument[FTValue("mode")]);
    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    zim->updateGroupInviteMode((ZIMGroupInviteMode)mode, groupID, [=](const std::string &groupID, ZIMGroupInviteMode mode, const ZIMError &errorInfo) {
        if (errorInfo.code == 0) {
            FTMap retMap;
            retMap[FTValue("groupID")] = FTValue(groupID);
            retMap[FTValue("mode")] = FTValue((int32_t)mode);
            sharedPtrResult->Success(retMap);
        }
        else {
            sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}

void ZIMPluginMethodHandler::updateGroupBeInviteMode(flutter::EncodableMap& argument,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }

    auto groupID = std::get<std::string>(argument[FTValue("groupID")]);
    auto mode =  (ZIMGroupBeInviteMode)std::get<int32_t>(argument[FTValue("mode")]);
    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    zim->updateGroupBeInviteMode(mode, groupID, [=](const std::string &groupID, ZIMGroupBeInviteMode mode, const ZIMError &errorInfo) {
        if (errorInfo.code == 0) {
            FTMap retMap;
            retMap[FTValue("groupID")] = FTValue(groupID);
            retMap[FTValue("mode")] = FTValue((int32_t)mode);
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
    int role = ZIMPluginConverter::cnvFTMapToInt32(argument[FTValue("role")]);
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

void ZIMPluginMethodHandler::searchLocalGroups(flutter::EncodableMap& argument,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }

    auto config = ZIMPluginConverter::cnvZIMGroupSearchConfigMapToObject(std::get<FTMap>(argument[FTValue("config")]));
    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    zim->searchLocalGroups(config, [=](const std::vector<ZIMGroupSearchInfo> &groupSearchInfoList, unsigned int nextFlag, const ZIMError &errorInfo) {
        if (errorInfo.code == 0) {
            FTMap retMap;
            retMap[FTValue("groupSearchInfoList")] = ZIMPluginConverter::cnvZIMGroupSearchInfoListToArray(groupSearchInfoList);
            retMap[FTValue("nextFlag")] = FTValue((int32_t)nextFlag);

            sharedPtrResult->Success(retMap);
        }
        else {
            sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}

void ZIMPluginMethodHandler::searchLocalGroupMembers(flutter::EncodableMap& argument,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
    
    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }

    auto groupID = std::get<std::string>(argument[FTValue("groupID")]);
    auto config = ZIMPluginConverter::cnvZIMGroupMemberSearchConfigMapToObject(std::get<FTMap>(argument[FTValue("config")]));
    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    zim->searchLocalGroupMembers(groupID, config, [=](const std::string &groupID, const std::vector<ZIMGroupMemberInfo> &userList, unsigned int nextFlag, const ZIMError &errorInfo) {
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

void ZIMPluginMethodHandler::muteGroup(flutter::EncodableMap& argument,
		std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result){
    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }

    auto groupID = std::get<std::string>(argument[FTValue("groupID")]);
    bool isMute =  std::get<bool>(argument[FTValue("isMute")]);
    auto config = ZIMPluginConverter::cnvZIMGroupMuteConfigToObject(std::get<FTMap>(argument[FTValue("config")]));
    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    zim->muteGroup(isMute,groupID,config,[=](const std::string &groupID, bool isMute,const ZIMGroupMuteInfo &info, const ZIMError &errorInfo){
        if (errorInfo.code == 0) {
            FTMap retMap;
            retMap[FTValue("isMute")] = FTValue(isMute);
            retMap[FTValue("groupID")] = FTValue(groupID);
            retMap[FTValue("info")] = ZIMPluginConverter::cnvZIMGroupMuteInfoToMap(info);
            sharedPtrResult->Success(retMap);
        }
        else {
            sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}

void ZIMPluginMethodHandler::sendGroupJoinApplication(flutter::EncodableMap& argument,
                              std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result){
    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }
    auto groupID = std::get<std::string>(argument[FTValue("groupID")]);
    auto config = ZIMPluginConverter::cnvZIMGroupJoinApplicationSendConfigToObject(std::get<FTMap>(argument[FTValue("config")]));
    auto configMap = std::get<FTMap>(argument[FTValue("config")]);
	std::shared_ptr<ZIMPushConfig> pushConfigPtr = nullptr;
	std::shared_ptr<ZIMVoIPConfig> voIPConfigPtr = nullptr;
	if (std::holds_alternative<std::monostate>(configMap[FTValue("pushConfig")])) {
		config.pushConfig = nullptr;
	}
	else {
		pushConfigPtr = ZIMPluginConverter::cnvZIMPushConfigToObject(std::get<FTMap>(configMap[FTValue("pushConfig")]), voIPConfigPtr);
		config.pushConfig = pushConfigPtr.get();
	}
    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    zim->sendGroupJoinApplication(groupID,config,[=](const std::string &groupID, const ZIMError &errorInfo){
        if (errorInfo.code == 0) {
            FTMap retMap;
            retMap[FTValue("groupID")] = FTValue(groupID);
            sharedPtrResult->Success(retMap);
        } else {
            sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}

void ZIMPluginMethodHandler::acceptGroupJoinApplication(flutter::EncodableMap& argument,
                                std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result){
    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }
    auto groupID = std::get<std::string>(argument[FTValue("groupID")]);
    auto userID = std::get<std::string>(argument[FTValue("userID")]);
    auto config = ZIMPluginConverter::cnvZIMGroupJoinApplicationAcceptConfigToObject(std::get<FTMap>(argument[FTValue("config")]));
	auto configMap = std::get<FTMap>(argument[FTValue("config")]);
	std::shared_ptr<ZIMPushConfig> pushConfigPtr = nullptr;
	std::shared_ptr<ZIMVoIPConfig> voIPConfigPtr = nullptr;
	if (std::holds_alternative<std::monostate>(configMap[FTValue("pushConfig")])) {
		config.pushConfig = nullptr;
	}
	else {
		pushConfigPtr = ZIMPluginConverter::cnvZIMPushConfigToObject(std::get<FTMap>(configMap[FTValue("pushConfig")]), voIPConfigPtr);
		config.pushConfig = pushConfigPtr.get();
	}
    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    zim->acceptGroupJoinApplication(userID, groupID, config, [=](const std::string &groupID, const std::string &userID, const ZIMError &errorInfo){
        if (errorInfo.code == 0) {
            FTMap retMap;
            retMap[FTValue("groupID")] = FTValue(groupID);
            retMap[FTValue("userID")] = FTValue(userID);
            sharedPtrResult->Success(retMap);
        } else {
            sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}

void ZIMPluginMethodHandler::rejectGroupJoinApplication(flutter::EncodableMap& argument,
                                std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result){
    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }
    auto groupID = std::get<std::string>(argument[FTValue("groupID")]);
    auto userID = std::get<std::string>(argument[FTValue("userID")]);
    auto config = ZIMPluginConverter::cnvZIMGroupJoinApplicationRejectConfigToObject(std::get<FTMap>(argument[FTValue("config")]));
	auto configMap = std::get<FTMap>(argument[FTValue("config")]);
	std::shared_ptr<ZIMPushConfig> pushConfigPtr = nullptr;
	std::shared_ptr<ZIMVoIPConfig> voIPConfigPtr = nullptr;
	if (std::holds_alternative<std::monostate>(configMap[FTValue("pushConfig")])) {
		config.pushConfig = nullptr;
	}
	else {
		pushConfigPtr = ZIMPluginConverter::cnvZIMPushConfigToObject(std::get<FTMap>(configMap[FTValue("pushConfig")]), voIPConfigPtr);
		config.pushConfig = pushConfigPtr.get();
	}
    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    zim->rejectGroupJoinApplication(userID, groupID, config, [=](const std::string &groupID, const std::string &userID, const ZIMError &errorInfo){
        if (errorInfo.code == 0) {
            FTMap retMap;
            retMap[FTValue("groupID")] = FTValue(groupID);
            retMap[FTValue("userID")] = FTValue(userID);
            sharedPtrResult->Success(retMap);
        } else {
            sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}

void ZIMPluginMethodHandler::sendGroupInviteApplications(flutter::EncodableMap& argument,
                                std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result){
    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }
    auto groupID = std::get<std::string>(argument[FTValue("groupID")]);
    auto userIDs = std::get<FTArray>(argument[FTValue("userIDs")]);
    std::vector<std::string> userIDsVec;
    for (auto& userIDValue : userIDs) {
        auto userID = std::get<std::string>(userIDValue);
        userIDsVec.emplace_back(userID);
    }
    auto config = ZIMPluginConverter::cnvZIMGroupInviteApplicationSendConfigToObject(std::get<FTMap>(argument[FTValue("config")]));
	auto configMap = std::get<FTMap>(argument[FTValue("config")]);
	std::shared_ptr<ZIMPushConfig> pushConfigPtr = nullptr;
	std::shared_ptr<ZIMVoIPConfig> voIPConfigPtr = nullptr;
	if (std::holds_alternative<std::monostate>(configMap[FTValue("pushConfig")])) {
		config.pushConfig = nullptr;
	}
	else {
		pushConfigPtr = ZIMPluginConverter::cnvZIMPushConfigToObject(std::get<FTMap>(configMap[FTValue("pushConfig")]), voIPConfigPtr);
		config.pushConfig = pushConfigPtr.get();
	}
    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    zim->sendGroupInviteApplications(userIDsVec, groupID, config, [=](
            const std::string &groupID, const std::vector<ZIMErrorUserInfo> &errorUserList,
            const ZIMError &errorInfo){
        if (errorInfo.code == 0) {
            FTMap retMap;
            retMap[FTValue("groupID")] = FTValue(groupID);
            retMap[FTValue("errorUserList")] = ZIMPluginConverter::cnvZIMErrorUserListToArray(errorUserList);

            sharedPtrResult->Success(retMap);
        } else {
            sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}

void ZIMPluginMethodHandler::acceptGroupInviteApplication(flutter::EncodableMap& argument,
                                  std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result){
    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }
    auto groupID = std::get<std::string>(argument[FTValue("groupID")]);
    auto inviterUserID = std::get<std::string>(argument[FTValue("inviterUserID")]);
    auto config = ZIMPluginConverter::cnvZIMGroupInviteApplicationAcceptConfigToObject(std::get<FTMap>(argument[FTValue("config")]));
	auto configMap = std::get<FTMap>(argument[FTValue("config")]);
	std::shared_ptr<ZIMPushConfig> pushConfigPtr = nullptr;
	std::shared_ptr<ZIMVoIPConfig> voIPConfigPtr = nullptr;
	if (std::holds_alternative<std::monostate>(configMap[FTValue("pushConfig")])) {
		config.pushConfig = nullptr;
	}
	else {
		pushConfigPtr = ZIMPluginConverter::cnvZIMPushConfigToObject(std::get<FTMap>(configMap[FTValue("pushConfig")]), voIPConfigPtr);
		config.pushConfig = pushConfigPtr.get();
	}
    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    zim->acceptGroupInviteApplication(inviterUserID, groupID, config, [=](
            const ZIMGroupFullInfo &fullInfo, const std::string &inviterUserID, const ZIMError &errorInfo){
        if (errorInfo.code == 0) {
            FTMap retMap;
            retMap[FTValue("groupInfo")] =  ZIMPluginConverter::cnvZIMGroupFullInfoToMap(fullInfo);
            retMap[FTValue("inviterUserID")] = FTValue(inviterUserID);

            sharedPtrResult->Success(retMap);
        } else {
            sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}

void ZIMPluginMethodHandler::rejectGroupInviteApplication(flutter::EncodableMap& argument,
                                  std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result){
    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }
    auto groupID = std::get<std::string>(argument[FTValue("groupID")]);
    auto inviterUserID = std::get<std::string>(argument[FTValue("inviterUserID")]);
    auto config = ZIMPluginConverter::cnvZIMGroupInviteApplicationRejectConfigToObject(std::get<FTMap>(argument[FTValue("config")]));
	auto configMap = std::get<FTMap>(argument[FTValue("config")]);
	std::shared_ptr<ZIMPushConfig> pushConfigPtr = nullptr;
	std::shared_ptr<ZIMVoIPConfig> voIPConfigPtr = nullptr;
	if (std::holds_alternative<std::monostate>(configMap[FTValue("pushConfig")])) {
		config.pushConfig = nullptr;
	}
	else {
		pushConfigPtr = ZIMPluginConverter::cnvZIMPushConfigToObject(std::get<FTMap>(configMap[FTValue("pushConfig")]), voIPConfigPtr);
		config.pushConfig = pushConfigPtr.get();
	}
    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    zim->rejectGroupInviteApplication(inviterUserID, groupID, config, [=](
            const std::string &groupID, const std::string &inviterUserID, const ZIMError &errorInfo){
        if (errorInfo.code == 0) {
            FTMap retMap;
            retMap[FTValue("groupID")] = FTValue(groupID);
            retMap[FTValue("inviterUserID")] = FTValue(inviterUserID);
            sharedPtrResult->Success(retMap);
        } else {
            sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}

void ZIMPluginMethodHandler::queryGroupApplicationList(flutter::EncodableMap& argument,
                               std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result){
    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }
    auto config = ZIMPluginConverter::cnvZIMGroupApplicationListQueryConfigToObject(std::get<FTMap>(argument[FTValue("config")]));
    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    zim->queryGroupApplicationList(config, [=](const std::vector<ZIMGroupApplicationInfo> &applicationList,
                                               unsigned long long nextFlag, const ZIMError &errorInfo){
        if (errorInfo.code == 0) {
            FTMap retMap;
            retMap[FTValue("nextFlag")] = FTValue((int32_t)nextFlag);
            retMap[FTValue("applicationList")] = ZIMPluginConverter::cnvZIMGroupApplicationInfoToArray(applicationList);
            sharedPtrResult->Success(retMap);
        } else {
            sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}

void ZIMPluginMethodHandler::muteGroupMemberList(flutter::EncodableMap& argument,
		std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result){
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
    auto groupID = std::get<std::string>(argument[FTValue("groupID")]);
    bool isMute =  std::get<bool>(argument[FTValue("isMute")]);
    auto config = ZIMPluginConverter::cnvZIMGroupMemberMuteConfigToObject(std::get<FTMap>(argument[FTValue("config")]));
    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    zim->muteGroupMembers(isMute,userIDsVec,groupID,config,[=](const std::string &groupID,bool isMute, unsigned int duration,
    const std::vector<std::string> &mutedMemberIDs,
    const std::vector<ZIMErrorUserInfo> &errorUserList, const ZIMError &errorInfo){
        if (errorInfo.code == 0) {
            FTMap retMap;
            retMap[FTValue("isMute")] = FTValue(isMute);
            retMap[FTValue("groupID")] = FTValue(groupID);
            retMap[FTValue("duration")] = FTValue((int32_t)duration);
            retMap[FTValue("mutedMemberIDs")] = ZIMPluginConverter::cnvStlVectorToFTArray(mutedMemberIDs);
            retMap[FTValue("errorUserList")] = ZIMPluginConverter::cnvZIMErrorUserListToArray(errorUserList);
            sharedPtrResult->Success(retMap);
        }
        else {
            sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}

void ZIMPluginMethodHandler::queryGroupMemberMutedList(flutter::EncodableMap& argument,
		std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result){
    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }
    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    auto groupID = std::get<std::string>(argument[FTValue("groupID")]);
    auto config = ZIMPluginConverter::cnvZIMGroupMemberMutedListQueryConfigToObject(std::get<FTMap>(argument[FTValue("config")]));
    zim->queryGroupMemberMutedList(groupID,config,[=](const std::string &groupID, unsigned long long nextFlag,
                       const std::vector<ZIMGroupMemberInfo> &userList, const ZIMError &errorInfo){
        if (errorInfo.code == 0) {
            FTMap retMap;
            retMap[FTValue("groupID")] = FTValue(groupID);
            retMap[FTValue("nextFlag")] = FTValue((int64_t)nextFlag);
            retMap[FTValue("userList")] = ZIMPluginConverter::cnvZIMGroupMemberInfoListToArray(userList);
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
    config.mode = (ZIMCallInvitationMode)std::get<int32_t>(configMap[FTValue("mode")]);
    config.timeout = ZIMPluginConverter::cnvFTMapToInt32(configMap[FTValue("timeout")]);
    config.extendedData = std::get<std::string>(configMap[FTValue("extendedData")]);
    config.enableNotReceivedCheck = std::get<bool>(configMap[FTValue("enableNotReceivedCheck")]);
    std::shared_ptr<ZIMPushConfig> pushConfigPtr = nullptr;
    std::shared_ptr<ZIMVoIPConfig> voIPConfigPtr = nullptr;
    if (std::holds_alternative<std::monostate>(configMap[FTValue("pushConfig")])) {
        config.pushConfig = nullptr;
    }
    else {
        pushConfigPtr = ZIMPluginConverter::cnvZIMPushConfigToObject(std::get<FTMap>(configMap[FTValue("pushConfig")]),voIPConfigPtr);
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

void ZIMPluginMethodHandler::callingInvite(flutter::EncodableMap& argument,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result){

    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }

    auto invitees = ZIMPluginConverter::cnvFTArrayToStlVector(std::get<FTArray>(argument[FTValue("invitees")]));
    auto callID = std::get<std::string>(argument[FTValue("callID")]);
    auto configMap = std::get<FTMap>(argument[FTValue("config")]);

    ZIMCallingInviteConfig config;
    std::shared_ptr<ZIMPushConfig> pushConfigPtr = nullptr;
    std::shared_ptr<ZIMVoIPConfig> voIPConfigPtr = nullptr;
    if (std::holds_alternative<std::monostate>(configMap[FTValue("pushConfig")])) {
        config.pushConfig = nullptr;
    }
    else {
        pushConfigPtr = ZIMPluginConverter::cnvZIMPushConfigToObject(std::get<FTMap>(configMap[FTValue("pushConfig")]),voIPConfigPtr);
        config.pushConfig = pushConfigPtr.get();
    }
    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    zim->callingInvite(invitees, callID, config, [=](const std::string& callID, const ZIMCallingInvitationSentInfo& info, const ZIMError& errorInfo) {
        if (errorInfo.code == 0) {
            FTMap retMap;
            retMap[FTValue("callID")] = FTValue(callID);
            retMap[FTValue("info")] = ZIMPluginConverter::cnvZIMCallingInvitationSentInfoToMap(info);

            sharedPtrResult->Success(retMap);
        }
        else {
            sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}

void ZIMPluginMethodHandler::callQuit(flutter::EncodableMap& argument,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }

    auto callID = std::get<std::string>(argument[FTValue("callID")]);
    auto configMap = std::get<FTMap>(argument[FTValue("config")]);

    ZIMCallQuitConfig config;
    config.extendedData = std::get<std::string>(configMap[FTValue("extendedData")]);
    std::shared_ptr<ZIMPushConfig> pushConfigPtr = nullptr;
    std::shared_ptr<ZIMVoIPConfig> voIPConfigPtr = nullptr;
    if (std::holds_alternative<std::monostate>(configMap[FTValue("pushConfig")])) {
        config.pushConfig = nullptr;
    }
    else {
        pushConfigPtr = ZIMPluginConverter::cnvZIMPushConfigToObject(std::get<FTMap>(configMap[FTValue("pushConfig")]),voIPConfigPtr);
        config.pushConfig = pushConfigPtr.get();
    }

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    zim->callQuit(callID, config, [=](const std::string& callID, const ZIMCallQuitSentInfo& info, const ZIMError& errorInfo) {
        if (errorInfo.code == 0) {
            FTMap retMap;
            retMap[FTValue("callID")] = FTValue(callID);
            retMap[FTValue("info")] = ZIMPluginConverter::cnvZIMCallQuitSentInfoToMap(info);
            sharedPtrResult->Success(retMap);
        }
        else {
            sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}

void ZIMPluginMethodHandler::callEnd(flutter::EncodableMap& argument,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }

    auto callID = std::get<std::string>(argument[FTValue("callID")]);
    auto configMap = std::get<FTMap>(argument[FTValue("config")]);

    ZIMCallEndConfig config;
    config.extendedData = std::get<std::string>(configMap[FTValue("extendedData")]);
    std::shared_ptr<ZIMPushConfig> pushConfigPtr = nullptr;
    std::shared_ptr<ZIMVoIPConfig> voIPConfigPtr = nullptr;
    if (std::holds_alternative<std::monostate>(configMap[FTValue("pushConfig")])) {
        config.pushConfig = nullptr;
    }
    else {
        pushConfigPtr = ZIMPluginConverter::cnvZIMPushConfigToObject(std::get<FTMap>(configMap[FTValue("pushConfig")]),voIPConfigPtr);
        config.pushConfig = pushConfigPtr.get();
    }

    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    zim->callEnd(callID, config, [=](const std::string& callID, const ZIMCallEndedSentInfo& info, const ZIMError& errorInfo) {
        if (errorInfo.code == 0) {
            FTMap retMap;
            retMap[FTValue("info")] = ZIMPluginConverter::cnvZIMCallEndSentInfoToMap(info);
            retMap[FTValue("callID")] = FTValue(callID);
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
    std::shared_ptr<ZIMPushConfig> pushConfigPtr = nullptr;
    std::shared_ptr<ZIMVoIPConfig> voIPConfigPtr = nullptr;
    if (std::holds_alternative<std::monostate>(configMap[FTValue("pushConfig")])) {
        config.pushConfig = nullptr;
    }
    else {
        pushConfigPtr = ZIMPluginConverter::cnvZIMPushConfigToObject(std::get<FTMap>(configMap[FTValue("pushConfig")]),voIPConfigPtr);
        config.pushConfig = pushConfigPtr.get();
    }
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

void ZIMPluginMethodHandler::callJoin(flutter::EncodableMap& argument,
	std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

	auto handle = std::get<std::string>(argument[FTValue("handle")]);
	auto zim = this->engineMap[handle];
	if (!zim) {
		result->Error("-1", "no native instance");
		return;
	}

	auto callID = std::get<std::string>(argument[FTValue("callID")]);
	auto configMap = std::get<FTMap>(argument[FTValue("config")]);

    ZIMCallJoinConfig  config;
	config.extendedData = std::get<std::string>(configMap[FTValue("extendedData")]);

	auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
	zim->callJoin(callID, config, [=](const std::string& callID, const ZIMCallJoinSentInfo& info, const ZIMError& errorInfo) {
		if (errorInfo.code == 0) {
			FTMap retMap;
			retMap[FTValue("info")] = ZIMPluginConverter::cnvZIMCallJoinSentInfoToMap(info);
			retMap[FTValue("callID")] = FTValue(callID);
			sharedPtrResult->Success(retMap);
		}
		else {
			sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
		}
		});
}

void ZIMPluginMethodHandler::queryCallList(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result){

    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }

    auto configMap = std::get<FTMap>(argument[FTValue("config")]);

    ZIMCallInvitationQueryConfig config;
    config.count = std::get<int32_t>(configMap[FTValue("count")]);

    if (std::holds_alternative<int32_t>(configMap[FTValue("nextFlag")])) {
        config.nextFlag = (unsigned int)std::get<int32_t>(configMap[FTValue("nextFlag")]);
    }
    else {
        config.nextFlag = (long long)std::get<int64_t>(configMap[FTValue("nextFlag")]);
    }
    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    zim->queryCallInvitationList(config, [=](const std::vector<ZIMCallInfo> &callList, long long nextFlag, const ZIMError& errorInfo) {
        if (errorInfo.code == 0) {
            FTMap retMap;

            FTArray callInfoArray;
            for (auto& callInfo : callList) {
                auto callInfoMap = ZIMPluginConverter::cnvZIMCallInfoToMap(callInfo);
                callInfoArray.emplace_back(callInfoMap);
            }

            retMap[FTValue("callList")] = callInfoArray;
            retMap[FTValue("nextFlag")] = FTValue((int64_t)nextFlag);

            sharedPtrResult->Success(retMap);
        }
        else {
            sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}
void ZIMPluginMethodHandler::addMessageReaction(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result){
    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }
    auto messagePtr = ZIMPluginConverter::cnvZIMMessageToObject(std::get<FTMap>(argument[FTValue("message")]));
    auto reactionType = std::get<std::string>(argument[FTValue("reactionType")]);
    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));

    zim->addMessageReaction(reactionType,messagePtr, [=](const ZIMMessageReaction &reaction, const ZIMError &errorInfo) {
        if (errorInfo.code == 0) {
            FTMap retMap;
            retMap[FTValue("reaction")] = ZIMPluginConverter::cnvZIMMessageReactionToMap(reaction);;
            sharedPtrResult->Success(retMap);
        }
        else {
            sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}
void ZIMPluginMethodHandler::deleteMessageReaction(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result){
    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }
    auto messagePtr = ZIMPluginConverter::cnvZIMMessageToObject(std::get<FTMap>(argument[FTValue("message")]));
    auto reactionType = std::get<std::string>(argument[FTValue("reactionType")]);
    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    zim->deleteMessageReaction(reactionType,messagePtr, [=](const ZIMMessageReaction &reaction, const ZIMError &errorInfo) {
        if (errorInfo.code == 0) {
            FTMap retMap;
            retMap[FTValue("reaction")] = ZIMPluginConverter::cnvZIMMessageReactionToMap(reaction);;
            sharedPtrResult->Success(retMap);
        }
        else {
            sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}
void ZIMPluginMethodHandler::queryMessageReactionUserList(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result){
    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }
    auto messagePtr = ZIMPluginConverter::cnvZIMMessageToObject(std::get<FTMap>(argument[FTValue("message")]));
    auto config = ZIMPluginConverter::cnvZIMMessageReactionUserQueryConfigMapToObject(std::get<FTMap>(argument[FTValue("config")]));
    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    zim->queryMessageReactionUserList(messagePtr,config, [=](const std::shared_ptr<ZIMMessage> &message,
    const std::vector<ZIMMessageReactionUserInfo> &userList, const std::string &reactionType,
    const long long nextFlag, const unsigned int totalCount, const ZIMError &errorInfo) {
        if (errorInfo.code == 0) {
            FTMap retMap;
            auto messageMap = ZIMPluginConverter::cnvZIMMessageObjectToMap(message.get());
            retMap[FTValue("message")] = messageMap;
            auto userListMap = ZIMPluginConverter::cnvZIMMessageReactionUserInfoListToArray(userList);
            retMap[FTValue("userList")] = userListMap;
            retMap[FTValue("reactionType")] = FTValue(reactionType);
            retMap[FTValue("nextFlag")] = FTValue((int64_t)nextFlag);
            retMap[FTValue("totalCount")] = FTValue((int32_t)totalCount);;
            sharedPtrResult->Success(retMap);
        }
        else {
            sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}

void ZIMPluginMethodHandler::addUsersToBlacklist(flutter::EncodableMap& argument,std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result){
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
    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    zim->addUsersToBlacklist(userIDsVec, [=](const std::vector<ZIMErrorUserInfo> &errorUserList, const ZIMError &errorInfo){
        if (errorInfo.code == 0) {
            FTMap retMap;
            retMap[FTValue("errorUserList")] = ZIMPluginConverter::cnvZIMErrorUserListToArray(errorUserList);
            sharedPtrResult->Success(retMap);
        }
        else {
            sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });

}
void ZIMPluginMethodHandler::removeUsersFromBlacklist(flutter::EncodableMap& argument,std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result){
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
    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    zim->removeUsersFromBlacklist(userIDsVec, [=](const std::vector<ZIMErrorUserInfo> &errorUserList, const ZIMError &errorInfo){
        if (errorInfo.code == 0) {
            FTMap retMap;
            retMap[FTValue("errorUserList")] = ZIMPluginConverter::cnvZIMErrorUserListToArray(errorUserList);
            sharedPtrResult->Success(retMap);
        }
        else {
            sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });

}
void ZIMPluginMethodHandler::queryBlackList(flutter::EncodableMap& argument,std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result){
    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }
    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    ZIMBlacklistQueryConfig config = ZIMPluginConverter::cnvZIMBlacklistQueryConfigToObject(std::get<FTMap>(argument[FTValue("config")]));
    zim->queryBlacklist(config, [=](const std::vector<ZIMUserInfo> &blacklist, long long nextFlag, const ZIMError &errorInfo){
        if (errorInfo.code == 0) {
            FTMap retMap;
            retMap[FTValue("nextFlag")] = FTValue((int64_t)nextFlag);
            retMap[FTValue("blacklist")] = ZIMPluginConverter::cnvZIMUserListToArray(blacklist);
            sharedPtrResult->Success(retMap);
        }
        else {
            sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}
void ZIMPluginMethodHandler::checkUserIsInBlackList(flutter::EncodableMap& argument,std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result){
    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }
    auto userID = std::get<std::string>(argument[FTValue("userID")]);
    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
    zim->checkUserIsInBlacklist(userID, [=](bool isUserInBlacklist, const ZIMError &errorInfo){
        if (errorInfo.code == 0) {
            FTMap retMap;
            retMap[FTValue("isUserInBlacklist")] = FTValue(isUserInBlacklist);
            sharedPtrResult->Success(retMap);
        }
        else {
            sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
        } 
    });
}

void ZIMPluginMethodHandler::addFriend(flutter::EncodableMap& argument, std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
	auto handle = std::get<std::string>(argument[FTValue("handle")]);
	auto zim = this->engineMap[handle];
	if (!zim) {
		result->Error("-1", "no native instance");
		return;
	}
	auto userID = std::get<std::string>(argument[FTValue("userID")]);
    ZIMFriendAddConfig config = ZIMPluginConverter::cnvZIMFriendAddConfigToObject(std::get<FTMap>(argument[FTValue("config")]));
	auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
	zim->addFriend(userID, config,[=](const ZIMFriendInfo& friendInfo, const ZIMError& errorInfo) {
		if (errorInfo.code == 0) {
			FTMap retMap;
            retMap[FTValue("friendInfo")] = ZIMPluginConverter::cnvZIMFriendInfoToMap(friendInfo);
			sharedPtrResult->Success(retMap);
		}
		else {
			sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
		}
		});
}

void ZIMPluginMethodHandler::sendFriendApplication(flutter::EncodableMap& argument, std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
	auto handle = std::get<std::string>(argument[FTValue("handle")]);
	auto zim = this->engineMap[handle];
	if (!zim) {
		result->Error("-1", "no native instance");
		return;
	}
	auto applyUserID = std::get<std::string>(argument[FTValue("userID")]);
    ZIMFriendApplicationSendConfig config = ZIMPluginConverter::cnvZIMFriendApplicationSendConfigToObject(std::get<FTMap>(argument[FTValue("config")]));
    
    FTMap configMap = std::get<FTMap>(argument[FTValue("config")]);
    std::shared_ptr<ZIMPushConfig> pushConfigPtr = nullptr;
	std::shared_ptr<ZIMVoIPConfig> voIPConfigPtr = nullptr;
	if (std::holds_alternative<std::monostate>(configMap[FTValue("pushConfig")])) {
		config.pushConfig = nullptr;
	}
	else {
		pushConfigPtr = ZIMPluginConverter::cnvZIMPushConfigToObject(std::get<FTMap>(configMap[FTValue("pushConfig")]), voIPConfigPtr);
		config.pushConfig = pushConfigPtr.get();
	}

	auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
	zim->sendFriendApplication(applyUserID, config, [=](
		const ZIMFriendApplicationInfo& friendApplicationInfo, const ZIMError& errorInfo) {
		if (errorInfo.code == 0) {
			FTMap retMap;
			retMap[FTValue("applicationInfo")] = ZIMPluginConverter::cnvZIMFriendApplicationInfoToMap(friendApplicationInfo);
			sharedPtrResult->Success(retMap);
		}
		else {
			sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
		}
		});
}

void ZIMPluginMethodHandler::deleteFriends(flutter::EncodableMap& argument, std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
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

    ZIMFriendDeleteConfig config = ZIMPluginConverter::cnvZIMFriendDeleteConfigToObject(std::get<FTMap>(argument[FTValue("config")]));
	auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
	zim->deleteFriends(userIDsVec, config, [=](
		const std::vector<ZIMErrorUserInfo>& errorUserList, const ZIMError& errorInfo) {
			if (errorInfo.code == 0) {
				FTMap retMap;
				FTArray errorUserInfoArray;
				for (auto& errorUserInfo : errorUserList) {
					auto errorUserInfoMap = ZIMPluginConverter::cnvZIMErrorUserInfoToMap(errorUserInfo);
					errorUserInfoArray.emplace_back(errorUserInfoMap);
				}

				retMap[FTValue("errorUserList")] = errorUserInfoArray;
                sharedPtrResult->Success(retMap);
			}
			else {
				sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
			}
		});
}

void ZIMPluginMethodHandler::checkFriendsRelation(flutter::EncodableMap& argument, std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
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
    ZIMFriendRelationCheckConfig config;
    config.type = (ZIMFriendRelationCheckType)ZIMPluginConverter::cnvFTMapToInt32(configMap[FTValue("type")]);
	auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
	zim->checkFriendsRelation(userIDsVec, config, [=](
		const std::vector<ZIMFriendRelationInfo>& friendRelationInfoList, const std::vector<ZIMErrorUserInfo>& errorUserList, const ZIMError& errorInfo) {
			if (errorInfo.code == 0) {
				FTArray friendRelationInfoArray;
				for (auto& info : friendRelationInfoList) {
					auto infoMap = ZIMPluginConverter::cnvZIMFriendRelationInfoToMap(info);
                    friendRelationInfoArray.emplace_back(infoMap);
				}

				FTArray errorUserInfoArray;
				for (auto& errorUserInfo : errorUserList) {
					auto errorUserInfoMap = ZIMPluginConverter::cnvZIMErrorUserInfoToMap(errorUserInfo);
					errorUserInfoArray.emplace_back(errorUserInfoMap);
				}

				FTMap retMap;
				retMap[FTValue("relationInfos")] = friendRelationInfoArray;
				retMap[FTValue("errorUserList")] = errorUserInfoArray;

				sharedPtrResult->Success(retMap);
			}
			else {
				sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
			}
		});
}

void ZIMPluginMethodHandler::updateFriendAlias(flutter::EncodableMap& argument, std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
	auto handle = std::get<std::string>(argument[FTValue("handle")]);
	auto zim = this->engineMap[handle];
	if (!zim) {
		result->Error("-1", "no native instance");
		return;
	}
	auto userID = std::get<std::string>(argument[FTValue("userID")]);
    auto friendAlias = std::get<std::string>(argument[FTValue("friendAlias")]);
	auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
	zim->updateFriendAlias(friendAlias, userID, [=](const ZIMFriendInfo& friendInfo, const ZIMError& errorInfo) {
			if (errorInfo.code == 0) {
				FTMap retMap;
				retMap[FTValue("friendInfo")] = ZIMPluginConverter::cnvZIMFriendInfoToMap(friendInfo);
				sharedPtrResult->Success(retMap);
			}
			else {
				sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
			}
		});
}

void ZIMPluginMethodHandler::updateFriendAttributes(flutter::EncodableMap& argument, std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
	auto handle = std::get<std::string>(argument[FTValue("handle")]);
	auto zim = this->engineMap[handle];
	if (!zim) {
		result->Error("-1", "no native instance");
		return;
	}
    auto friendAttributes = ZIMPluginConverter::cnvFTMapToSTLMap(std::get<FTMap>(argument[FTValue("friendAttributes")]));
    auto userID = std::get<std::string>(argument[FTValue("userID")]);
	auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
	zim->updateFriendAttributes(friendAttributes, userID, [=](const ZIMFriendInfo& friendInfo, const ZIMError& errorInfo) {
		if (errorInfo.code == 0) {
			FTMap retMap;
			retMap[FTValue("friendInfo")] = ZIMPluginConverter::cnvZIMFriendInfoToMap(friendInfo);
			sharedPtrResult->Success(retMap);
		}
		else {
			sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
		}
		});
}

void ZIMPluginMethodHandler::queryFriendsInfo(flutter::EncodableMap& argument, std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
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

	auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
	zim->queryFriendsInfo(userIDsVec, [=](
		const std::vector<ZIMFriendInfo>& friendInfoList,
		const std::vector<ZIMErrorUserInfo>& errorUserList, const ZIMError& errorInfo) {
			if (errorInfo.code == 0) {
				FTArray friendInfoArray;
				for (auto& info : friendInfoList) {
					auto infoMap = ZIMPluginConverter::cnvZIMFriendInfoToMap(info);
                    friendInfoArray.emplace_back(infoMap);
				}

				FTArray errorUserInfoArray;
				for (auto& errorUserInfo : errorUserList) {
					auto errorUserInfoMap = ZIMPluginConverter::cnvZIMErrorUserInfoToMap(errorUserInfo);
					errorUserInfoArray.emplace_back(errorUserInfoMap);
				}

				FTMap retMap;
				retMap[FTValue("friendInfos")] = friendInfoArray;
				retMap[FTValue("errorUserList")] = errorUserInfoArray;

				sharedPtrResult->Success(retMap);
			}
			else {
				sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
			}
		});
}

void ZIMPluginMethodHandler::acceptFriendApplication(flutter::EncodableMap& argument, std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
	auto handle = std::get<std::string>(argument[FTValue("handle")]);
	auto zim = this->engineMap[handle];
	if (!zim) {
		result->Error("-1", "no native instance");
		return;
	}
	auto userID = std::get<std::string>(argument[FTValue("userID")]);
	auto configMap = std::get<FTMap>(argument[FTValue("config")]);
    ZIMFriendApplicationAcceptConfig config = ZIMPluginConverter::cnvZIMFriendApplicationAcceptConfigToObject(std::get<FTMap>(argument[FTValue("config")]));

	std::shared_ptr<ZIMPushConfig> pushConfigPtr = nullptr;
	std::shared_ptr<ZIMVoIPConfig> voIPConfigPtr = nullptr;
	if (std::holds_alternative<std::monostate>(configMap[FTValue("pushConfig")])) {
		config.pushConfig = nullptr;
	}
	else {
		pushConfigPtr = ZIMPluginConverter::cnvZIMPushConfigToObject(std::get<FTMap>(configMap[FTValue("pushConfig")]), voIPConfigPtr);
		config.pushConfig = pushConfigPtr.get();
	}

	auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
	zim->acceptFriendApplication(userID, config, [=](
		const ZIMFriendInfo& friendInfo, const ZIMError& errorInfo) {
		if (errorInfo.code == 0) {
			FTMap retMap;
			retMap[FTValue("friendInfo")] = ZIMPluginConverter::cnvZIMFriendInfoToMap(friendInfo);
			sharedPtrResult->Success(retMap);
		}
		else {
			sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
		}
		});
}

void ZIMPluginMethodHandler::rejectFriendApplication(flutter::EncodableMap& argument, std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
	auto handle = std::get<std::string>(argument[FTValue("handle")]);
	auto zim = this->engineMap[handle];
	if (!zim) {
		result->Error("-1", "no native instance");
		return;
	}
	auto userID = std::get<std::string>(argument[FTValue("userID")]);
	auto configMap = std::get<FTMap>(argument[FTValue("config")]);
    ZIMFriendApplicationRejectConfig config = ZIMPluginConverter::cnvZIMFriendApplicationRejectConfigToObject(std::get<FTMap>(argument[FTValue("config")]));

	std::shared_ptr<ZIMPushConfig> pushConfigPtr = nullptr;
	std::shared_ptr<ZIMVoIPConfig> voIPConfigPtr = nullptr;
	if (std::holds_alternative<std::monostate>(configMap[FTValue("pushConfig")])) {
		config.pushConfig = nullptr;
	}
	else {
		pushConfigPtr = ZIMPluginConverter::cnvZIMPushConfigToObject(std::get<FTMap>(configMap[FTValue("pushConfig")]), voIPConfigPtr);
		config.pushConfig = pushConfigPtr.get();
	}

	auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
	zim->rejectFriendApplication(userID, config, [=](const ZIMUserInfo& userInfo, const ZIMError& errorInfo) {
			if (errorInfo.code == 0) {
				FTMap retMap;
				retMap[FTValue("userInfo")] = ZIMPluginConverter::cnvZIMUserInfoObjectToMap(userInfo);
				sharedPtrResult->Success(retMap);
			}
			else {
				sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
			}
		});
}

void ZIMPluginMethodHandler::queryFriendList(flutter::EncodableMap& argument, std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
	auto handle = std::get<std::string>(argument[FTValue("handle")]);
	auto zim = this->engineMap[handle];
	if (!zim) {
		result->Error("-1", "no native instance");
		return;
	}

	auto configMap = std::get<FTMap>(argument[FTValue("config")]);
    ZIMFriendListQueryConfig config = ZIMPluginConverter::cnvZIMFriendListQueryConfigToObject(std::get<FTMap>(argument[FTValue("config")]));

	auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
	zim->queryFriendList(config, [=](const std::vector<ZIMFriendInfo>& friendInfoList, unsigned int nextFlag,
		const ZIMError& errorInfo) {
			if (errorInfo.code == 0) {
				FTArray friendInfoArray;
				for (auto& info : friendInfoList) {
					auto infoMap = ZIMPluginConverter::cnvZIMFriendInfoToMap(info);
					friendInfoArray.emplace_back(infoMap);
				}

				FTMap retMap;
				retMap[FTValue("friendList")] = friendInfoArray;
                retMap[FTValue("nextFlag")] = FTValue((int32_t)nextFlag);
				sharedPtrResult->Success(retMap);
			}
			else {
				sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
			}
		});
}

void ZIMPluginMethodHandler::queryFriendApplicationList(flutter::EncodableMap& argument, std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
	auto handle = std::get<std::string>(argument[FTValue("handle")]);
	auto zim = this->engineMap[handle];
	if (!zim) {
		result->Error("-1", "no native instance");
		return;
	}

	auto configMap = std::get<FTMap>(argument[FTValue("config")]);
    ZIMFriendApplicationListQueryConfig config = ZIMPluginConverter::cnvZIMFriendApplicationListQueryConfigToObject(std::get<FTMap>(argument[FTValue("config")]));

	auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
	zim->queryFriendApplicationList(config, [=](const std::vector<ZIMFriendApplicationInfo>& applicationList,
		unsigned int nextFlag, const ZIMError& errorInfo) {
			if (errorInfo.code == 0) {
				FTArray friendApplicationInfoArray;
				for (auto& info : applicationList) {
					auto infoMap = ZIMPluginConverter::cnvZIMFriendApplicationInfoToMap(info);
                    friendApplicationInfoArray.emplace_back(infoMap);
				}
				FTMap retMap;
				retMap[FTValue("applicationList")] = friendApplicationInfoArray;
				retMap[FTValue("nextFlag")] = FTValue((int32_t)nextFlag);
				sharedPtrResult->Success(retMap);
			}
			else {
				sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
			}
		});
}


void ZIMPluginMethodHandler::searchLocalFriends(flutter::EncodableMap& argument, std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
	auto handle = std::get<std::string>(argument[FTValue("handle")]);
	auto zim = this->engineMap[handle];
	if (!zim) {
		result->Error("-1", "no native instance");
		return;
	}

	auto configMap = std::get<FTMap>(argument[FTValue("config")]);
    ZIMFriendSearchConfig config = ZIMPluginConverter::cnvZIMFriendSearchConfigToObject(std::get<FTMap>(argument[FTValue("config")]));
	auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
	zim->searchLocalFriends(config, [=](const std::vector<ZIMFriendInfo>& friendInfos,
		unsigned int nextFlag, const ZIMError& errorInfo) {
			if (errorInfo.code == 0) {
				FTArray friendInfoArray;
				for (auto& info : friendInfos) {
					auto infoMap = ZIMPluginConverter::cnvZIMFriendInfoToMap(info);
                    friendInfoArray.emplace_back(infoMap);
				}
                
				FTMap retMap;
				retMap[FTValue("friendInfos")] = friendInfoArray;
				retMap[FTValue("nextFlag")] = FTValue((int32_t)nextFlag);
				sharedPtrResult->Success(retMap);
			}
			else {
				sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
			}
		});
}


void ZIMPluginMethodHandler::queryCombineMessageDetail(flutter::EncodableMap& argument,
	std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
	auto handle = std::get<std::string>(argument[FTValue("handle")]);
	auto zim = this->engineMap[handle];
	if (!zim) {
		result->Error("-1", "no native instance");
		return;
	}

    std::shared_ptr<ZIMMessage> message = ZIMPluginConverter::cnvZIMMessageToObject(std::get<FTMap>(argument[FTValue("message")]));
    auto combineMessagePtr = std::static_pointer_cast<ZIMCombineMessage>(message);
    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));

	zim->queryCombineMessageDetail(combineMessagePtr, [=](const std::shared_ptr<ZIMCombineMessage>& message, ZIMError& errorInfo) {
		FTMap retMap;
		auto messageMap = ZIMPluginConverter::cnvZIMMessageObjectToMap(message.get());
		retMap[FTValue("message")] = messageMap;
		if (errorInfo.code == 0) {
			sharedPtrResult->Success(retMap);
		}
		else {
			sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message, retMap);
		}
		});
}

void ZIMPluginMethodHandler::clearLocalFileCache(flutter::EncodableMap& argument,
	std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
	auto handle = std::get<std::string>(argument[FTValue("handle")]);
	auto zim = this->engineMap[handle];
	if (!zim) {
		result->Error("-1", "no native instance");
		return;
	}

	auto configMap = std::get<FTMap>(argument[FTValue("config")]);
	ZIMFileCacheClearConfig config = ZIMPluginConverter::cnvZIMFileCacheClearConfigToObject(std::get<FTMap>(argument[FTValue("config")]));
	auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
	zim->clearLocalFileCache(config, [=](const ZIMError& errorInfo) {
		if (errorInfo.code == 0) {
			sharedPtrResult->Success();
		}
		else {
			sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
		}
		});
}

void ZIMPluginMethodHandler::queryLocalFileCache(flutter::EncodableMap& argument,
	std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
	auto handle = std::get<std::string>(argument[FTValue("handle")]);
	auto zim = this->engineMap[handle];
	if (!zim) {
		result->Error("-1", "no native instance");
		return;
	}

	auto configMap = std::get<FTMap>(argument[FTValue("config")]);
	ZIMFileCacheQueryConfig config = ZIMPluginConverter::cnvZIMFileCacheQueryConfigToObject(std::get<FTMap>(argument[FTValue("config")]));
	auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));
	zim->queryLocalFileCache(config, [=](const ZIMFileCacheInfo& cacheInfo, const ZIMError& errorInfo) {
		if (errorInfo.code == 0) {
			FTMap retMap;
			retMap[FTValue("fileCacheInfo")] = ZIMPluginConverter::cnvZIMFileCacheInfoToMap(cacheInfo);
			sharedPtrResult->Success(retMap);
		}
		else {
			sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
		}
		});
}

void ZIMPluginMethodHandler::importLocalMessages(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result){
    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }

    auto folderPath = std::get<std::string>(argument[FTValue("folderPath")]);
    ZIMMessageImportConfig config;
    auto progressID = ZIMPluginConverter::cnvFTMapToInt32(argument[FTValue("progressID")]);
    auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));

	zim->importLocalMessages(folderPath, config, [=](unsigned long long importedMessageCount,
		unsigned long long totalMessageCount) {
			FTMap progressRetMap;
			progressRetMap[FTValue("handle")] = FTValue(handle);
			progressRetMap[FTValue("method")] = FTValue("messageImportingProgress");
			progressRetMap[FTValue("progressID")] = FTValue(progressID);
			progressRetMap[FTValue("importedMessageCount")] = FTValue((int64_t)importedMessageCount);
			progressRetMap[FTValue("totalMessageCount")] = FTValue((int64_t)totalMessageCount);
			ZIMPluginEventHandler::getInstance()->sendEvent(progressRetMap);
        }, [=](const ZIMError& errorInfo) {
			if (errorInfo.code == 0) {
				sharedPtrResult->Success();
			}
			else {
				sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
			}
    });
}

void ZIMPluginMethodHandler::exportLocalMessages(flutter::EncodableMap& argument,
	std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
	auto handle = std::get<std::string>(argument[FTValue("handle")]);
	auto zim = this->engineMap[handle];
	if (!zim) {
		result->Error("-1", "no native instance");
		return;
	}

	auto folderPath = std::get<std::string>(argument[FTValue("folderPath")]);
	ZIMMessageExportConfig config;
	auto progressID = ZIMPluginConverter::cnvFTMapToInt32(argument[FTValue("progressID")]);
	auto sharedPtrResult = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));

	zim->exportLocalMessages(folderPath, config, [=](unsigned long long exportedMessageCount,
		unsigned long long totalMessageCount) {
			FTMap progressRetMap;
			progressRetMap[FTValue("handle")] = FTValue(handle);
			progressRetMap[FTValue("method")] = FTValue("messageExportingProgress");
			progressRetMap[FTValue("progressID")] = FTValue(progressID);
			progressRetMap[FTValue("exportedMessageCount")] = FTValue((int64_t)exportedMessageCount);
			progressRetMap[FTValue("totalMessageCount")] = FTValue((int64_t)totalMessageCount);
			ZIMPluginEventHandler::getInstance()->sendEvent(progressRetMap);
		}, [=](const ZIMError& errorInfo) {
			if (errorInfo.code == 0) {
				sharedPtrResult->Success();
			}
			else {
				sharedPtrResult->Error(std::to_string(errorInfo.code), errorInfo.message);
			}
		});
}


