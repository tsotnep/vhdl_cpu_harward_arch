--***************************************************************************************************
 --*	Author: Tsotne Putkaradze, tsotnep@gmail.com
 --*	Professor: Peeter Ellervee
 --*	Lab Assitant: Siavoosh Payandeh Azad, Muhammad Adeel Tajammul
 --*	University: Tallinn Technical University, subject: IAY0340
 --*	Board: Nexys 2, Nexys 3
 --*	Manual of Board nexys 2: http://www.pld.ttu.ee/~alsu/DE_Nexys2.pdf
 --*	Manual of Board nexys 3: http://www.pld.ttu.ee/~alsu/DE_Nexys3.pdf
 --*	Description of Software:
 --*		Harvard architecture based CPU - using seven segment display on board
 --*
 --* 	copyright: you can use anything from here, you can also add some manual
 --***************************************************************************************************/
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use work.TsotnePackage.ALL;

entity SevSeg is
	port(
		an    : out STD_LOGIC_VECTOR(3 downto 0);
		ss    : out STD_LOGIC_VECTOR(7 downto 0);
		StLed : out STD_LOGIC_VECTOR(3 downto 0);
		state : in  STATES;
		data  : in  STD_LOGIC_VECTOR(7 downto 0);
		rst	: in	STD_LOGIC;
		clk   : in  STD_LOGIC
	);
end SevSeg;
architecture Behavioral of SevSeg is
signal SegSt : STD_LOGIC_VECTOR (1 downto 0) := "00";
signal dataBCD,dataBCDNegated: STD_LOGIC_VECTOR (8 downto 0);
signal sign  : STD_LOGIC;
begin
---=======STATES IN LEDS========-----
process(state) begin
case state is
	when Fetch => StLed <= "0001";
	when Decode => StLed <= "0010";
	when Execution => StLed <= "0100";
	when stateHalt => StLed <= "1000";
	when others => StLed <= "1111";
end case;
end process;
---=======SEVEN SEGMENT========-----
process (clk,rst) begin
	if rst = '1' then
		SegSt <= "00";
		an <= "0000";
		ss <= "00000000";
	elsif rising_edge(clk) then -- if AN(x) = '0' than it is ON
		dataBCD <= to_bcd('0' & data(6 downto 0))(8 downto 0);
		dataBCDNegated <= to_bcd('0' & NOT (data(6 downto 0)) + 1 )(8 downto 0);
		sign <= data(7);
		if sign = '0' then
		case SegSt is
			when "00" 	=> SegSt <= "01"; an <= "1110"; ss <= bcd_to_SevSeg(dataBCD (3 downto 0));
			when "01" 	=> SegSt <= "10"; an <= "1101"; ss <= bcd_to_SevSeg(dataBCD (7 downto 4));
			when "10" 	=> SegSt <= "11"; an <= "1011"; ss <= bcd_to_SevSeg("000" & dataBCD (8));
			when "11" 	=> SegSt <= "00"; an <= "0111"; ss <= bcd_to_SevSeg("111" & sign);
			when others => SegSt <= "00"; an <= "1111"; ss <= "11111111";
		end case;
		else
		case SegSt is
			when "00" 	=> SegSt <= "01"; an <= "1110"; ss <= bcd_to_SevSeg(dataBCDNegated (3 downto 0));
			when "01" 	=> SegSt <= "10"; an <= "1101"; ss <= bcd_to_SevSeg(dataBCDNegated (7 downto 4));
			when "10" 	=> SegSt <= "11"; an <= "1011"; ss <= bcd_to_SevSeg("000" & dataBCDNegated (8));
			when "11" 	=> SegSt <= "00"; an <= "0111"; ss <= bcd_to_SevSeg("111" & sign);
			when others => SegSt <= "00"; an <= "1111"; ss <= "11111111";
		end case;
		end if;
	end if;
end process;
end Behavioral;

