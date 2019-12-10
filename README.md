VxWorks® 7 Build Layer for OpenAMP Master and Remote

---

# Overview
This layer is part of the [OpenAMP for VxWorks Remote Compute](https://github.com/Wind-River/openamp-for-vxworks-remote-compute) project.  It provides build time integration of the **OpenAMP** libraries, 
**libmetal** and **open-amp**, and a **vxWorks** demo application.

This layer was derived from [wr-MultiOS-OpenAMP](https://github.com/Wind-River/wr-MultiOS-OpenAMP) and supports the **Xilinx® Zynq® UltraScale+™ MPSoC ZCU102** reference platform. 

Use this layer for creating **VxWorks OpenAMP** images for any of the **OpenAMP for VxWorks Remote Compute** demos including
1. [**VxWorks OpenAMP** master and **VxWorks OpenAMP** remote](https://github.com/Wind-River/vxworks7-openamp-layer-for-zcu102)
*  **VxWorks OpenAMP** master that boots on the **ARM® Cortex®-A53** processor; and 
*  **VxWorks OpenAMP** remote that resides in **/romfs** of the **VxWorks OpenAMP** master and boots on the **ARM® Cortex®-R5** processor 
2. [**Wind River Linux** master and **VxWorks OpenAMP** remote](https://github.com/Wind-River/wr-vxworks7-openamp-demo-for-zcu102) 
*  **VxWorks OpenAMP** remote that resides in **/lib/firmware** of the root file system of **WindRiver Linux** and boots on the **ARM® Cortex®-R5** processor only 
3. [**Wind River Linux Helix Virtualization Platform** guest master and **VxWorks OpenAMP** remote](https://github.com/Wind-River/wr-vxworks7-openamp-demo-for-zcu102) 
*  **VxWorks OpenAMP** remote that resides in **/lib/firmware** of the root file system of **WindRiver Linux Helix Virtualization Platform** guest and boots on the **ARM® Cortex®-R5** processor only 

# Project License  
The source code for this project is provided under the BSD-3-Clause license. 
Text for the open-amp and libmetal applicable license notices can be found in 
the LICENSE_NOTICES.txt file in the project top level directory. Different 
files may be under different licenses. Each source file should include a 
license notice that designates the licensing terms for the respective file.
  
# Prerequisite(s)
* Installation of [**Wind River® VxWorks® 7 SR0620 for ARM**](https://www.windriver.com/products/vxworks/)
* Network access to third party libraries (automatically downloaded by this layer)
   * [**libmetal**](https://github.com/OpenAMP/libmetal/releases/tag/v2016.10)
   * [**open-amp**](https://github.com/OpenAMP/open-amp/releases/tag/v2016.10)
* Required host utilities
   * **cmake**
   * **patch** 

# Tested Development Environment

## Host Operating System
Both the VxWorks Master image and the VxWorks remote images were created on an Ubuntu 18.04 host.
```
wruser@Mothra:~$ uname -a 
Linux Mothra 5.0.0-32-generic #34~18.04.2-Ubuntu SMP Thu Oct 10 10:36:02 UTC 2019 x86_64 x86_64 x86_64 GNU/Linux
```
## Supported/Tested VxWorks 7 Installation

This project was tested with an SR0620 installation.

## CMake version
This layer requires CMake.
```
wruser@Mothra:~$  cmake --version
cmake version 3.10.2
 
CMake suite maintained and supported by Kitware (kitware.com/cmake).
```
## patch version
This layer requires the patch utility.

```
wruser@Mothra:~$ patch --version
GNU patch 2.7.6
Copyright (C) 2003, 2009-2012 Free Software Foundation, Inc.
Copyright (C) 1988 Larry Wall

License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>.
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

Written by Larry Wall and Paul Eggert
```
## Supported Target
This layer has been tested and is supported with the **Xilinx Zynq UltraScale+ MPSoC ZCU102** only using the **xlnx_zynqmp SR0620 ARM Cortex A53 BSP (ARMv8 libraries)** to build a VxWorks master and the **xlnx_zynqmp_r5 SR0620 ARM Cortex R5 BSP (ARMv7 libraries** to build a VxWorks remote image.  

## OpenAMP Version
This layer was adapted from the existing [**wr-MultiOS-OpenAMP**](https://github.com/Wind-River/wr-MultiOS-OpenAMP) **VxWorks** layer which provides integration to [**libmetal v2016.10**](https://github.com/OpenAMP/libmetal/releases/tag/v2016.10) and [**open-amp v2016.10**](https://github.com/OpenAMP/open-amp/releases/tag/v2016.10) with some patches that implement fixes and backports. See below.  


# Limitations
## Number of Peers
Only one **VxWorks** master and one **VxWorks** remote is supported.
 
## Limits on RPU
**Remoteproc** supports loading and booting **VxWorks**  on the first R5 core in split mode.  The second R5 core is not used.

## Basic IPI Driver support.
A [VxWorks FDT VxBus driver](https://github.com/Wind-River/vxworks7-ipi-driver-for-zcu102) was developed to support basic APU to RPU communications. 

## ssp Applications with Dynamic Endpoints
**VxWorks OpenAMP** master to **VxWorks OpenAMP** remote configuration supports multiple applications that can be initiated from either end using EPT callbacks.  For simplicity, the demo focuses on running the **ssp** application from the master only.  The basic channel callback has not been tested.  The **VxWorks OpenAMP** Remote Image must be compiled with **INCLUDE_OPENAMP_REMOTEPROC**.

## Not Tested
The following has not been tested with this release.
* Windows hosts.
* Teardown of RPMsg connections.
* VxWorks OpenAMP proxy code.
* TI Sitara or Freescale IMx.6sx boards. 

# openamp layer Features
This layer was adapted from the existing [**wr-MultiOS-OpenAMP**](https://github.com/Wind-River/wr-MultiOS-OpenAMP) **VxWorks** layer which uses the following open source projects: OpenAMP v2016.10 and Libmetal v2016.10.  The following changes/additions were added to the layer.

 ## New target support
* Integration of support for the **Xilinx zcu102** master (**xlnx_zynqmp**) and remote (**xlnx_zynqmp_r5**).
* Remoteproc support for booting remote on R5 (split mode)
* Updates to the resource table and samples.

## Fixes/enhancements to layer
* CMake changes to support SR0620/Workbench 4.
* General build system changes to support new boards
* Layer version has been decoupled from openamp and libmetal version.
* Makefiles have been modified to separate and apply multiple patches to libmetal and open-amp.
* Patches have been spit into logic groups to support different versions of libmetal and open-amp.
* Changes to the hierarchy and dependencies of the Kernel Configuration for OpenAMP.
* Patches have be added to support LLVM stdatomic.h.

## Fixes and Backports to OpenAMP
* Fixes to the Remoteproc ELF32 loader used from 64-bit master.
* Backport of the **RSC_RPROC_MEM**, feature (with updates to the resource table) so that a Linux master can be told to allocate VRINGS and buffers from a predefined shared memory region.
* Fixes to OpenAMP to support LLVM and stdatomic.h.

## Support for Linux Master and VxWorks Remote
* Updates to the resource table and samples to include backported **RSC_RPROC_MEM** feature.
* Addition of sample code for VxWorks remote application talking to a Linux RPMsg Char driver.

## VIP Configuration Changes
* Addition of RPMsg Dump routines as configuration option
* Addition of RPMsg char option to suport Linux master
* New cdf heirarchy and dependency fixes

# Installation
Ensure that the following prerequisites are installed on your host machine.
* **Wind River VxWorks 7 for ARM, SR0620**
* **cmake**
* **patch** 

## Adding the VxWorks 7 IPI Driver for the Xilinx® Zynq® UltraScale+™ MPSoC ZCU102 reference platform.
The driver and instructions can be found [here](https://github.com/Wind-River/vxworks7-ipi-driver-for-zcu102)

## Adding the VxWorks® 7 Build Layer for OpenAMP Master and Remote
It is assumed that you are running on a **Linux** host and the **$WIND_HOME** variable is set to the root of your **Wind River** installation. 
```
wruser@Mothra:~$ echo $WIND_HOME
/home/wruser/WindRiver-SR0620
``` 
Execute the following commands to create a layer called **openamp-1.0.1.0** in the **ipc** directory of **pkgs_v2**.
```
mkdir -p $WIND_HOME/vxworks-7/pkgs_v2/ipc
cd $WIND_HOME/vxworks-7/pkgs_v2/ipc
git clone https://github.com/Wind-River/vxworks7-openamp-layer-for-zcu102.git
mv vxworks7-openamp-layer-for-zcu102 openamp-1.0.1.0 
cd -
```
The layer is now ready to use.

# Creating and Running the VxWorks OpenAMP Master and VxWorks OpenAMP Remote Demo
## Creating a VxWorksa OpenAMP Remote Image
This image is booted onto the RPU by the master.  It is required for all usecases.  
Instructions can be found [here](https://github.com/Wind-River/vxworks7-openamp-layer-for-zcu102/blob/master/BUILD-REMOTE.md)

## Creating a VxWorks OpenAMP Master Image
This image is required to run the VxWorks master/VxWorks remote demo.  
Instructions can be found [here](https://github.com/Wind-River/vxworks7-openamp-layer-for-zcu102/blob/master/BUILD-MASTER.md)

## Running the VxWorks OpenAMP Master and VxWorks OpenAMP Remote Demo
Instructions can be found [here](https://github.com/Wind-River/vxworks7-openamp-layer-for-zcu102/blob/master/RUN.md)


# Legal Notices
All product names, logos, and brands are property of their respective owners. All company,
product and service names used in this software are for identification purposes only. 
Wind River and VxWorks are registered trademarks of Wind River Systems, Inc.  Xilinx,
UltraScale,  Zynq, are trademarks of Xilinx in the United States and other countries.
Arm and Cortex are registered trademarks of Arm Limited (or its subsidiaries) in the US 
and/or elsewhere.  CMake is the registered trademark of Kitware, Inc.

Disclaimer of Warranty / No Support: Wind River does not provide support 
and maintenance services for this software, under Wind River's standard 
Software Support and Maintenance Agreement or otherwise. Unless required 
by applicable law, Wind River provides the software (and each contributor 
provides its contribution) on an "AS IS" BASIS, WITHOUT WARRANTIES OF ANY 
KIND, either express or implied, including, without limitation, any warranties 
of TITLE, NONINFRINGEMENT, MERCHANTABILITY, or FITNESS FOR A PARTICULAR 
PURPOSE. You are solely responsible for determining the appropriateness of 
using or redistributing the software and assume any risks associated with 
your exercise of permissions under the license.
