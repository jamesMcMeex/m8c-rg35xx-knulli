# m8c-Knulli Build Environment

This repository contains a Dockerfile and build script for compiling the [m8c](https://github.com/laamaa/m8c) ([DirtyWave M8 Headless](https://github.com/Dirtywave/M8HeadlessFirmware) Client) and necessary kernel modules for use with [Knulli custom firmware](https://knulli.org/) on the [Anbernic RG35XX*](https://anbernic.com/products/rg35xx-2024-new) family of embedded Linux handheld retro console devices.

_Note: I have only tested this on an Anbernic RG35XXSP, but others in the Discord community have basically run this on other RG35XX* devices_

## Overview

The idea behind this is to provide a platform that makes it relatively easy for most people to compile a runnable executable of the M8 Tracker software for handheld gaming consoles. With a bit more tinkering, this could be made more flexible so that it's easy to build m8c for other devices and/or other firmware.

## Requirements

- Docker
- Git

## Dependencies
This version builds using:
- Linux kernel `v4.9.170`
- Knulli RG35XX Plus/H/2024 toolchain `rg35xx-plush-sdk-20240421/aarch64-buildroot-linux-gnu_sdk-buildroot`
- m8c `v1.7.8`

## Usage

1. Clone this repository:
   ```shell
   git clone https://github.com/jamesMcMeex/m8c-rg35xx-knulli.git
   ```

2. Go into the directory:
    ```shell
    cd m8c-build-environment
    ```

3. Build the Docker image:
   ```shell
   docker build -t m8c-knulli .
   ```

4. Run the Docker container to start the build process:

   For Windows (PowerShell):
   ```powershell
   docker run -v ${PWD}/output:/build/compiled/m8c m8c-knulli
   ```

   For Mac/Linux:
   ```shell
   docker run -v $(pwd)/output:/build/compiled/m8c m8c-knulli
   ```

5. After the build process completes, you'll find the compiled files in a new `output/` directory located inside inside the source directory (`m8c-build-environment`).

## What's Included

- `Dockerfile`: Sets up the build environment with necessary dependencies.
- `build_script.sh`: Automates the process of building m8c, compiling kernel modules, and preparing the startup script.

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

## Customization
You could modify the `Dockerfile` and `build_script.sh` to adjust the build process according to your needs. For example, you can change the kernel version, the toolchain used for , or M8C repository URL.

## Troubleshooting
If you encounter any issues during the build process:

1. Ensure you have a stable internet connection for downloading dependencies.
2. Check that you have the latest version of Docker installed.
3. Verify that you have sufficient disk space for the build process.

If problems persist, please open an issue in this repository with detailed information about the error you're experiencing. I will try to help but I am a frontend engineer and a Linux noob!

## Contributing
Contributions to improve the build process or extend functionality are welcome. Please fork the repository, make your changes, and submit a pull request.

## Acknowledgments
- [DirtyWave](https://dirtywave.com/) for creating the M8 tracker
- [laamaa](https://github.com/laamaa) for developing m8c
- [mnml](https://github.com/mnml) for writing the script that gave me the inspiration to hack
- [knulli-cfw](https://github.com/knulli-cfw) for the RG35XX Plus custom firmware work
- All the other people who contributed to the mountain of software that makes things run on a dinky little computer

## License
[MIT License](LICENSE.md)
