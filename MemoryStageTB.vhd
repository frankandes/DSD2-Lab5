library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MemoryStage_tb is
end MemoryStage_tb;

architecture Behavioral of MemoryStage_tb is

    -- Component declaration
    component MemoryStage
        port (
            clk : in std_logic;
            rst : in std_logic;
            MemWrite : in std_logic;
            MemtoReg : in std_logic;
            WriteReg : in std_logic_vector(4 downto 0);
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
    end component;

    -- Signals declaration
    signal clk_tb       : std_logic := '0';
    signal rst_tb       : std_logic := '0';
    signal MemWrite_tb  : std_logic := '0';
    signal MemtoReg_tb  : std_logic := '0';
    signal WriteReg_tb  : std_logic_vector(4 downto 0) := (others => '0');
    signal ALUResult_tb : std_logic_vector(31 downto 0) := (others => '0');
    signal WriteData_tb : std_logic_vector(31 downto 0) := (others => '0');
    signal Switches_tb  : std_logic_vector(15 downto 0) := (others => '0');
    signal RegWrite_tb  : std_logic;
    signal MemtoRegOut_tb  : std_logic;
    signal WriteRegOut_tb  : std_logic_vector(4 downto 0);
    signal MemOut_tb   : std_logic_vector(31 downto 0);
    signal ALUResultOut_tb : std_logic_vector(31 downto 0);
    signal Active_Digit_tb  : std_logic_vector(3 downto 0);
    signal Seven_Seg_Digit_tb : std_logic_vector(6 downto 0);

    type test_rec is record
        MemWrite : std_logic;
        MemtoReg : std_logic;
        WriteReg : std_logic_vector(4 downto 0);
        ALUResult : std_logic_vector(31 downto 0);
        WriteData : std_logic_vector(31 downto 0);
        Switches : std_logic_vector(15 downto 0);
        RegWrite : std_logic;
        MemtoRegOut : std_logic;
        WriteRegOut : std_logic_vector(4 downto 0);
        MemOut : std_logic_vector(31 downto 0);
        ALUResultOut : std_logic_vector(31 downto 0);
        Active_Digit : std_logic_vector(3 downto 0);
        Seven_Seg_Digit : std_logic_vector(6 downto 0);
    end record;

    type test_array is array (natural range <>) of test_rec;
    constant test_data : test_array := (
        (MemWrite => '1',
        MemtoReg => '0',
        WriteReg => "00001",
        ALUResult => x"00000001",
        WriteData => x"00000011",
        Switches => x"0000",
        RegWrite => '0',
        MemtoRegOut => '0',
        WriteRegOut => "00001",
        MemOut => x"00000011",
        ALUResultOut => x"00000001",
        Active_Digit => "0000",
        Seven_Seg_Digit => "0000000"),
        (MemWrite => '0',
        MemtoReg => '1',
        WriteReg => "10110",
        ALUResult => x"00000011",
        WriteData => x"ABCDEF01",
        Switches => x"FFFF",
        RegWrite => '1',
        MemtoRegOut => '1',
        WriteRegOut => "10110",
        MemOut => x"00000000",
        ALUResultOut => x"FFFFFFFE",
        Active_Digit => "0010",
        Seven_Seg_Digit => "0000010")
        );

begin

    -- Instantiate the unit under test (UUT)
    uut : MemoryStage
        port map (
            clk => clk_tb,
            rst => rst_tb,
            MemWrite => MemWrite_tb,
            MemtoReg => MemtoReg_tb,
            WriteReg => WriteReg_tb,
            ALUResult => ALUResult_tb,
            WriteData => WriteData_tb,
            Switches => Switches_tb,
            RegWriteOut => RegWrite_tb,
            MemtoRegOut => MemtoRegOut_tb,
            WriteRegOut => WriteRegOut_tb,
            MemOut => MemOut_tb,
            ALUResultOut => ALUResultOut_tb,
            Active_Digit => Active_Digit_tb,
            Seven_Seg_Digit => Seven_Seg_Digit_tb
        );

    -- Clock generator process
    clk_process : process
    begin
        clk_tb <= '0';
        wait for 10 ns;
        clk_tb <= '1';
        wait for 10 ns;
    end process;

    -- Stimulus process
    stimulus : process
    begin
    -- Reset the module
    rst_tb <= '1';
    wait for 20 ns;
    rst_tb <= '0';
        -- Apply test cases
        for i in test_data'range loop
            MemWrite_tb <= test_data(i).MemWrite;
            MemtoReg_tb <= test_data(i).MemtoReg;
            WriteReg_tb <= test_data(i).WriteReg;
            ALUResult_tb <= test_data(i).ALUResult;
            WriteData_tb <= test_data(i).WriteData;
            Switches_tb <= test_data(i).Switches;
            wait for 35 ns;
            assert RegWrite_tb = test_data(i).RegWrite
                report "Error: RegWrite is " & std_logic'image(RegWrite_tb) & " but should be " & std_logic'image(test_data(i).RegWrite);
            assert MemtoRegOut_tb = test_data(i).MemtoRegOut
                report "Error: MemtoRegOut is " & std_logic'image(MemtoRegOut_tb) & " but should be " & std_logic'image(test_data(i).MemtoRegOut);
            assert WriteRegOut_tb = test_data(i).WriteRegOut
                report "Error: WriteRegOut is " & to_hstring(to_bitvector(WriteRegOut_tb)) & " but should be " & to_hstring(to_bitvector(test_data(i).WriteRegOut));
            assert MemOut_tb = test_data(i).MemOut
                report "Error: MemOut is " & to_hstring(to_bitvector(MemOut_tb)) & " but should be " & to_hstring(to_bitvector(test_data(i).MemOut));
            assert ALUResultOut_tb = test_data(i).ALUResultOut
                report "Error: ALUResultOut is " & to_hstring(to_bitvector(ALUResultOut_tb)) & " but should be " & to_hstring(to_bitvector(test_data(i).ALUResultOut)); 
            assert Active_Digit_tb = test_data(i).Active_Digit
                report "Error: Active_Digit is " & to_hstring(to_bitvector(Active_Digit_tb)) & " but should be " & to_hstring(to_bitvector(test_data(i).Active_Digit)); 
            assert Seven_Seg_Digit_tb = test_data(i).Seven_Seg_Digit
                report "Error: Seven_Seg_Digit is " & to_hstring(to_bitvector(Seven_Seg_Digit_tb)) & " but should be " & to_hstring(to_bitvector(test_data(i).Seven_Seg_Digit));
            wait for 5 ns;
        end loop;
    
        -- End testbench
        wait;
    end process;
end Behavioral;    