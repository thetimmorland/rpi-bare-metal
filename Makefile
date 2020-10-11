SOURCE_DIR = src
BUILD_DIR = build

ASM_SOURCES = $(wildcard $(SOURCE_DIR)/*.s)
C_SOURCES = $(wildcard $(SOURCE_DIR)/*.c)

OBJECTS = $(patsubst $(SOURCE_DIR)/%.s,$(BUILD_DIR)/%.o,$(ASM_SOURCES))
OBJECTS += $(patsubst $(SOURCE_DIR)/%.c,$(BUILD_DIR)/%.o,$(C_SOURCES))

LINK_SCRIPT = $(SOURCE_DIR)/link.ld

CFLAGS = -Wall -g -O0 -ffreestanding -nostdinc -nostdlib -nostartfiles
LDFLAGS = -nostdlib -nostartfiles

all: $(BUILD_DIR)/kernel.img $(BUILD_DIR)/kernel.dump

$(BUILD_DIR)/kernel.img: $(BUILD_DIR)/kernel.elf
	arm-none-eabi-objcopy $^ -O binary $@

$(BUILD_DIR)/kernel.dump: $(BUILD_DIR)/kernel.elf
	arm-none-eabi-objdump -S --disassemble $< > $@

$(BUILD_DIR)/kernel.elf: $(OBJECTS)
	arm-none-eabi-ld $(LDFLAGS) $^ -T $(LINK_SCRIPT) -o $@

$(BUILD_DIR)/%.o: $(SOURCE_DIR)/%.s
	arm-none-eabi-gcc $(CFLAGS) -c $< -o $@

$(BUILD_DIR)/%.o: $(SOURCE_DIR)/%.c
	arm-none-eabi-gcc $(CFLAGS) -c $< -o $@