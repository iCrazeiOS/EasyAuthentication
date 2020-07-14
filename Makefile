ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = EasyAuthentication

EasyAuthentication_FILES = Tweak.xm
EasyAuthentication_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
