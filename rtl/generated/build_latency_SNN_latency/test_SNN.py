# import cocotb
# from cocotb.triggers import RisingEdge, Timer, FallingEdge
# from cocotb.clock import Clock
# from cocotb.result import TestFailure
# from cocotb.binary import BinaryValue
# import numpy as np
# import os

# @cocotb.test()
# async def test_snn_with_raw_data(dut):
#     """
#     Load raw x_data (T_data, N_samples, M_IN) and y_labels (N_samples,)
#     → run classification on all samples via spike-count (rate encoding) and report accuracy.
#     """
#     # 1) Load data files
#     cwd = os.path.dirname(__file__)
#     x_data = np.load(os.path.join(cwd, "new_x_test_spikes.npy"))  # (T_data, N_samples, M_IN)
#     y_labels = np.load(os.path.join(cwd, "new_y_test_spikes.npy"))  # (N_samples,)

#     # 2) Infer data dimensions
#     T_data, N_samples, M_IN = x_data.shape
#     if y_labels.shape[0] != N_samples:
#         raise TestFailure(f"Sample count mismatch: x_data has {N_samples}, labels have {y_labels.shape[0]}")

#     # 3) Infer DUT port widths
#     in_width = len(dut.in_spikes_buffer)  # total input bits = M_IN * TIMESTEPS
#     if in_width % M_IN != 0:
#         raise TestFailure(f"in_spikes_buffer width {in_width} not divisible by M_IN {M_IN}")
#     TIMESTEPS = in_width // M_IN

#     out_width = len(dut.out_spikes_buffer)  # total output bits = M_OUT * TIMESTEPS
#     if out_width % TIMESTEPS != 0:
#         raise TestFailure(f"out_spikes_buffer width {out_width} not divisible by TIMESTEPS {TIMESTEPS}")
#     M_OUT = out_width // TIMESTEPS

#     dut._log.info(f"x_data shape = {x_data.shape}, y_labels shape = {y_labels.shape}")
#     dut._log.info(f"Inferred M_IN={M_IN}, TIMESTEPS={TIMESTEPS}, M_OUT={M_OUT}")

#     # 4) Start clock and reset
#     cocotb.start_soon(Clock(dut.clk, 10, units='ns').start())

#     await FallingEdge(dut.clk)  # wait for initial clock edge
#     dut.rst.value = 1
#     dut.start.value = 0
#     dut.sample_ready.value = 1


#     await FallingEdge(dut.clk)
#     dut.rst.value = 0

#     await FallingEdge(dut.clk)

#     while (dut.ready.value != 1):
#         await FallingEdge(dut.clk)

#     # 5) Run classification on all samples

#     correct_count = 0
#     for i in range(N_samples):
#         label = int(y_labels[i])

#         # raw already contains binary spikes (0 or 1)
#         spikes = x_data[:TIMESTEPS, i, :].astype(int)  # (TIMESTEPS, M_IN)
#         flat_in = spikes.flatten()                     # length = TIMESTEPS * M_IN

#         # pack and drive input using BinaryValue
#         bin_str = ''.join(str(bit) for bit in flat_in)
#         dut.in_spikes_buffer.value = BinaryValue(
#             value=bin_str,
#             n_bits=in_width,
#             bigEndian=True
#         )

#         # trigger inference
#         await FallingEdge(dut.clk)
#         dut.start.value = 1

#         await FallingEdge(dut.clk)
#         dut.start.value = 0

#         # wait for ready
#         timeout = 10000
#         while not dut.ready.value and timeout > 0:
#             await FallingEdge(dut.clk)
#             timeout -= 1

#         if timeout == 0:
#             raise TestFailure("Timeout waiting for DUT.ready")

#         await FallingEdge(dut.clk)


#         # read and reshape output spike-train
#         out_val = int(dut.out_spikes_buffer.value)
#         out_bits = np.array(list(map(int, f"{out_val:0{out_width}b}")), dtype=int)
#         out_mat = out_bits.reshape(TIMESTEPS, M_OUT)

#         # classification: rate encoding → sum spikes over all timesteps
#         spike_counts = out_mat.sum(axis=0)
#         predicted = int(np.argmax(spike_counts))
#         dut._log.info(f"Sample {i}: label={label}, spike_counts={spike_counts.tolist()}, predicted={predicted}")

#         # tally correctness
#         if predicted == label:
#             correct_count += 1


#     # 6) Report accuracy
#     accuracy = correct_count / N_samples * 100
#     dut._log.info(f"Total accuracy: {correct_count}/{N_samples} = {accuracy:.2f}%")

#     # Optionally, you can assert a minimum accuracy threshold
#     # if accuracy < 90:
#     #     raise TestFailure(f"Accuracy below threshold: {accuracy:.2f}% < 90%")



import cocotb
from cocotb.triggers import RisingEdge, FallingEdge, Timer
from cocotb.clock import Clock
from cocotb.result import TestFailure
from cocotb.binary import BinaryValue
import numpy as np
import os

@cocotb.test()
async def test_snn_with_raw_data(dut):
   
    # 1) Load waveform data and labels
    cwd = os.path.dirname(__file__)
    x_data = np.load(os.path.join(cwd, "latency_spike_x.npy"))  # shape: (TIMESTEPS, N_samples, M_IN)
    y_labels = np.load(os.path.join(cwd, "latency_spike_y.npy"))  # shape: (N_samples,)

    # 2) Sanity-check dimensions
    TIMESTEPS = 10
    M_IN = 83
    M_OUT = 3
    N_samples = x_data.shape[1]

    dut._log.info(f"Running {N_samples} samples | TIMESTEPS={TIMESTEPS}, M_IN={M_IN}, M_OUT={M_OUT}")

    # 4) Clock and reset sequence
    cocotb.start_soon(Clock(dut.clk, 10, units='ns').start())

    await FallingEdge(dut.clk)
    dut.rst.value = 1
    dut.sample_ready.value = 1
    dut.start.value = 0

    await FallingEdge(dut.clk)
    dut.rst.value = 0

    await FallingEdge(dut.clk)
    # wait for DUT to signal ready before starting samples
    while not dut.ready.value:
        await FallingEdge(dut.clk)

    # 5) Iterate through samples, drive inputs, and collect outputs
    correct = 0


    for idx in range(N_samples):
        label = int(y_labels[idx])

        # Drive each timestep slice of in_spikes_buffer
        for t in range(TIMESTEPS):
            vec = x_data[t, idx, :].astype(int)  # binary vector length M_IN
            
            rev_vec = vec[::-1]                                # e.g. […,1,0,1,0]

            bitstr = ''.join(str(b) for b in rev_vec)
            # print(f"original: {vec}")
            vector = BinaryValue(value=bitstr, n_bits=M_IN, bigEndian=True)
            dut.in_spikes_buffer[t].value = vector

        # Trigger inference
        await FallingEdge(dut.clk)
        dut.start.value = 1

        await FallingEdge(dut.clk)
        dut.start.value = 0

        # for t in range(TIMESTEPS):
        #     print(dut.in_spikes_buffer[t].value)

        while not dut.ready.value:
            await FallingEdge(dut.clk)
    

        await FallingEdge(dut.clk)
        # Read output unpacked per timestep

        # for t in range(TIMESTEPS):
        #    print(dut.out_spikes_buffer[t].value.binstr)
    

        # out_mat = np.zeros((TIMESTEPS, M_OUT), dtype=int)
        # for t in range(TIMESTEPS):
        #     val = int(dut.out_spikes_buffer[t].value)
        #     bs = f"{val:0{M_OUT}b}"
        #     out_mat[t, :] = [int(x) for x in bs]

        out_mat = np.zeros((TIMESTEPS, M_OUT), dtype=int)
        
        for t in range(TIMESTEPS):
            val = int(dut.out_spikes_buffer[t].value)
            # MSB-first bitstring
            bs = f"{val:0{M_OUT}b}"        # e.g. "01011…"
            # flip it to LSB-first
            bs_rev = bs[::-1]             # e.g. "…11010"
            # fill row with reversed bits
            out_mat[t, :] = [int(x) for x in bs_rev]

        
        # Find first spike for each class
        first_spike_times = np.full(M_OUT, TIMESTEPS)  # Init to max (no spike yet)

        for c in range(M_OUT):
            spike_times = np.where(out_mat[:, c] == 1)[0]  # All timesteps where this class spikes
            if len(spike_times) > 0:
                first_spike_times[c] = spike_times[0]  # Take the earliest spike time

        # Predict the class with the earliest spike
        pred = int(np.argmin(first_spike_times))
        dut._log.info(f"Sample {idx}: true={label}, first_spikes={first_spike_times.tolist()}, pred={pred}")

        if pred == label:
            correct += 1

    # 6) Compute and log accuracy
    acc = correct / N_samples * 100
    dut._log.info(f"Final Accuracy: {correct}/{N_samples} = {acc:.2f}%")

