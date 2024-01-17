package im.zego.zim_flutter.internal;

import java.lang.reflect.Method;
public class LogWriter {
    public static void writeLog(String log){
        try {
            Class<?>clazz = Class.forName("im.zego.zim.internal.util.ZIMLogUtil");
            Method method = clazz.getDeclaredMethod("writeCustomLog",String.class,String.class);
            method.setAccessible(true);
            method.invoke(clazz,log,"Auto Test");
            method.setAccessible(false);
        }
        catch (Exception e){
            e.printStackTrace();
        }

    }
}
