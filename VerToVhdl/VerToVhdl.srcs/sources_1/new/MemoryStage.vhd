library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity MemoryStage is
    port (
        clk : in std_logic;
        rst : in std_logic;
        MemtoReg : in std_logic;
        RegWrite : in std_logic;
        WriteReg : in std_logic_vector(4 downto 0);
        MemWrite : in std_logic;
        ALUResult : in std_logic_vector(31 downto 0);
        WriteData : in std_logic_vector(31 downto 0);
        Switches : in std_logic_vector(15 downto 0);
        RegWriteOut : out std_logic;
        MemtoRegOut : out std_logic;
        WriteRegOut : out std_logic_vector(4 downto 0);
        MemOut : out std_logic_vector(31 downto 0);
        ALUResultOut : out std_logic_vector(31 downto 0);
        Active_Digit : out std_logic_vector(3 downto 0);
        Seven_Seg_Digit : out std_logic_vector(6 downto 0)
    );

end MemoryStage;

architecture Behavioral of MemoryStage is

    signal Seven_Seg_internal : std_logic_vector(15 downto 0);

begin

    dataMem_inst : entity work.data_memory
        generic map (
            WIDTH => 32,
            ADDR_SPACE => 10
        )
        port map (
            clk => clk,
            W_EN => MemWrite,
            ADDR => ALUResult(9 downto 0),
            D_IN => WriteData,
            D_OUT => MemOut,
            SWITCHES => Switches,
            SEVEN_SEG => Seven_Seg_internal
        );

    seven_seg_controller_inst : entity work.sevenSegController
        port map (
            clk => clk,
            rst => rst,
            display_number => Seven_Seg_internal,
            active_segment => Active_Digit,
            led_out => Seven_Seg_Digit
        );

    RegWriteOut <= RegWrite;
    MemtoRegOut <= MemtoReg;
    WriteRegOut <= WriteReg;
    ALUResultOut <= ALUResult;

end Behavioral;