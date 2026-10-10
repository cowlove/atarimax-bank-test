platform(atari8-cart-atarimax128 COMPLETE PARENT atari8-common)

if(NOT CMAKE_CROSSCOMPILING)
  return()
endif()

install(FILES link.ld TYPE LIB)

add_platform_library(atari8-cart-atarimax128-crt0 syms.s banked-call.s banked-call.c)
merge_libraries(atari8-cart-atarimax128-crt0
  common-copy-data
  common-zero-bss
  common-exit-loop
)
target_link_libraries(atari8-cart-atarimax128-crt0 PRIVATE common-asminc)
install(FILES banked-call.h TYPE INCLUDE)
