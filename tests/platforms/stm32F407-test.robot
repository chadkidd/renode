# Filename: stm32F407-test.robot
*** Settings ***
Suite Setup                   Setup
Suite Teardown                Teardown
Test Setup                    Reset Emulation
Resource                      ${RENODEKEYWORDS}

*** Test Cases ***
Should Read Accelerometer X/Y
    Execute Command         mach create
    Execute Command         machine LoadPlatformDescription @/Users/chadkidd/development/renode/platforms/boards/stm32f4_discovery-kit.repl
    Execute Command         sysbus LoadELF @${PATH}/STM32F4-Discovery.elf
    Execute Command	   logLevel 3 sysbus.spi1

    Create Terminal Tester  sysbus.uart2

    Start Emulation
    Wait For Line On Uart   Processor init complete

    Execute Command         sysbus.gpioPortA.UserButton Press
    Execute Command         sysbus.gpioPortA.UserButton Release
    Wait For Line On Uart   Accelerometer reading started

    Execute Command	   sysbus.spi1.Accelerometer AccelerationX 5
    Wait For Line On Uart   x value above threshold = 250
    Execute Command	   sysbus.spi1.Accelerometer AccelerationX -5
    Wait For Line On Uart   x value below threshold = -265
    Execute Command	   sysbus.spi1.Accelerometer AccelerationX 0

    Execute Command	   sysbus.spi1.Accelerometer AccelerationY 5
    Wait For Line On Uart   y value above threshold = 250
    Execute Command	   sysbus.spi1.Accelerometer AccelerationY -5
    Wait For Line On Uart   y value below threshold = -265
    Execute Command	   sysbus.spi1.Accelerometer AccelerationY 0
