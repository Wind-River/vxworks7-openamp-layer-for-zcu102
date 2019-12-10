# Building a VxWorks OpenAMP Remote Image
## Creating, Configuring and Building Source Build Project for VxWorks OpenAMP Remote Image
The following procedure was executed on a Linux host using a **VxWorks Development Shell**.  It is assumed that all [prerequisites](https://github.com/Wind-River/vxworks7-openamp-layer-for-zcu102) have been met.

1. Start **Workbench** and select a new directory for the workpace.

2. From the top menu, select **Project > Open Development Shell…**.

A **VxWorks Development shell**  (**VxWorks 7** tab) will appear under the **Terminal** tab.

**The building of the openamp and its third party components is known to fail when parallel builds in enabled.**

3. Click the **Build Console** tab and ensure that the **Parallel Builds** icon has parallel builds disabled.

4. Click on the **VxWorks 7** tab to bring the **VxWorks Development shell** into focus.

For convenience, the commands executed in the rest of this section rely on environment variables defined for the various project names.  You may change the names of the projects by setting the appropriated variables. 

5. Define the name of the source build project for the **VxWorks OpenAMP** remote image.
```
export RPU_VSB=rpu-libs-openamp
```
6. Define the name of the kernel image project for the **VxWorks OpenAMP** remote image.
```
export RPU_VIP=rpu-kern-openamp
```
7. Create the source build project based on the **xlnx_zynqmp_r5** BSP.

```
wrtool prj vsb create -bsp xlnx_zynqmp_r5 -S $RPU_VSB
```
The **rpu-libs-openamp** project appears in the **Project Explorer**.  

8. Enable the **OPENAMP** layer.
```
wrtool prj vsb add OPENAMP $RPU_VSB
```
**Note that the next step will fail unless you have disabled parallel builds as per step 3**.

9.  Build the project.
```
wrtool prj build $RPU_VSB
```
**Note:  this step will take some time to complete**

## Creating, Configuring and Building Image Project for VxWorks OpenAMP Remote Image

1. Create the image project based on the VSB created in the previous section and with **PROFILE_STANDALONE_DEVELOPMENT**.
```
wrtool prj vip create -vsb $RPU_VSB -profile PROFILE_STANDALONE_DEVELOPMENT xlnx_zynqmp_r5 llvm $RPU_VIP
```
The **rpu-kern-openamp** project appears in the **Project Explorer**.  

2. In the **Project Explorer**, expand the the **rpu-kern-openamp** project, and double-click **usrAppInit.c**.

A text editor window will open.

3. In the **usrAppInit.c** window, locate the following text near the top of the file.
```
#include <vxWorks.h>
#if defined(PRJ_BUILD)
#include "prjParams.h"
#endif /* defined PRJ_BUILD */
```
4. Insert the prototype for the **rpmsg_test_remote** function at the top of the file as follows.
```
#include <vxWorks.h>
#if defined(PRJ_BUILD)
#include "prjParams.h"
#endif /* defined PRJ_BUILD */

extern void rpmsg_test_remote(void);
```
5. Scroll down to the **usrAppInit** function until you see the following line:
```
            /* TODO: add application specific code here */
```

6. Insert the **taskSpawn** function as follows:
```
           /* TODO: add application specific code here */
             taskSpawn("tOpenAMP", 200, 0, 40000, rpmsg_test_remote, 0, 0, 0, 0 , 0, 0, 0, 0, 0, 0);
```
This will start the initiatation of **OpenAMP** once the VxWorks Remote image is booted..

7. Highlight the text editor window and type **CTRL-s** to save the file.

8. Expand **rpu-kernel-openamp > xlnx_xynqmp_r5_2_0_1_0**, and double-click **zynqmp-r5.dtsi**.

A text editor window will open.

9. In the **zynqmp-r5.dtsi** window, locate the following text near the bottom of the file.
```
            #ifdef XLNX_ZYNQ_END_BD_TX_NUM
                     tx-bd-num = <XLNX_ZYNQ_END_BD_TX_NUM>;
            #endif /* XLNX_ZYNQ_END_BD_TX_NUM */
                     local-mac-address = [ 00 0A 35 11 22 33 ];
                      clocks = <&gem3_ref_div_clk>;
                     interrupts = <95 0 0x104>;
                     interrupt-parent = <&intc>;
                   };
               }; /* end soc */
            };
```
10. Insert the definition of the **ipi** driver before **}; /\*end soc \*/** for the RPU as follows.
```
            #ifdef XLNX_ZYNQ_END_BD_TX_NUM
                   tx-bd-num = <XLNX_ZYNQ_END_BD_TX_NUM>;
            #endif /* XLNX_ZYNQ_END_BD_TX_NUM */
                   local-mac-address = [ 00 0A 35 11 22 33 ];
                   clocks = <&gem3_ref_div_clk>;
                   interrupts = <95 0 0x104>;
                   interrupt-parent = <&intc>;
                   };

                  /* OpenAMP will use RPU0 0 for IPI interrupts */
                      ipi: ipi@ff310000
                   {
                   compatible = "xlnx,zynqmp-ipi";
                   status = "disabled";
                   reg = <0xff310000 0x100>;
                   interrupts = <65 0 4>;
                   interrupt-parent = <&intc>;
                   };

               }; /* end soc */
           };
```
11. Highlight the text editor window and type **CTRL-s** to save the file. 

12. Expand **rpu-kernel-openamp > xlnx_xynqmp_r5_2_0_1_0**, and double-click **xlnx-zcu102-r5-rev-1.1.dts**.

A text editor window will open.

13. In the  **xlnx-zcu102-r5-rev-1.1.dts** window, locate the following text near the top of the file.
```
            chosen
                {
                bootargs = "gem(0,0)host:vxWorks h=192.168.1.1 e=192.168.1.6:ffffff00 g=192.168.1.1 u=a pw=a";
                stdout-path = "serial0";
                };
             };
```
14. Insert the definition to enable the **ipi** driver as follows:
```
            chosen
                {
                bootargs = "gem(0,0)host:vxWorks h=192.168.1.1 e=192.168.1.6:ffffff00 g=192.168.1.1 u=a pw=a";
                stdout-path = "serial0";              
                };
             };


            &ipi
             {
                status = "okay";
             };
```
15. Scroll down to the **&gem3** entry.
```
            &gem3
             {
             status = "okay";
             phy-handle = <&phy3>;
```
16. Change status from **"okay"** to **"disabled"**,.
```
            &gem3
             {
            status = "disabled";
            phy-handle = <&phy3>;
```
17. Highlight the text editor window and type **CTRL-s** to save the file.

18. In the **VxWorks Development shell**, execute the following commands to configure the image project.
```
wrtool prj vip component add $RPU_VIP \
INCLUDE_STANDALONE_DTB \
INCLUDE_DEBUG_KPRINTF \
DRV_IPI_XLNX_ZYNQMP \
INCLUDE_OPENAMP_DUMP_ROUTINES 

wrtool prj vip component remove $RPU_VIP INCLUDE_NETWORKING

wrtool prj vip parameter set $RPU_VIP USER_D_CACHE_ENABLE FALSE
```

19. The configuration Macro used in this step depends on which operating system is used as a master to boot this image.  Carefully chose the correct option based on your configuration.

### VxWorks OpenAMP Master
If you are booting this **VxWorks** remote image from a **VxWorks** master, execute the following command:
```
wrtool prj vip component add $RPU_VIP \
INCLUDE_OPENAMP_SAMPLE_REMOTE 
```

### Wind River Linux Master or Wind River Linux Helix Virtualization Platform Guest Master
If you are booting this  **VxWorks** remote image from a **Wind River Linux** master or a **Wind River Linux Helix Virtualization Platform** guest master, execute the following command.
```
wrtool prj vip component add $RPU_VIP \
INCLUDE_OPENAMP_SAMPLE_REMOTE_LINUX_CHAR 
```

20. Build the image project.
```
wrtool prj build $RPU_VIP -target vxWorks
```

After the the build finishes, the **vxWorks** ELF image will reside in **./rpu-kern-openamp/default/**

