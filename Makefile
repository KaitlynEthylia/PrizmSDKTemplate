.SUFFIXES:

include $(FXCGSDK)/toolchain/prizm_rules

NAME        := template
SOURCES		:= src
DATA		:= data  
INCLUDES	:=
BUILD		:= build

LIBS		:= -lc -lfxcg -lgcc
LIBDIRS		:= $(FXCGSDK)

MKG3AFLAGS	:= -n basic:$(NAME) -i uns:unselected.bmp -i sel:selected.bmp

CFLAGS		= -Os -Wall $(MACHDEP) $(INCLUDE) -ffunction-sections -fdata-sections
CXXFLAGS	= $(CFLAGS) -fno-exceptions

LDFLAGS		= $(MACHDEP) -T$(FXCGSDK)/toolchain/prizm.x -Wl,-static -Wl,-gc-sections

CFILES		:= $(foreach dir,$(SOURCES),$(wildcard $(dir)/*.c))
CPPFILES	:= $(foreach dir,$(SOURCES),$(wildcard $(dir)/*.cpp))
sFILES		:= $(foreach dir,$(SOURCES),$(wildcard $(dir)/*.s))
SFILES		:= $(foreach dir,$(SOURCES),$(wildcard $(dir)/*.S))
BINFILES	:= $(foreach dir,$(DATA),$(wildcard $(dir)/*.*))


ifeq ($(strip $(CPPFILES)),)
export LD := $(CC)
else
export LD := $(CXX)
endif

export DEPSDIR	:= .

export OFILES	:= $(addsuffix .o,$(BINFILES)) \
	$(CPPFILES:.cpp=.o) $(CFILES:.c=.o) \
	$(sFILES:.s=.o) $(SFILES:.S=.o)

export INCLUDE	:= $(foreach di,$(INCLUDES), -iquote $(CURDUR)/$(di)) \
	$(foreach dir,$(LIBDIRS),-I$(dir)/include) \
	-I$(FXCGSDK)/include

export LIBPATHS	:=	$(foreach dir,$(LIBDIRS),-L$(dir)/lib)

export OUTPUT	:=	$(BUILD)/$(NAME)
.PHONY: all

all: $(BUILD) $(DEPSDIR) $(OUTPUT).g3a

$(BUILD):
	mkdir -p $@

$(OUTPUT).g3a: $(OUTPUT).bin
$(OUTPUT).bin: $(OFILES)


DEPENDS	:=	$(OFILES:.o=.d)
-include $(DEPENDS)
