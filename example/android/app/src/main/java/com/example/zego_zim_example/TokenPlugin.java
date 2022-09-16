package com.example.zego_zim_example;

import androidx.annotation.NonNull;

import java.util.HashMap;
import java.util.Objects;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;

import im.zego.zim_flutter.internal.ZIMPluginCommonTools;
import com.example.zego_zim_example.src.im.zego.serverassistant.utils.TokenServerAssistant;

import org.json.JSONException;

public class TokenPlugin implements FlutterPlugin, MethodCallHandler {


    private MethodChannel methodChannel;

    private FlutterPluginBinding binding = null;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        methodChannel = new MethodChannel(binding.getBinaryMessenger(),"token_plugin");
        methodChannel.setMethodCallHandler(this);

        this.binding = binding;
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        methodChannel.setMethodCallHandler(null);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {

        if(call.method.equals("makeToken")){
            long appID = safeGetLongValue(Objects.requireNonNull(call.argument("appID")));
            String userID = call.argument("userID");
            String secret = call.argument("secret");
            TokenServerAssistant.TokenInfo tokenInfo = null;
            if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.LOLLIPOP) {
                try {
                    tokenInfo = TokenServerAssistant.generateToken04(appID,userID,secret,60*60*24,"");
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }
            HashMap<String,String> resultMap = new HashMap<String,String>();
            resultMap.put("token",tokenInfo.data.toString());
            result.success(resultMap);
        }
    }

    static public long safeGetLongValue(Object longObject){
        if( longObject instanceof Integer){
            return ((Integer) longObject).longValue();
        }
        if( longObject   != null){
            return (Long)longObject;
        }
        else{
            return 0;
        }
    }
}
