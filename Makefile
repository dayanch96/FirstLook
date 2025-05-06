ifeq ($(ROOTLESS),1)
THEOS_DEVICE_IP = 192.168.1.8
THEOS_DEVICE_PORT = 22
THEOS_PACKAGE_SCHEME = rootless
else ifeq ($(ROOTHIDE),1)
THEOS_PACKAGE_SCHEME = roothide
else
THEOS_DEVICE_IP = 192.168.1.9
THEOS_DEVICE_PORT = 22
endif

DEBUG = 0
FINALPACKAGE = 1
TARGET := iphone:clang:16.5:12.0
INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = FirstLook
$(TWEAK_NAME)_FILES = Tweak.x Models/FirstLookManager.m
$(TWEAK_NAME)_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
