import math
import os

def generate_ROM_MxN(directory, module_name, data_list):
    num_rows = len(data_list)
    data_width = len(data_list[0])
    addr_width = max(1, math.ceil(math.log2(num_rows)))

    with open(f"{directory}/{module_name}.sv", "w") as f:
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



def generate_ROM_MxN_Split(directory, split_module_name, rom_module_name, num_entries, data_width, num_chunks):
    addr_width = max(1, math.ceil(math.log2(num_entries)))

    with open(f"{directory}/{split_module_name}.sv", "w") as f:
        f.write(f"""\
// Auto-generated ROM split module: {split_module_name}
// Wraps {rom_module_name} and splits its {data_width}-bit output into {num_chunks}x8-bit outputs
// Also provides the full 'total' output

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
