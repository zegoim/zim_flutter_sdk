#pragma once

#include <memory>
#include <flutter/event_channel.h>

#include <ZIM.h>
using namespace zim;

#define FTValue(varName) flutter::EncodableValue(varName)
#define FTMap flutter::EncodableMap
#define FTArray flutter::EncodableList

class ZIMPluginEventHandler 
    /*: public EXPRESS::IZegoEventHandler
    , public EXPRESS::IZegoAudioEffectPlayerEventHandler
    , public EXPRESS::IZegoMediaPlayerEventHandler
    , public EXPRESS::IZegoAudioDataHandler*/
{
public:
    ~ZIMPluginEventHandler() {}
    ZIMPluginEventHandler() {}

    static std::shared_ptr<ZIMPluginEventHandler>& getInstance()
    {
        if (!m_instance) {
            m_instance = std::shared_ptr<ZIMPluginEventHandler>(new ZIMPluginEventHandler);
        }

        return m_instance;
    }

    void setEventSink(std::unique_ptr<flutter::EventSink<flutter::EncodableValue>> &&eventSink);
    void clearEventSink();

private:
    static std::shared_ptr<ZIMPluginEventHandler> m_instance;

private:
    std::unique_ptr<flutter::EventSink<flutter::EncodableValue>> eventSink_;
};