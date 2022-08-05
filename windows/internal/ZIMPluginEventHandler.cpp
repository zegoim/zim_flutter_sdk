#include "ZIMPluginEventHandler.h"
#include <flutter/encodable_value.h>
#include <memory>

std::shared_ptr<ZIMPluginEventHandler> ZIMPluginEventHandler::m_instance = nullptr;

void ZIMPluginEventHandler::setEventSink(std::unique_ptr<flutter::EventSink<flutter::EncodableValue>>&& eventSink)
{
	eventSink_ = std::move(eventSink);
}

void ZIMPluginEventHandler::clearEventSink()
{
	eventSink_.reset();
}
