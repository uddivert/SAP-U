import cocotb
from cocotb.triggers import RisingEdge, FallingEdge, Timer
from cocotb.clock import Clock

# Utility function to setup clock
async def setup_clock(dut, period_ns=10):
    clock = Clock(dut.clk, period_ns, units="ns")  # Create a clock for dut.clk
    cocotb.start_soon(clock.start())  # Start the clock

@cocotb.test()
async def test_dff(dut):
    await setup_clock(dut)  # Set up the clock for input signal
    dut.reset_dff.setimmediatevalue(0)
    dut.data_dff.setimmediatevalue(0)

    # Reset the DFF
    dut.reset_dff.value = 1
    await RisingEdge(dut.clk)
    dut.reset_dff.value = 0

    # Test the D flip-flop behavior
    for i in range(10):
        dut.data_dff.value = i % 2
        await RisingEdge(dut.clk)
        assert dut.q_dff.value == dut.data_dff.value, f"Mismatch Q={dut.q_dff.value}, expected={dut.data_dff.value}"
        assert dut.q_not_dff.value == ~dut.data_dff.value, f"Mismatch Not Q={dut.q_not_dff.value}, expected={~dut.data_dff.value & 1}"

        # Introduce delay to allow manual observation in case of running on an actual simulator
        await Timer(5, units="ns")

    # Toggle Reset and check outputs
    dut.reset_dff.value = 1
    await RisingEdge(dut.clk)
    dut.reset_dff.value = 0
    await FallingEdge(dut.clk)
    assert dut.q_dff.value == 0, "Mismatch after reset Q should be 0"
    assert dut.q_not_dff.value == 1, "Mismatch after reset Not Q should be 1"

@cocotb.test()
async def test_dlatch(dut):
    await setup_clock(dut)  # Set up the clock for input signal
    dut.enable_dl.setimmediatevalue(0)
    dut.data_dl.setimmediatevalue(0)

    # Test the D latch behavior
    for i in range(4):
        dut.data_dl.value = i % 2
        dut.enable_dl.value = 1
        await Timer(5, units="ns")  # Wait for some time to ensure data is latched
        assert dut.q_dl.value == dut.data_dl.value, f"Mismatch Q={dut.q_dl.value}, expected={dut.data_dl.value}"
        assert dut.q_not_dl.value == ~dut.data_dl.value, f"Mismatch Not Q={dut.q_not_dl.value}, expected={~dut.data_dl.value & 1}"

        # Disable the latch and change data
        dut.enable_dl.value = 0
        dut.data_dl.value = (i + 1) % 2
        await Timer(5, units="ns")
        assert dut.q_dl.value == i % 2, f"Latch should hold the value Q={dut.q_dl.value}, expected={i % 2}"

        # Enable and check again
        dut.enable_dl.value = 1
        await Timer(5, units="ns")
        assert dut.q_dl.value == dut.data_dl.value, f"Latch didn't update Q={dut.q_dl.value}, expected={dut.data_dl.value}"
        assert dut.q_not_dl.value == ~dut.data_dl.value, f"Mismatch Not Q={dut.q_not_dl.value}, expected={~dut.data_dl.value & 1}"

    # Disable latch and verify it holds the last value
    dut.enable_dl.value = 0
    last_value = dut.q_dl.value
    await Timer(5, units="ns")
    assert dut.q_dl.value == last_value, f"Latch should hold the last value Q={dut.q_dl.value}, expected={last_value}"