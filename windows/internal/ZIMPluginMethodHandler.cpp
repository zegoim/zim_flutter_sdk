#include "ZIMPluginMethodHandler.h"
#include "ZIMPluginEventHandler.h"

#include <flutter/encodable_value.h>
#include <functional>
#include <variant>

#include "ZIMPluginConverter.h"

void ZIMPluginMethodHandler::getVersion(FArgument &argument, FResult result) {
    result->Success(ZIM::getVersion());
}

void ZIMPluginMethodHandler::create(FArgument &argument, FResult result) {
    ZIM *oldZIM = ZIM::getInstance();
    if (oldZIM) {
        oldZIM->destroy();
    }

    auto handle = std::get<std::string>(argument[FTValue("handle")]);

    auto configMap = std::get<FTMap>(argument[FTValue("config")]);

    unsigned int appID =
        (unsigned int)ZIMPluginConverter::cnvFTValueToInt64(configMap[FTValue("appID")]);
    auto appSign = std::get<std::string>(configMap[FTValue("appSign")]);

    ZIMAppConfig appConfig;
    appConfig.appID = appID;
    appConfig.appSign = appSign;
    ZIM::setAdvancedConfig("zim_cross_platform", "flutter");
    auto zim = ZIM::create(appConfig);
    if (zim) {
        this->engineMap[handle] = zim;
        ZIMPluginEventHandler::getInstance()->engineEventMap[zim] = handle;
        zim->setEventHandler(ZIMPluginEventHandler::getInstance());
    }

    result->Success();
}

void ZIMPluginMethodHandler::destroy(FArgument &argument, FResult result) {
    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (zim) {
        zim->destroy();

        this->engineMap.erase(handle);
        ZIMPluginEventHandler::getInstance()->engineEventMap.erase(zim);
    }

    result->Success();
}

void ZIMPluginMethodHandler::setLogConfig(FArgument &argument, FResult result) {

    ZIMLogConfig logConfig;
    logConfig.logPath = std::get<std::string>(argument[FTValue("logPath")]);
    logConfig.logSize = ZIMPluginConverter::cnvFTValueToInt32(argument[FTValue("logSize")]);

    ZIM::setLogConfig(logConfig);

    result->Success();
}

void ZIMPluginMethodHandler::setAdvancedConfig(FArgument &argument, FResult result) {

    std::string key = std::get<std::string>(argument[FTValue("key")]);
    std::string value = std::get<std::string>(argument[FTValue("value")]);

    ZIM::setAdvancedConfig(key, value);

    result->Success();
}

void ZIMPluginMethodHandler::setCacheConfig(FArgument &argument, FResult result) {

    ZIMCacheConfig cacheConfig;
    cacheConfig.cachePath = std::get<std::string>(argument[FTValue("cachePath")]);

    ZIM::setCacheConfig(cacheConfig);

    result->Success();
}

void ZIMPluginMethodHandler::setGeofencingConfig(FArgument &argument, FResult result) {

    int geofencingType = ZIMPluginConverter::cnvFTValueToInt32(argument[FTValue("type")]);

    auto areaList = std::get<FTArray>(argument[FTValue("areaList")]);
    std::vector<int> areaListVec;
    for (auto &areaValue : areaList) {
        auto area = ZIMPluginConverter::cnvFTValueToInt32(areaValue);
        areaListVec.emplace_back(area);
    }
    bool operatorResult = ZIM::setGeofencingConfig(areaListVec, (ZIMGeofencingType)geofencingType);
    result->Success(operatorResult);
}

void ZIMPluginMethodHandler::login(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    std::string userID = std::get<std::string>(argument[FTValue("userID")]);
    ZIMLoginConfig loginConfig =
        ZIMPluginConverter::cnvZIMLoginConfigToObject(std::get<FTMap>(argument[FTValue("config")]));

    zim->login(userID, loginConfig, [=](const ZIMError &errorInfo) {
        if (errorInfo.code == 0) {
            result->Success();
        } else {
            result->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}

void ZIMPluginMethodHandler::logout(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    zim->logout();

    result->Success();
}

void ZIMPluginMethodHandler::uploadLog(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    zim->uploadLog([=](const ZIMError &errorInfo) {
        if (errorInfo.code == 0) {
            result->Success();
        } else {
            result->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}

void ZIMPluginMethodHandler::renewToken(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto token = std::get<std::string>(argument[FTValue("token")]);

    zim->renewToken(token, [=](const std::string &token, const ZIMError &errorInfo) {
        if (errorInfo.code == 0) {
            FTMap retMap;
            retMap[FTValue("token")] = FTValue(token);

            result->Success(retMap);
        } else {
            result->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}

void ZIMPluginMethodHandler::updateUserName(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto userName = std::get<std::string>(argument[FTValue("userName")]);

    zim->updateUserName(userName, [=](const std::string &userName, const ZIMError &errorInfo) {
        if (errorInfo.code == 0) {
            FTMap retMap;
            retMap[FTValue("userName")] = FTValue(userName);

            result->Success(retMap);
        } else {
            result->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}

void ZIMPluginMethodHandler::updateUserAvatarUrl(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto userAvatarUrl = std::get<std::string>(argument[FTValue("userAvatarUrl")]);

    zim->updateUserAvatarUrl(
        userAvatarUrl, [=](const std::string &userAvatarUrl, const ZIMError &errorInfo) {
            if (errorInfo.code == 0) {
                FTMap retMap;
                retMap[FTValue("userAvatarUrl")] = FTValue(userAvatarUrl);

                result->Success(retMap);
            } else {
                result->Error(std::to_string(errorInfo.code), errorInfo.message);
            }
        });
}

void ZIMPluginMethodHandler::updateUserExtendedData(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto userExtendedData = std::get<std::string>(argument[FTValue("extendedData")]);

    zim->updateUserExtendedData(
        userExtendedData, [=](const std::string &userExtendedData, const ZIMError &errorInfo) {
            if (errorInfo.code == 0) {
                FTMap retMap;
                retMap[FTValue("extendedData")] = FTValue(userExtendedData);
                result->Success(retMap);
            } else {
                result->Error(std::to_string(errorInfo.code), errorInfo.message);
            }
        });
}

void ZIMPluginMethodHandler::updateUserOfflinePushRule(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    ZIMUserOfflinePushRule rule = ZIMPluginConverter::cnvZIMUserOfflinePushRuleToObject(
        std::get<FTMap>(argument[FTValue("offlinePushRule")]));

    zim->updateUserOfflinePushRule(
        rule, [=](const ZIMUserOfflinePushRule &offlinePushRule, const ZIMError &errorInfo) {
            if (errorInfo.code == 0) {
                FTMap retMap;
                retMap[FTValue("offlinePushRule")] =
                    ZIMPluginConverter::cnvZIMUserOfflinePushRuleToMap(offlinePushRule);
                result->Success(retMap);
            } else {
                result->Error(std::to_string(errorInfo.code), errorInfo.message);
            }
        });
}

void ZIMPluginMethodHandler::querySelfUserInfo(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    zim->querySelfUserInfo([=](const ZIMSelfUserInfo &selfUserInfo, const ZIMError &errorInfo) {
        if (errorInfo.code == 0) {
            FTMap retMap;
            retMap[FTValue("selfUserInfo")] =
                ZIMPluginConverter::cnvZIMSelfUserInfoToMap(selfUserInfo);
            result->Success(retMap);
        } else {
            result->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}

void ZIMPluginMethodHandler::queryUsersInfo(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto userIDs = std::get<FTArray>(argument[FTValue("userIDs")]);
    std::vector<std::string> userIDsVec;
    for (auto &userIDValue : userIDs) {
        auto userID = std::get<std::string>(userIDValue);
        userIDsVec.emplace_back(userID);
    }

    auto configMap = std::get<FTMap>(argument[FTValue("config")]);
    ZIMUsersInfoQueryConfig config;
    config.isQueryFromServer = std::get<bool>(configMap[FTValue("isQueryFromServer")]);

    zim->queryUsersInfo(
        userIDsVec, config,
        [=](const std::vector<ZIMUserFullInfo> &userList,
            const std::vector<ZIMErrorUserInfo> &errorUserList, const ZIMError &errorInfo) {
            if (errorInfo.code == 0) {
                FTArray userFullInfoArray;
                for (auto &userFullInfo : userList) {
                    auto userFullInfoMap =
                        ZIMPluginConverter::cnvZIMUserFullInfoObjectToMap(userFullInfo);
                    userFullInfoArray.emplace_back(userFullInfoMap);
                }

                FTArray errorUserInfoArray;
                for (auto &errorUserInfo : errorUserList) {
                    auto errorUserInfoMap =
                        ZIMPluginConverter::cnvZIMErrorUserInfoToMap(errorUserInfo);
                    errorUserInfoArray.emplace_back(errorUserInfoMap);
                }

                FTMap retMap;
                retMap[FTValue("userList")] = userFullInfoArray;
                retMap[FTValue("errorUserList")] = errorUserInfoArray;

                result->Success(retMap);
            } else {
                result->Error(std::to_string(errorInfo.code), errorInfo.message);
            }
        });
}

void ZIMPluginMethodHandler::queryConversationList(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    FTMap configMap = std::get<FTMap>(argument[FTValue("config")]);
    ZIMConversationQueryConfig queryConfig;
    queryConfig.count = ZIMPluginConverter::cnvFTValueToInt32(configMap[FTValue("count")]);

    if (std::holds_alternative<std::monostate>(configMap[FTValue("nextConversation")])) {
        queryConfig.nextConversation = nullptr;
    } else {
        auto nextConversation = std::get<FTMap>(configMap[FTValue("nextConversation")]);
        queryConfig.nextConversation =
            ZIMPluginConverter::cnvZIMConversationToObject(nextConversation);
    }

    if (std::holds_alternative<std::monostate>(argument[FTValue("option")])) {
        zim->queryConversationList(
            queryConfig, [=](const std::vector<std::shared_ptr<ZIMConversation>> &conversationList,
                             const ZIMError &errorInfo) {
                if (errorInfo.code == 0) {
                    FTMap retMap;
                    retMap[FTValue("conversationList")] =
                        ZIMPluginConverter::cnvZIMConversationListToArray(conversationList);

                    result->Success(retMap);
                } else {
                    result->Error(std::to_string(errorInfo.code), errorInfo.message);
                }
            });
    } else {
        FTMap option = std::get<FTMap>(argument[FTValue("option")]);
        ZIMConversationFilterOption queryOption =
            ZIMPluginConverter::oZIMConversationFilterOption(option);

        zim->queryConversationList(
            queryConfig, queryOption,
            [=](const std::vector<std::shared_ptr<ZIMConversation>> &conversationList,
                const ZIMError &errorInfo) {
                if (errorInfo.code == 0) {
                    FTMap retMap;
                    retMap[FTValue("conversationList")] =
                        ZIMPluginConverter::cnvZIMConversationListToArray(conversationList);

                    result->Success(retMap);
                } else {
                    result->Error(std::to_string(errorInfo.code), errorInfo.message);
                }
            });
    }
}

void ZIMPluginMethodHandler::queryConversation(FArgument &argument, FResult result) {

    auto handle = std::get<std::string>(argument[FTValue("handle")]);
    auto zim = this->engineMap[handle];
    if (!zim) {
        result->Error("-1", "no native instance");
        return;
    }

    auto conversationID = std::get<std::string>(argument[FTValue("conversationID")]);
    int conversationType =
        ZIMPluginConverter::cnvFTValueToInt32(argument[FTValue("conversationType")]);

    zim->queryConversation(
        conversationID, (ZIMConversationType)conversationType,
        [=](const std::shared_ptr<ZIMConversation> &conversation, const ZIMError &errorInfo) {
            if (errorInfo.code == 0) {
                FTMap retMap;
                retMap[FTValue("conversation")] =
                    ZIMPluginConverter::cnvZIMConversationToMap(conversation);

                result->Success(retMap);
            } else {
                result->Error(std::to_string(errorInfo.code), errorInfo.message);
            }
        });
}

void ZIMPluginMethodHandler::queryConversationPinnedList(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    FTMap configMap = std::get<FTMap>(argument[FTValue("config")]);
    ZIMConversationQueryConfig queryConfig;
    queryConfig.count = ZIMPluginConverter::cnvFTValueToInt32(configMap[FTValue("count")]);

    if (std::holds_alternative<std::monostate>(configMap[FTValue("nextConversation")])) {
        queryConfig.nextConversation = nullptr;
    } else {
        auto nextConversation = std::get<FTMap>(configMap[FTValue("nextConversation")]);
        queryConfig.nextConversation =
            ZIMPluginConverter::cnvZIMConversationToObject(nextConversation);
    }

    zim->queryConversationPinnedList(
        queryConfig, [=](const std::vector<std::shared_ptr<ZIMConversation>> &conversationList,
                         const ZIMError &errorInfo) {
            if (errorInfo.code == 0) {
                FTMap retMap;
                retMap[FTValue("conversationList")] =
                    ZIMPluginConverter::cnvZIMConversationListToArray(conversationList);

                result->Success(retMap);
            } else {
                result->Error(std::to_string(errorInfo.code), errorInfo.message);
            }
        });
}

void ZIMPluginMethodHandler::updateConversationPinnedState(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto conversationID = std::get<std::string>(argument[FTValue("conversationID")]);
    int conversationType =
        ZIMPluginConverter::cnvFTValueToInt32(argument[FTValue("conversationType")]);

    zim->updateConversationPinnedState(
        isPinned, conversationID, (ZIMConversationType)conversationType,
        [=](const std::string &conversationID, ZIMConversationType conversationType,
            const ZIMError &errorInfo) {
            if (errorInfo.code == 0) {
                FTMap retMap;
                retMap[FTValue("conversationID")] = FTValue(conversationID);
                retMap[FTValue("conversationType")] = FTValue(conversationType);

                result->Success(retMap);
            } else {
                result->Error(std::to_string(errorInfo.code), errorInfo.message);
            }
        });
}

void ZIMPluginMethodHandler::deleteConversation(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto conversationID = std::get<std::string>(argument[FTValue("conversationID")]);
    int conversationType =
        ZIMPluginConverter::cnvFTValueToInt32(argument[FTValue("conversationType")]);
    auto configMap = std::get<FTMap>(argument[FTValue("config")]);

    ZIMConversationDeleteConfig deleteConfig =
        ZIMPluginConverter::cnvZIMConversationDeleteConfigToObject(configMap);

    zim->deleteConversation(conversationID, (ZIMConversationType)conversationType, deleteConfig,
                            [=](const std::string &conversationID,
                                ZIMConversationType conversationType, const ZIMError &errorInfo) {
                                if (errorInfo.code == 0) {
                                    FTMap retMap;
                                    retMap[FTValue("conversationID")] = FTValue(conversationID);
                                    retMap[FTValue("conversationType")] = FTValue(conversationType);

                                    result->Success(retMap);
                                } else {
                                    result->Error(std::to_string(errorInfo.code),
                                                  errorInfo.message);
                                }
                            });
}

void ZIMPluginMethodHandler::deleteAllConversations(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto configMap = std::get<FTMap>(argument[FTValue("config")]);

    ZIMConversationDeleteConfig deleteConfig =
        ZIMPluginConverter::cnvZIMConversationDeleteConfigToObject(configMap);

    zim->deleteAllConversations(deleteConfig, [=](const ZIMError &errorInfo) {
        if (errorInfo.code == 0) {
            result->Success();
        } else {
            result->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}

void ZIMPluginMethodHandler::clearConversationUnreadMessageCount(FArgument &argument,
                                                                 FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto conversationID = std::get<std::string>(argument[FTValue("conversationID")]);
    int conversationType =
        ZIMPluginConverter::cnvFTValueToInt32(argument[FTValue("conversationType")]);

    zim->clearConversationUnreadMessageCount(
        conversationID, (ZIMConversationType)conversationType,
        [=](const std::string &conversationID, ZIMConversationType conversationType,
            const ZIMError &errorInfo) {
            if (errorInfo.code == 0) {
                FTMap retMap;
                retMap[FTValue("conversationID")] = FTValue(conversationID);
                retMap[FTValue("conversationType")] = FTValue(conversationType);

                result->Success(retMap);
            } else {
                result->Error(std::to_string(errorInfo.code), errorInfo.message);
            }
        });
}

void ZIMPluginMethodHandler::clearConversationTotalUnreadMessageCount(FArgument &argument,
                                                                      FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    zim->clearConversationTotalUnreadMessageCount([=](const ZIMError &errorInfo) {
        if (errorInfo.code == 0) {
            result->Success();
        } else {
            result->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}

void ZIMPluginMethodHandler::setConversationNotificationStatus(FArgument &argument,
                                                               FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto conversationID = std::get<std::string>(argument[FTValue("conversationID")]);
    int conversationType =
        ZIMPluginConverter::cnvFTValueToInt32(argument[FTValue("conversationType")]);

    int status = ZIMPluginConverter::cnvFTValueToInt32(argument[FTValue("status")]);

    zim->setConversationNotificationStatus(
        (ZIMConversationNotificationStatus)status, conversationID,
        (ZIMConversationType)conversationType,
        [=](const std::string &conversationID, ZIMConversationType conversationType,
            const ZIMError &errorInfo) {
            if (errorInfo.code == 0) {
                FTMap retMap;
                retMap[FTValue("conversationID")] = FTValue(conversationID);
                retMap[FTValue("conversationType")] = FTValue(conversationType);

                result->Success(retMap);
            } else {
                result->Error(std::to_string(errorInfo.code), errorInfo.message);
            }
        });
}

void ZIMPluginMethodHandler::sendConversationMessageReceiptRead(FArgument &argument,
                                                                FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto conversationID = std::get<std::string>(argument[FTValue("conversationID")]);
    int conversationType =
        ZIMPluginConverter::cnvFTValueToInt32(argument[FTValue("conversationType")]);

    zim->sendConversationMessageReceiptRead(
        conversationID, (ZIMConversationType)conversationType,
        [=](const std::string &conversationID, ZIMConversationType conversationType,
            const ZIMError &errorInfo) {
            if (errorInfo.code == 0) {
                FTMap retMap;
                retMap[FTValue("conversationID")] = FTValue(conversationID);
                retMap[FTValue("conversationType")] = FTValue(conversationType);

                result->Success(retMap);
            } else {
                result->Error(std::to_string(errorInfo.code), errorInfo.message);
            }
        });
}

void ZIMPluginMethodHandler::setConversationDraft(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto draft = std::get<std::string>(argument[FTValue("draft")]);
    auto conversationID = std::get<std::string>(argument[FTValue("conversationID")]);
    int conversationType =
        ZIMPluginConverter::cnvFTValueToInt32(argument[FTValue("conversationType")]);

    zim->setConversationDraft(
        draft, conversationID, (ZIMConversationType)conversationType,
        [=](const std::string &conversationID, ZIMConversationType conversationType,
            const ZIMError &errorInfo) {
            if (errorInfo.code == 0) {
                FTMap retMap;
                retMap[FTValue("conversationID")] = FTValue(conversationID);
                retMap[FTValue("conversationType")] = FTValue(conversationType);

                result->Success(retMap);
            } else {
                result->Error(std::to_string(errorInfo.code), errorInfo.message);
            }
        });
}

void ZIMPluginMethodHandler::setConversationMark(FArgument &argument, FResult result) {
    CheckZIMInstanceExistAndObtainZIM();

    auto markType = GetParamsFromArgument(int32_t, markType);
    auto enable = GetParamsFromArgument(bool, enable);
    FTArray infoArray = GetParamsFromArgument(FTArray, infos);
    auto infos = ZIMPluginConverter::oZIMConversationBaseInfoList(infoArray);

    zim->setConversationMark(
        markType, enable, infos,
        [=](const std::vector<ZIMConversationBaseInfo> &failedConversationList,
            const ZIMError &errorInfo) {
            if (errorInfo.code == 0) {
                FTMap retMap;
                retMap[FTValue("failedConversationInfos")] =
                    ZIMPluginConverter::aZIMConversationBaseInfoList(failedConversationList);

                result->Success(retMap);
            } else {
                result->Error(std::to_string(errorInfo.code), errorInfo.message);
            }
        });
}

void ZIMPluginMethodHandler::queryConversationTotalUnreadCount(FArgument &argument,
                                                               FResult result) {
    CheckZIMInstanceExistAndObtainZIM();

    auto configMap = std::get<FTMap>(argument[FTValue("config")]);
    auto config = ZIMPluginConverter::oZIMConversationTotalUnreadCountQueryConfig(configMap);

    zim->queryConversationTotalUnreadCount(
        config, [=](unsigned int totalUnreadCount, const ZIMError &errorInfo) {
            if (errorInfo.code == 0) {
                FTMap retMap;
                retMap[FTValue("unreadCount")] = FTValue(static_cast<int32_t>(totalUnreadCount));

                result->Success(retMap);
            } else {
                result->Error(std::to_string(errorInfo.code), errorInfo.message);
            }
        });
}

void ZIMPluginMethodHandler::revokeMessage(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto messagePtr =
        ZIMPluginConverter::cnvZIMMessageToObject(std::get<FTMap>(argument[FTValue("message")]));

    FTMap configMap = std::get<FTMap>(argument[FTValue("config")]);
    ZIMMessageRevokeConfig config;
    std::shared_ptr<ZIMPushConfig> pushConfigPtr = nullptr;
    std::shared_ptr<ZIMVoIPConfig> voIPConfigPtr = nullptr;
    if (std::holds_alternative<std::monostate>(configMap[FTValue("pushConfig")])) {
        config.config = nullptr;
    } else {
        pushConfigPtr = ZIMPluginConverter::cnvZIMPushConfigToObject(
            std::get<FTMap>(configMap[FTValue("pushConfig")]), voIPConfigPtr);
        config.config = pushConfigPtr.get();
    }
    auto revokeExtendedData = std::get<std::string>(configMap[FTValue("revokeExtendedData")]);
    config.revokeExtendedData = revokeExtendedData;

    zim->revokeMessage(messagePtr, config,
                       [=](const std::shared_ptr<ZIMMessage> &message, const ZIMError &errorInfo) {
                           if (errorInfo.code == 0) {
                               FTMap retMap;
                               auto messageMap =
                                   ZIMPluginConverter::cnvZIMMessageObjectToMap(message.get());
                               retMap[FTValue("message")] = messageMap;
                               result->Success(retMap);
                           } else {
                               result->Error(std::to_string(errorInfo.code), errorInfo.message);
                           }
                       });
}

void ZIMPluginMethodHandler::insertMessageToLocalDB(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto messagePtr =
        ZIMPluginConverter::cnvZIMMessageToObject(std::get<FTMap>(argument[FTValue("message")]));
    auto messageID = ZIMPluginConverter::cnvFTValueToInt32(argument[FTValue("messageID")]);
    auto conversationID = std::get<std::string>(argument[FTValue("conversationID")]);
    int conversationType =
        ZIMPluginConverter::cnvFTValueToInt32(argument[FTValue("conversationType")]);
    auto senderUserID = std::get<std::string>(argument[FTValue("senderUserID")]);

    zim->insertMessageToLocalDB(
        std::static_pointer_cast<zim::ZIMMessage>(messagePtr), conversationID,
        (ZIMConversationType)conversationType, senderUserID,
        [=](const std::shared_ptr<zim::ZIMMessage> &message, const zim::ZIMError &errorInfo) {
            FTMap retMap;
            auto messageMap = ZIMPluginConverter::cnvZIMMessageObjectToMap(message.get());
            retMap[FTValue("message")] = messageMap;
            retMap[FTValue("messageID")] = FTValue(messageID);
            if (errorInfo.code == 0) {
                result->Success(retMap);
            } else {
                result->Error(std::to_string(errorInfo.code), errorInfo.message, retMap);
            }
        });
}

void ZIMPluginMethodHandler::updateMessageLocalExtendedData(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto messagePtr =
        ZIMPluginConverter::cnvZIMMessageToObject(std::get<FTMap>(argument[FTValue("message")]));
    auto localExtendedData = std::get<std::string>(argument[FTValue("localExtendedData")]);

    zim->updateMessageLocalExtendedData(
        localExtendedData, std::static_pointer_cast<zim::ZIMMessage>(messagePtr),
        [=](const std::shared_ptr<zim::ZIMMessage> &message, const zim::ZIMError &errorInfo) {
            FTMap retMap;
            auto messageMap = ZIMPluginConverter::cnvZIMMessageObjectToMap(message.get());
            retMap[FTValue("message")] = messageMap;
            if (errorInfo.code == 0) {
                result->Success(retMap);
            } else {
                result->Error(std::to_string(errorInfo.code), errorInfo.message, retMap);
            }
        });
}

void ZIMPluginMethodHandler::sendMessage(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto messagePtr =
        ZIMPluginConverter::cnvZIMMessageToObject(std::get<FTMap>(argument[FTValue("message")]));
    auto toConversationID = std::get<std::string>(argument[FTValue("toConversationID")]);
    int conversationType =
        ZIMPluginConverter::cnvFTValueToInt32(argument[FTValue("conversationType")]);
    auto messageID = ZIMPluginConverter::cnvFTValueToInt32(argument[FTValue("messageID")]);

    int32_t messageAttachedCallbackID =
        ZIMPluginConverter::cnvFTValueToInt32(argument[FTValue("messageAttachedCallbackID")]);
    auto config =
        ZIMPluginConverter::oZIMMessageSendConfig(std::get<FTMap>(argument[FTValue("config")]));

    auto notification = std::make_shared<zim::ZIMMessageSendNotification>(
        [=](const std::shared_ptr<zim::ZIMMessage> &message) {
            if (messageAttachedCallbackID == 0) {
                return;
            }
            FTMap onMessageAttachedMap;
            onMessageAttachedMap[FTValue("handle")] = FTValue(handle);
            onMessageAttachedMap[FTValue("method")] = FTValue("onMessageAttached");
            onMessageAttachedMap[FTValue("messageAttachedCallbackID")] =
                FTValue(messageAttachedCallbackID);
            onMessageAttachedMap[FTValue("messageID")] = FTValue(messageID);
            onMessageAttachedMap[FTValue("message")] =
                ZIMPluginConverter::cnvZIMMessageObjectToMap(message.get());
            ZIMPluginEventHandler::getInstance()->sendEvent(onMessageAttachedMap);
        },
        nullptr);

    zim->sendMessage(
        messagePtr, toConversationID, (ZIMConversationType)conversationType, config, notification,
        [=](const std::shared_ptr<zim::ZIMMessage> &message, const zim::ZIMError &errorInfo) {
            FTMap retMap;
            auto messageMap = ZIMPluginConverter::cnvZIMMessageObjectToMap(message.get());
            retMap[FTValue("message")] = messageMap;
            retMap[FTValue("messageID")] = FTValue(messageID);
            if (errorInfo.code == 0) {
                result->Success(retMap);
            } else {
                result->Error(std::to_string(errorInfo.code), errorInfo.message, retMap);
            }
        });
}

void ZIMPluginMethodHandler::sendPeerMessage(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto messagePtr =
        ZIMPluginConverter::cnvZIMMessageToObject(std::get<FTMap>(argument[FTValue("message")]));
    auto toUserID = std::get<std::string>(argument[FTValue("toUserID")]);

    FTMap configMap = std::get<FTMap>(argument[FTValue("config")]);
    auto config =
        ZIMPluginConverter::oZIMMessageSendConfig(std::get<FTMap>(argument[FTValue("config")]));

    zim->sendPeerMessage(
        messagePtr.get(), toUserID, config,
        [=](const std::shared_ptr<ZIMMessage> &message, const ZIMError &errorInfo) {
            if (errorInfo.code == 0) {
                FTMap retMap;
                auto messageMap = ZIMPluginConverter::cnvZIMMessageObjectToMap(message.get());
                retMap[FTValue("message")] = messageMap;

                result->Success(retMap);
            } else {
                result->Error(std::to_string(errorInfo.code), errorInfo.message);
            }
        });
}

void ZIMPluginMethodHandler::sendRoomMessage(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto messagePtr =
        ZIMPluginConverter::cnvZIMMessageToObject(std::get<FTMap>(argument[FTValue("message")]));
    auto toRoomID = std::get<std::string>(argument[FTValue("toRoomID")]);

    FTMap configMap = std::get<FTMap>(argument[FTValue("config")]);
    auto config =
        ZIMPluginConverter::oZIMMessageSendConfig(std::get<FTMap>(argument[FTValue("config")]));

    zim->sendRoomMessage(
        messagePtr.get(), toRoomID, config,
        [=](const std::shared_ptr<ZIMMessage> &message, const ZIMError &errorInfo) {
            if (errorInfo.code == 0) {
                FTMap retMap;
                auto messageMap = ZIMPluginConverter::cnvZIMMessageObjectToMap(message.get());
                retMap[FTValue("message")] = messageMap;

                result->Success(retMap);
            } else {
                result->Error(std::to_string(errorInfo.code), errorInfo.message);
            }
        });
}

void ZIMPluginMethodHandler::sendGroupMessage(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto messagePtr =
        ZIMPluginConverter::cnvZIMMessageToObject(std::get<FTMap>(argument[FTValue("message")]));
    auto toGroupID = std::get<std::string>(argument[FTValue("toGroupID")]);

    FTMap configMap = std::get<FTMap>(argument[FTValue("config")]);
    auto config =
        ZIMPluginConverter::oZIMMessageSendConfig(std::get<FTMap>(argument[FTValue("config")]));

    zim->sendGroupMessage(
        messagePtr.get(), toGroupID, config,
        [=](const std::shared_ptr<ZIMMessage> &message, const ZIMError &errorInfo) {
            if (errorInfo.code == 0) {
                FTMap retMap;
                auto messageMap = ZIMPluginConverter::cnvZIMMessageObjectToMap(message.get());
                retMap[FTValue("message")] = messageMap;

                result->Success(retMap);
            } else {
                result->Error(std::to_string(errorInfo.code), errorInfo.message);
            }
        });
}

void ZIMPluginMethodHandler::sendMediaMessage(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto messagePtr =
        ZIMPluginConverter::cnvZIMMessageToObject(std::get<FTMap>(argument[FTValue("message")]));
    auto toConversationID = std::get<std::string>(argument[FTValue("toConversationID")]);
    auto conversationType =
        ZIMPluginConverter::cnvFTValueToInt32(argument[FTValue("conversationType")]);

    FTMap configMap = std::get<FTMap>(argument[FTValue("config")]);
    auto config =
        ZIMPluginConverter::oZIMMessageSendConfig(std::get<FTMap>(argument[FTValue("config")]));

    auto mediaMessagePtr = std::static_pointer_cast<ZIMMediaMessage>(messagePtr);
    int32_t progressID = ZIMPluginConverter::cnvFTValueToInt32(argument[FTValue("progressID")]);
    auto messageID = ZIMPluginConverter::cnvFTValueToInt32(argument[FTValue("messageID")]);
    int32_t messageAttachedCallbackID =
        ZIMPluginConverter::cnvFTValueToInt32(argument[FTValue("messageAttachedCallbackID")]);

    auto notification = std::make_shared<zim::ZIMMediaMessageSendNotification>(
        [=](const std::shared_ptr<zim::ZIMMessage> &message) {
            if (messageAttachedCallbackID == 0) {
                return;
            }
            FTMap onMessageAttachedMap;
            onMessageAttachedMap[FTValue("handle")] = FTValue(handle);
            onMessageAttachedMap[FTValue("method")] = FTValue("onMessageAttached");
            onMessageAttachedMap[FTValue("messageAttachedCallbackID")] =
                FTValue(messageAttachedCallbackID);
            onMessageAttachedMap[FTValue("messageID")] = FTValue(messageID);
            onMessageAttachedMap[FTValue("message")] =
                ZIMPluginConverter::cnvZIMMessageObjectToMap(message.get());
            ZIMPluginEventHandler::getInstance()->sendEvent(onMessageAttachedMap);
        },
        [=](const std::shared_ptr<zim::ZIMMediaMessage> &message,
            unsigned long long currentFileSize, unsigned long long totalFileSize) {
            FTMap progressRetMap;
            progressRetMap[FTValue("handle")] = FTValue(handle);
            progressRetMap[FTValue("method")] = FTValue("uploadMediaProgress");
            progressRetMap[FTValue("progressID")] = FTValue(progressID);
            progressRetMap[FTValue("message")] =
                ZIMPluginConverter::cnvZIMMessageObjectToMap(message.get());
            progressRetMap[FTValue("currentFileSize")] = FTValue((int64_t)currentFileSize);
            progressRetMap[FTValue("totalFileSize")] = FTValue((int64_t)totalFileSize);
            ZIMPluginEventHandler::getInstance()->sendEvent(progressRetMap);
        });

    zim->sendMediaMessage(
        mediaMessagePtr, toConversationID, (ZIMConversationType)conversationType, config,
        notification,
        [=](const std::shared_ptr<zim::ZIMMessage> &message, const zim::ZIMError &errorInfo) {
            FTMap retMap;
            auto messageMap = ZIMPluginConverter::cnvZIMMessageObjectToMap(message.get());
            retMap[FTValue("message")] = messageMap;
            retMap[FTValue("messageID")] = FTValue(messageID);
            if (errorInfo.code == 0) {
                result->Success(retMap);
            } else {
                result->Error(std::to_string(errorInfo.code), errorInfo.message, retMap);
            }
        });
}

void ZIMPluginMethodHandler::downloadMediaFile(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto fileType = ZIMPluginConverter::cnvFTValueToInt32(argument[FTValue("fileType")]);
    auto messagePtr =
        ZIMPluginConverter::cnvZIMMessageToObject(std::get<FTMap>(argument[FTValue("message")]));

    auto mediaMessagePtr = std::static_pointer_cast<ZIMMediaMessage>(messagePtr);
    auto progressID = ZIMPluginConverter::cnvFTValueToInt32(argument[FTValue("progressID")]);

    zim->downloadMediaFile(
        mediaMessagePtr.get(), (ZIMMediaFileType)fileType,
        [=](const std::shared_ptr<ZIMMediaMessage> &message, unsigned long long currentFileSize,
            unsigned long long totalFileSize) {
            FTMap progressRetMap;
            progressRetMap[FTValue("handle")] = FTValue(handle);
            progressRetMap[FTValue("method")] = FTValue("downloadMediaFileProgress");
            progressRetMap[FTValue("progressID")] = FTValue(progressID);
            progressRetMap[FTValue("message")] =
                ZIMPluginConverter::cnvZIMMessageObjectToMap(message.get());
            progressRetMap[FTValue("currentFileSize")] = FTValue((int64_t)currentFileSize);
            progressRetMap[FTValue("totalFileSize")] = FTValue((int64_t)totalFileSize);
            ZIMPluginEventHandler::getInstance()->sendEvent(progressRetMap);
        },
        [=](const std::shared_ptr<ZIMMediaMessage> &message, const ZIMError &errorInfo) {
            if (errorInfo.code == 0) {
                FTMap retMap;
                auto messageMap = ZIMPluginConverter::cnvZIMMessageObjectToMap(message.get());
                retMap[FTValue("message")] = messageMap;

                result->Success(retMap);
            } else {
                result->Error(std::to_string(errorInfo.code), errorInfo.message);
            }
        });
}

void ZIMPluginMethodHandler::replyMessage(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto message =
        ZIMPluginConverter::cnvZIMMessageToObject(std::get<FTMap>(argument[FTValue("message")]));
    auto toOriginalMessage = ZIMPluginConverter::cnvZIMMessageToObject(
        std::get<FTMap>(argument[FTValue("toOriginalMessage")]));

    auto config =
        ZIMPluginConverter::oZIMMessageSendConfig(std::get<FTMap>(argument[FTValue("config")]));

    auto messageID = ZIMPluginConverter::cnvFTValueToInt32(argument[FTValue("messageID")]);
    int32_t progressID = ZIMPluginConverter::cnvFTValueToInt32(argument[FTValue("progressID")]);
    int32_t messageAttachedCallbackID =
        ZIMPluginConverter::cnvFTValueToInt32(argument[FTValue("messageAttachedCallbackID")]);

    auto notification = std::make_shared<zim::ZIMMessageSendNotification>(
        [=](const std::shared_ptr<zim::ZIMMessage> &message) {
            if (messageAttachedCallbackID == 0) {
                return;
            }
            FTMap onMessageAttachedMap;
            onMessageAttachedMap[FTValue("handle")] = FTValue(handle);
            onMessageAttachedMap[FTValue("method")] = FTValue("onMessageAttached");
            onMessageAttachedMap[FTValue("messageAttachedCallbackID")] =
                FTValue(messageAttachedCallbackID);
            onMessageAttachedMap[FTValue("messageID")] = FTValue(messageID);
            onMessageAttachedMap[FTValue("message")] =
                ZIMPluginConverter::cnvZIMMessageObjectToMap(message.get());
            ZIMPluginEventHandler::getInstance()->sendEvent(onMessageAttachedMap);
        },
        [=](const std::shared_ptr<zim::ZIMMediaMessage> &message,
            unsigned long long currentFileSize, unsigned long long totalFileSize) {
            FTMap progressRetMap;
            progressRetMap[FTValue("handle")] = FTValue(handle);
            progressRetMap[FTValue("method")] = FTValue("uploadMediaProgress");
            progressRetMap[FTValue("progressID")] = FTValue(progressID);
            progressRetMap[FTValue("message")] =
                ZIMPluginConverter::cnvZIMMessageObjectToMap(message.get());
            progressRetMap[FTValue("currentFileSize")] = FTValue((int64_t)currentFileSize);
            progressRetMap[FTValue("totalFileSize")] = FTValue((int64_t)totalFileSize);
            ZIMPluginEventHandler::getInstance()->sendEvent(progressRetMap);
        });

    zim->replyMessage(
        message, toOriginalMessage, config, notification,
        [=](const std::shared_ptr<zim::ZIMMessage> &callbackMessage,
            const zim::ZIMError &errorInfo) {
            FTMap retMap;
            auto messageMap = ZIMPluginConverter::cnvZIMMessageObjectToMap(callbackMessage.get());
            retMap[FTValue("message")] = messageMap;
            retMap[FTValue("messageID")] = FTValue(messageID);
            if (errorInfo.code == 0) {
                result->Success(retMap);
            } else {
                result->Error(std::to_string(errorInfo.code), errorInfo.message, retMap);
            }
        });
}

void ZIMPluginMethodHandler::queryHistoryMessage(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto conversationID = std::get<std::string>(argument[FTValue("conversationID")]);
    int conversationType =
        ZIMPluginConverter::cnvFTValueToInt32(argument[FTValue("conversationType")]);

    FTMap configMap = std::get<FTMap>(argument[FTValue("config")]);
    ZIMMessageQueryConfig config;
    config.count = ZIMPluginConverter::cnvFTValueToInt32(configMap[FTValue("count")]);
    config.reverse = std::get<bool>(configMap[FTValue("reverse")]);

    std::shared_ptr<ZIMMessage> nextMessagePtr = nullptr;
    if (std::holds_alternative<std::monostate>(configMap[FTValue("nextMessage")])) {
        config.nextMessage = nullptr;
    } else {
        auto nextMessageMap = std::get<FTMap>(configMap[FTValue("nextMessage")]);
        nextMessagePtr = ZIMPluginConverter::cnvZIMMessageToObject(nextMessageMap);
        config.nextMessage = nextMessagePtr;
    }

    zim->queryHistoryMessage(
        conversationID, (ZIMConversationType)conversationType, config,
        [=](const std::string &conversationID, ZIMConversationType conversationType,
            const std::vector<std::shared_ptr<ZIMMessage>> &messageList,
            const ZIMError &errorInfo) {
            if (errorInfo.code == 0) {
                FTMap retMap;
                auto messageArray = ZIMPluginConverter::cnvZIMMessageListToArray(messageList);
                retMap[FTValue("messageList")] = messageArray;
                retMap[FTValue("conversationID")] = FTValue(conversationID);
                retMap[FTValue("conversationType")] = FTValue(conversationType);

                result->Success(retMap);
            } else {
                result->Error(std::to_string(errorInfo.code), errorInfo.message);
            }
        });
}

void ZIMPluginMethodHandler::queryMessages(FArgument &argument, FResult result) {
    CheckZIMInstanceExistAndObtainZIM();

    auto conversationID = std::get<std::string>(argument[FTValue("conversationID")]);
    auto conversationType = static_cast<ZIMConversationType>(
        ZIMPluginConverter::cnvFTValueToInt32(argument[FTValue("conversationType")]));
    auto messageSeq = ZIMPluginConverter::cnvFTArrayToInt64Vec(
        std::get<FTArray>(argument[FTValue("messageSeqs")]));

    zim->queryMessages(messageSeq, conversationID, conversationType,
                       [=](const std::string &conversationID, ZIMConversationType conversationType,
                           const std::vector<std::shared_ptr<ZIMMessage>> &messageList,
                           const ZIMError &errorInfo) {
                           if (errorInfo.code == ZIMErrorCode::ZIM_ERROR_CODE_SUCCESS) {
                               FTMap retMap;
                               retMap[FTValue("messageList")] =
                                   ZIMPluginConverter::cnvZIMMessageListToArray(messageList);
                               retMap[FTValue("conversationID")] = FTValue(conversationID);
                               retMap[FTValue("conversationType")] = FTValue(conversationType);

                               result->Success(retMap);
                           } else {
                               result->Error(std::to_string(errorInfo.code), errorInfo.message);
                           }
                       });
}

void ZIMPluginMethodHandler::queryMessageRepliedList(FArgument &argument, FResult result) {
    CheckZIMInstanceExistAndObtainZIM();

    auto message =
        ZIMPluginConverter::cnvZIMMessageToObject(std::get<FTMap>(argument[FTValue("message")]));
    auto config = ZIMPluginConverter::oZIMMessageRepliedListQueryConfig(
        std::get<FTMap>(argument[FTValue("config")]));

    zim->queryMessageRepliedList(
        message, config,
        [=](const std::vector<std::shared_ptr<ZIMMessage>> &messageList, long long nextFlag,
            const ZIMMessageRootRepliedInfo &rootRepliedInfo, const ZIMError &errorInfo) {
            if (errorInfo.code == ZIMErrorCode::ZIM_ERROR_CODE_SUCCESS) {
                FTMap retMap;
                retMap[FTValue("messageList")] =
                    ZIMPluginConverter::cnvZIMMessageListToArray(messageList);
                retMap[FTValue("nextFlag")] = FTValue(nextFlag);
                retMap[FTValue("rootRepliedInfo")] =
                    ZIMPluginConverter::cnvZIMMessageRootRepliedInfoToMap(rootRepliedInfo);

                result->Success(retMap);
            } else {
                result->Error(std::to_string(errorInfo.code), errorInfo.message);
            }
        });
}

void ZIMPluginMethodHandler::deleteAllMessage(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto conversationID = std::get<std::string>(argument[FTValue("conversationID")]);
    int conversationType =
        ZIMPluginConverter::cnvFTValueToInt32(argument[FTValue("conversationType")]);

    FTMap configMap = std::get<FTMap>(argument[FTValue("config")]);
    ZIMMessageDeleteConfig config;
    config.isAlsoDeleteServerMessage =
        std::get<bool>(configMap[FTValue("isAlsoDeleteServerMessage")]);

    zim->deleteAllMessage(conversationID, (ZIMConversationType)conversationType, config,
                          [=](const std::string &conversationID,
                              ZIMConversationType conversationType, const ZIMError &errorInfo) {
                              if (errorInfo.code == 0) {
                                  FTMap retMap;
                                  retMap[FTValue("conversationID")] = FTValue(conversationID);
                                  retMap[FTValue("conversationType")] = FTValue(conversationType);

                                  result->Success(retMap);
                              } else {
                                  result->Error(std::to_string(errorInfo.code), errorInfo.message);
                              }
                          });
}

void ZIMPluginMethodHandler::deleteMessages(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto messageArray = std::get<FTArray>(argument[(FTValue("messageList"))]);
    auto messageObjectList = ZIMPluginConverter::cnvZIMMessageArrayToObjectList(messageArray);
    auto conversationID = std::get<std::string>(argument[FTValue("conversationID")]);
    int conversationType =
        ZIMPluginConverter::cnvFTValueToInt32(argument[FTValue("conversationType")]);
    FTMap configMap = std::get<FTMap>(argument[FTValue("config")]);
    ZIMMessageDeleteConfig config;
    config.isAlsoDeleteServerMessage =
        std::get<bool>(configMap[FTValue("isAlsoDeleteServerMessage")]);

    zim->deleteMessages(messageObjectList, conversationID, (ZIMConversationType)conversationType,
                        config,
                        [=](const std::string &conversationID, ZIMConversationType conversationType,
                            const ZIMError &errorInfo) {
                            if (errorInfo.code == 0) {
                                FTMap retMap;
                                retMap[FTValue("conversationID")] = FTValue(conversationID);
                                retMap[FTValue("conversationType")] = FTValue(conversationType);

                                result->Success(retMap);
                            } else {
                                result->Error(std::to_string(errorInfo.code), errorInfo.message);
                            }
                        });
}

void ZIMPluginMethodHandler::deleteAllConversationMessages(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    FTMap configMap = std::get<FTMap>(argument[FTValue("config")]);
    ZIMMessageDeleteConfig config;
    config.isAlsoDeleteServerMessage =
        std::get<bool>(configMap[FTValue("isAlsoDeleteServerMessage")]);

    zim->deleteAllConversationMessages(config, [=](const ZIMError &errorInfo) {
        if (errorInfo.code == 0) {
            result->Success();
        } else {
            result->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}

void ZIMPluginMethodHandler::sendMessageReceiptsRead(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto messageArray = std::get<FTArray>(argument[(FTValue("messageList"))]);
    auto messageObjectList = ZIMPluginConverter::cnvZIMMessageArrayToObjectList(messageArray);
    auto conversationID = std::get<std::string>(argument[FTValue("conversationID")]);
    int conversationType =
        ZIMPluginConverter::cnvFTValueToInt32(argument[FTValue("conversationType")]);

    zim->sendMessageReceiptsRead(
        messageObjectList, conversationID, (ZIMConversationType)conversationType,
        [=](const std::string &conversationID, ZIMConversationType conversationType,
            const std::vector<long long> &errorMessageIDs, const ZIMError &errorInfo) {
            if (errorInfo.code == 0) {
                FTMap retMap;
                retMap[FTValue("conversationID")] = FTValue(conversationID);
                retMap[FTValue("conversationType")] = FTValue(conversationType);

                retMap[FTValue("errorMessageIDs")] =
                    ZIMPluginConverter::cnvStlVectorToFTArray(errorMessageIDs);
                result->Success(retMap);
            } else {
                result->Error(std::to_string(errorInfo.code), errorInfo.message);
            }
        });
}

void ZIMPluginMethodHandler::queryMessageReceiptsInfo(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto messageArray = std::get<FTArray>(argument[(FTValue("messageList"))]);
    auto messageObjectList = ZIMPluginConverter::cnvZIMMessageArrayToObjectList(messageArray);
    auto conversationID = std::get<std::string>(argument[FTValue("conversationID")]);
    int conversationType =
        ZIMPluginConverter::cnvFTValueToInt32(argument[FTValue("conversationType")]);

    zim->queryMessageReceiptsInfo(
        messageObjectList, conversationID, (ZIMConversationType)conversationType,
        [=](const std::vector<ZIMMessageReceiptInfo> &infos, std::vector<long long> errorMessageIDs,
            const ZIMError &errorInfo) {
            if (errorInfo.code == 0) {
                FTMap retMap;
                retMap[FTValue("infos")] =
                    ZIMPluginConverter::cnvZIMMessageReceiptInfoListToArray(infos);
                retMap[FTValue("errorMessageIDs")] =
                    ZIMPluginConverter::cnvStlVectorToFTArray(errorMessageIDs);
                result->Success(retMap);
            } else {
                result->Error(std::to_string(errorInfo.code), errorInfo.message);
            }
        });
}

void ZIMPluginMethodHandler::queryGroupMessageReceiptReadMemberList(FArgument &argument,
                                                                    FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto messagePtr =
        ZIMPluginConverter::cnvZIMMessageToObject(std::get<FTMap>(argument[FTValue("message")]));
    auto groupID = std::get<std::string>(argument[FTValue("groupID")]);
    auto config = ZIMPluginConverter::cnvZIMGroupMessageReceiptMemberQueryConfigMapToObject(
        std::get<FTMap>(argument[FTValue("config")]));

    zim->queryGroupMessageReceiptReadMemberList(
        messagePtr, groupID, config,
        [=](const std::string &groupID, const std::vector<ZIMGroupMemberInfo> &userList,
            unsigned int nextFlag, const ZIMError &errorInfo) {
            if (errorInfo.code == 0) {
                FTMap retMap;
                retMap[FTValue("groupID")] = FTValue(groupID);
                retMap[FTValue("userList")] =
                    ZIMPluginConverter::cnvZIMGroupMemberInfoListToArray(userList);
                retMap[FTValue("nextFlag")] = FTValue((int32_t)nextFlag);
                result->Success(retMap);
            } else {
                result->Error(std::to_string(errorInfo.code), errorInfo.message);
            }
        });
}

void ZIMPluginMethodHandler::queryGroupMessageReceiptUnreadMemberList(FArgument &argument,
                                                                      FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto messagePtr =
        ZIMPluginConverter::cnvZIMMessageToObject(std::get<FTMap>(argument[FTValue("message")]));
    auto groupID = std::get<std::string>(argument[FTValue("groupID")]);
    auto config = ZIMPluginConverter::cnvZIMGroupMessageReceiptMemberQueryConfigMapToObject(
        std::get<FTMap>(argument[FTValue("config")]));

    zim->queryGroupMessageReceiptUnreadMemberList(
        messagePtr, groupID, config,
        [=](const std::string &callbackGroupID, const std::vector<ZIMGroupMemberInfo> &userList,
            unsigned int nextFlag, const ZIMError &errorInfo) {
            if (errorInfo.code == 0) {
                FTMap retMap;
                retMap[FTValue("groupID")] = FTValue(callbackGroupID);
                retMap[FTValue("userList")] =
                    ZIMPluginConverter::cnvZIMGroupMemberInfoListToArray(userList);
                retMap[FTValue("nextFlag")] = FTValue((int32_t)nextFlag);
                result->Success(retMap);
            } else {
                result->Error(std::to_string(errorInfo.code), errorInfo.message);
            }
        });
}

void ZIMPluginMethodHandler::searchLocalMessages(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto conversationID = std::get<std::string>(argument[FTValue("conversationID")]);
    int conversationType = std::get<int32_t>(argument[FTValue("conversationType")]);
    auto config = ZIMPluginConverter::cnvZIMMessageSearchConfigMapToObject(
        std::get<FTMap>(argument[FTValue("config")]));

    zim->searchLocalMessages(
        conversationID, (ZIMConversationType)conversationType, config,
        [=](const std::string &conversationID, ZIMConversationType conversationType,
            const std::vector<std::shared_ptr<ZIMMessage>> &messageList,
            const std::shared_ptr<ZIMMessage> &nextMessage, const ZIMError &errorInfo) {
            if (errorInfo.code == 0) {
                FTMap retMap;
                retMap[FTValue("conversationID")] = FTValue(conversationID);
                retMap[FTValue("conversationType")] = FTValue(conversationType);
                retMap[FTValue("messageList")] =
                    ZIMPluginConverter::cnvZIMMessageListToArray(messageList);
                retMap[FTValue("nextMessage")] =
                    ZIMPluginConverter::cnvZIMMessageObjectToMap(nextMessage.get());
                result->Success(retMap);
            } else {
                result->Error(std::to_string(errorInfo.code), errorInfo.message);
            }
        });
}

void ZIMPluginMethodHandler::searchGlobalLocalMessages(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto config = ZIMPluginConverter::cnvZIMMessageSearchConfigMapToObject(
        std::get<FTMap>(argument[FTValue("config")]));

    zim->searchGlobalLocalMessages(
        config, [=](const std::vector<std::shared_ptr<ZIMMessage>> &messageList,
                    const std::shared_ptr<ZIMMessage> &nextMessage, const ZIMError &errorInfo) {
            if (errorInfo.code == 0) {
                FTMap retMap;
                retMap[FTValue("messageList")] =
                    ZIMPluginConverter::cnvZIMMessageListToArray(messageList);
                retMap[FTValue("nextMessage")] =
                    ZIMPluginConverter::cnvZIMMessageObjectToMap(nextMessage.get());
                result->Success(retMap);
            } else {
                result->Error(std::to_string(errorInfo.code), errorInfo.message);
            }
        });
}

void ZIMPluginMethodHandler::searchLocalConversations(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto config = ZIMPluginConverter::cnvZIMConversationSearchConfigMapToObject(
        std::get<FTMap>(argument[FTValue("config")]));

    zim->searchLocalConversations(
        config, [=](const std::vector<ZIMConversationSearchInfo> &conversationSearchInfoList,
                    unsigned int nextFlag, const ZIMError &errorInfo) {
            if (errorInfo.code == 0) {
                FTMap retMap;
                retMap[FTValue("conversationSearchInfoList")] =
                    ZIMPluginConverter::cnvZIMConversationSearchInfoListToArray(
                        conversationSearchInfoList);
                retMap[FTValue("nextFlag")] = FTValue((int32_t)nextFlag);
                result->Success(retMap);
            } else {
                result->Error(std::to_string(errorInfo.code), errorInfo.message);
            }
        });
}

void ZIMPluginMethodHandler::createRoom(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto roomInfo =
        ZIMPluginConverter::cnvZIMRoomInfoToObject(std::get<FTMap>(argument[FTValue("roomInfo")]));

    zim->createRoom(roomInfo, [=](const ZIMRoomFullInfo &roomInfo, const ZIMError &errorInfo) {
        if (errorInfo.code == 0) {
            FTMap retMap;
            auto roomFullInfoMap = ZIMPluginConverter::cnvZIMRoomFullInfoToMap(roomInfo);
            retMap[FTValue("roomInfo")] = roomFullInfoMap;

            result->Success(retMap);
        } else {
            result->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}

void ZIMPluginMethodHandler::createRoomWithConfig(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto roomInfo =
        ZIMPluginConverter::cnvZIMRoomInfoToObject(std::get<FTMap>(argument[FTValue("roomInfo")]));
    auto roomAdvancedConfig = ZIMPluginConverter::cnvZIMRoomAdvancedConfigToObject(
        std::get<FTMap>(argument[FTValue("config")]));

    zim->createRoom(roomInfo, roomAdvancedConfig,
                    [=](const ZIMRoomFullInfo &roomInfo, const ZIMError &errorInfo) {
                        if (errorInfo.code == 0) {
                            FTMap retMap;
                            auto roomFullInfoMap =
                                ZIMPluginConverter::cnvZIMRoomFullInfoToMap(roomInfo);
                            retMap[FTValue("roomInfo")] = roomFullInfoMap;

                            result->Success(retMap);
                        } else {
                            result->Error(std::to_string(errorInfo.code), errorInfo.message);
                        }
                    });
}

void ZIMPluginMethodHandler::enterRoom(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto roomInfo =
        ZIMPluginConverter::cnvZIMRoomInfoToObject(std::get<FTMap>(argument[FTValue("roomInfo")]));
    auto roomAdvancedConfig = ZIMPluginConverter::cnvZIMRoomAdvancedConfigToObject(
        std::get<FTMap>(argument[FTValue("config")]));

    zim->enterRoom(roomInfo, roomAdvancedConfig,
                   [=](const ZIMRoomFullInfo &roomInfo, const ZIMError &errorInfo) {
                       if (errorInfo.code == 0) {
                           FTMap retMap;
                           auto roomFullInfoMap =
                               ZIMPluginConverter::cnvZIMRoomFullInfoToMap(roomInfo);
                           retMap[FTValue("roomInfo")] = roomFullInfoMap;

                           result->Success(retMap);
                       } else {
                           result->Error(std::to_string(errorInfo.code), errorInfo.message);
                       }
                   });
}

void ZIMPluginMethodHandler::joinRoom(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto roomID = std::get<std::string>(argument[FTValue("roomID")]);

    zim->joinRoom(roomID, [=](const ZIMRoomFullInfo &roomInfo, const ZIMError &errorInfo) {
        if (errorInfo.code == 0) {
            FTMap retMap;
            auto roomFullInfoMap = ZIMPluginConverter::cnvZIMRoomFullInfoToMap(roomInfo);
            retMap[FTValue("roomInfo")] = roomFullInfoMap;

            result->Success(retMap);
        } else {
            result->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}

void ZIMPluginMethodHandler::leaveRoom(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto roomID = std::get<std::string>(argument[FTValue("roomID")]);

    zim->leaveRoom(roomID, [=](const std::string &roomID, const ZIMError &errorInfo) {
        if (errorInfo.code == 0) {
            FTMap retMap;
            retMap[FTValue("roomID")] = FTValue(roomID);

            result->Success(retMap);
        } else {
            result->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}

void ZIMPluginMethodHandler::leaveAllRoom(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    zim->leaveAllRoom([=](const std::vector<std::string> &roomIDList, const ZIMError &errorInfo) {
        if (errorInfo.code == 0) {
            FTMap retMap;
            retMap[FTValue("roomIDList")] = ZIMPluginConverter::cnvStlVectorToFTArray(roomIDList);
            result->Success(retMap);
        } else {
            result->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}

void ZIMPluginMethodHandler::queryRoomMemberList(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto roomID = std::get<std::string>(argument[FTValue("roomID")]);
    auto queryConfig = ZIMPluginConverter::cnvZIMRoomMemberQueryConfigToObject(
        std::get<FTMap>(argument[FTValue("config")]));

    zim->queryRoomMemberList(
        roomID, queryConfig,
        [=](const std::string &roomID, const std::vector<ZIMUserInfo> &memberList,
            const std::string &nextFlag, const ZIMError &errorInfo) {
            if (errorInfo.code == 0) {
                FTMap retMap;
                retMap[FTValue("memberList")] =
                    ZIMPluginConverter::cnvZIMUserListToArray(memberList);
                retMap[FTValue("roomID")] = FTValue(roomID);
                retMap[FTValue("nextFlag")] = FTValue(nextFlag);

                result->Success(retMap);
            } else {
                result->Error(std::to_string(errorInfo.code), errorInfo.message);
            }
        });
}

void ZIMPluginMethodHandler::queryRoomMembers(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto roomID = std::get<std::string>(argument[FTValue("roomID")]);
    auto userIDs =
        ZIMPluginConverter::cnvFTArrayToStlVector(std::get<FTArray>(argument[FTValue("userIDs")]));

    zim->queryRoomMembers(
        userIDs, roomID,
        [=](const std::string &roomID, const std::vector<ZIMRoomMemberInfo> &memberList,
            const std::vector<ZIMErrorUserInfo> &errorUserList, const ZIMError &errorInfo) {
            if (errorInfo.code == 0) {
                FTMap retMap;
                retMap[FTValue("memberList")] =
                    ZIMPluginConverter::cnvZIMRoomMemberInfoListToArray(memberList);
                retMap[FTValue("roomID")] = FTValue(roomID);
                retMap[FTValue("errorUserList")] =
                    ZIMPluginConverter::cnvZIMErrorUserListToArray(errorUserList);
                result->Success(retMap);
            } else {
                result->Error(std::to_string(errorInfo.code), errorInfo.message);
            }
        });
}

void ZIMPluginMethodHandler::queryRoomOnlineMemberCount(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto roomID = std::get<std::string>(argument[FTValue("roomID")]);

    zim->queryRoomOnlineMemberCount(
        roomID, [=](const std::string &roomID, unsigned int count, const ZIMError &errorInfo) {
            if (errorInfo.code == 0) {
                FTMap retMap;
                retMap[FTValue("roomID")] = FTValue(roomID);
                retMap[FTValue("count")] = FTValue((int32_t)count);

                result->Success(retMap);
            } else {
                result->Error(std::to_string(errorInfo.code), errorInfo.message);
            }
        });
}

void ZIMPluginMethodHandler::setRoomAttributes(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto roomID = std::get<std::string>(argument[FTValue("roomID")]);
    auto roomAttributes =
        ZIMPluginConverter::cnvFTMapToSTLMap(std::get<FTMap>(argument[FTValue("roomAttributes")]));
    auto roomAttributesSetConfig = ZIMPluginConverter::cnvZIMRoomAttributesSetConfigToObject(
        std::get<FTMap>(argument[FTValue("config")]));

    zim->setRoomAttributes(roomAttributes, roomID, &roomAttributesSetConfig,
                           [=](const std::string &roomID,
                               const std::vector<std::string> &errorKeyList,
                               const ZIMError &errorInfo) {
                               if (errorInfo.code == 0) {
                                   FTMap retMap;
                                   retMap[FTValue("roomID")] = FTValue(roomID);
                                   retMap[FTValue("errorKeys")] =
                                       ZIMPluginConverter::cnvStlVectorToFTArray(errorKeyList);

                                   result->Success(retMap);
                               } else {
                                   result->Error(std::to_string(errorInfo.code), errorInfo.message);
                               }
                           });
}

void ZIMPluginMethodHandler::deleteRoomAttributes(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto roomID = std::get<std::string>(argument[FTValue("roomID")]);
    auto keys =
        ZIMPluginConverter::cnvFTArrayToStlVector(std::get<FTArray>(argument[FTValue("keys")]));
    auto roomAttributesDeleteConfig = ZIMPluginConverter::cnvZIMRoomAttributesDeleteConfigToObject(
        std::get<FTMap>(argument[FTValue("config")]));

    zim->deleteRoomAttributes(
        keys, roomID, &roomAttributesDeleteConfig,
        [=](const std::string &roomID, const std::vector<std::string> &errorKeyList,
            const ZIMError &errorInfo) {
            if (errorInfo.code == 0) {
                FTMap retMap;
                retMap[FTValue("roomID")] = FTValue(roomID);
                retMap[FTValue("errorKeys")] =
                    ZIMPluginConverter::cnvStlVectorToFTArray(errorKeyList);

                result->Success(retMap);
            } else {
                result->Error(std::to_string(errorInfo.code), errorInfo.message);
            }
        });
}

void ZIMPluginMethodHandler::beginRoomAttributesBatchOperation(FArgument &argument,
                                                               FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto roomID = std::get<std::string>(argument[FTValue("roomID")]);
    auto config = ZIMPluginConverter::cnvZIMRoomAttributesBatchOperationConfigToObject(
        std::get<FTMap>(argument[FTValue("config")]));

    zim->beginRoomAttributesBatchOperation(roomID, &config);
    result->Success();
}

void ZIMPluginMethodHandler::endRoomAttributesBatchOperation(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto roomID = std::get<std::string>(argument[FTValue("roomID")]);

    zim->endRoomAttributesBatchOperation(
        roomID, [=](const std::string &roomID, const ZIMError &errorInfo) {
            if (errorInfo.code == 0) {
                FTMap retMap;
                retMap[FTValue("roomID")] = FTValue(roomID);

                result->Success(retMap);
            } else {
                result->Error(std::to_string(errorInfo.code), errorInfo.message);
            }
        });
}

void ZIMPluginMethodHandler::queryRoomAllAttributes(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto roomID = std::get<std::string>(argument[FTValue("roomID")]);

    zim->queryRoomAllAttributes(
        roomID, [=](const std::string &roomID,
                    const std::unordered_map<std::string, std::string> &roomAttributes,
                    const ZIMError &errorInfo) {
            if (errorInfo.code == 0) {
                FTMap retMap;
                retMap[FTValue("roomID")] = FTValue(roomID);
                retMap[FTValue("roomAttributes")] =
                    ZIMPluginConverter::cnvSTLMapToFTMap(roomAttributes);

                result->Success(retMap);
            } else {
                result->Error(std::to_string(errorInfo.code), errorInfo.message);
            }
        });
}

void ZIMPluginMethodHandler::setRoomMembersAttributes(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto roomID = std::get<std::string>(argument[FTValue("roomID")]);
    auto attributes =
        ZIMPluginConverter::cnvFTMapToSTLMap(std::get<FTMap>(argument[FTValue("attributes")]));
    auto userIDs =
        ZIMPluginConverter::cnvFTArrayToStlVector(std::get<FTArray>(argument[FTValue("userIDs")]));
    auto config = ZIMPluginConverter::cnvZIMRoomMemberAttributesSetConfigToObject(
        std::get<FTMap>(argument[FTValue("config")]));

    zim->setRoomMembersAttributes(
        attributes, userIDs, roomID, config,
        [=](const std::string &roomID,
            const std::vector<ZIMRoomMemberAttributesOperatedInfo> &infos,
            const std::vector<std::string> &errorUserList, const ZIMError &errorInfo) {
            if (errorInfo.code == 0) {
                FTMap retMap;
                retMap[FTValue("roomID")] = FTValue(roomID);
                FTArray infosModel;
                for (ZIMRoomMemberAttributesOperatedInfo info : infos) {
                    FTMap infoModel =
                        ZIMPluginConverter::cnvZIMRoomMemberAttributesOperatedInfoToMap(info);
                    infosModel.emplace_back(infoModel);
                }
                retMap[FTValue("infos")] = infosModel;
                retMap[FTValue("errorUserList")] =
                    ZIMPluginConverter::cnvStlVectorToFTArray(errorUserList);
                result->Success(retMap);
            } else {
                result->Error(std::to_string(errorInfo.code), errorInfo.message);
            }
        });
}
void ZIMPluginMethodHandler::queryRoomMembersAttributes(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto roomID = std::get<std::string>(argument[FTValue("roomID")]);
    auto userIDs =
        ZIMPluginConverter::cnvFTArrayToStlVector(std::get<FTArray>(argument[FTValue("userIDs")]));

    zim->queryRoomMembersAttributes(
        userIDs, roomID,
        [=](const std::string &roomID, const std::vector<ZIMRoomMemberAttributesInfo> &infos,
            const ZIMError &errorInfo) {
            if (errorInfo.code == 0) {
                FTMap retMap;
                retMap[FTValue("roomID")] = FTValue(roomID);
                FTArray infosModel;
                for (ZIMRoomMemberAttributesInfo info : infos) {
                    FTMap infoModel = ZIMPluginConverter::cnvZIMRoomMemberAttributesInfoToMap(info);
                    infosModel.emplace_back(infoModel);
                }
                retMap[FTValue("infos")] = infosModel;
                result->Success(retMap);
            } else {
                result->Error(std::to_string(errorInfo.code), errorInfo.message);
            }
        });
}
void ZIMPluginMethodHandler::queryRoomMemberAttributesList(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto config = ZIMPluginConverter::cnvZIMRoomMemberAttributesQueryConfigToObject(
        std::get<FTMap>(argument[FTValue("config")]));
    auto roomID = std::get<std::string>(argument[FTValue("roomID")]);

    zim->queryRoomMemberAttributesList(
        roomID, config,
        [=](const std::string &roomID, const std::vector<ZIMRoomMemberAttributesInfo> &infos,
            const std::string &nextFlag, const ZIMError &errorInfo) {
            if (errorInfo.code == 0) {
                FTMap retMap;
                retMap[FTValue("roomID")] = FTValue(roomID);
                FTArray infosModel;
                for (ZIMRoomMemberAttributesInfo info : infos) {
                    FTMap infoModel = ZIMPluginConverter::cnvZIMRoomMemberAttributesInfoToMap(info);
                    infosModel.emplace_back(infoModel);
                }
                retMap[FTValue("infos")] = infosModel;
                retMap[FTValue("nextFlag")] = nextFlag;
                result->Success(retMap);
            } else {
                result->Error(std::to_string(errorInfo.code), errorInfo.message);
            }
        });
}

void ZIMPluginMethodHandler::createGroup(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto groupInfo = ZIMPluginConverter::cnvZIMGroupInfoToObject(
        std::get<FTMap>(argument[FTValue("groupInfo")]));
    auto userIDs =
        ZIMPluginConverter::cnvFTArrayToStlVector(std::get<FTArray>(argument[FTValue("userIDs")]));

    zim->createGroup(
        groupInfo, userIDs,
        [=](const ZIMGroupFullInfo &groupInfo, const std::vector<ZIMGroupMemberInfo> &userList,
            const std::vector<ZIMErrorUserInfo> &errorUserList, const ZIMError &errorInfo) {
            if (errorInfo.code == 0) {
                FTMap retMap;
                retMap[FTValue("groupInfo")] =
                    ZIMPluginConverter::cnvZIMGroupFullInfoToMap(groupInfo);
                retMap[FTValue("userList")] =
                    ZIMPluginConverter::cnvZIMGroupMemberInfoListToArray(userList);
                retMap[FTValue("errorUserList")] =
                    ZIMPluginConverter::cnvZIMErrorUserListToArray(errorUserList);

                result->Success(retMap);
            } else {
                result->Error(std::to_string(errorInfo.code), errorInfo.message);
            }
        });
}

void ZIMPluginMethodHandler::createGroupWithConfig(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto groupInfo = ZIMPluginConverter::cnvZIMGroupInfoToObject(
        std::get<FTMap>(argument[FTValue("groupInfo")]));
    auto userIDs =
        ZIMPluginConverter::cnvFTArrayToStlVector(std::get<FTArray>(argument[FTValue("userIDs")]));
    auto config = ZIMPluginConverter::cnvZIMGroupAdvancedConfigToObject(
        std::get<FTMap>(argument[FTValue("config")]));

    zim->createGroup(
        groupInfo, userIDs, config,
        [=](const ZIMGroupFullInfo &groupInfo, const std::vector<ZIMGroupMemberInfo> &userList,
            const std::vector<ZIMErrorUserInfo> &errorUserList, const ZIMError &errorInfo) {
            if (errorInfo.code == 0) {
                FTMap retMap;
                retMap[FTValue("groupInfo")] =
                    ZIMPluginConverter::cnvZIMGroupFullInfoToMap(groupInfo);
                retMap[FTValue("userList")] =
                    ZIMPluginConverter::cnvZIMGroupMemberInfoListToArray(userList);
                retMap[FTValue("errorUserList")] =
                    ZIMPluginConverter::cnvZIMErrorUserListToArray(errorUserList);

                result->Success(retMap);
            } else {
                result->Error(std::to_string(errorInfo.code), errorInfo.message);
            }
        });
}

void ZIMPluginMethodHandler::joinGroup(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto groupID = std::get<std::string>(argument[FTValue("groupID")]);

    zim->joinGroup(groupID, [=](const ZIMGroupFullInfo &groupInfo, const ZIMError &errorInfo) {
        if (errorInfo.code == 0) {
            FTMap retMap;
            retMap[FTValue("groupInfo")] = ZIMPluginConverter::cnvZIMGroupFullInfoToMap(groupInfo);

            result->Success(retMap);
        } else {
            result->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}

void ZIMPluginMethodHandler::dismissGroup(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto groupID = std::get<std::string>(argument[FTValue("groupID")]);

    zim->dismissGroup(groupID, [=](const std::string &groupID, const ZIMError &errorInfo) {
        if (errorInfo.code == 0) {
            FTMap retMap;
            retMap[FTValue("groupID")] = FTValue(groupID);

            result->Success(retMap);
        } else {
            result->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}

void ZIMPluginMethodHandler::leaveGroup(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto groupID = std::get<std::string>(argument[FTValue("groupID")]);

    zim->leaveGroup(groupID, [=](const std::string &groupID, const ZIMError &errorInfo) {
        if (errorInfo.code == 0) {
            FTMap retMap;
            retMap[FTValue("groupID")] = FTValue(groupID);

            result->Success(retMap);
        } else {
            result->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}

void ZIMPluginMethodHandler::inviteUsersIntoGroup(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto groupID = std::get<std::string>(argument[FTValue("groupID")]);
    auto userIDs =
        ZIMPluginConverter::cnvFTArrayToStlVector(std::get<FTArray>(argument[FTValue("userIDs")]));

    zim->inviteUsersIntoGroup(
        userIDs, groupID,
        [=](const std::string &groupID, const std::vector<ZIMGroupMemberInfo> &userList,
            const std::vector<ZIMErrorUserInfo> &errorUserList, const ZIMError &errorInfo) {
            if (errorInfo.code == 0) {
                FTMap retMap;
                retMap[FTValue("groupID")] = FTValue(groupID);
                retMap[FTValue("userList")] =
                    ZIMPluginConverter::cnvZIMGroupMemberInfoListToArray(userList);
                retMap[FTValue("errorUserList")] =
                    ZIMPluginConverter::cnvZIMErrorUserListToArray(errorUserList);

                result->Success(retMap);
            } else {
                result->Error(std::to_string(errorInfo.code), errorInfo.message);
            }
        });
}

void ZIMPluginMethodHandler::kickGroupMembers(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto groupID = std::get<std::string>(argument[FTValue("groupID")]);
    auto userIDs =
        ZIMPluginConverter::cnvFTArrayToStlVector(std::get<FTArray>(argument[FTValue("userIDs")]));

    zim->kickGroupMembers(
        userIDs, groupID,
        [=](const std::string &groupID, const std::vector<std::string> &kickedUserIDList,
            const std::vector<ZIMErrorUserInfo> &errorUserList, const ZIMError &errorInfo) {
            if (errorInfo.code == 0) {
                FTMap retMap;
                retMap[FTValue("groupID")] = FTValue(groupID);
                retMap[FTValue("kickedUserIDList")] =
                    ZIMPluginConverter::cnvStlVectorToFTArray(kickedUserIDList);
                retMap[FTValue("errorUserList")] =
                    ZIMPluginConverter::cnvZIMErrorUserListToArray(errorUserList);

                result->Success(retMap);
            } else {
                result->Error(std::to_string(errorInfo.code), errorInfo.message);
            }
        });
}

void ZIMPluginMethodHandler::transferGroupOwner(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto groupID = std::get<std::string>(argument[FTValue("groupID")]);
    auto toUserID = std::get<std::string>(argument[FTValue("toUserID")]);

    zim->transferGroupOwner(
        toUserID, groupID,
        [=](const std::string &groupID, const std::string &toUserID, const ZIMError &errorInfo) {
            if (errorInfo.code == 0) {
                FTMap retMap;
                retMap[FTValue("groupID")] = FTValue(groupID);
                retMap[FTValue("toUserID")] = FTValue(toUserID);

                result->Success(retMap);
            } else {
                result->Error(std::to_string(errorInfo.code), errorInfo.message);
            }
        });
}

void ZIMPluginMethodHandler::updateGroupName(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto groupID = std::get<std::string>(argument[FTValue("groupID")]);
    auto groupName = std::get<std::string>(argument[FTValue("groupName")]);

    zim->updateGroupName(
        groupName, groupID,
        [=](const std::string &groupID, const std::string &groupName, const ZIMError &errorInfo) {
            if (errorInfo.code == 0) {
                FTMap retMap;
                retMap[FTValue("groupID")] = FTValue(groupID);
                retMap[FTValue("groupName")] = FTValue(groupName);

                result->Success(retMap);
            } else {
                result->Error(std::to_string(errorInfo.code), errorInfo.message);
            }
        });
}

void ZIMPluginMethodHandler::updateGroupAvatarUrl(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto groupID = std::get<std::string>(argument[FTValue("groupID")]);
    auto groupAvatarUrl = std::get<std::string>(argument[FTValue("groupAvatarUrl")]);

    zim->updateGroupAvatarUrl(groupAvatarUrl, groupID,
                              [=](const std::string &groupID, const std::string &groupAvatarUrl,
                                  const ZIMError &errorInfo) {
                                  if (errorInfo.code == 0) {
                                      FTMap retMap;
                                      retMap[FTValue("groupID")] = FTValue(groupID);
                                      retMap[FTValue("groupAvatarUrl")] = FTValue(groupAvatarUrl);

                                      result->Success(retMap);
                                  } else {
                                      result->Error(std::to_string(errorInfo.code),
                                                    errorInfo.message);
                                  }
                              });
}

void ZIMPluginMethodHandler::updateGroupNotice(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto groupID = std::get<std::string>(argument[FTValue("groupID")]);
    auto groupNotice = std::get<std::string>(argument[FTValue("groupNotice")]);

    zim->updateGroupNotice(
        groupNotice, groupID,
        [=](const std::string &groupID, const std::string &groupNotice, const ZIMError &errorInfo) {
            if (errorInfo.code == 0) {
                FTMap retMap;
                retMap[FTValue("groupID")] = FTValue(groupID);
                retMap[FTValue("groupNotice")] = FTValue(groupNotice);

                result->Success(retMap);
            } else {
                result->Error(std::to_string(errorInfo.code), errorInfo.message);
            }
        });
}

void ZIMPluginMethodHandler::updateGroupJoinMode(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto groupID = std::get<std::string>(argument[FTValue("groupID")]);
    auto mode = (ZIMGroupJoinMode)std::get<int32_t>(argument[FTValue("mode")]);

    zim->updateGroupJoinMode(
        mode, groupID,
        [=](const std::string &groupID, ZIMGroupJoinMode mode, const ZIMError &errorInfo) {
            if (errorInfo.code == 0) {
                FTMap retMap;
                retMap[FTValue("groupID")] = FTValue(groupID);
                retMap[FTValue("mode")] = FTValue((int32_t)mode);
                result->Success(retMap);
            } else {
                result->Error(std::to_string(errorInfo.code), errorInfo.message);
            }
        });
}

void ZIMPluginMethodHandler::updateGroupInviteMode(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto groupID = std::get<std::string>(argument[FTValue("groupID")]);

    int mode = ZIMPluginConverter::cnvFTValueToInt32(argument[FTValue("mode")]);

    zim->updateGroupInviteMode(
        (ZIMGroupInviteMode)mode, groupID,
        [=](const std::string &groupID, ZIMGroupInviteMode mode, const ZIMError &errorInfo) {
            if (errorInfo.code == 0) {
                FTMap retMap;
                retMap[FTValue("groupID")] = FTValue(groupID);
                retMap[FTValue("mode")] = FTValue((int32_t)mode);
                result->Success(retMap);
            } else {
                result->Error(std::to_string(errorInfo.code), errorInfo.message);
            }
        });
}

void ZIMPluginMethodHandler::updateGroupBeInviteMode(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto groupID = std::get<std::string>(argument[FTValue("groupID")]);
    auto mode = (ZIMGroupBeInviteMode)std::get<int32_t>(argument[FTValue("mode")]);

    zim->updateGroupBeInviteMode(
        mode, groupID,
        [=](const std::string &groupID, ZIMGroupBeInviteMode mode, const ZIMError &errorInfo) {
            if (errorInfo.code == 0) {
                FTMap retMap;
                retMap[FTValue("groupID")] = FTValue(groupID);
                retMap[FTValue("mode")] = FTValue((int32_t)mode);
                result->Success(retMap);
            } else {
                result->Error(std::to_string(errorInfo.code), errorInfo.message);
            }
        });
}

void ZIMPluginMethodHandler::queryGroupInfo(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto groupID = std::get<std::string>(argument[FTValue("groupID")]);

    zim->queryGroupInfo(groupID, [=](const ZIMGroupFullInfo &groupInfo, const ZIMError &errorInfo) {
        if (errorInfo.code == 0) {
            FTMap retMap;
            retMap[FTValue("groupInfo")] = ZIMPluginConverter::cnvZIMGroupFullInfoToMap(groupInfo);

            result->Success(retMap);
        } else {
            result->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}

void ZIMPluginMethodHandler::setGroupAttributes(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto groupID = std::get<std::string>(argument[FTValue("groupID")]);
    auto groupAttributes =
        ZIMPluginConverter::cnvFTMapToSTLMap(std::get<FTMap>(argument[FTValue("groupAttributes")]));

    zim->setGroupAttributes(
        groupAttributes, groupID,
        [=](const std::string &groupID, const std::vector<std::string> &errorKeys,
            const ZIMError &errorInfo) {
            if (errorInfo.code == 0) {
                FTMap retMap;
                retMap[FTValue("groupID")] = FTValue(groupID);
                retMap[FTValue("errorKeys")] = ZIMPluginConverter::cnvStlVectorToFTArray(errorKeys);

                result->Success(retMap);
            } else {
                result->Error(std::to_string(errorInfo.code), errorInfo.message);
            }
        });
}

void ZIMPluginMethodHandler::deleteGroupAttributes(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto groupID = std::get<std::string>(argument[FTValue("groupID")]);
    auto keys =
        ZIMPluginConverter::cnvFTArrayToStlVector(std::get<FTArray>(argument[FTValue("keys")]));

    zim->deleteGroupAttributes(
        keys, groupID,
        [=](const std::string &groupID, const std::vector<std::string> &errorKeys,
            const ZIMError &errorInfo) {
            if (errorInfo.code == 0) {
                FTMap retMap;
                retMap[FTValue("groupID")] = FTValue(groupID);
                retMap[FTValue("errorKeys")] = ZIMPluginConverter::cnvStlVectorToFTArray(errorKeys);

                result->Success(retMap);
            } else {
                result->Error(std::to_string(errorInfo.code), errorInfo.message);
            }
        });
}

void ZIMPluginMethodHandler::queryGroupAttributes(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto groupID = std::get<std::string>(argument[FTValue("groupID")]);
    auto keys =
        ZIMPluginConverter::cnvFTArrayToStlVector(std::get<FTArray>(argument[FTValue("keys")]));

    zim->queryGroupAttributes(
        keys, groupID,
        [result =
             std::move(result)](const std::string &groupID,
                                const std::unordered_map<std::string, std::string> &groupAttributes,
                                const ZIMError &errorInfo) {
            if (errorInfo.code == 0) {
                FTMap retMap;
                retMap[FTValue("groupID")] = FTValue(groupID);
                retMap[FTValue("groupAttributes")] =
                    ZIMPluginConverter::cnvSTLMapToFTMap(groupAttributes);

                result->Success(retMap);
            } else {
                result->Error(std::to_string(errorInfo.code), errorInfo.message);
            }
        });
}

void ZIMPluginMethodHandler::queryGroupAllAttributes(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto groupID = std::get<std::string>(argument[FTValue("groupID")]);

    zim->queryGroupAllAttributes(
        groupID, [=](const std::string &groupID,
                     const std::unordered_map<std::string, std::string> &groupAttributes,
                     const ZIMError &errorInfo) {
            if (errorInfo.code == 0) {
                FTMap retMap;
                retMap[FTValue("groupID")] = FTValue(groupID);
                retMap[FTValue("groupAttributes")] =
                    ZIMPluginConverter::cnvSTLMapToFTMap(groupAttributes);

                result->Success(retMap);
            } else {
                result->Error(std::to_string(errorInfo.code), errorInfo.message);
            }
        });
}

void ZIMPluginMethodHandler::setGroupMemberRole(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto groupID = std::get<std::string>(argument[FTValue("groupID")]);
    int role = ZIMPluginConverter::cnvFTValueToInt32(argument[FTValue("role")]);
    auto forUserID = std::get<std::string>(argument[FTValue("forUserID")]);

    zim->setGroupMemberRole(role, forUserID, groupID,
                            [=](const std::string &groupID, const std::string &forUserID,
                                ZIMGroupMemberRole role, const ZIMError &errorInfo) {
                                if (errorInfo.code == 0) {
                                    FTMap retMap;
                                    retMap[FTValue("groupID")] = FTValue(groupID);
                                    retMap[FTValue("forUserID")] = FTValue(forUserID);
                                    retMap[FTValue("role")] = FTValue((int32_t)role);

                                    result->Success(retMap);
                                } else {
                                    result->Error(std::to_string(errorInfo.code),
                                                  errorInfo.message);
                                }
                            });
}

void ZIMPluginMethodHandler::setGroupMemberNickname(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto groupID = std::get<std::string>(argument[FTValue("groupID")]);
    auto nickname = std::get<std::string>(argument[FTValue("nickname")]);
    auto forUserID = std::get<std::string>(argument[FTValue("forUserID")]);

    zim->setGroupMemberNickname(nickname, forUserID, groupID,
                                [=](const std::string &groupID, const std::string &forUserID,
                                    const std::string &nickname, const ZIMError &errorInfo) {
                                    if (errorInfo.code == 0) {
                                        FTMap retMap;
                                        retMap[FTValue("groupID")] = FTValue(groupID);
                                        retMap[FTValue("forUserID")] = FTValue(forUserID);
                                        retMap[FTValue("nickname")] = FTValue(nickname);

                                        result->Success(retMap);
                                    } else {
                                        result->Error(std::to_string(errorInfo.code),
                                                      errorInfo.message);
                                    }
                                });
}

void ZIMPluginMethodHandler::queryGroupMemberInfo(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto groupID = std::get<std::string>(argument[FTValue("groupID")]);
    auto userID = std::get<std::string>(argument[FTValue("userID")]);

    zim->queryGroupMemberInfo(userID, groupID,
                              [=](const std::string &groupID, const ZIMGroupMemberInfo &userInfo,
                                  const ZIMError &errorInfo) {
                                  if (errorInfo.code == 0) {
                                      FTMap retMap;
                                      retMap[FTValue("groupID")] = FTValue(groupID);
                                      retMap[FTValue("userInfo")] =
                                          ZIMPluginConverter::cnvZIMGroupMemberInfoToMap(userInfo);

                                      result->Success(retMap);
                                  } else {
                                      result->Error(std::to_string(errorInfo.code),
                                                    errorInfo.message);
                                  }
                              });
}

void ZIMPluginMethodHandler::queryGroupList(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    zim->queryGroupList([=](const std::vector<ZIMGroup> &groupList, const ZIMError &errorInfo) {
        if (errorInfo.code == 0) {
            FTMap retMap;
            retMap[FTValue("groupList")] = ZIMPluginConverter::cnvZIMGroupListToArray(groupList);

            result->Success(retMap);
        } else {
            result->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}

void ZIMPluginMethodHandler::queryGroupMemberList(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto groupID = std::get<std::string>(argument[FTValue("groupID")]);
    auto config = ZIMPluginConverter::cnvZIMGroupMemberQueryConfigToObject(
        std::get<FTMap>(argument[FTValue("config")]));

    zim->queryGroupMemberList(
        groupID, config,
        [=](const std::string &groupID, const std::vector<ZIMGroupMemberInfo> &userList,
            unsigned int nextFlag, const ZIMError &errorInfo) {
            if (errorInfo.code == 0) {
                FTMap retMap;
                retMap[FTValue("groupID")] = FTValue(groupID);
                retMap[FTValue("userList")] =
                    ZIMPluginConverter::cnvZIMGroupMemberInfoListToArray(userList);
                retMap[FTValue("nextFlag")] = FTValue((int32_t)nextFlag);

                result->Success(retMap);
            } else {
                result->Error(std::to_string(errorInfo.code), errorInfo.message);
            }
        });
}

void ZIMPluginMethodHandler::queryGroupMemberCount(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto groupID = std::get<std::string>(argument[FTValue("groupID")]);

    zim->queryGroupMemberCount(
        groupID, [=](const std::string &groupID, unsigned int count, const ZIMError &errorInfo) {
            if (errorInfo.code == 0) {
                FTMap retMap;
                retMap[FTValue("groupID")] = FTValue(groupID);
                retMap[FTValue("count")] = FTValue((int32_t)count);

                result->Success(retMap);
            } else {
                result->Error(std::to_string(errorInfo.code), errorInfo.message);
            }
        });
}

void ZIMPluginMethodHandler::searchLocalGroups(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto config = ZIMPluginConverter::cnvZIMGroupSearchConfigMapToObject(
        std::get<FTMap>(argument[FTValue("config")]));

    zim->searchLocalGroups(config, [=](const std::vector<ZIMGroupSearchInfo> &groupSearchInfoList,
                                       unsigned int nextFlag, const ZIMError &errorInfo) {
        if (errorInfo.code == 0) {
            FTMap retMap;
            retMap[FTValue("groupSearchInfoList")] =
                ZIMPluginConverter::cnvZIMGroupSearchInfoListToArray(groupSearchInfoList);
            retMap[FTValue("nextFlag")] = FTValue((int32_t)nextFlag);

            result->Success(retMap);
        } else {
            result->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}

void ZIMPluginMethodHandler::searchLocalGroupMembers(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto groupID = std::get<std::string>(argument[FTValue("groupID")]);
    auto config = ZIMPluginConverter::cnvZIMGroupMemberSearchConfigMapToObject(
        std::get<FTMap>(argument[FTValue("config")]));

    zim->searchLocalGroupMembers(
        groupID, config,
        [=](const std::string &groupID, const std::vector<ZIMGroupMemberInfo> &userList,
            unsigned int nextFlag, const ZIMError &errorInfo) {
            if (errorInfo.code == 0) {
                FTMap retMap;
                retMap[FTValue("groupID")] = FTValue(groupID);
                retMap[FTValue("userList")] =
                    ZIMPluginConverter::cnvZIMGroupMemberInfoListToArray(userList);
                retMap[FTValue("nextFlag")] = FTValue((int32_t)nextFlag);

                result->Success(retMap);
            } else {
                result->Error(std::to_string(errorInfo.code), errorInfo.message);
            }
        });
}

void ZIMPluginMethodHandler::muteGroup(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto groupID = std::get<std::string>(argument[FTValue("groupID")]);
    bool isMute = std::get<bool>(argument[FTValue("isMute")]);
    auto config = ZIMPluginConverter::cnvZIMGroupMuteConfigToObject(
        std::get<FTMap>(argument[FTValue("config")]));

    zim->muteGroup(isMute, groupID, config,
                   [=](const std::string &groupID, bool isMute, const ZIMGroupMuteInfo &info,
                       const ZIMError &errorInfo) {
                       if (errorInfo.code == 0) {
                           FTMap retMap;
                           retMap[FTValue("isMute")] = FTValue(isMute);
                           retMap[FTValue("groupID")] = FTValue(groupID);
                           retMap[FTValue("info")] =
                               ZIMPluginConverter::cnvZIMGroupMuteInfoToMap(info);
                           result->Success(retMap);
                       } else {
                           result->Error(std::to_string(errorInfo.code), errorInfo.message);
                       }
                   });
}

void ZIMPluginMethodHandler::sendGroupJoinApplication(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto groupID = std::get<std::string>(argument[FTValue("groupID")]);
    auto config = ZIMPluginConverter::cnvZIMGroupJoinApplicationSendConfigToObject(
        std::get<FTMap>(argument[FTValue("config")]));
    auto configMap = std::get<FTMap>(argument[FTValue("config")]);
    std::shared_ptr<ZIMPushConfig> pushConfigPtr = nullptr;
    std::shared_ptr<ZIMVoIPConfig> voIPConfigPtr = nullptr;
    if (std::holds_alternative<std::monostate>(configMap[FTValue("pushConfig")])) {
        config.pushConfig = nullptr;
    } else {
        pushConfigPtr = ZIMPluginConverter::cnvZIMPushConfigToObject(
            std::get<FTMap>(configMap[FTValue("pushConfig")]), voIPConfigPtr);
        config.pushConfig = pushConfigPtr.get();
    }

    zim->sendGroupJoinApplication(
        groupID, config, [=](const std::string &groupID, const ZIMError &errorInfo) {
            if (errorInfo.code == 0) {
                FTMap retMap;
                retMap[FTValue("groupID")] = FTValue(groupID);
                result->Success(retMap);
            } else {
                result->Error(std::to_string(errorInfo.code), errorInfo.message);
            }
        });
}

void ZIMPluginMethodHandler::acceptGroupJoinApplication(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto groupID = std::get<std::string>(argument[FTValue("groupID")]);
    auto userID = std::get<std::string>(argument[FTValue("userID")]);
    auto config = ZIMPluginConverter::cnvZIMGroupJoinApplicationAcceptConfigToObject(
        std::get<FTMap>(argument[FTValue("config")]));
    auto configMap = std::get<FTMap>(argument[FTValue("config")]);
    std::shared_ptr<ZIMPushConfig> pushConfigPtr = nullptr;
    std::shared_ptr<ZIMVoIPConfig> voIPConfigPtr = nullptr;
    if (std::holds_alternative<std::monostate>(configMap[FTValue("pushConfig")])) {
        config.pushConfig = nullptr;
    } else {
        pushConfigPtr = ZIMPluginConverter::cnvZIMPushConfigToObject(
            std::get<FTMap>(configMap[FTValue("pushConfig")]), voIPConfigPtr);
        config.pushConfig = pushConfigPtr.get();
    }

    zim->acceptGroupJoinApplication(
        userID, groupID, config,
        [=](const std::string &groupID, const std::string &userID, const ZIMError &errorInfo) {
            if (errorInfo.code == 0) {
                FTMap retMap;
                retMap[FTValue("groupID")] = FTValue(groupID);
                retMap[FTValue("userID")] = FTValue(userID);
                result->Success(retMap);
            } else {
                result->Error(std::to_string(errorInfo.code), errorInfo.message);
            }
        });
}

void ZIMPluginMethodHandler::rejectGroupJoinApplication(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto groupID = std::get<std::string>(argument[FTValue("groupID")]);
    auto userID = std::get<std::string>(argument[FTValue("userID")]);
    auto config = ZIMPluginConverter::cnvZIMGroupJoinApplicationRejectConfigToObject(
        std::get<FTMap>(argument[FTValue("config")]));
    auto configMap = std::get<FTMap>(argument[FTValue("config")]);
    std::shared_ptr<ZIMPushConfig> pushConfigPtr = nullptr;
    std::shared_ptr<ZIMVoIPConfig> voIPConfigPtr = nullptr;
    if (std::holds_alternative<std::monostate>(configMap[FTValue("pushConfig")])) {
        config.pushConfig = nullptr;
    } else {
        pushConfigPtr = ZIMPluginConverter::cnvZIMPushConfigToObject(
            std::get<FTMap>(configMap[FTValue("pushConfig")]), voIPConfigPtr);
        config.pushConfig = pushConfigPtr.get();
    }

    zim->rejectGroupJoinApplication(
        userID, groupID, config,
        [=](const std::string &groupID, const std::string &userID, const ZIMError &errorInfo) {
            if (errorInfo.code == 0) {
                FTMap retMap;
                retMap[FTValue("groupID")] = FTValue(groupID);
                retMap[FTValue("userID")] = FTValue(userID);
                result->Success(retMap);
            } else {
                result->Error(std::to_string(errorInfo.code), errorInfo.message);
            }
        });
}

void ZIMPluginMethodHandler::sendGroupInviteApplications(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto groupID = std::get<std::string>(argument[FTValue("groupID")]);
    auto userIDs = std::get<FTArray>(argument[FTValue("userIDs")]);
    std::vector<std::string> userIDsVec;
    for (auto &userIDValue : userIDs) {
        auto userID = std::get<std::string>(userIDValue);
        userIDsVec.emplace_back(userID);
    }
    auto config = ZIMPluginConverter::cnvZIMGroupInviteApplicationSendConfigToObject(
        std::get<FTMap>(argument[FTValue("config")]));
    auto configMap = std::get<FTMap>(argument[FTValue("config")]);
    std::shared_ptr<ZIMPushConfig> pushConfigPtr = nullptr;
    std::shared_ptr<ZIMVoIPConfig> voIPConfigPtr = nullptr;
    if (std::holds_alternative<std::monostate>(configMap[FTValue("pushConfig")])) {
        config.pushConfig = nullptr;
    } else {
        pushConfigPtr = ZIMPluginConverter::cnvZIMPushConfigToObject(
            std::get<FTMap>(configMap[FTValue("pushConfig")]), voIPConfigPtr);
        config.pushConfig = pushConfigPtr.get();
    }

    zim->sendGroupInviteApplications(
        userIDsVec, groupID, config,
        [=](const std::string &groupID, const std::vector<ZIMErrorUserInfo> &errorUserList,
            const ZIMError &errorInfo) {
            if (errorInfo.code == 0) {
                FTMap retMap;
                retMap[FTValue("groupID")] = FTValue(groupID);
                retMap[FTValue("errorUserList")] =
                    ZIMPluginConverter::cnvZIMErrorUserListToArray(errorUserList);

                result->Success(retMap);
            } else {
                result->Error(std::to_string(errorInfo.code), errorInfo.message);
            }
        });
}

void ZIMPluginMethodHandler::acceptGroupInviteApplication(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto groupID = std::get<std::string>(argument[FTValue("groupID")]);
    auto inviterUserID = std::get<std::string>(argument[FTValue("inviterUserID")]);
    auto config = ZIMPluginConverter::cnvZIMGroupInviteApplicationAcceptConfigToObject(
        std::get<FTMap>(argument[FTValue("config")]));
    auto configMap = std::get<FTMap>(argument[FTValue("config")]);
    std::shared_ptr<ZIMPushConfig> pushConfigPtr = nullptr;
    std::shared_ptr<ZIMVoIPConfig> voIPConfigPtr = nullptr;
    if (std::holds_alternative<std::monostate>(configMap[FTValue("pushConfig")])) {
        config.pushConfig = nullptr;
    } else {
        pushConfigPtr = ZIMPluginConverter::cnvZIMPushConfigToObject(
            std::get<FTMap>(configMap[FTValue("pushConfig")]), voIPConfigPtr);
        config.pushConfig = pushConfigPtr.get();
    }

    zim->acceptGroupInviteApplication(
        inviterUserID, groupID, config,
        [=](const ZIMGroupFullInfo &fullInfo, const std::string &inviterUserID,
            const ZIMError &errorInfo) {
            if (errorInfo.code == 0) {
                FTMap retMap;
                retMap[FTValue("groupInfo")] =
                    ZIMPluginConverter::cnvZIMGroupFullInfoToMap(fullInfo);
                retMap[FTValue("inviterUserID")] = FTValue(inviterUserID);

                result->Success(retMap);
            } else {
                result->Error(std::to_string(errorInfo.code), errorInfo.message);
            }
        });
}

void ZIMPluginMethodHandler::rejectGroupInviteApplication(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto groupID = std::get<std::string>(argument[FTValue("groupID")]);
    auto inviterUserID = std::get<std::string>(argument[FTValue("inviterUserID")]);
    auto config = ZIMPluginConverter::cnvZIMGroupInviteApplicationRejectConfigToObject(
        std::get<FTMap>(argument[FTValue("config")]));
    auto configMap = std::get<FTMap>(argument[FTValue("config")]);
    std::shared_ptr<ZIMPushConfig> pushConfigPtr = nullptr;
    std::shared_ptr<ZIMVoIPConfig> voIPConfigPtr = nullptr;
    if (std::holds_alternative<std::monostate>(configMap[FTValue("pushConfig")])) {
        config.pushConfig = nullptr;
    } else {
        pushConfigPtr = ZIMPluginConverter::cnvZIMPushConfigToObject(
            std::get<FTMap>(configMap[FTValue("pushConfig")]), voIPConfigPtr);
        config.pushConfig = pushConfigPtr.get();
    }

    zim->rejectGroupInviteApplication(
        inviterUserID, groupID, config,
        [=](const std::string &groupID, const std::string &inviterUserID,
            const ZIMError &errorInfo) {
            if (errorInfo.code == 0) {
                FTMap retMap;
                retMap[FTValue("groupID")] = FTValue(groupID);
                retMap[FTValue("inviterUserID")] = FTValue(inviterUserID);
                result->Success(retMap);
            } else {
                result->Error(std::to_string(errorInfo.code), errorInfo.message);
            }
        });
}

void ZIMPluginMethodHandler::queryGroupApplicationList(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto config = ZIMPluginConverter::cnvZIMGroupApplicationListQueryConfigToObject(
        std::get<FTMap>(argument[FTValue("config")]));

    zim->queryGroupApplicationList(
        config, [=](const std::vector<ZIMGroupApplicationInfo> &applicationList,
                    unsigned long long nextFlag, const ZIMError &errorInfo) {
            if (errorInfo.code == 0) {
                FTMap retMap;
                retMap[FTValue("nextFlag")] = FTValue((int32_t)nextFlag);
                retMap[FTValue("applicationList")] =
                    ZIMPluginConverter::cnvZIMGroupApplicationInfoToArray(applicationList);
                result->Success(retMap);
            } else {
                result->Error(std::to_string(errorInfo.code), errorInfo.message);
            }
        });
}

void ZIMPluginMethodHandler::muteGroupMemberList(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto userIDs = std::get<FTArray>(argument[FTValue("userIDs")]);
    std::vector<std::string> userIDsVec;
    for (auto &userIDValue : userIDs) {
        auto userID = std::get<std::string>(userIDValue);
        userIDsVec.emplace_back(userID);
    }
    auto groupID = std::get<std::string>(argument[FTValue("groupID")]);
    bool isMute = std::get<bool>(argument[FTValue("isMute")]);
    auto config = ZIMPluginConverter::cnvZIMGroupMemberMuteConfigToObject(
        std::get<FTMap>(argument[FTValue("config")]));

    zim->muteGroupMembers(isMute, userIDsVec, groupID, config,
                          [=](const std::string &groupID, bool isMute, unsigned int duration,
                              const std::vector<std::string> &mutedMemberIDs,
                              const std::vector<ZIMErrorUserInfo> &errorUserList,
                              const ZIMError &errorInfo) {
                              if (errorInfo.code == 0) {
                                  FTMap retMap;
                                  retMap[FTValue("isMute")] = FTValue(isMute);
                                  retMap[FTValue("groupID")] = FTValue(groupID);
                                  retMap[FTValue("duration")] = FTValue((int32_t)duration);
                                  retMap[FTValue("mutedMemberIDs")] =
                                      ZIMPluginConverter::cnvStlVectorToFTArray(mutedMemberIDs);
                                  retMap[FTValue("errorUserList")] =
                                      ZIMPluginConverter::cnvZIMErrorUserListToArray(errorUserList);
                                  result->Success(retMap);
                              } else {
                                  result->Error(std::to_string(errorInfo.code), errorInfo.message);
                              }
                          });
}

void ZIMPluginMethodHandler::queryGroupMemberMutedList(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto groupID = std::get<std::string>(argument[FTValue("groupID")]);
    auto config = ZIMPluginConverter::cnvZIMGroupMemberMutedListQueryConfigToObject(
        std::get<FTMap>(argument[FTValue("config")]));
    zim->queryGroupMemberMutedList(
        groupID, config,
        [=](const std::string &groupID, unsigned long long nextFlag,
            const std::vector<ZIMGroupMemberInfo> &userList, const ZIMError &errorInfo) {
            if (errorInfo.code == 0) {
                FTMap retMap;
                retMap[FTValue("groupID")] = FTValue(groupID);
                retMap[FTValue("nextFlag")] = FTValue((int64_t)nextFlag);
                retMap[FTValue("userList")] =
                    ZIMPluginConverter::cnvZIMGroupMemberInfoListToArray(userList);
                result->Success(retMap);
            } else {
                result->Error(std::to_string(errorInfo.code), errorInfo.message);
            }
        });
}

void ZIMPluginMethodHandler::callInvite(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto invitees =
        ZIMPluginConverter::cnvFTArrayToStlVector(std::get<FTArray>(argument[FTValue("invitees")]));
    auto configMap = std::get<FTMap>(argument[FTValue("config")]);

    ZIMCallInviteConfig config;
    config.mode = (ZIMCallInvitationMode)std::get<int32_t>(configMap[FTValue("mode")]);
    config.timeout = ZIMPluginConverter::cnvFTValueToInt32(configMap[FTValue("timeout")]);
    config.extendedData = std::get<std::string>(configMap[FTValue("extendedData")]);
    config.enableNotReceivedCheck = std::get<bool>(configMap[FTValue("enableNotReceivedCheck")]);
    std::shared_ptr<ZIMPushConfig> pushConfigPtr = nullptr;
    std::shared_ptr<ZIMVoIPConfig> voIPConfigPtr = nullptr;
    if (std::holds_alternative<std::monostate>(configMap[FTValue("pushConfig")])) {
        config.pushConfig = nullptr;
    } else {
        pushConfigPtr = ZIMPluginConverter::cnvZIMPushConfigToObject(
            std::get<FTMap>(configMap[FTValue("pushConfig")]), voIPConfigPtr);
        config.pushConfig = pushConfigPtr.get();
    }

    zim->callInvite(invitees, config,
                    [=](const std::string &callID, const ZIMCallInvitationSentInfo &info,
                        const ZIMError &errorInfo) {
                        if (errorInfo.code == 0) {
                            FTMap retMap;
                            retMap[FTValue("callID")] = FTValue(callID);
                            retMap[FTValue("info")] =
                                ZIMPluginConverter::cnvZIMCallInvitationSentInfoToMap(info);

                            result->Success(retMap);
                        } else {
                            result->Error(std::to_string(errorInfo.code), errorInfo.message);
                        }
                    });
}

void ZIMPluginMethodHandler::callingInvite(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto invitees =
        ZIMPluginConverter::cnvFTArrayToStlVector(std::get<FTArray>(argument[FTValue("invitees")]));
    auto callID = std::get<std::string>(argument[FTValue("callID")]);
    auto configMap = std::get<FTMap>(argument[FTValue("config")]);

    ZIMCallingInviteConfig config;
    std::shared_ptr<ZIMPushConfig> pushConfigPtr = nullptr;
    std::shared_ptr<ZIMVoIPConfig> voIPConfigPtr = nullptr;
    if (std::holds_alternative<std::monostate>(configMap[FTValue("pushConfig")])) {
        config.pushConfig = nullptr;
    } else {
        pushConfigPtr = ZIMPluginConverter::cnvZIMPushConfigToObject(
            std::get<FTMap>(configMap[FTValue("pushConfig")]), voIPConfigPtr);
        config.pushConfig = pushConfigPtr.get();
    }

    zim->callingInvite(invitees, callID, config,
                       [=](const std::string &callID, const ZIMCallingInvitationSentInfo &info,
                           const ZIMError &errorInfo) {
                           if (errorInfo.code == 0) {
                               FTMap retMap;
                               retMap[FTValue("callID")] = FTValue(callID);
                               retMap[FTValue("info")] =
                                   ZIMPluginConverter::cnvZIMCallingInvitationSentInfoToMap(info);

                               result->Success(retMap);
                           } else {
                               result->Error(std::to_string(errorInfo.code), errorInfo.message);
                           }
                       });
}

void ZIMPluginMethodHandler::callQuit(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto callID = std::get<std::string>(argument[FTValue("callID")]);
    auto configMap = std::get<FTMap>(argument[FTValue("config")]);

    ZIMCallQuitConfig config;
    config.extendedData = std::get<std::string>(configMap[FTValue("extendedData")]);
    std::shared_ptr<ZIMPushConfig> pushConfigPtr = nullptr;
    std::shared_ptr<ZIMVoIPConfig> voIPConfigPtr = nullptr;
    if (std::holds_alternative<std::monostate>(configMap[FTValue("pushConfig")])) {
        config.pushConfig = nullptr;
    } else {
        pushConfigPtr = ZIMPluginConverter::cnvZIMPushConfigToObject(
            std::get<FTMap>(configMap[FTValue("pushConfig")]), voIPConfigPtr);
        config.pushConfig = pushConfigPtr.get();
    }

    zim->callQuit(
        callID, config,
        [=](const std::string &callID, const ZIMCallQuitSentInfo &info, const ZIMError &errorInfo) {
            if (errorInfo.code == 0) {
                FTMap retMap;
                retMap[FTValue("callID")] = FTValue(callID);
                retMap[FTValue("info")] = ZIMPluginConverter::cnvZIMCallQuitSentInfoToMap(info);
                result->Success(retMap);
            } else {
                result->Error(std::to_string(errorInfo.code), errorInfo.message);
            }
        });
}

void ZIMPluginMethodHandler::callEnd(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto callID = std::get<std::string>(argument[FTValue("callID")]);
    auto configMap = std::get<FTMap>(argument[FTValue("config")]);

    ZIMCallEndConfig config;
    config.extendedData = std::get<std::string>(configMap[FTValue("extendedData")]);
    std::shared_ptr<ZIMPushConfig> pushConfigPtr = nullptr;
    std::shared_ptr<ZIMVoIPConfig> voIPConfigPtr = nullptr;
    if (std::holds_alternative<std::monostate>(configMap[FTValue("pushConfig")])) {
        config.pushConfig = nullptr;
    } else {
        pushConfigPtr = ZIMPluginConverter::cnvZIMPushConfigToObject(
            std::get<FTMap>(configMap[FTValue("pushConfig")]), voIPConfigPtr);
        config.pushConfig = pushConfigPtr.get();
    }

    zim->callEnd(callID, config,
                 [=](const std::string &callID, const ZIMCallEndedSentInfo &info,
                     const ZIMError &errorInfo) {
                     if (errorInfo.code == 0) {
                         FTMap retMap;
                         retMap[FTValue("info")] =
                             ZIMPluginConverter::cnvZIMCallEndSentInfoToMap(info);
                         retMap[FTValue("callID")] = FTValue(callID);
                         result->Success(retMap);
                     } else {
                         result->Error(std::to_string(errorInfo.code), errorInfo.message);
                     }
                 });
}

void ZIMPluginMethodHandler::callCancel(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto invitees =
        ZIMPluginConverter::cnvFTArrayToStlVector(std::get<FTArray>(argument[FTValue("invitees")]));
    auto callID = std::get<std::string>(argument[FTValue("callID")]);
    auto configMap = std::get<FTMap>(argument[FTValue("config")]);

    ZIMCallCancelConfig config;
    config.extendedData = std::get<std::string>(configMap[FTValue("extendedData")]);
    std::shared_ptr<ZIMPushConfig> pushConfigPtr = nullptr;
    std::shared_ptr<ZIMVoIPConfig> voIPConfigPtr = nullptr;
    if (std::holds_alternative<std::monostate>(configMap[FTValue("pushConfig")])) {
        config.pushConfig = nullptr;
    } else {
        pushConfigPtr = ZIMPluginConverter::cnvZIMPushConfigToObject(
            std::get<FTMap>(configMap[FTValue("pushConfig")]), voIPConfigPtr);
        config.pushConfig = pushConfigPtr.get();
    }

    zim->callCancel(invitees, callID, config,
                    [=](const std::string &callID, const std::vector<std::string> &errorInvitees,
                        const ZIMError &errorInfo) {
                        if (errorInfo.code == 0) {
                            FTMap retMap;
                            retMap[FTValue("callID")] = FTValue(callID);
                            retMap[FTValue("errorInvitees")] =
                                ZIMPluginConverter::cnvStlVectorToFTArray(errorInvitees);

                            result->Success(retMap);
                        } else {
                            result->Error(std::to_string(errorInfo.code), errorInfo.message);
                        }
                    });
}

void ZIMPluginMethodHandler::callAccept(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto callID = std::get<std::string>(argument[FTValue("callID")]);
    auto configMap = std::get<FTMap>(argument[FTValue("config")]);

    ZIMCallAcceptConfig config;
    config.extendedData = std::get<std::string>(configMap[FTValue("extendedData")]);

    zim->callAccept(callID, config, [=](const std::string &callID, const ZIMError &errorInfo) {
        if (errorInfo.code == 0) {
            FTMap retMap;
            retMap[FTValue("callID")] = FTValue(callID);

            result->Success(retMap);
        } else {
            result->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}

void ZIMPluginMethodHandler::callReject(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto callID = std::get<std::string>(argument[FTValue("callID")]);
    auto configMap = std::get<FTMap>(argument[FTValue("config")]);

    ZIMCallRejectConfig config;
    config.extendedData = std::get<std::string>(configMap[FTValue("extendedData")]);

    zim->callReject(callID, config, [=](const std::string &callID, const ZIMError &errorInfo) {
        if (errorInfo.code == 0) {
            FTMap retMap;
            retMap[FTValue("callID")] = FTValue(callID);

            result->Success(retMap);
        } else {
            result->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}

void ZIMPluginMethodHandler::callJoin(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto callID = std::get<std::string>(argument[FTValue("callID")]);
    auto configMap = std::get<FTMap>(argument[FTValue("config")]);

    ZIMCallJoinConfig config;
    config.extendedData = std::get<std::string>(configMap[FTValue("extendedData")]);

    zim->callJoin(
        callID, config,
        [=](const std::string &callID, const ZIMCallJoinSentInfo &info, const ZIMError &errorInfo) {
            if (errorInfo.code == 0) {
                FTMap retMap;
                retMap[FTValue("info")] = ZIMPluginConverter::cnvZIMCallJoinSentInfoToMap(info);
                retMap[FTValue("callID")] = FTValue(callID);
                result->Success(retMap);
            } else {
                result->Error(std::to_string(errorInfo.code), errorInfo.message);
            }
        });
}

void ZIMPluginMethodHandler::queryCallList(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto configMap = std::get<FTMap>(argument[FTValue("config")]);

    ZIMCallInvitationQueryConfig config;
    config.count = std::get<int32_t>(configMap[FTValue("count")]);

    if (std::holds_alternative<int32_t>(configMap[FTValue("nextFlag")])) {
        config.nextFlag = (unsigned int)std::get<int32_t>(configMap[FTValue("nextFlag")]);
    } else {
        config.nextFlag = (long long)std::get<int64_t>(configMap[FTValue("nextFlag")]);
    }

    zim->queryCallInvitationList(config, [=](const std::vector<ZIMCallInfo> &callList,
                                             long long nextFlag, const ZIMError &errorInfo) {
        if (errorInfo.code == 0) {
            FTMap retMap;

            FTArray callInfoArray;
            for (auto &callInfo : callList) {
                auto callInfoMap = ZIMPluginConverter::cnvZIMCallInfoToMap(callInfo);
                callInfoArray.emplace_back(callInfoMap);
            }

            retMap[FTValue("callList")] = callInfoArray;
            retMap[FTValue("nextFlag")] = FTValue((int64_t)nextFlag);

            result->Success(retMap);
        } else {
            result->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}
void ZIMPluginMethodHandler::addMessageReaction(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto messagePtr =
        ZIMPluginConverter::cnvZIMMessageToObject(std::get<FTMap>(argument[FTValue("message")]));
    auto reactionType = std::get<std::string>(argument[FTValue("reactionType")]);

    zim->addMessageReaction(reactionType, messagePtr,
                            [=](const ZIMMessageReaction &reaction, const ZIMError &errorInfo) {
                                if (errorInfo.code == 0) {
                                    FTMap retMap;
                                    retMap[FTValue("reaction")] =
                                        ZIMPluginConverter::cnvZIMMessageReactionToMap(reaction);

                                    result->Success(retMap);
                                } else {
                                    result->Error(std::to_string(errorInfo.code),
                                                  errorInfo.message);
                                }
                            });
}
void ZIMPluginMethodHandler::deleteMessageReaction(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto messagePtr =
        ZIMPluginConverter::cnvZIMMessageToObject(std::get<FTMap>(argument[FTValue("message")]));
    auto reactionType = std::get<std::string>(argument[FTValue("reactionType")]);

    zim->deleteMessageReaction(reactionType, messagePtr,
                               [=](const ZIMMessageReaction &reaction, const ZIMError &errorInfo) {
                                   if (errorInfo.code == 0) {
                                       FTMap retMap;
                                       retMap[FTValue("reaction")] =
                                           ZIMPluginConverter::cnvZIMMessageReactionToMap(reaction);
                                       ;
                                       result->Success(retMap);
                                   } else {
                                       result->Error(std::to_string(errorInfo.code),
                                                     errorInfo.message);
                                   }
                               });
}
void ZIMPluginMethodHandler::queryMessageReactionUserList(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto messagePtr =
        ZIMPluginConverter::cnvZIMMessageToObject(std::get<FTMap>(argument[FTValue("message")]));
    auto config = ZIMPluginConverter::cnvZIMMessageReactionUserQueryConfigMapToObject(
        std::get<FTMap>(argument[FTValue("config")]));

    zim->queryMessageReactionUserList(
        messagePtr, config,
        [=](const std::shared_ptr<ZIMMessage> &message,
            const std::vector<ZIMMessageReactionUserInfo> &userList,
            const std::string &reactionType, const long long nextFlag,
            const unsigned int totalCount, const ZIMError &errorInfo) {
            if (errorInfo.code == 0) {
                FTMap retMap;
                auto messageMap = ZIMPluginConverter::cnvZIMMessageObjectToMap(message.get());
                retMap[FTValue("message")] = messageMap;
                auto userListMap =
                    ZIMPluginConverter::cnvZIMMessageReactionUserInfoListToArray(userList);
                retMap[FTValue("userList")] = userListMap;
                retMap[FTValue("reactionType")] = FTValue(reactionType);
                retMap[FTValue("nextFlag")] = FTValue((int64_t)nextFlag);
                retMap[FTValue("totalCount")] = FTValue((int32_t)totalCount);

                result->Success(retMap);
            } else {
                result->Error(std::to_string(errorInfo.code), errorInfo.message);
            }
        });
}

void ZIMPluginMethodHandler::addUsersToBlacklist(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto userIDs = std::get<FTArray>(argument[FTValue("userIDs")]);
    std::vector<std::string> userIDsVec;
    for (auto &userIDValue : userIDs) {
        auto userID = std::get<std::string>(userIDValue);
        userIDsVec.emplace_back(userID);
    }

    zim->addUsersToBlacklist(userIDsVec, [=](const std::vector<ZIMErrorUserInfo> &errorUserList,
                                             const ZIMError &errorInfo) {
        if (errorInfo.code == 0) {
            FTMap retMap;
            retMap[FTValue("errorUserList")] =
                ZIMPluginConverter::cnvZIMErrorUserListToArray(errorUserList);
            result->Success(retMap);
        } else {
            result->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}
void ZIMPluginMethodHandler::removeUsersFromBlacklist(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto userIDs = std::get<FTArray>(argument[FTValue("userIDs")]);
    std::vector<std::string> userIDsVec;
    for (auto &userIDValue : userIDs) {
        auto userID = std::get<std::string>(userIDValue);
        userIDsVec.emplace_back(userID);
    }

    zim->removeUsersFromBlacklist(
        userIDsVec,
        [=](const std::vector<ZIMErrorUserInfo> &errorUserList, const ZIMError &errorInfo) {
            if (errorInfo.code == 0) {
                FTMap retMap;
                retMap[FTValue("errorUserList")] =
                    ZIMPluginConverter::cnvZIMErrorUserListToArray(errorUserList);
                result->Success(retMap);
            } else {
                result->Error(std::to_string(errorInfo.code), errorInfo.message);
            }
        });
}
void ZIMPluginMethodHandler::queryBlackList(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    ZIMBlacklistQueryConfig config = ZIMPluginConverter::cnvZIMBlacklistQueryConfigToObject(
        std::get<FTMap>(argument[FTValue("config")]));
    zim->queryBlacklist(config, [=](const std::vector<ZIMUserInfo> &blacklist, long long nextFlag,
                                    const ZIMError &errorInfo) {
        if (errorInfo.code == 0) {
            FTMap retMap;
            retMap[FTValue("nextFlag")] = FTValue((int64_t)nextFlag);
            retMap[FTValue("blacklist")] = ZIMPluginConverter::cnvZIMUserListToArray(blacklist);
            result->Success(retMap);
        } else {
            result->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}
void ZIMPluginMethodHandler::checkUserIsInBlackList(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto userID = std::get<std::string>(argument[FTValue("userID")]);

    zim->checkUserIsInBlacklist(userID, [=](bool isUserInBlacklist, const ZIMError &errorInfo) {
        if (errorInfo.code == 0) {
            FTMap retMap;
            retMap[FTValue("isUserInBlacklist")] = FTValue(isUserInBlacklist);
            result->Success(retMap);
        } else {
            result->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}

void ZIMPluginMethodHandler::addFriend(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto userID = std::get<std::string>(argument[FTValue("userID")]);
    ZIMFriendAddConfig config = ZIMPluginConverter::cnvZIMFriendAddConfigToObject(
        std::get<FTMap>(argument[FTValue("config")]));

    zim->addFriend(userID, config, [=](const ZIMFriendInfo &friendInfo, const ZIMError &errorInfo) {
        if (errorInfo.code == 0) {
            FTMap retMap;
            retMap[FTValue("friendInfo")] = ZIMPluginConverter::cnvZIMFriendInfoToMap(friendInfo);
            result->Success(retMap);
        } else {
            result->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}

void ZIMPluginMethodHandler::sendFriendApplication(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto applyUserID = std::get<std::string>(argument[FTValue("userID")]);
    ZIMFriendApplicationSendConfig config =
        ZIMPluginConverter::cnvZIMFriendApplicationSendConfigToObject(
            std::get<FTMap>(argument[FTValue("config")]));

    FTMap configMap = std::get<FTMap>(argument[FTValue("config")]);
    std::shared_ptr<ZIMPushConfig> pushConfigPtr = nullptr;
    std::shared_ptr<ZIMVoIPConfig> voIPConfigPtr = nullptr;
    if (std::holds_alternative<std::monostate>(configMap[FTValue("pushConfig")])) {
        config.pushConfig = nullptr;
    } else {
        pushConfigPtr = ZIMPluginConverter::cnvZIMPushConfigToObject(
            std::get<FTMap>(configMap[FTValue("pushConfig")]), voIPConfigPtr);
        config.pushConfig = pushConfigPtr.get();
    }

    zim->sendFriendApplication(
        applyUserID, config,
        [=](const ZIMFriendApplicationInfo &friendApplicationInfo, const ZIMError &errorInfo) {
            if (errorInfo.code == 0) {
                FTMap retMap;
                retMap[FTValue("applicationInfo")] =
                    ZIMPluginConverter::cnvZIMFriendApplicationInfoToMap(friendApplicationInfo);
                result->Success(retMap);
            } else {
                result->Error(std::to_string(errorInfo.code), errorInfo.message);
            }
        });
}

void ZIMPluginMethodHandler::deleteFriends(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto userIDs = std::get<FTArray>(argument[FTValue("userIDs")]);
    std::vector<std::string> userIDsVec;
    for (auto &userIDValue : userIDs) {
        auto userID = std::get<std::string>(userIDValue);
        userIDsVec.emplace_back(userID);
    }

    ZIMFriendDeleteConfig config = ZIMPluginConverter::cnvZIMFriendDeleteConfigToObject(
        std::get<FTMap>(argument[FTValue("config")]));

    zim->deleteFriends(
        userIDsVec, config,
        [=](const std::vector<ZIMErrorUserInfo> &errorUserList, const ZIMError &errorInfo) {
            if (errorInfo.code == 0) {
                FTMap retMap;
                FTArray errorUserInfoArray;
                for (auto &errorUserInfo : errorUserList) {
                    auto errorUserInfoMap =
                        ZIMPluginConverter::cnvZIMErrorUserInfoToMap(errorUserInfo);
                    errorUserInfoArray.emplace_back(errorUserInfoMap);
                }

                retMap[FTValue("errorUserList")] = errorUserInfoArray;
                result->Success(retMap);
            } else {
                result->Error(std::to_string(errorInfo.code), errorInfo.message);
            }
        });
}

void ZIMPluginMethodHandler::checkFriendsRelation(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto userIDs = std::get<FTArray>(argument[FTValue("userIDs")]);
    std::vector<std::string> userIDsVec;
    for (auto &userIDValue : userIDs) {
        auto userID = std::get<std::string>(userIDValue);
        userIDsVec.emplace_back(userID);
    }
    auto configMap = std::get<FTMap>(argument[FTValue("config")]);
    ZIMFriendRelationCheckConfig config;
    config.type = (ZIMFriendRelationCheckType)ZIMPluginConverter::cnvFTValueToInt32(
        configMap[FTValue("type")]);

    zim->checkFriendsRelation(
        userIDsVec, config,
        [=](const std::vector<ZIMFriendRelationInfo> &friendRelationInfoList,
            const std::vector<ZIMErrorUserInfo> &errorUserList, const ZIMError &errorInfo) {
            if (errorInfo.code == 0) {
                FTArray friendRelationInfoArray;
                for (auto &info : friendRelationInfoList) {
                    auto infoMap = ZIMPluginConverter::cnvZIMFriendRelationInfoToMap(info);
                    friendRelationInfoArray.emplace_back(infoMap);
                }

                FTArray errorUserInfoArray;
                for (auto &errorUserInfo : errorUserList) {
                    auto errorUserInfoMap =
                        ZIMPluginConverter::cnvZIMErrorUserInfoToMap(errorUserInfo);
                    errorUserInfoArray.emplace_back(errorUserInfoMap);
                }

                FTMap retMap;
                retMap[FTValue("relationInfos")] = friendRelationInfoArray;
                retMap[FTValue("errorUserList")] = errorUserInfoArray;

                result->Success(retMap);
            } else {
                result->Error(std::to_string(errorInfo.code), errorInfo.message);
            }
        });
}

void ZIMPluginMethodHandler::updateFriendAlias(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto userID = std::get<std::string>(argument[FTValue("userID")]);
    auto friendAlias = std::get<std::string>(argument[FTValue("friendAlias")]);

    zim->updateFriendAlias(friendAlias, userID,
                           [=](const ZIMFriendInfo &friendInfo, const ZIMError &errorInfo) {
                               if (errorInfo.code == 0) {
                                   FTMap retMap;
                                   retMap[FTValue("friendInfo")] =
                                       ZIMPluginConverter::cnvZIMFriendInfoToMap(friendInfo);
                                   result->Success(retMap);
                               } else {
                                   result->Error(std::to_string(errorInfo.code), errorInfo.message);
                               }
                           });
}

void ZIMPluginMethodHandler::updateFriendAttributes(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto friendAttributes = ZIMPluginConverter::cnvFTMapToSTLMap(
        std::get<FTMap>(argument[FTValue("friendAttributes")]));
    auto userID = std::get<std::string>(argument[FTValue("userID")]);

    zim->updateFriendAttributes(
        friendAttributes, userID, [=](const ZIMFriendInfo &friendInfo, const ZIMError &errorInfo) {
            if (errorInfo.code == 0) {
                FTMap retMap;
                retMap[FTValue("friendInfo")] =
                    ZIMPluginConverter::cnvZIMFriendInfoToMap(friendInfo);
                result->Success(retMap);
            } else {
                result->Error(std::to_string(errorInfo.code), errorInfo.message);
            }
        });
}

void ZIMPluginMethodHandler::queryFriendsInfo(FArgument &argument, FResult result) {
    
    CheckZIMInstanceExistAndObtainZIM();
    auto userIDs = std::get<FTArray>(argument[FTValue("userIDs")]);
    std::vector<std::string> userIDsVec;
    for (auto &userIDValue : userIDs) {
        auto userID = std::get<std::string>(userIDValue);
        userIDsVec.emplace_back(userID);
    }

    zim->queryFriendsInfo(userIDsVec, [=](const std::vector<ZIMFriendInfo> &friendInfoList,
                                          const std::vector<ZIMErrorUserInfo> &errorUserList,
                                          const ZIMError &errorInfo) {
        if (errorInfo.code == 0) {
            FTArray friendInfoArray;
            for (auto &info : friendInfoList) {
                auto infoMap = ZIMPluginConverter::cnvZIMFriendInfoToMap(info);
                friendInfoArray.emplace_back(infoMap);
            }

            FTArray errorUserInfoArray;
            for (auto &errorUserInfo : errorUserList) {
                auto errorUserInfoMap = ZIMPluginConverter::cnvZIMErrorUserInfoToMap(errorUserInfo);
                errorUserInfoArray.emplace_back(errorUserInfoMap);
            }

            FTMap retMap;
            retMap[FTValue("friendInfos")] = friendInfoArray;
            retMap[FTValue("errorUserList")] = errorUserInfoArray;

            result->Success(retMap);
        } else {
            result->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}

void ZIMPluginMethodHandler::acceptFriendApplication(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto userID = std::get<std::string>(argument[FTValue("userID")]);
    auto configMap = std::get<FTMap>(argument[FTValue("config")]);
    ZIMFriendApplicationAcceptConfig config =
        ZIMPluginConverter::cnvZIMFriendApplicationAcceptConfigToObject(
            std::get<FTMap>(argument[FTValue("config")]));

    std::shared_ptr<ZIMPushConfig> pushConfigPtr = nullptr;
    std::shared_ptr<ZIMVoIPConfig> voIPConfigPtr = nullptr;
    if (std::holds_alternative<std::monostate>(configMap[FTValue("pushConfig")])) {
        config.pushConfig = nullptr;
    } else {
        pushConfigPtr = ZIMPluginConverter::cnvZIMPushConfigToObject(
            std::get<FTMap>(configMap[FTValue("pushConfig")]), voIPConfigPtr);
        config.pushConfig = pushConfigPtr.get();
    }

    zim->acceptFriendApplication(
        userID, config, [=](const ZIMFriendInfo &friendInfo, const ZIMError &errorInfo) {
            if (errorInfo.code == 0) {
                FTMap retMap;
                retMap[FTValue("friendInfo")] =
                    ZIMPluginConverter::cnvZIMFriendInfoToMap(friendInfo);
                result->Success(retMap);
            } else {
                result->Error(std::to_string(errorInfo.code), errorInfo.message);
            }
        });
}

void ZIMPluginMethodHandler::rejectFriendApplication(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto userID = std::get<std::string>(argument[FTValue("userID")]);
    auto configMap = std::get<FTMap>(argument[FTValue("config")]);
    ZIMFriendApplicationRejectConfig config =
        ZIMPluginConverter::cnvZIMFriendApplicationRejectConfigToObject(
            std::get<FTMap>(argument[FTValue("config")]));

    std::shared_ptr<ZIMPushConfig> pushConfigPtr = nullptr;
    std::shared_ptr<ZIMVoIPConfig> voIPConfigPtr = nullptr;
    if (std::holds_alternative<std::monostate>(configMap[FTValue("pushConfig")])) {
        config.pushConfig = nullptr;
    } else {
        pushConfigPtr = ZIMPluginConverter::cnvZIMPushConfigToObject(
            std::get<FTMap>(configMap[FTValue("pushConfig")]), voIPConfigPtr);
        config.pushConfig = pushConfigPtr.get();
    }

    zim->rejectFriendApplication(
        userID, config, [=](const ZIMUserInfo &userInfo, const ZIMError &errorInfo) {
            if (errorInfo.code == 0) {
                FTMap retMap;
                retMap[FTValue("userInfo")] =
                    ZIMPluginConverter::cnvZIMUserInfoObjectToMap(userInfo);
                result->Success(retMap);
            } else {
                result->Error(std::to_string(errorInfo.code), errorInfo.message);
            }
        });
}

void ZIMPluginMethodHandler::queryFriendList(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto configMap = std::get<FTMap>(argument[FTValue("config")]);
    ZIMFriendListQueryConfig config = ZIMPluginConverter::cnvZIMFriendListQueryConfigToObject(
        std::get<FTMap>(argument[FTValue("config")]));

    zim->queryFriendList(config, [=](const std::vector<ZIMFriendInfo> &friendInfoList,
                                     unsigned int nextFlag, const ZIMError &errorInfo) {
        if (errorInfo.code == 0) {
            FTArray friendInfoArray;
            for (auto &info : friendInfoList) {
                auto infoMap = ZIMPluginConverter::cnvZIMFriendInfoToMap(info);
                friendInfoArray.emplace_back(infoMap);
            }

            FTMap retMap;
            retMap[FTValue("friendList")] = friendInfoArray;
            retMap[FTValue("nextFlag")] = FTValue((int32_t)nextFlag);
            result->Success(retMap);
        } else {
            result->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}

void ZIMPluginMethodHandler::queryFriendApplicationList(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto configMap = std::get<FTMap>(argument[FTValue("config")]);
    ZIMFriendApplicationListQueryConfig config =
        ZIMPluginConverter::cnvZIMFriendApplicationListQueryConfigToObject(
            std::get<FTMap>(argument[FTValue("config")]));

    zim->queryFriendApplicationList(
        config, [=](const std::vector<ZIMFriendApplicationInfo> &applicationList,
                    unsigned int nextFlag, const ZIMError &errorInfo) {
            if (errorInfo.code == 0) {
                FTArray friendApplicationInfoArray;
                for (auto &info : applicationList) {
                    auto infoMap = ZIMPluginConverter::cnvZIMFriendApplicationInfoToMap(info);
                    friendApplicationInfoArray.emplace_back(infoMap);
                }
                FTMap retMap;
                retMap[FTValue("applicationList")] = friendApplicationInfoArray;
                retMap[FTValue("nextFlag")] = FTValue((int32_t)nextFlag);
                result->Success(retMap);
            } else {
                result->Error(std::to_string(errorInfo.code), errorInfo.message);
            }
        });
}

void ZIMPluginMethodHandler::searchLocalFriends(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto configMap = std::get<FTMap>(argument[FTValue("config")]);
    ZIMFriendSearchConfig config = ZIMPluginConverter::cnvZIMFriendSearchConfigToObject(
        std::get<FTMap>(argument[FTValue("config")]));

    zim->searchLocalFriends(config, [=](const std::vector<ZIMFriendInfo> &friendInfos,
                                        unsigned int nextFlag, const ZIMError &errorInfo) {
        if (errorInfo.code == 0) {
            FTArray friendInfoArray;
            for (auto &info : friendInfos) {
                auto infoMap = ZIMPluginConverter::cnvZIMFriendInfoToMap(info);
                friendInfoArray.emplace_back(infoMap);
            }

            FTMap retMap;
            retMap[FTValue("friendInfos")] = friendInfoArray;
            retMap[FTValue("nextFlag")] = FTValue((int32_t)nextFlag);
            result->Success(retMap);
        } else {
            result->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}

void ZIMPluginMethodHandler::queryCombineMessageDetail(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    std::shared_ptr<ZIMMessage> message =
        ZIMPluginConverter::cnvZIMMessageToObject(std::get<FTMap>(argument[FTValue("message")]));
    auto combineMessagePtr = std::static_pointer_cast<ZIMCombineMessage>(message);

    zim->queryCombineMessageDetail(
        combineMessagePtr,
        [=](const std::shared_ptr<ZIMCombineMessage> &message, ZIMError &errorInfo) {
            FTMap retMap;
            auto messageMap = ZIMPluginConverter::cnvZIMMessageObjectToMap(message.get());
            retMap[FTValue("message")] = messageMap;
            if (errorInfo.code == 0) {
                result->Success(retMap);
            } else {
                result->Error(std::to_string(errorInfo.code), errorInfo.message, retMap);
            }
        });
}

void ZIMPluginMethodHandler::clearLocalFileCache(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto configMap = std::get<FTMap>(argument[FTValue("config")]);
    ZIMFileCacheClearConfig config = ZIMPluginConverter::cnvZIMFileCacheClearConfigToObject(
        std::get<FTMap>(argument[FTValue("config")]));

    zim->clearLocalFileCache(config, [=](const ZIMError &errorInfo) {
        if (errorInfo.code == 0) {
            result->Success();
        } else {
            result->Error(std::to_string(errorInfo.code), errorInfo.message);
        }
    });
}

void ZIMPluginMethodHandler::queryLocalFileCache(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto configMap = std::get<FTMap>(argument[FTValue("config")]);
    ZIMFileCacheQueryConfig config = ZIMPluginConverter::cnvZIMFileCacheQueryConfigToObject(
        std::get<FTMap>(argument[FTValue("config")]));

    zim->queryLocalFileCache(
        config, [=](const ZIMFileCacheInfo &cacheInfo, const ZIMError &errorInfo) {
            if (errorInfo.code == 0) {
                FTMap retMap;
                retMap[FTValue("fileCacheInfo")] =
                    ZIMPluginConverter::cnvZIMFileCacheInfoToMap(cacheInfo);
                result->Success(retMap);
            } else {
                result->Error(std::to_string(errorInfo.code), errorInfo.message);
            }
        });
}

void ZIMPluginMethodHandler::importLocalMessages(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto folderPath = std::get<std::string>(argument[FTValue("folderPath")]);
    ZIMMessageImportConfig config;
    auto progressID = ZIMPluginConverter::cnvFTValueToInt32(argument[FTValue("progressID")]);

    zim->importLocalMessages(
        folderPath, config,
        [=](unsigned long long importedMessageCount, unsigned long long totalMessageCount) {
            FTMap progressRetMap;
            progressRetMap[FTValue("handle")] = FTValue(handle);
            progressRetMap[FTValue("method")] = FTValue("messageImportingProgress");
            progressRetMap[FTValue("progressID")] = FTValue(progressID);
            progressRetMap[FTValue("importedMessageCount")] =
                FTValue((int64_t)importedMessageCount);
            progressRetMap[FTValue("totalMessageCount")] = FTValue((int64_t)totalMessageCount);
            ZIMPluginEventHandler::getInstance()->sendEvent(progressRetMap);
        },
        [=](const ZIMError &errorInfo) {
            if (errorInfo.code == 0) {
                result->Success();
            } else {
                result->Error(std::to_string(errorInfo.code), errorInfo.message);
            }
        });
}

void ZIMPluginMethodHandler::exportLocalMessages(FArgument &argument, FResult result) {

    CheckZIMInstanceExistAndObtainZIM();

    auto folderPath = std::get<std::string>(argument[FTValue("folderPath")]);
    ZIMMessageExportConfig config;
    auto progressID = ZIMPluginConverter::cnvFTValueToInt32(argument[FTValue("progressID")]);

    zim->exportLocalMessages(
        folderPath, config,
        [=](unsigned long long exportedMessageCount, unsigned long long totalMessageCount) {
            FTMap progressRetMap;
            progressRetMap[FTValue("handle")] = FTValue(handle);
            progressRetMap[FTValue("method")] = FTValue("messageExportingProgress");
            progressRetMap[FTValue("progressID")] = FTValue(progressID);
            progressRetMap[FTValue("exportedMessageCount")] =
                FTValue((int64_t)exportedMessageCount);
            progressRetMap[FTValue("totalMessageCount")] = FTValue((int64_t)totalMessageCount);
            ZIMPluginEventHandler::getInstance()->sendEvent(progressRetMap);
        },
        [=](const ZIMError &errorInfo) {
            if (errorInfo.code == 0) {
                result->Success();
            } else {
                result->Error(std::to_string(errorInfo.code), errorInfo.message);
            }
        });
}
