import os
import shutil
import glob
import math

from build_network.veriloggen.layer import *
from build_network.veriloggen.network import *
from build_network.veriloggen.rom import *



class SNNModel:
    def __init__(self, model_name="SNNModel", temporal_step=1):
        self.model_name = model_name
        self.model_step = temporal_step
        self.layers = []

    def add_layer(self, num_inputs, num_outputs, weights_file,
                  neuron_vth=64, neuron_width=8, neuron_shift=4):
        layer_id = len(self.layers)
        layer_name = f"Layer_{layer_id}"

        if not os.path.exists(weights_file):
            raise FileNotFoundError(f"Weights file not found: {weights_file}")

        self.layers.append({
            "name": layer_name,
            "num_inputs": num_inputs,
            "num_outputs": num_outputs,
            "weights_file": weights_file,
            "neuron_vth": neuron_vth,
            "neuron_shift": neuron_shift,
            "neuron_width": neuron_width
        })

        print(f"[+] Added layer '{layer_name}' — Inputs: {num_inputs}, Outputs: {num_outputs}, "
              f"V_th: {neuron_vth}, Width: {neuron_width}, Shift: {neuron_width}, "
              f"Weights: '{weights_file}'")


    def generate(self, path="."):
        model_dir = os.path.join(path, self.model_name)
        os.makedirs(model_dir, exist_ok=True)
        print(f"[~] Generating model '{self.model_name}' in '{model_dir}'...\n")

        # Copy Verilog files from shared folders before generating layers
        verilog_dirs = [
            "verilog/common/hdl",
            "verilog/layer/hdl",
            "verilog/network/hdl",
            "verilog/neuron/hdl"
        ]
        for vdir in verilog_dirs:
            if not os.path.exists(vdir):
                print(f"Warning: Verilog directory '{vdir}' not found.")
                continue
            for verilog_file in glob.glob(os.path.join(vdir, "*.[svv]*")):  # Matches .v and .sv
                shutil.copy(verilog_file, model_dir)
                print(f"[+] Copied '{verilog_file}' to '{model_dir}'")

        for layer in self.layers:
            name = layer["name"]
            num_inputs = layer["num_inputs"]
            num_outputs = layer["num_outputs"]
            weights_file = layer["weights_file"]
            neuron_width = layer["neuron_width"]
            shift_bits = layer["neuron_shift"]
            neuron_vth = layer["neuron_vth"]

            rom_split_name = f"ROM{num_inputs}x{num_outputs}Split"
            rom_name = f"ROM{num_inputs}x{num_outputs}"

            print(f"Generating ROM: {rom_name} from '{weights_file}'...")

            generate_ROM_MxN(
                directory=model_dir,
                module_name=rom_name,
                data_list=load_coe_data(weights_file)
            )

            generate_ROM_MxN_Split(
                directory=model_dir,
                split_module_name=rom_split_name,
                rom_module_name=rom_name,
                num_entries=num_inputs,
                data_width=neuron_width * num_outputs,
                num_chunks=num_outputs
            )

            print(f"Generating Layer module: {name}...")

            generate_layer_sv(
                directory=model_dir,
                module_name=name,
                num_inputs=num_inputs,
                num_outputs=num_outputs,
                neuron_width=neuron_width,
                neuron_shift=shift_bits,
                neuron_vth=neuron_vth
            )

            print(f"Layer '{name}' done.\n")

        if self.layers:
          generate_network_sv(
              directory=model_dir,
              module_name=self.model_name,
              num_inputs=self.layers[0]["num_inputs"],
              num_outputs=self.layers[-1]["num_outputs"],
              num_outputs_per_layer = [layer["num_outputs"] for layer in self.layers],
              cycles_cnt_bitwidth=self.layers[0]["num_inputs"],
              n_cycles=self.model_step
          )
        else:
          raise ValueError("Invalid or missing layer[0]")


        print(f"Model generation complete: {len(self.layers)} layers written to '{model_dir}'")

