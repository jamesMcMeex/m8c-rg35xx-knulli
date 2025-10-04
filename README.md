# m8c for the H700 SoC (RG35XX* & RG40XX* devices)

This repository contains a Dockerfile and build script for compiling the [m8c](https://github.com/laamaa/m8c) client for the [DirtyWave M8 Headless](https://github.com/Dirtywave/M8HeadlessFirmware) firmware and necessary kernel modules for Anbernic's Linux-based handheld console devices based on the Allwinner h700 chip. Broadly, these are the RG35XX* & RG40XX* devices

_Note on IRL Anbernic device tests: I have only tested this on an Anbernic RG35XXSP & RG40XXV myself, but others in the Discord community have basically run this on other RG35XX* & RG40XX* devices._

_Note on custom firmware on Anbernic device: This uses tooling from the Knulli CFW project. It might work on other custom firmwares, but I haven't tested them (yet)._

## Overview

The idea behind this is to provide a platform that makes it relatively easy for most people to compile a runnable executable of the M8 Tracker software for handheld gaming consoles. With a bit more tinkering, this could be made more flexible so that it's easy to build m8c for other devices and/or other firmware.

## Requirements

- Git
- Docker

## Dependencies
This version builds using:
- Linux kernel `v4.9.170`
- Knulli RG35XX Plus/H/SP/2024 toolchain `rg35xx-plush-sdk-20240421/aarch64-buildroot-linux-gnu_sdk-buildroot`
- m8c `v1.7.10`

## Usage

### On Linux/macOS:
1. Clone this repository:
   ```shell
   git clone https://github.com/jamesMcMeex/m8c-rg35xx-knulli.git
   ```

2. Go into the directory:
    ```shell
    cd m8c-rg35xx-knulli
    ```

3. Run the build script:
   ```shell
    ./build.sh
   ```

### On Windows:
1. Clone this repository:
   ```powershell
   git clone https://github.com/jamesMcMeex/m8c-rg35xx-knulli.git
   ```

2. Go into the directory:
    ```powershell
    cd m8c-rg35xx-knulli
    ```

3. Run Docker commands directly:
   ```powershell
   docker buildx create --name m8c-builder --driver docker-container --bootstrap
   docker buildx use m8c-builder
   docker buildx build --platform linux/amd64 --load -f Dockerfile.x86_64 -t m8c-knulli .
   mkdir -p output
   docker run -v ${pwd}/output:/build/compiled m8c-knulli
   ```

The script automatically detects system architecture on Linux/macOS and uses the appropriate build configuration. After the build process completes, you'll find the compiled files in a new `output/` directory located inside the source directory.

## What's Included

- `build.sh`: Main build script that detects architecture and manages the build process
- `Dockerfile.arm64` and `Dockerfile.x86_64`: Sets up the build environment for different architectures
- `build_script.arm64.sh` and `build_script.x86_64.sh`: Architecture-specific build scripts

## Build Process

The build process includes the following steps:

1. Downloads and extracts the Linux kernel source (version 4.9.170)
2. Downloads and extracts the Knulli ARM64 toolchain
3. Downloads the Knulli Linux config file for RG35XX* devices
4. Downloads and extracts the m8c project
5. Configures and builds the necessary kernel modules
6. Builds m8c
7. Collects all built files and creates a startup script

## Output

After a successful build, you'll find the following in the `output` directory:

- A folder named `m8c` with the `m8c` executable and the compiled kernel modules (`cdc-acm.ko`, `snd-hwdep.ko`, `snd-usbmidi-lib.ko`, `snd-usb-audio.ko`) inside
- `m8c.sh` startup script

## Installation on device (Knulli CFW-specific)
- Locate the `roms/ports` folder in the partition used to store ROMs (this will either be the `SHARE` volume when using a single SD card setup, or on the second SD card, if you've set up Knulli on your device this way)
- Drop the `m8c` folder and the `m8c.sh` script into this location
- (Optional) Add the m8c application to the `gamelist.xml` file to make it a bit more pretty in the Knulli UI

## Troubleshooting

If you encounter issues running m8c on your device, here are some common problems and solutions:

### "Permission denied" Errors
When you see "Permission denied" or the app won't launch:

1. Make sure both files are executable by running these commands in the ports/m8c directory:
   ```bash
   chmod +x m8c.sh
   chmod +x m8c/m8c
   ```

2. For kernel module loading issues, you may need to set correct permissions:
   ```bash
   chmod 644 m8c/*.ko
   ```

### "Failed to start PipeWire loopback" Error
If you get audio-related errors:

1. First make sure your M8 is properly connected via USB
2. Try unplugging and reconnecting your M8
3. If the error persists, you may need to restart your device

### Getting Help
If you're still having issues:
1. Check existing [Issues](https://github.com/jamesMcMeex/m8c-rg35xx-knulli/issues) to see if others have solved your problem
2. When creating a new issue, please include:
   - Your device model (RG35XX+, RG35XXSP, etc.)
   - The exact error message you're seeing
   - Steps you've already tried

## Customization
You can modify the build process by adjusting any of these files:
- Architecture-specific Dockerfiles (`Dockerfile.arm64`, `Dockerfile.x86_64`) to change the build environment
- Build scripts (`build_script.arm64.sh`, `build_script.x86_64.sh`) to modify the build process
- Main build script (`build.sh`) to change how architecture detection and Docker builds are handled

Common customizations include:
- Changing the kernel version
- Using a different toolchain
- Updating the M8C repository URL or version
- Modifying kernel module configurations

## Contributing
Feel free to fork the repository, make your changes, and submit a pull request.

## Acknowledgments
- [DirtyWave](https://dirtywave.com/) for creating the M8 tracker
- [laamaa](https://github.com/laamaa) for developing m8c
- [mnml](https://github.com/mnml) for writing the script that gave me the inspiration to hack
- [knulli-cfw](https://github.com/knulli-cfw) for the RG35XX Plus custom firmware work
- All the other people who contributed to the mountain of software that makes things run on a dinky little computer

## License
[MIT License](LICENSE.md)
