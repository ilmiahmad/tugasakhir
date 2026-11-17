def to_float(fixed_val: int, total_bits: int, frac_bits: int, signed=True) -> float:
    """
    Convert fixed-point integer to float.

    Args:
        fixed_val (int): The fixed-point integer value.
        total_bits (int): Total number of bits in the fixed-point format.
        frac_bits (int): Number of fractional bits.
        signed (bool): Whether the value is signed or not.

    Returns:
        float: The corresponding float value.
    """
    if signed:
        # Handle two's complement if negative
        if fixed_val & (1 << (total_bits - 1)):
            fixed_val -= (1 << total_bits)
    return fixed_val / (2 ** frac_bits)


def to_fixed(value: float, total_bits: int, frac_bits: int) -> int:
    """
    Convert a float to fixed-point representation as an integer.
    
    Parameters:
        value (float): The float value to convert.
        total_bits (int): Total number of bits in the fixed-point number.
        frac_bits (int): Number of fractional bits.

    Returns:
        int: Integer representation of the fixed-point value.
    """
    scaling_factor = 1 << frac_bits  # same as 2**frac_bits
    fixed_val = int(round(value * scaling_factor))

    # Optional: wrap around for signed values
    max_val = (1 << (total_bits - 1)) - 1
    min_val = - (1 << (total_bits - 1))

    if fixed_val > max_val or fixed_val < min_val:
        raise ValueError(f"Value {value} out of range for {total_bits}-bit signed fixed-point.")

    return fixed_val