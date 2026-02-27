
# Module name
obj-m += hp-wmi.o

# Kernel build directory
KDIR := /lib/modules/$(shell uname -r)/build

# Current directory
PWD := $(shell pwd)

# Get package info from dkms.conf
DKMS_CONF := $(PWD)/dkms.conf
PKGNAME := $(shell grep -oP 'PACKAGE_NAME="\K[^"]+' $(DKMS_CONF) 2>/dev/null)
VERSION := $(shell grep -oP 'PACKAGE_VERSION="\K[^"]+' $(DKMS_CONF) 2>/dev/null)

# Default target
all:
	$(MAKE) -C $(KDIR) M=$(PWD) modules

# Clean target
clean:
	$(MAKE) -C $(KDIR) M=$(PWD) clean
	rm -rf *.pkg.tar.zst

install: all
	$(MAKE) -C $(KDIR) M=$(PWD) modules_install
	depmod -a

install-dkms:
	dkms add .
	dkms build -m $(PKGNAME) -v $(VERSION)
	dkms install -m $(PKGNAME) -v $(VERSION)

install-arch:
	makepkg -si

uninstall:
	rm -f /lib/modules/$(shell uname -r)/extra/hp-wmi.ko
	depmod -a

uninstall-dkms:
	dkms remove -m $(PKGNAME) -v $(VERSION) --all
	rm -rf /usr/src/$(PKGNAME)-$(VERSION)

.PHONY: all clean install uninstall install-dkms uninstall-dkms install-arch