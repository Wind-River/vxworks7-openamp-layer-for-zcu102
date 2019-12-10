# Running the VxWorks OpenAMP Master and VxWorks OpenAMP Remote Demo

## Prerequisites
### Required images
* **vxWorks.bin** - **VxWorks OpenAMP** master **binary** image built with this [procedure](https://github.com/Wind-River/vxworks7-openamp-layer-for-zcu102/blob/master/BUILD-MASTER.md).
```
wruser@Mothra:~/WindRiver-SR0620/workspace$ ls $APU_VIP/default/vxWorks.bin
apu-kern-openamp/default/vxWorks.bin
```
* **BOOT.BIN** - the tested **BOOT.BIN** file was obtained from the stock [**2018.1**](https://xilinx-wiki.atlassian.net/wiki/spaces/A/pages/18841902/2018.1+u-boot+release+notes#id-2018.1u-bootreleasenotes-Features) version of [**U-Boot**](https://www.xilinx.com/member/forms/download/xef.html?filename=2018.1-zcu102-release.tar.xz).

### Tested Board
This example was validated on a **Xilinx Zcu102** populated with 4G RAM. A USB to microUSB cable with a **Silicon Labs CP2108 Quad USB to UART Birdge Controller** is attached between the host computer and the target computer.

### Tested Flash Drive
This example was validated with an 8Gig uSD card with 3 partitions formated as follows:  
* partition 1 1-Gig FAT32                            
* partition 2 3.5-Gig ext4 (not used in this example)
* partition 3 3.5-Gig ext4 (not used in this example)

## Preparing you target
### Location of Images
In the following example,
* **vxWorks.bin** is available at **$APU_VIP/default**.
* **BOOT.BIN** is available in the workspace directory.
 
### Mountpoint of uSD FAT32 Partition 
In the following example, the FAT32 partition of the uSD card is a mounted at **/media/wruser/EA08-13E2**. 

1. Copy the **vxWorks.bin** as **vxWorks_a53.bin** to the uSD drive.

```
  cp  $APU_VIP/default/vxWorks.bin /media/wruser/EA08-13E2/vxWorks_a53.bin
```
2. Copy the **BOOT.bin** to the uSD drive.
```
  cp  ./BOOT.BIN /media/wruser/EA08-13E2/
```
3. Unmount the uSD card.
4. Powerdown the target, instert the boot medium, and power it back on.
5. From the termnial, hit any key to enter the **ZynqMP>** prompt.

## Configuring **U-boot** Enviroment Variable
At them**ZynqMP>** prompt, enter the following commands to create the variable to boot the **VxWorks OpenAMP** master image.
```
setenv vx_vx 'fatload mmc 0:1 0x100000 vxWorks_a53.bin; go 100000'
saveenv
``` 
## Booting the VxWorks OpenAMP Master on the APUs
In the tested configuration, the first two serial devices appeared as **/dev/ttyUSB0** and **/dev/ttyUSB1**.
1. Select the **Workbench** **Terminal** tab and click the **Terminal** icon.
A **Launch Terminal** dialog will appear.
2. From the **Choose terminal:** pulldown, select **Serial Terminal**.
3. From the **Port:** pulldown, select **/dev/ttyUSB0**.
4. From the **Baud Rate:** pulldown, select **115200**.
5. Click the **OK** to save the configuration.
6. Repeat steps 1-5 but select the next serial port, **/dev/ttyUSB1**.
The first **Terminal** window will be used by the **VxWorks OpenAMP** master and the second will be used by the **VxWorks OpenAMP** remote.
7 Open terminal sessions for the first two serial ports of the QUAD UART attached to the Zynqmp board.

The first terminal will show the u-Boot output and will be used by the **VxWorks OpenAMP** master.  The second terminal will show the output of the **VxWorks OpenAMP** remote.

8 Poweron the **Zynqmp** and hit a key to stop the **U-Boot** bootstrap.
```
U-Boot 2018.01 (Dec 06 2018 - 10:00:41 +0000) Xilinx ZynqMP ZCU102 rev1.0

I2C: ready
DRAM: 4 GiB
EL Level: EL2
Chip ID: zu9eg
MMC: mmc@ff170000: 0 (SD)
SF: Detected n25q512a with page size 512 Bytes, erase size 128 KiB, total 128 MiB
In: serial@ff000000
Out: serial@ff000000
Err: serial@ff000000
Model: ZynqMP ZCU102 Rev1.0
Board: Xilinx ZynqMP
Net: ZYNQ GEM: ff0e0000, phyaddr c, interface rgmii-id

Warning: ethernet@ff0e0000 MAC addresses don't match:
Address in ROM is 01:02:03:04:05:06
Address in environment is aa:bb:cc:dd:ee:ff
eth0: ethernet@ff0e0000
Hit any key to stop autoboot: 0 
ZynqMP>
```
9. At the **ZynqMP>** prompt enter the following command
```
run vx_vx.
```

The **VxWorks** banner will appear followed by the target shell prompt.
```
Adding 8946 symbols for standalone.

->
```
10. Type the following to display the **VxWorks OpenAMP** remote ELF file in Romfs.
```
-> ls "/romfs"
/romfs/. 
/romfs/.. 
/romfs/vxWorks 
value = 0 = 0x0
->
```
11. Boot the **VxWorks OpenAMP** remote image via **Remoteproc** and start the **RPMsg/Virtio** session by issuing the following command:
```
-> sp rpmsg_test_master, "/romfs/vxWorks"
```
The shell output shows that the remote image was started and a connection was established over **rpmsg-openamp-demo-channel**.
```
-> sp rpmsg_test_master, "/romfs/vxWorks"
Task spawned: id = 0xffff8000002f1420, name = t1
value = -1407374master-[t1]rpmsg_test_master(84): remoteproc_init OK
85269984 = 0xffff8000002f1420
-> master-[t1]rpmsg_test_master(88): remoteproc_boot OK
master-[t1]rpmsg_test_master(100): remote is ready ...
master-[t1]rpmsg_channel_created(92): Channel rpmsg-openamp-demo-channel @0x0030c950 is created
```
12. Go to the second terminal.

The banner for the **VxWorks OpenAMP** remote image is displayed and the creation of channel, **rpmsg-openamp-demo-channel** is confirmed.
```
Adding 8072 symbols for standalone.

-> remote-[tOpenAMP]rpmsg_test_remote(106): remoteproc_resource_init OK, return 0
remote-[tOpenAMP]rpmsg_channel_created(92): Channel rpmsg-openamp-demo-channel @0x78393fe8 is created
```

13. On the first terminal type the following cmd.
```
->ssp 1
```
 
This command will initiate  a test where the **VxWorks OpenAMP** master will send the string "1234567890" to the **VxWorks OpenAMP** remote.  When either the master or remote received a message to the endpoint in question, it will

* display the received string
* remove the last character
* send the new string back to its peer
* stop the transmissiong when the string is only on character.

-----"1234567890------------------------->  
<-------------------------"123456789"----- 

-----"12345678"--------------------------->  
----------------------------"1234567"-----  

-----"123456"------------------------------>  
<--------------------------------"12345-----  

-----"1234"--------------------------------->  
<---------------------------------"123"----->  

-----"12"------------------------------------->  
<--------------------------------------"1"-----  

14. Observe the output on the first terminal
```
master-[t1]rpmsg_echo_cb(59): Msg:123456789,len:10,src:15
master-[t1]rpmsg_echo_cb(59): Msg:1234567,len:8,src:15
master-[t1]rpmsg_echo_cb(59): Msg:12345,len:6,src:15
master-[t1]rpmsg_echo_cb(59): Msg:123,len:4,src:15
master-[t1]rpmsg_echo_cb(59): Msg:1,len:2,src:15
```
The output indicates that messages with the following strings were received from the Remote: "123456789", "1234567", "12345", "123", "1".

15. Observe the output on the second terminal.
```
remote-[tOpenAMP]rpmsg_echo_cb(59): Msg:1234567890,len:11,src:15
remote-[tOpenAMP]rpmsg_echo_cb(59): Msg:12345678,len:9,src:15
remote-[tOpenAMP]rpmsg_echo_cb(59): Msg:123456,len:7,src:15
remote-[tOpenAMP]rpmsg_echo_cb(59): Msg:1234,len:5,src:15
remote-[tOpenAMP]rpmsg_echo_cb(59): Msg:12,len:3,src:15
```
The output indicates that messages with the following strings were received from the Master: "1234567890", "12345678", "123456", "1234", "12"
