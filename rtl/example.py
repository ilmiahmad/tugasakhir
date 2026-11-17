from build_network.gen_network import SNNModel
from build_network.utils import *

# model = SNNModel("SNN_latency",10)


# # model.add_layer(
# #     num_inputs=5,
# #     num_outputs=15,
# #     weights_file="fc1_weights.coe",
# #     neuron_vth=to_fixed(1.0, 8, 6),
# #     neuron_width=8,
# #     neuron_shift=7
# # )


# # model.add_layer(
# #     num_inputs=15,
# #     num_outputs=10,
# #     weights_file="fc2_weights.coe",
# #     neuron_vth=to_fixed(1.0, 8, 6),
# #     neuron_width=8,
# #     neuron_shift=7
# # )

# # model.add_layer(
# #     num_inputs=32,
# #     num_outputs=64,
# #     weights_file="fc0_weights_new.coe",
# #     neuron_vth=to_fixed(0.3152, 8, 6),
# #     neuron_width=8,
# #     neuron_shift=7
# # )


# # model.add_layer(
# #     num_inputs=64,
# #     num_outputs=3,
# #     weights_file="fc1_weights_new.coe",
# #     neuron_vth=to_fixed(1.5529, 8, 6),
# #     neuron_width=8,
# #     neuron_shift=7
# # )


# # model.generate(path="./build")


# model.add_layer(
#     num_inputs=83,
#     num_outputs=64,
#     weights_file="latency_fc0_weights.coe",
#     neuron_vth=to_fixed(0.24, 8, 6),
#     neuron_width=8,
#     neuron_shift=7
# )


# model.add_layer(
#     num_inputs=64,
#     num_outputs=32,
#     weights_file="latency_fc1_weights.coe",
#     neuron_vth=to_fixed(0.63, 8, 6),
#     neuron_width=8,
#     neuron_shift=7
# )

# model.add_layer(
#     num_inputs=32,
#     num_outputs=3,
#     weights_file="latency_fc2_weights.coe",
#     neuron_vth=to_fixed(1.82, 8, 6),
#     neuron_width=8,
#     neuron_shift=7
# )

# model.generate(path="./build_latency")



# model = SNNModel("SNN_rate",20)

# model.add_layer(
#     num_inputs=83,
#     num_outputs=64,
#     weights_file="new_rate_fc0_weights.coe",
#     neuron_vth=to_fixed(0.24, 8, 6),
#     neuron_width=8,
#     neuron_shift=7
# )


# model.add_layer(
#     num_inputs=64,
#     num_outputs=32,
#     weights_file="new_rate_fc1_weights.coe",
#     neuron_vth=to_fixed(0.6, 8, 6),
#     neuron_width=8,
#     neuron_shift=7
# )

# model.add_layer(
#     num_inputs=32,
#     num_outputs=3,
#     weights_file="new_rate_fc2_weights.coe",
#     neuron_vth=to_fixed(1.07, 8, 6),
#     neuron_width=8,
#     neuron_shift=7
# )

# model.generate(path="./build_rate")


model = SNNModel("SNN_lat",10)

model.add_layer(
    num_inputs=83,
    num_outputs=64,
    weights_file="new_lat_fc0_weights.coe",
    neuron_vth=to_fixed(0.199, 8, 5),
    neuron_width=8,
    neuron_shift=7
)


model.add_layer(
    num_inputs=64,
    num_outputs=32,
    weights_file="new_lat_fc1_weights.coe",
    neuron_vth=to_fixed(0.66, 8, 5),
    neuron_width=8,
    neuron_shift=7
)

model.add_layer(
    num_inputs=32,
    num_outputs=3,
    weights_file="new_lat_fc2_weights.coe",
    neuron_vth=to_fixed(1.87, 8, 5),
    neuron_width=8,
    neuron_shift=7
)

model.generate(path="./build_lat")