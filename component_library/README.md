# Folder Overview

This folder contains the source code for the basic components used for the project.

* button_synchronizer:  VHDL source code for the button synchronizer, used for 
switches and click buttons.
* ctrl: VHDL source for the click controller and its testbench.
* delay: VHDL source code for the delay element.
* fork: VHDL source code for a click fork component.
* join: VHDL source code for a click join component.
* memory: VHDL source code for BRAM.
* rings: VHDL source code for a number of different ring configurations used 
for verifying the functionality of the controller, fork and join components.


# Verification

The following is an overview of the components which pass their tests in
Modelsim or some other form of verification.

- [ ] bram.vhdl (Not necessary to test)
- [X] button_synchronizer.vhdl
- [X] ctrl.vhdl
- [X] delay.vhdl (Verified LUT configuration in Vivado)
- [X] fork.vhdl
- [X] join.vhdl

For the rings

- [ ] XXXX.vhdl

# Testing

The following is an overview of the components which have been tested on
an FPGA.

- [ ] ctrl.vhdl
- [ ] delay.vhdl
- [ ] fork.vhdl
- [ ] join.vhdl
- [ ] memory.vhdl

For the rings

- [ ] XXXX.vhdl