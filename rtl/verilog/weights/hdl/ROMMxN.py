import math

def generate_ROM_MxN(module_name, data_list):
    num_rows = len(data_list)
    data_width = len(data_list[0])
    addr_width = max(1, math.ceil(math.log2(num_rows)))

    with open(f"{module_name}.sv", "w") as f:
        f.write(f"""\
                
// Auto-generated ROM module: {module_name}
// {num_rows} entries, {data_width} bits wide

module {module_name} (
  input  logic [{addr_width - 1}:0] addr,  // address input
  input  logic                      clk,   // clock
  input  logic                      rst,   // active-high reset
  output logic [{data_width - 1}:0] data   // ROM data output
);

  // ROM storage
  logic [{data_width - 1}:0] rom [0:{num_rows - 1}];
  logic [{data_width - 1}:0] dout;

  // ROM initialization
  initial begin
""")
        for i, binary in enumerate(data_list):
            formatted = "_".join([binary[j:j+8] for j in range(0, len(binary), 8)])
            f.write(f"    rom[{i}] = {data_width}'b{formatted};\n")

        f.write(f"""  end

  // Sequential logic
  always_ff @(posedge clk) begin
    if (rst)
      dout <= {data_width}'d0;
    else if (addr < {num_rows})
      dout <= rom[addr];
    else
      dout <= {data_width}'d0;
  end

  // Output assignment
  assign data = dout;

endmodule
""")


# Optional: helper to load from COE file (if requested later)
def load_coe_data(filename):
    """
    Load binary ROM data from a .coe file (assuming binary radix).
    """
    data = []
    reading = False
    with open(filename, "r") as file:
        for line in file:
            line = line.strip()
            if line.startswith("memory_initialization_vector"):
                reading = True
                line = line.split("=")[1]  # remove everything before '='
            if reading:
                line = line.replace(";", "").replace(" ", "")
                data.extend([val for val in line.split(",") if val])
    return data


def generate_ROM_MxN_Split(split_module_name, rom_module_name, num_entries, data_width):

    addr_width = max(1, math.ceil(math.log2(num_entries)))
    num_chunks = math.ceil(data_width / 8)

    with open(f"{split_module_name}.sv", "w") as f:
        f.write(f"""\
// Auto-generated ROM split module: {split_module_name}
// Wraps {rom_module_name} and splits its {data_width}-bit output into {num_chunks}x8-bit outputs

module {split_module_name} (
  input  logic                   clk,
  input  logic                   rst,
  input  logic [{addr_width-1}:0] addr,
  output logic [7:0]             dout [{num_chunks - 1}:0]
);

  logic [{data_width - 1}:0] rom_data;

  // Instantiate base ROM
  {rom_module_name} rom_inst (
    .clk   (clk),
    .rst   (rst),
    .addr  (addr),
    .data  (rom_data)
  );

  // Split into 8-bit chunks (MSB-first)
  genvar i;
  generate
    for (i = 0; i < {num_chunks}; i++) begin
      assign dout[i] = rom_data[{data_width - 1} - 8*i -: 8];
    end
  endgenerate

endmodule
""")

# module_name = "ROM5x10"
# data = [
#         "11111010101100000000111100110111000011100000110111101110010100011111010000011011",
#         "00101100010111101000000010100001010000110010011111100110111010000000110100101100",
#         "11101011111000000001001011101001010001010001000000010110111001110001011000010101",
#         "00111011000010100010111110010110111100111000000000110011001001000010101110000101",
#         "00000011001101100010011000101100100101110010010100011010110011100000001000001110"
# ]
# generate_ROM_MxN(module_name, data)
# generate_ROM_MxN_Split("ROM5x10Split", "ROM5x80", num_entries=5, data_width=8*10)
