# Building a VxWorks OpenAMP Master Image
## Prerequisites
The following procedures assume that you have just completed building the **vxWorks OpenAMP** remote image using these [instructions](https://github.com/Wind-River/vxworks7-openamp-layer-for-zcu102/blob/master/BUILD-REMOTE.md) and that 
* Workbench is open in the workspace where the **VxWorks OpenAMP** remote image was built.
* Parallel Builds is disabled.
* A **VxWorks Development Shell** is open.
* The environment variable **$RPU_VIP** is defined to the **VxWorks Image Project** that was used to build the **VxWorks OpenAMP** remote image.
```
wruser@Mothra:~/WindRiver-SR0620/workspace$ echo $RPU_VIP
rpu-kern-openamp
```
* The **VxWorks OpenAMP** ELF image had been built and is available in **$RPU_VIP/default**.  
```
wruser@Mothra:~/WindRiver-SR0620/workspace$ ls $RPU_VIP/default/vxWorks
rpu-kern-openamp/default/vxWorks
```

## Creating, Configuring and Building Source Build Project for VxWorks OpenAMP Master Image
1. Define the name of the source build project for the **VxWorks OpenAMP** master image.
```
export APU_VSB=apu-libs-openamp
```
2. Define the name of the kernel image project for the **VxWorks OpenAMP** master image.
```
export APU_VIP=apu-kern-openamp
```
3. Define the name of the **romfs** project for the **VxWorks OpenAMP** master image that will contain the **VxWorks OpenAMP** remote image.
```
export APU_ROMFS=apu-romfs-openamp
```
4. Create the source build project based on the **xlnx_zynqmp** BSP.
```
wrtool prj vsb create -bsp xlnx_zynqmp -S $APU_VSB
```
The **apu-libs-openamp** project appears in the **Project Explorer**.  

5. Enable the **OPENAMP** layer.
```
wrtool prj vsb add OPENAMP $APU_VSB
```
6. Build the project.
```
wrtool prj build $APU_VSB
```
Note:  this step will take some time to complete.
 
## Creating, Configuring and Building Image Project with Romfs for VxWorks OpenAMP Remote Image

1. Create the image project based on the VSB created in the previous section and with **PROFILE_STANDALONE_DEVELOPMENT**.
```
wrtool prj vip create -vsb $APU_VSB -profile PROFILE_STANDALONE_DEVELOPMENT xlnx_zynqmp llvm $APU_VIP
```
The **apu-kern-openamp** project appears in the **Project Explorer**.  

2. In the **Project Explorer**, expand **apu-kernel-openamp > xlnx_zynqmp_2_0_2_0** and double-click **zynqmp.dtsi**.

A text editor window will open.

3. In the **zynqmp.dtsi** window, locate the following text near the bottom of the file.
```
   can1: xcanps@0xff070000
            {
            compatible = "xlnx,xcanps";
            status = "disabled";
            reg = <0x0 0xff070000 0x0 0x1000>;
            clock-frequency = <20000000>;
            interrupts = <56 0 4>;
            interrupt-parent = <&intc>;
            };
        };
    };

```
4. Insert the definition for the ipi driver as follows.
```
   can1: xcanps@0xff070000
            {
            compatible = "xlnx,xcanps";
            status = "disabled";
            reg = <0x0 0xff070000 0x0 0x1000>;
            clock-frequency = <20000000>;
            interrupts = <56 0 4>;
            interrupt-parent = <&intc>;
            };

/* OpenAMP will use PL 0 for IPI interrupts */

         ipi: ipi@ff340000
             {
             compatible = "xlnx,zynqmp-ipi";
             status = "disabled";
             reg = <0 0xff340000 0 0x100>;
             interrupts = <61 0 4>;
             interrupt-parent = <&intc>;
             };
        };
    };

```
5. Highlight the text editor window and type **CTRL-s** to save the file.

6. Using Workbench, expand **apu-kernel-openamp > xlnx_zynqmp_2_0_2_0** and double-click **xlnx-zcu102-rev-1.1.dts**.

A text editor window will open.

7. In the **xlnx-zcu102-rev-1.1.dts** window, locate **chosen** text near the top of the file.
```
            chosen
                {
                bootargs = "gem(0,0)host:vxWorks h=192.168.1.2 e=192.168.1.6:ffffff00 g=192.168.1.1 u=target pw=vxTarget";
                stdout-path = "serial0";
             };
             };

``` 
8. Insert the definition to enable the **ipi** driver and disable **TTC0** as follows:
```
            chosen
                {
                bootargs = "gem(0,0)host:vxWorks h=192.168.1.2 e=192.168.1.6:ffffff00 g=192.168.1.1 u=target pw=vxTarget";
                stdout-path = "serial0";
             };
             };

&ipi
   {
      status = "okay";
   };

/* Leave TTC0 to VxWorks on RPU */
&ttc_0
    {
    status = "disable";
    }; 
``` 
9. Scroll up a bit until you see **memory**.

```
            memory
             {
             device_type = "memory";
             reg = <0x0 0x00000000 0x0 0x80000000>,
                   <0x8 0x00000000 0x0 0x80000000>;
             };
```
There are two banks of memory defined. The last 128G of the first 2G bank will be reserved for the **VxWorks OpenAMP** remote image and 1M will be reserved as a shared memory region for **VIRTIO** communications.

10. Reduce the size of the first memory bank by 129M by changing the range in the first **reg** entry from 0x80000000 to 0x77f00000.

```
             memory
             {
             device_type = "memory";
             /* 
             At the end of the first 2G of memory we reserve
             1M for OpenAMP VRINGS and buffers
             128M for VxWorks R5 instance loaded by remoteproc
            */
             reg = <0x0 0x00000000 0x0 0x77f00000>,
                   <0x8 0x00000000 0x0 0x80000000>;
             };
```
11. Highlight the text editor window and type **CTRL-s** to save the file.

12. Execute the following command to configure the image project.
```
wrtool prj vip component add $APU_VIP \
INCLUDE_STANDALONE_DTB \
INCLUDE_DEBUG_KPRINTF \
INCLUDE_ROMFS \
DRV_IPI_XLNX_ZYNQMP \
INCLUDE_OPENAMP_DUMP_ROUTINES \
INCLUDE_OPENAMP_SAMPLE_MASTER
```
13. Execute the following commands to create a romfs sub-project containing the VxWorks elf file created in [**Building a VxWorks Remote Image**](https://github.com/Wind-River/vxworks7-openamp-layer-for-zcu102/blob/master/BUILD-REMOTE.md).
```
wrtool prj romfs create -force $APU_ROMFS
wrtool prj romfs add -file $RPU_VIP/default/vxWorks $APU_ROMFS
wrtool prj subproject add $APU_ROMFS $APU_VIP
```
The romfs project defined in $APU_ROMFS will appear as a subproject of $APU_VIP.

14. Build the image project.
```
wrtool prj build $APU_VIP -target vxWorks.bin
```
When the build completes the **vxWorks.bin** binary image will reside in **$APU_VIP/default/**.
This file will be renamed to **vxWorks_a53.bin** and booted using **run vx_vx** from the **U-Boot** shell.
