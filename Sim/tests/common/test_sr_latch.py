import cocotb
from cocotb.triggers import Timer
from cocotb.result import TestFailure

@cocotb.test()
async def test_sr_latch(dut):
    """Test SR latch functionality"""

    dut.set.value = 0  # Initialize inputs
    dut.reset.value = 1
    await Timer(10, units="ns")  # Allow time for initial stabilization

    async def test_combination(set_val, reset_val, expected_q, expected_q_not):
        dut.set.value = set_val
        dut.reset.value = reset_val
        await Timer(10, units="ns")  # Allow propagation delay
        actual_q = dut.q.value
        actual_q_not = dut.q_not.value

        if actual_q != expected_q or actual_q_not != expected_q_not:
            assert TestFailure(f"Failed: set={set_val}, reset={reset_val}: "
                             f"Expected q={expected_q}, q_not={expected_q_not}, "
                             f"Got q={actual_q}, q_not={actual_q_not}")
        else:  # Optional: print success for each test case
            dut._log.info(f"Passed: set={set_val}, reset={reset_val}: "
                         f"q={actual_q}, q_not={actual_q_not}")


    # Test sequence - Comprehensive
    await test_combination(1, 0, 1, 0)  # Set
    await test_combination(0, 0, 1, 0)  # Hold after set
    await test_combination(0, 1, 0, 1)  # Reset
    await test_combination(0, 0, 0, 1)  # Hold after reset
    await test_combination(1, 0, 1, 0)  # Set again
