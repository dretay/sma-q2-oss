include conf/protobuff.mk

OBJCOPY = arm-none-eabi-objcopy

#our default target is to compile all the proto files into c files, then to generate all the objects
all: $(PBMODELS) $(OBJECTS)

#create a bin file for flashing
$(RELEASE_DIR)$(PROJECT_NAME).bin: $(BUILD_DIR)$(PROJECT_NAME).$(TARGET_EXTENSION)
	$(MKDIR) $(dir $@)
	$(OBJCOPY) -O binary $< $@

#create a hex file for flashing
$(RELEASE_DIR)$(PROJECT_NAME).hex: $(BUILD_DIR)$(PROJECT_NAME).$(TARGET_EXTENSION)
	$(MKDIR) $(dir $@)
	$(OBJCOPY) -O ihex $< $@

#link objects into an so to be included elsewhere
$(BUILD_DIR)$(PROJECT_NAME).out: $(OBJECTS)
	$(CC) $(LDFLAGS) $(OBJECTS) $(LIBS) -lm -o $@

# assembly
$(BUILD_DIR)%.o: %.s
	$(MKDIR) $(dir $@)
	$(CC) $(ASMFLAGS) -c $< -o $@

# c source
$(BUILD_DIR)%.c.o: %.c
	$(MKDIR) $(dir $@)
	$(CC) $(CFLAGS) $(INC_DIRS) -c $< -o $@