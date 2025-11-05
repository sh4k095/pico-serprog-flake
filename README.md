# pico-serprog-flake ❄️
This flake defines a development environment suitable for working with Raspberry Pi Pico and `pico-serprog`. It properly defines the `PICO_SDK_PATH` environment variable and fetches all `pico-sdk` submodules from nixpkgs, overriding [the default](https://github.com/NixOS/nixpkgs/blob/7241bcbb4f099a66aafca120d37c65e8dda32717/pkgs/by-name/pi/pico-sdk/package.nix#L12-L15) (`withSubmodules = false`). Otherwise, compile will fail due to the lack of several libraries, i.e. tinyusb.

## Build
```
nix develop
mkdir build && cd build
cmake ..
make
```
This should generate a file named `pico_serprog.uf2`.

## Install
Connect your Raspberry Pi Pico via USB, mount it as a mass storage device and transfer `pico_serprog.uf2` to it. Your programmer is now ready to use.

## Libreboot flashing
Pinout [here](https://libreboot.org/docs/install/spi.html#wiring).
Read and verify flash:
```
flashprog -p serprog:dev=/dev/ttyACM0,spispeed=16M -c MX25L6405 -r read_1.bin
flashprog -p serprog:dev=/dev/ttyACM0,spispeed=16M -c MX25L6405 -r read_2.bin
diff read_1.bin read_2.bin # output should be empty
```
Flash:
```
flashprog -p serprog:dev=/dev/ttyACM0,spispeed=16M -c MX25L6405 -w seauboot_x200_8mb_libgfxinit_corebootfb.rom
```

## That's it!
Original `README.md` content follows.

# pico-serprog

Slightly less terrible serprog implementation for the Raspberry Pi Pico and
other RP2040 based boards. Based on
![pico-serprog by stacksmashing](https://github.com/stacksmashing/pico-serprog/).
Further improved by kukrimate ![here](https://github.com/kukrimate/pico-serprog).
And me (Riku\_V) here.

Pre-compiled binaries can be downloaded from the
![Libreboot project](https://libreboot.org/download.html#https).

For a guide on how to flash a chip see
![this page](https://libreboot.org/docs/install/spi.html#raspberry-pi-pico).

This takes about 17 seconds to read the 8MiB BIOS chip of an X200.

Pinout for the SPI lines:
| Pin | Function |
|-----|----------|
|  7  | CS       |
|  6  | MISO     |
|  5  | MOSI     |
|  4  | SCK      |

![Pico pinout](pinout.png)

## Compiling

```
cmake .
make
```

Plug in your Pico. Mount it as you would any other USB flash drive.
Copy `pico_serprog.uf2` into it. Your programmer is now ready.
If you want to change the firmware, you need to press the button
on the board while you plug it in.

## Usage

Substitute ttyACMx with the actual tty device corresponding to the firmware.
You can find this by running `dmesg -wH`. When you plug in the device, a line
containing something like this will appear:

```
[453876.669019] cdc_acm 2-1.2:1.0: ttyACM0: USB ACM device
```


Read chip:

```
flashprog -p serprog:dev=/dev/ttyACMx,spispeed=32M -r flash.bin
```

Write chip:
```
flashprog -p serprog:dev=/dev/ttyACMx,spispeed=32M -w flash.bin
```

Multiple chips can be connected at the same time. Pins GP5-GP8 are Chip
Selects 0-3, respectively. The firmware defaults to using Chip Select 0.
```
flashprog -p serprog:dev=/dev/ttyACMx,cs=0 -r chip0.bin
flashprog -p serprog:dev=/dev/ttyACMx,cs=1 -r chip1.bin
```

## License

As a lot of the code itself was heavily inspired/influenced by `stm32-vserprog`
this code is licensed under GPLv3.

pinout.png is based on
[pico-pinout.svg](https://www.raspberrypi.com/documentation/microcontrollers/images/pico-pinout.svg)
by Raspberry Pi Ltd, under the
[Creative Commons Attribution-ShareAlike 4.0 International](https://creativecommons.org/licenses/by-sa/4.0/)
license.

