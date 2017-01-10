project (meadow)
cmake_minimum_required (VERSION 2.8)
cmake_policy (VERSION 2.6)

find_package(PkgConfig)
pkg_check_modules(DEPS REQUIRED liblightdm-gobject-1 gtk+-3.0 gdk-3.0 acis)
add_definitions(${DEPS_CFLAGS})
link_libraries(${DEPS_LIBRARIES})
link_directories(${DEPS_LIBRARY_DIRS})

# Some configuration
list (APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake/vala)
list (APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)
set (DATADIR "${CMAKE_INSTALL_PREFIX}/share")

# Package Dir
set (PKGDATADIR "${DATADIR}/meadow")
set (CMAKE_INSTALL_PREFIX /usr)
set (GETTEXT_PACKAGE "meadow")
set (RELEASE_NAME "summit")
set (VERSION "0.8")
set (VERSION_INFO "BETA")
set (CMAKE_C_FLAGS "-ggdb")

find_package(Vala REQUIRED)
include(ValaVersion)
ensure_vala_version("0.16.0" MINIMUM)
include(ValaPrecompile)

vala_precompile(VALA_C
    src/Main.vala

    src/Control/UserControl.vala

    src/OnScreen/LockWindow.vala
    src/OnScreen/UserBox.vala
    src/OnScreen/SessionMenu.vala
    src/OnScreen/OptionsSack.vala
    src/OnScreen/SessionOption.vala
    src/OnScreen/SelectedUserBox.vala
    src/OnScreen/PowerBox.vala
    src/OnScreen/PowerOption.vala

PACKAGES
    liblightdm-gobject-1
    gtk+-3.0
    gee-0.8
    gdk-x11-3.0
    x11-custom
    gdk-3.0
    acis
    posix
OPTIONS
    --disable-warnings
    --vapidir=${CMAKE_SOURCE_DIR}/vapi
    )

add_executable(meadow ${VALA_C})
target_link_libraries(meadow m X11)

install (TARGETS meadow RUNTIME DESTINATION /usr/share/xgreeters)
install (FILES data/Resources/meadow.desktop DESTINATION /usr/share/xgreeters)

install (CODE "message(\" -- Copying resources ..\")")
install (FILES data/Resources/4-meadow.conf DESTINATION /usr/share/lightdm/lightdm.conf.d/)
install(FILES data/Resources/user-box-shadow.svg DESTINATION /System/Resources/Meadow/)
install(FILES data/Resources/user-box.svg DESTINATION /System/Resources/Meadow/)
install(FILES data/Resources/back-arrow.svg DESTINATION /System/Resources/Meadow/)
install(FILES data/Resources/cloud-login.svg DESTINATION /System/Resources/Meadow/)

install(FILES data/Resources/system-reboot.svg DESTINATION /System/Resources/Meadow/)
install(FILES data/Resources/system-reboot-click.svg DESTINATION /System/Resources/Meadow/)
install(FILES data/Resources/system-reboot-hover.svg DESTINATION /System/Resources/Meadow/)

install(FILES data/Resources/system-shutdown.svg DESTINATION /System/Resources/Meadow/)
install(FILES data/Resources/system-shutdown-click.svg DESTINATION /System/Resources/Meadow/)
install(FILES data/Resources/system-shutdown-hover.svg DESTINATION /System/Resources/Meadow/)

install(FILES data/Resources/system-suspend.svg DESTINATION /System/Resources/Meadow/)
install(FILES data/Resources/system-suspend-click.svg DESTINATION /System/Resources/Meadow/)
install(FILES data/Resources/system-suspend-hover.svg DESTINATION /System/Resources/Meadow/)
