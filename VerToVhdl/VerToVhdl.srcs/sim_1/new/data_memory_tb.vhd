library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity data_memory_tb is
end data_memory_tb;

architecture Behavioral of data_memory_tb is

    signal clk : std_logic := '0';
    signal w_en : std_logic;
    signal addr : std_logic_vector(9 downto 0);
    signal d_in : std_logic_vector(31 downto 0);
    signal switches : std_logic_vector(15 downto 0);
    signal d_out : std_logic_vector(31 downto 0);
    signal seven_seg : std_logic_vector(15 downto 0);
    
begin
    uut : entity work.data_memory
        generic map (
            WIDTH => 32,
            ADDR_SPACE => 10
        )
        port map (
            clk => clk,
            w_en => w_en,
            addr => addr,
            d_in => d_in,
            switches => switches,
            d_out => d_out,
            seven_seg => seven_seg
        );

    process
    begin
        clk <= '0';
        wait for 20 ns;
        clk <= '1';
        wait for 20 ns;
    end process;

    process
    begin
        wait until falling_edge(clk);
        w_en <= '1';
        addr <= "00" & x"1B";
        d_in <= x"AAAA5555";
        wait until falling_edge(clk);
        addr <= "00" & x"1C";
        d_in <= x"5555AAAA";
        wait until falling_edge(clk);
        w_en <= '0';
        addr <= "00" & x"1B";
        wait until rising_edge(clk);
        wait for 1 ns;
        if (d_out /= x"AAAA5555") then
            report "addr=" & to_string(addr) & ", read=" & to_string(d_out) & " but should be xAAAA5555";
        end if;
        wait until falling_edge(clk);
        addr <= "00" & x"1C";
        wait until rising_edge(clk);
        wait for 1 ns;
        if (d_out /= x"5555AAAA") then
            report "addr=" & to_string(addr) & ", read=" & to_string(d_out) & " but should be x5555AAAA";
        end if;
        wait until falling_edge(clk);
        w_en <= '0';
        switches <= x"1111";
        addr <= "11" & x"FE";
        wait until rising_edge(clk);
        wait for 1 ns;
        if (d_out /= x"00001111") then
            report "addr=" & to_string(addr) & ", read=" & to_string(d_out) & " but should be x00001111";
        end if;
        wait until falling_edge(clk);
        w_en <= '1';
        addr <= "11" & x"FF";
        d_in <= x"00003333";
        wait until rising_edge(clk);
        wait for 1 ns;
        if (seven_seg /= x"3333") then
            report "addr=" & to_string(addr) & ", read=" & to_string(seven_seg) & " but should be x00003333";
        end if;
    end process;
end Behavioral;