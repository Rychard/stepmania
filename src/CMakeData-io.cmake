list(APPEND SMDATA_IO_SRC
  "io/P2IO.cpp"
  "io/P3IO.cpp"
  "io/USBDevice_Libusb.cpp"
  "io/USBDriver.cpp"
)

list(APPEND SMDATA_IO_HPP
  "io/P2IO.h"
  "io/P3IO.h"
  "io/USBDevice.h"
  "io/USBDriver.h"
)


source_group("SM IO" FILES ${SMDATA_IO_SRC} ${SMDATA_IO_HPP})