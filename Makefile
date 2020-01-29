SDKVERSION_armv6 = 4.3
SDKVERSION_armv7 = 4.3
SDKVERSION_armv7s = 6.0
SDKVERSION_arm64 = 9.0
SDKVERSION_arm64e = 12.2
TARGET_IPHONEOS_DEPLOYMENT_VERSION = 7.0
TARGET_IPHONEOS_DEPLOYMENT_VERSION_armv6 = 2.0
TARGET_IPHONEOS_DEPLOYMENT_VERSION_armv7 = 3.0
TARGET_IPHONEOS_DEPLOYMENT_VERSION_armv7s = 6.0
TARGET_IPHONEOS_DEPLOYMENT_VERSION_arm64 = 7.0
TARGET_IPHONEOS_DEPLOYMENT_VERSION_arm64e = 12.0
IPHONE_ARCHS = armv6 armv7 arm64 arm64e
libprefs_IPHONE_ARCHS = armv6 armv7 armv7s arm64 arm64e

include framework/makefiles/common.mk

LIBRARY_NAME = libprefs
libprefs_FILES = prefs.xm
libprefs_FRAMEWORKS = UIKit
libprefs_LIBRARIES = substrate
libprefs_PRIVATE_FRAMEWORKS = Preferences
libprefs_CFLAGS = -I.
libprefs_COMPATIBILITY_VERSION = 2.2.0
libprefs_LIBRARY_VERSION = $(shell echo "$(THEOS_PACKAGE_BASE_VERSION)" | cut -d'~' -f1)
libprefs_LDFLAGS  = -compatibility_version $($(THEOS_CURRENT_INSTANCE)_COMPATIBILITY_VERSION)
libprefs_LDFLAGS += -current_version $($(THEOS_CURRENT_INSTANCE)_LIBRARY_VERSION)

TWEAK_NAME = PreferenceLoader
PreferenceLoader_FILES = Tweak.xm
PreferenceLoader_FRAMEWORKS = UIKit
PreferenceLoader_PRIVATE_FRAMEWORKS = Preferences
PreferenceLoader_LIBRARIES = prefs
PreferenceLoader_CFLAGS = -I.
PreferenceLoader_LDFLAGS = -L$(THEOS_OBJ_DIR)

include $(THEOS_MAKE_PATH)/library.mk
include $(THEOS_MAKE_PATH)/tweak.mk

after-libprefs-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/usr/include/libprefs$(ECHO_END)
	$(ECHO_NOTHING)cp prefs.h $(THEOS_STAGING_DIR)/usr/include/libprefs/prefs.h$(ECHO_END)

after-stage::
	find $(THEOS_STAGING_DIR) -iname '*.plist' -exec plutil -convert binary1 {} \;
	#$(FAKEROOT) chown -R root:admin $(THEOS_STAGING_DIR)
	mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceBundles $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences
# 	sudo chown -R root:admin $(THEOS_STAGING_DIR)/Library $(THEOS_STAGING_DIR)/usr

after-install::
	install.exec "killall -9 Preferences"
