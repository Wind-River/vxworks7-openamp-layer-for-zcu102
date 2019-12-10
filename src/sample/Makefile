# Makefile - makefile for OpenAMP sample code
#
# Copyright (c) 2015-2016, 2019 Wind River Systems, Inc. 
# 
# Redistribution and use in source and binary forms, with or without modification, are 
# permitted provided that the following conditions are met: 
# 
# 1) Redistributions of source code must retain the above copyright notice, 
# this list of conditions and the following disclaimer. 
# 
# 2) Redistributions in binary form must reproduce the above copyright notice, 
# this list of conditions and the following disclaimer in the documentation and/or 
# other materials provided with the distribution. 
# 
# 3) Neither the name of Wind River Systems nor the names of its contributors may be 
# used to endorse or promote products derived from this software without specific 
# prior written permission. 
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE 
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL 
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR 
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER 
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, 
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE 
# USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. 
#
# modification history
# --------------------
# 06jun19,drp  adapted to support Xilinx zcu102
# 25nov16,ghl  port for OpenAMP-v201610 (F8373)
#
# DESCRIPTION
# This file contains the makefile rules for building OpenAMP sample code.
#

LIB_BASE_NAME = OPENAMP

include $(WIND_KRNL_MK)/defs.library.mk

ifdef   _WRS_CONFIG_FSL_IMX
OBJS_ARMARCH7M  = openamp_dump.o
OBJS_ARMARCH7  = openamp_dump.o
endif

ifdef   _WRS_CONFIG_TI_SITARA
OBJS_ARMARCH7M  = openamp_dump.o
OBJS_ARMARCH7  = openamp_dump.o
endif

ifdef   _WRS_CONFIG_XLNX_ZYNQ
OBJS_ARMARCH7  = openamp_dump.o
OBJS_ARMARCH8A  = openamp_dump.o
endif

DOC_FILES      = 

include $(wildcard $(sort *.mk))

OBJS=$(OBJS_$(CPU))

include $(WIND_KRNL_MK)/rules.library.mk
