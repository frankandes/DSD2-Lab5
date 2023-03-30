-- 'timescale 1 ns /1 ps
-- module WriteBackTB ;
-- reg [4:0] WriteReg;
-- reg RegWrite, MemtoReg;
-- reg [31:0] ALUResult, ReadData;
-- wire [31:0] Result;
-- wire [4:0] WriteRegOut;
-- wire RegWriteOut;
-- WriteBack uut ( .WriteReg(WriteReg),
-- . RegWrite(RegWrite),
-- . MemtoReg(MemtoReg),
-- . ALUResult(ALUResult),
-- . ReadData(ReadData),
-- . Result(Result),
-- . WriteRegOut(WriteRegOut),
-- initial begin
-- WriteReg = 5'b00000; #20
-- if (WriteRegOut !== 5'b00000) $display("WriteRegOut FAILED in %m");
-- WriteReg = 5'b11111; #20
-- if (WriteRegOut !== 5'b11111) $display("WriteRegOut FAILED in %m");
-- RegWrite = 1'b0; #20
-- if (RegWriteOut !== 1'b0) $display("RegWriteOut FAILED in %m");
-- RegWrite = 1'b1; #20
-- if (RegWriteOut !== 1'b1) $display("RegWriteOut FAILED in %m");
-- MemtoReg = 1'b0;
-- ALUResult = 32'h0;
-- ReadData = 32'hFFFFFFFF; #20
-- if (Result !== 32'h0) $display("Result FAILED with reg = 0 in %m");
-- MemtoReg = 1'b1; #20
-- if (Result !== 32'hFFFFFFFF) $display("Result FAILED with mem = FFFFFFFF in %m");
-- MemtoReg = 1'b0;
-- ALUResult = 32'h55555555;
-- ReadData = 32'hAAAAAAAA; #20
-- if (Result !== 32'h55555555) $display("Result FAILED with reg = 55555555 in %m");
-- MemtoReg = 1'b1; #20
-- if (Result !== 32'hAAAAAAAA) $display("Result FAILED in mem = AAAAAAAA %m");
-- end
-- endmodule


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
    uut: entity work.WritebackStage
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
            report "WriteRegOut FAILED in " & to_string(SEVERITY_LEVEL) severity failure;
        end if;
        WriteReg <= "11111"; wait for 20 ns;
        if (WriteRegOut /= "11111") then
            report "WriteRegOut FAILED in " & to_string(SEVERITY_LEVEL) severity failure;
        end if;
        RegWrite <= '0'; wait for 20 ns;
        if (RegWriteOut /= '0') then
            report "RegWriteOut FAILED in " & to_string(SEVERITY_LEVEL) severity failure;
        end if;
        RegWrite <= '1'; wait for 20 ns;
        if (RegWriteOut /= '1') then
            report "RegWriteOut FAILED in " & to_string(SEVERITY_LEVEL) severity failure;
        end if;
        MemtoReg <= '0';
        ALUResult <= x"00000000";
        ReadData <= x"FFFFFFFF"; wait for 20 ns;
        if (Result /= x"00000000") then
            report "Result FAILED with reg = 0 in " & to_string(SEVERITY_LEVEL) severity failure;
        end if;
        MemtoReg <= '1'; wait for 20 ns;
        if (Result /= x"FFFFFFFF") then
            report "Result FAILED with mem = FFFFFFFF in " & to_string(SEVERITY_LEVEL) severity failure;
        end if;
        MemtoReg <= '0';
        ALUResult <= x"55555555";
        ReadData <= x"AAAAAAAA"; wait for 20 ns;
        if (Result /= x"55555555") then
            report "Result FAILED with reg = 55555555 in " & to_string(SEVERITY_LEVEL) severity failure;
        end if;
        MemtoReg <= '1'; wait for 20 ns;
        if (Result /= x"AAAAAAAA") then
            report "Result FAILED in mem = AAAAAAAA " & to_string(SEVERITY_LEVEL) severity failure;
        end if;
        wait;
    end process;
end Behavioral;




