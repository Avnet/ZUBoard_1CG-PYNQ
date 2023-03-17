FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += "file://bsp.cfg \
            file://user.cfg \
            file://0001-hwmon-pmbus-Add-Infineon-IR38060-62-63-driver.patch \
            file://0001-drivers-iio-temperature-import-ssts22h-driver.patch \
            "
