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
        await Timer(1, units="ns")  # Small delay before checking
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
async def test_srlatch(dut):
    await setup_clock(dut)  # Setup clock for input signal
    dut.set_sr.setimmediatevalue = 0  # Initialize inputs
    dut.reset_sr.setimmediatevalue = 1
 
    await Timer(10, units="ns")  # Allow time for initial stabilization

    async def test_combination(set_val, reset_val, expected_q, expected_q_not):
        dut.set_sr.setimmediatevalue = set_val
        dut.reset_sr.setimmediatevalue = reset_val
        await Timer(10, units="ns")  # Allow propagation delay
        actual_q = dut.q_sr.value
        actual_q_not = dut.q_not_sr.value

        if actual_q != expected_q or actual_q_not != expected_q_not:
            assert (f"Failed: set={set_val}, reset={reset_val}: "
                    f"Expected q={expected_q}, q_not={expected_q_not}, "
                    f"Got q={actual_q}, q_not={actual_q_not}")
        else:
            dut._log.info(f"Passed: set={set_val}, reset={reset_val}: "
                            f"q={actual_q}, q_not={actual_q_not}")

    # Test sequence - Comprehensive
    await test_combination(1, 0, 1, 0)  # Set
    await test_combination(0, 0, 1, 0)  # Hold after set
    await test_combination(0, 1, 0, 1)  # Reset
    await test_combination(0, 0, 0, 1)  # Hold after reset
    await test_combination(1, 0, 1, 0)  # Set again

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

@cocotb.test()
async def test_full_adder(dut):
    # Helper function to apply inputs and check outputs
    async def apply_and_check(a, b, cin, expected_sum, expected_carry):
        dut.a_fa.value = a
        dut.b_fa.value = b
        dut.cin_fa.value = cin
        await Timer(1, units="ns")
        assert dut.s_fa.value == expected_sum, f"Sum mismatch: a={a}, b={b}, cin={cin}, expected={expected_sum}, got={dut.s_fa.value}"
        assert dut.cout_fa.value == expected_carry, f"Carry out mismatch: a={a}, b={b}, cin={cin}, expected={expected_carry}, got={dut.cout_fa.value}"

    # Test all possible input combinations
    test_vectors = [
        (0, 0, 0, 0, 0),  # a, b, cin, expected_sum, expected_carry
        (0, 0, 1, 1, 0),
        (0, 1, 0, 1, 0),
        (0, 1, 1, 0, 1),
        (1, 0, 0, 1, 0),
        (1, 0, 1, 0, 1),
        (1, 1, 0, 0, 1),
        (1, 1, 1, 1, 1)
    ]

    for vector in test_vectors:
        a, b, cin, expected_sum, expected_carry = vector
        await apply_and_check(a, b, cin, expected_sum, expected_carry)

@cocotb.test()
async def test_dm74ls283_quad_adder(dut):
    # Helper function to apply inputs and check outputs
    async def apply_and_check(a_vals, b_vals, cin, expected_sum, expected_cout):
        # Applying input values
        dut.a_cla.value = int("".join(map(str, a_vals[::-1])), 2) # Converts list to integer
        dut.b_cla.value = int("".join(map(str, b_vals[::-1])), 2)
        dut.cin_cla.value = cin
        await Timer(1, units="ns")
        
        # Convert dut outputs to integers for comparison
        actual_sum = [dut.sum_cla[i].value.integer for i in range(1, 5)]
        actual_cout = dut.cout_cla.value.integer
        
        # Verifying the outputs
        assert actual_sum == expected_sum, f"Sum mismatch: a={a_vals}, b={b_vals}, cin={cin}, expected={expected_sum}, got={actual_sum}"
        assert actual_cout == expected_cout, f"Carry out mismatch: a={a_vals}, b={b_vals}, cin={cin}, expected={expected_cout}, got={actual_cout}"

    # Test vectors as tuples: (a, b, cin, expected_sum, expected_cout)
    test_vectors = [
        ([0, 0, 0, 0], [0, 0, 0, 0], 0, [0, 0, 0, 0], 0),
        ([0, 0, 0, 1], [0, 0, 0, 1], 0, [0, 0, 0, 0], 1),  # 1 + 1 = 10
        ([0, 0, 1, 1], [0, 0, 1, 0], 0, [0, 0, 0, 1], 1),  # 11 + 10 = 101
        ([1, 1, 1, 1], [1, 1, 1, 1], 0, [0, 1, 1, 1], 1),  # 1111 + 1111 = 11110
        ([1, 0, 1, 0], [0, 1, 0, 1], 1, [0, 0, 0, 0], 1),  # 1010 + 0101 + 1 = 10000
        ([1, 1, 1, 1], [0, 0, 0, 0], 1, [1, 1, 1, 0], 0),  # 1111 + 0000 + 1 = 01111
        ([1, 0, 1, 0], [1, 0, 1, 0], 0, [0, 1, 0, 1], 1),  # 1010 + 1010 = 10100
        ([0, 1, 0, 1], [1, 0, 0, 1], 1, [1, 1, 0, 1], 0),  # 0101 + 1001 + 1 = 1101 (+ carry-out 0)
    ]

    # Loop over the test vectors and run the tests
    for vector in test_vectors:
        a, b, cin, expected_sum, expected_cout = vector
        await apply_and_check(a, b, cin, expected_sum, expected_cout)