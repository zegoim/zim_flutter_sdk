package com.zego.im.zim.internal;

import java.util.HashMap;

public class ZIMPluginCommonTools {
    static public int safeGetIntValue(Object intObject){
        if(intObject instanceof Integer){
            return ((Integer) intObject).intValue();
        }
        if(intObject != null){
            return (int) intObject;
        }
        else{
            return 0;
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

    static public Boolean safeGetBoolValue(Object booleanObject){
        if(booleanObject != null){
            return (boolean)booleanObject;
        }
        else {
            return false;
        }
    }

    static public HashMap<String,Object> safeGetHashMap(Object mapObject){
        if(mapObject == null ){
            return null;
        }

        return (HashMap<String,Object>)mapObject;
    }


}
