library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity WriteBack is
    port (
        WriteReg : in std_logic_vector(4 downto 0);
        RegWrite : in std_logic;
        MemtoReg : in std_logic;
        ALUResult : in std_logic_vector(31 downto 0);
        ReadData : in std_logic_vector(31 downto 0);
        Result : out std_logic_vector(31 downto 0);
        WriteRegOut : out std_logic_vector(4 downto 0);
        RegWriteOut : out std_logic
    );
end WriteBack;

architecture Behavioral of WriteBack is
begin
    process (ReadData, MemtoReg, ALUResult)
    begin
        if (MemtoReg = '1') then
            Result <= ReadData;
        else
            Result <= ALUResult;
        end if;
    end process;

    WriteRegOut <= WriteReg;
    RegWriteOut <= RegWrite;
end Behavioral;
