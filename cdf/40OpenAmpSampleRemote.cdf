/* 40OpenAmpSampleRemote.cdf - OpenAMP sample for remote Component */

/* 
* Copyright (c) 2016, 2019 Wind River Systems, Inc. 
* 
* Redistribution and use in source and binary forms, with or without modification, are 
* permitted provided that the following conditions are met: 
* 
* 1) Redistributions of source code must retain the above copyright notice, 
* this list of conditions and the following disclaimer. 
* 
* 2) Redistributions in binary form must reproduce the above copyright notice, 
* this list of conditions and the following disclaimer in the documentation and/or 
* other materials provided with the distribution. 
* 
* 3) Neither the name of Wind River Systems nor the names of its contributors may be 
* used to endorse or promote products derived from this software without specific 
* prior written permission. 
* 
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
* AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
* IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
* ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE 
* LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL 
* DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR 
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER 
* CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, 
* OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE 
* USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. 
*/
 
/*
modification history
--------------------
14jul19,drp  Changed REQUIRES to INCLUDE_OPENAMP_REMOTEPROC.   Added selection for INCLUDE_OPENAMP_SAMPLE_REMOTE_LINUX_CHAR
25nov16,ghl  port for OpenAMP-v201610 (F8373)
*/


Selection       SELECT_OPENAMP_SAMPLE_REMOTE {
    NAME        Select remote demo for VxWorks or Linux Master
    COUNT       0-1
    CHILDREN    INCLUDE_OPENAMP_SAMPLE_REMOTE \
		INCLUDE_OPENAMP_SAMPLE_REMOTE_LINUX_CHAR
    _CHILDREN   FOLDER_OPENAMP_REMOTE
}

Component INCLUDE_OPENAMP_SAMPLE_REMOTE {
    NAME            OpenAMP Sample code for remote
    SYNOPSIS        Sample code for remote processor coming along with OpenAMP.
    LINK_SYMS       rpmsg_test_remote
    REQUIRES        INCLUDE_OPENAMP_REMOTEPROC
}


Component INCLUDE_OPENAMP_SAMPLE_REMOTE_LINUX_CHAR {
    NAME            OpenAMP Sample code for remote with peer Linux
    SYNOPSIS        Sample code for remote processor coming along with OpenAMP.
    MODULES         rpmsg_test_remote.o
    PROTOTYPE       void configDemoForLinuxMaster(void);
    INIT_RTN        configDemoForLinuxMaster ();
    _INIT_ORDER     usrRoot
    INIT_BEFORE     INCLUDE_USER_APPL
    EXCLUDES        INCLUDE_OPENAMP_PROXY_REMOTE
    REQUIRES        INCLUDE_OPENAMP_REMOTEPROC
}


