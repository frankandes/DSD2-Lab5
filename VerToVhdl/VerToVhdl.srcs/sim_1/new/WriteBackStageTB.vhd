library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity WriteBackTB is
end WriteBackTB;

architecture Behavioral of WriteBackTB is

    signal WriteReg: std_logic_vector(4 downto 0);
    signal RegWrite: std_logic;
    signal MemtoReg: std_logic;
    signal ALUResult: std_logic_vector(31 downto 0);
    signal ReadData: std_logic_vector(31 downto 0);
    signal Result: std_logic_vector(31 downto 0);
    signal WriteRegOut: std_logic_vector(4 downto 0);
    signal RegWriteOut: std_logic;

begin
    uut: entity work.Writeback
        port map(
            WriteReg => WriteReg,
            RegWrite => RegWrite,
            MemtoReg => MemtoReg,
            ALUResult => ALUResult,
            ReadData => ReadData,
            Result => Result,
            WriteRegOut => WriteRegOut,
            RegWriteOut => RegWriteOut
        );

    process
    begin
        WriteReg <= "00000"; wait for 20 ns;
        if (WriteRegOut /= "00000") then
            report "WriteRegOut FAILED in " severity failure;
        end if;
        WriteReg <= "11111"; wait for 20 ns;
        if (WriteRegOut /= "11111") then
            report "WriteRegOut FAILED in " severity failure;
        end if;
        RegWrite <= '0'; wait for 20 ns;
        if (RegWriteOut /= '0') then
            report "RegWriteOut FAILED in " severity failure;
        end if;
        RegWrite <= '1'; wait for 20 ns;
        if (RegWriteOut /= '1') then
            report "RegWriteOut FAILED in " severity failure;
        end if;
        MemtoReg <= '0';
        ALUResult <= x"00000000";
        ReadData <= x"FFFFFFFF"; wait for 20 ns;
        if (Result /= x"00000000") then
            report "Result FAILED with reg = 0 in " severity failure;
        end if;
        MemtoReg <= '1'; wait for 20 ns;
        if (Result /= x"FFFFFFFF") then
            report "Result FAILED with mem = FFFFFFFF in " severity failure;
        end if;
        MemtoReg <= '0';
        ALUResult <= x"55555555";
        ReadData <= x"AAAAAAAA"; wait for 20 ns;
        if (Result /= x"55555555") then
            report "Result FAILED with reg = 55555555 in " severity failure;
        end if;
        MemtoReg <= '1'; wait for 20 ns;
        if (Result /= x"AAAAAAAA") then
            report "Result FAILED in mem = AAAAAAAA " severity failure;
        end if;
        wait;
    end process;
end Behavioral;
