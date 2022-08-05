#include "ZIMPluginMethodHandler.h"
#include "ZIMPluginEventHandler.h"

#include <variant>
#include <functional>
#include <flutter/encodable_value.h>

void ZIMPluginMethodHandler::getVersion(flutter::EncodableMap& argument,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result)
{
    result->Success(ZIM::getVersion());
}

void ZIMPluginMethodHandler::create(flutter::EncodableMap& argument,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result)
{
    result->Success();
    // TODO: need to write getValue utils
    /*unsigned int appID = 0;
    if(std::holds_alternative<int32_t>(argument[FTValue("appID")])) {
        appID = (unsigned int)std::get<int32_t>(argument[FTValue("appID")]);
    } else {
        appID = (unsigned int)std::get<int64_t>(argument[FTValue("appID")]);
    }
    std::string appSign = std::get<std::string>(argument[FTValue("appSign")]);
    bool isTestEnv = std::get<bool>(argument[FTValue("isTestEnv")]);
    int scenario = std::get<int32_t>(argument[FTValue("scenario")]);

    auto engine = EXPRESS::ZegoExpressSDK::createEngine(appID, appSign, isTestEnv, (EXPRESS::ZegoScenario)scenario, ZegoExpressEngineEventHandler::getInstance());
    engine->setAudioDataHandler(ZegoExpressEngineEventHandler::getInstance());

    result->Success();*/
}
        

