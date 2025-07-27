
# Module name
obj-m += hp-wmi.o

# Kernel build directory
KDIR := /lib/modules/$(shell uname -r)/build

# Current directory
PWD := $(shell pwd)

# Default target
all:
	$(MAKE) -C $(KDIR) M=$(PWD) modules

# Clean target
clean:
	$(MAKE) -C $(KDIR) M=$(PWD) clean

# Install module
install: all
	$(MAKE) -C $(KDIR) M=$(PWD) modules_install
	depmod -a

# Remove module
uninstall:
	rm -f /lib/modules/$(shell uname -r)/extra/hp-wmi.ko
	depmod -a

.PHONY: all clean install uninstall