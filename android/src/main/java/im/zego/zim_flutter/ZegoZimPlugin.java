package im.zego.zim_flutter;

import androidx.annotation.NonNull;

import im.zego.zim_flutter.internal.ZIMPluginEventHandler;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.HashMap;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** ZegoZimPlugin */
public class ZegoZimPlugin implements FlutterPlugin, MethodCallHandler,EventChannel.StreamHandler{
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel methodChannel;

  private final Class<?> manager;

  private ZIMPluginEventHandler zimPluginEventHandler = null;

  private final HashMap<String, Method> methodHashMap = new HashMap<>();

  private FlutterPluginBinding binding = null;

  public ZegoZimPlugin() {
    try{
      this.manager = Class.forName("im.zego.zim_flutter.internal.ZIMPluginMethodHandler");
    }catch (ClassNotFoundException e){
      throw new RuntimeException(e);
    }
  }

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    methodChannel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "zego_zim_plugin");
    methodChannel.setMethodCallHandler(this);

    EventChannel eventChannel = new EventChannel(flutterPluginBinding.getBinaryMessenger(), "zim_event_handler");
    eventChannel.setStreamHandler(this);

    this.binding = flutterPluginBinding;
    this.zimPluginEventHandler = new ZIMPluginEventHandler();
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    try{
      Method method = methodHashMap.get(call.method);
      if(method == null){
        if(call.method.equals("create")){
          method = this.manager.getMethod(call.method,MethodCall.class,Result.class,FlutterPluginBinding.class,ZIMPluginEventHandler.class);
        }else {
          method = this.manager.getMethod(call.method, MethodCall.class, Result.class);
        }
        methodHashMap.put(call.method, method);
      }
      if(call.method.equals(("create"))){
        method.invoke(null,call,result,this.binding,this.zimPluginEventHandler);
      }
      else {
        method.invoke(null,call, result);
      }
    }
    catch (NoSuchMethodException e){
      result.notImplemented();
    }
    catch (InvocationTargetException e){
      result.notImplemented();
    }
    catch (IllegalAccessException e){
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    methodChannel.setMethodCallHandler(null);
  }


  @Override
  public void onListen(Object arguments, EventChannel.EventSink events) {
    this.zimPluginEventHandler.setSink(events);
  }

  @Override
  public void onCancel(Object arguments) {
    this.zimPluginEventHandler.setSink(null);
  }
}
