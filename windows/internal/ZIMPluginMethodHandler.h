#pragma once

#include <flutter/method_channel.h>
#include <flutter/encodable_value.h>

#include <ZIM.h>
using namespace zim;

class ZIMPluginMethodHandler 
{
public:
    ~ZIMPluginMethodHandler(){}

    static ZIMPluginMethodHandler & getInstance()
    {
        static ZIMPluginMethodHandler m_instance;
        return m_instance;
    }

public:
    void getVersion(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    void create(flutter::EncodableMap& argument,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

private:
    ZIMPluginMethodHandler() = default;
};