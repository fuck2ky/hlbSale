LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

#备份一下当前路径,因为当加载其他模块的Android.mk时可能会覆盖 LOCAL_PATH 这个变量,导致后续路径出错
HLB_DIR := $(LOCAL_PATH)



#SDK_TAG_CFLAGS 脚本自动添加代码时用来定位，不要删！！by hlb

LOCAL_MODULE := cocos2dlua_shared

LOCAL_MODULE_FILENAME := libcocos2dlua

LOCAL_SRC_FILES := \
../../../Classes/AppDelegate.cpp \
../../../Classes/network/tcp/SimpleSocket/SimpleSocket.cpp \
../../../Classes/network/tcp/NetManager.cpp \
../../../Classes/network/tcp/NetConnectionImpl.cpp \
../../../Classes/network/tcp/NetLua.cpp \
../../../Classes/network/http/HttpNet.cpp \
../../../Classes/forLua/forLua.cpp \
../../../Classes/encrypt/aes.c \
../../../Classes/encrypt/msgPack.cpp \
../../../Classes/cjson/fpconv.c \
../../../Classes/cjson/lua_cjson.c \
../../../Classes/cjson/strbuf.c \
../../../Classes/common/GameUtil.cpp \
hellolua/main.cpp



#SDK_TAG_SRC 脚本自动添加代码时用来定位，不要删！！by hlb

LOCAL_C_INCLUDES := $(LOCAL_PATH)/../../../Classes


# _COCOS_HEADER_ANDROID_BEGIN
# _COCOS_HEADER_ANDROID_END

LOCAL_STATIC_LIBRARIES := cocos2d_lua_static

LOCAL_STATIC_LIBRARIES += cocos_curl_static

# _COCOS_LIB_ANDROID_BEGIN

#引入AnySDK全局静态库, 必须放在 include $(BUILD_SHARED_LIBRARY) 之前, by hlb


#SDK_TAG_LIB 脚本自动添加代码时用来定位，不要删！！by hlb

# _COCOS_LIB_ANDROID_END



include $(BUILD_SHARED_LIBRARY)


$(call import-module,scripting/lua-bindings/proj.android)

$(call import-module,./curl/prebuilt/Android)


# _COCOS_LIB_IMPORT_ANDROID_BEGIN


#SDK_TAG_IMPORET_MODULE 脚本自动添加代码时用来定位，不要删！！by hlb

# _COCOS_LIB_IMPORT_ANDROID_END








