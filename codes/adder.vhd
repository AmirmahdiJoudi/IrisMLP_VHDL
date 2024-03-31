LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY adder IS
    GENERIC (
        size :INTEGER := 8
    );
    PORT (
        inA : IN STD_LOGIC_VECTOR (size-1 DOWNTO 0);
        inB : IN STD_LOGIC_VECTOR (size-1 DOWNTO 0);
        outY : OUT STD_LOGIC_VECTOR (size-1 DOWNTO 0)
    );
END ENTITY adder;

ARCHITECTURE behavioral OF adder IS
BEGIN

    outY <= STD_LOGIC_VECTOR (signed(inA) + signed(inB));

END ARCHITECTURE behavioral;