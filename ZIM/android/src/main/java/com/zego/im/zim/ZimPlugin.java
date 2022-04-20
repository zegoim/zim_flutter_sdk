package com.zego.im.zim;

import androidx.annotation.NonNull;

import java.lang.reflect.Method;
import java.util.HashMap;
import java.util.Map;
import java.util.TreeMap;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.HashMap;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import im.zego.zim.ZIM;

/** ZimPlugin */
public class ZimPlugin implements FlutterPlugin, MethodCallHandler, EventChannel.StreamHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel methodChannel;

  private EventChannel eventChannel;

  private EventChannel.EventSink sink;

  private final Class<?> manager;

  private final HashMap<String,Method> methodHashMap = new HashMap<>();

  private FlutterPluginBinding binding = null;

  public ZimPlugin(){
    try{
      this.manager = Class.forName("com.zego.im.zim.internal.ZIMMethodEventHandler");
    }catch (ClassNotFoundException e){
      throw new RuntimeException(e);
    }
  }


  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    methodChannel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "zim");
    methodChannel.setMethodCallHandler(this);
    this.binding = flutterPluginBinding;
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    try{
      Method method = methodHashMap.get(call.method);
      if(method == null){
        if(call.method.equals("create")){
          method = this.manager.getMethod(call.method,MethodCall.class,Result.class,FlutterPluginBinding.class);
        }else {
          method = this.manager.getMethod(call.method, MethodCall.class, Result.class);
        }
        methodHashMap.put(call.method, method);
      }
      if(call.method.equals(("create"))){
        method.invoke(null,call,result,this.binding);
      }
      else {
        method.invoke(null, call, result);
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
    this.sink = events;
  }

  @Override
  public void onCancel(Object arguments) {
    this.sink = null;
  }
}
