# Folder Overview

This folder contains the source code for the basic components used for the project.

* bram: VHDL source code for BRAM.
* buffer: VHDL source code for a buffer
* button_synchronizer:  VHDL source code for the button synchronizer, used for 
switches and click buttons.
* ctrl: VHDL source for the click controller and its testbench.
* ctrl_delay: VHDL source for the click controller with delays and its testbench.
* delay: VHDL source code for the delay element.
* fork: VHDL source code for a click fork component.
* gcd_3stage: VHDL source code for the 3-stage Asynchronous GCD circuit
* join: VHDL source code for a click join component.
* rings: VHDL source code for a number of different ring configurations used 
for verifying the functionality of the controller, fork and join components.
* rom: VHDL source code for a ROM used for test-vectors.
* top_level_verification_circuit: The top-level for the verification circuit on the FPGA.
* verification_circuit: Verification circuit for the GCD circuit


# Verification

The following is an overview of the components which pass their tests in
Modelsim or some other form of verification.

- [ ] bram.vhdl (Not necessary to test)
- [ ] buffer.vhdl (Not necessary to test, tested together with delay.vhdl)
- [X] button_synchronizer.vhdl
- [X] ctrl.vhdl
- [X] ctrl_delay.vhdl
- [X] delay.vhdl (Verified LUT configuration in Vivado)
- [X] fork.vhdl
- [ ] gcd_3stage
- [X] join.vhdl
- [ ] rom.vhdl (Not necessary to test by itself, tested in verification_circuit.vhdl)
- [ ] top_level_verification_circuit.vhdl
- [ ] verification_circuit.vhdl

For the rings

- [ ] XXXX.vhdl

# Testing

The following is an overview of the components which have been tested on
an FPGA either directly or indirectly.

- [ ] bram.vhdl (Not necessary to test)
- [X] buffer.vhdl (Not necessary to test, tested together with delay.vhdl)
- [X] button_synchronizer.vhdl
- [X] ctrl.vhdl
- [X] ctrl_delay.vhdl
- [X] delay.vhdl (Verified LUT configuration in Vivado)
- [ ] fork.vhdl
- [ ] gcd_3stage
- [ ] join.vhdl
- [ ] rom.vhdl (Not necessary to test by itself, tested in verification_circuit.vhdl)
- [ ] top_level_verification_circuit.vhdl
- [ ] verification_circuit.vhdl


For the rings

- [ ] XXXX.vhdl