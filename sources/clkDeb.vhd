--***************************************************************************************************
 --*	Author: Tsotne Putkaradze, tsotnep@gmail.com
 --*	Professor: Peeter Ellervee
 --*	Lab Assitant: Siavoosh Payandeh Azad, Muhammad Adeel Tajammul
 --*	University: Tallinn Technical University, subject: IAY0340
 --*	Board: Nexys 2, Nexys 3
 --*	Manual of Board nexys 2: http://www.pld.ttu.ee/~alsu/DE_Nexys2.pdf
 --*	Manual of Board nexys 3: http://www.pld.ttu.ee/~alsu/DE_Nexys3.pdf
 --*	Description of Software:
 --*		Harvard architecture based CPU - clock debouncing
 --*
 --* 	copyright: you can use anything from here, you can also add some manual
 --***************************************************************************************************/

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

entity clkDeb is
	Port(
		clkBtn  : in  STD_LOGIC;
		realCLK : in  STD_LOGIC;
		rst     : in  STD_LOGIC;
		clk_SS  : out STD_LOGIC;
		clk     : out STD_LOGIC
	);
end clkDeb;

architecture Behavioral of clkDeb is
	--constant oneSecFor100MGHZ : STD_LOGIC_VECTOR (27 downto 0):="0101111101011110000100000000";
	constant SimSyn   : integer                           := 20;
	signal counter    : STD_LOGIC_VECTOR(SimSyn downto 0) := (others => '0');
	signal innerCLK   : std_logic                         := '0';
	signal oldLastBit : std_logic                         := '0';
	signal shiftReg   : STD_LOGIC_VECTOR(2 downto 0)      := "000";
begin
	clk <= innerCLK;
	process(realCLK, clkBtn, rst)
	begin
		if rst = '1' then
			counter  <= (others => '0');
			innerCLK <= '0';
			shiftReg <= "000";
		elsif rising_edge(realCLK) then
			counter    <= counter + 1;
			oldLastBit <= counter(SimSyn);
			clk_SS     <= counter(SimSyn-2);
			if oldLastBit = '1' and counter(SimSyn) = '0' then
				shiftReg(0) <= clkBtn;
				shiftReg(1) <= shiftReg(0);
				shiftReg(2) <= shiftReg(1);
			end if;

			if (shiftReg = "110" AND (innerCLK = '0')) or (shiftReg = "011" AND innerCLK = '1') then
				innerCLK <= NOT innerCLK;
			end if;

		end if;
	end process;
end Behavioral;

