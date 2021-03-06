--***************************************************************************************************
 --*	Author: Tsotne Putkaradze, tsotnep@gmail.com
 --*	Professor: Peeter Ellervee
 --*	Lab Assitant: Siavoosh Payandeh Azad, Muhammad Adeel Tajammul
 --*	University: Tallinn Technical University, subject: IAY0340
 --*	Board: Nexys 2, Nexys 3
 --*	Manual of Board nexys 2: http://www.pld.ttu.ee/~alsu/DE_Nexys2.pdf
 --*	Manual of Board nexys 3: http://www.pld.ttu.ee/~alsu/DE_Nexys3.pdf
 --*	Description of Software:
 --*		Harvard architecture based CPU - memory unit
 --*
 --* 	copyright: you can use anything from here, you can also add some manual
 --***************************************************************************************************/
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE std.textio.all;
use ieee.std_logic_textio.all;
use IEEE.NUMERIC_STD.ALL;

entity mem is
	Port(
		M_FrD_RW      : in  STD_LOGIC;
		M_FrD_Address : in  STD_LOGIC_VECTOR(7 downto 0);
		M_FrD_data    : in  STD_LOGIC_VECTOR(7 downto 0);
		M_ToD_data    : out STD_LOGIC_VECTOR(7 downto 0);

		rst           : in  STD_LOGIC;
		clk           : in  STD_LOGIC
	);
end mem;

architecture Behavioral of mem is
	type Mem_type is array (0 to 255) of std_logic_vector(7 downto 0);
	signal Mem : Mem_type;
begin
	process(clk, rst) is
	begin
		if rst = '1' then
			Mem <= ((others => (others => '0')));
		elsif rising_edge(clk) then
			if M_FrD_RW = '1' then
				Mem(to_integer(unsigned(M_FrD_Address))) <= M_FrD_data;
			end if;
		end if;
	end process;

	M_ToD_data <= Mem(to_integer(unsigned(M_FrD_Address)));

end Behavioral;

