--***************************************************************************************************
 --*	Author: Tsotne Putkaradze, tsotnep@gmail.com
 --*	Professor: Peeter Ellervee
 --*	Lab Assitant: Siavoosh Payandeh Azad, Muhammad Adeel Tajammul
 --*	University: Tallinn Technical University, subject: IAY0340
 --*	Board: Nexys 2, Nexys 3
 --*	Manual of Board nexys 2: http://www.pld.ttu.ee/~alsu/DE_Nexys2.pdf
 --*	Manual of Board nexys 3: http://www.pld.ttu.ee/~alsu/DE_Nexys3.pdf
 --*	Description of Software:
 --*		Harvard architecture based CPU - instructions, states, to_bcd, bcd_to_sevseg
 --*
 --* 	copyright: you can use anything from here, you can also add some manual
 --***************************************************************************************************/

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.STD_LOGIC_ARITH.ALL;

package TsotnePackage is
	TYPE Instruction IS (NOP, ADD, INCA, ADDAM, SUB,
		                 DECA, SUBAM, MYAND, MYOR, MYXOR, MYNOT, BypassB,
		                 NEG, LSR, LSL, ASL, ASR, CLRA, CLRZ, CLRO, JMP, JMPZ,
		                 JMPO, LOAD, STORE, HALT, JMPIFX, PUSH, POP);

	TYPE STATES IS (Fetch, Decode, Execution,StateHalt);
	
	--source of this to_bcd code: http://vhdlguru.blogspot.com.ee/2010/04/8-bit-binary-to-bcd-converter-double.html
	function to_bcd(bin : std_logic_vector(7 downto 0)) return std_logic_vector is
		variable i    : integer                       := 0;
		variable bcd  : std_logic_vector(11 downto 0) := (others => '0');
		variable bint : std_logic_vector(7 downto 0)  := bin;
	begin
		for i in 0 to 7 loop            -- repeating 8 times.
			bcd(11 downto 1) := bcd(10 downto 0); --shifting the bits.
			bcd(0)           := bint(7);
			bint(7 downto 1) := bint(6 downto 0);
			bint(0)          := '0';

			if (i < 7 and bcd(3 downto 0) > "0100") then --add 3 if BCD digit is greater than 4.
				bcd(3 downto 0) := bcd(3 downto 0) + "0011";
			end if;

			if (i < 7 and bcd(7 downto 4) > "0100") then --add 3 if BCD digit is greater than 4.
				bcd(7 downto 4) := bcd(7 downto 4) + "0011";
			end if;

			if (i < 7 and bcd(11 downto 8) > "0100") then --add 3 if BCD digit is greater than 4.
				bcd(11 downto 8) := bcd(11 downto 8) + "0011";
			end if;

		end loop;
		return bcd;
	end to_bcd;


	function bcd_to_SevSeg(bcd : std_logic_vector(3 downto 0)) return std_logic_vector is
	type TenDig is array ( 0 to 15) of std_logic_vector(7 downto 0);
	constant digits : TenDig := (
		"11000000", --0
		"11111001", --1
		"10100100",
		"10110000",
		"10011001",
		"10010010",
		"10000010",
		"11111000",
		"10000000",
		"10010000", --9
		
		"10111111",
		"10111111",
		"10111111",
		"10111111",
		"10001111", -- +
		"10111111"  -- -
		);
	begin
		return digits(CONV_INTEGER(bcd)); --CONV_STD_LOGIC_VECTOR(CONV_INTEGER(bcd),8)
	end bcd_to_SevSeg;
-- type <new_type> is
--  record
--    <type_name>        : std_logic_vector( 7 downto 0);
--    <type_name>        : std_logic;
-- end record;
--
-- Declare constants
--
-- constant <constant_name>		: time := <time_unit> ns;
-- constant <constant_name>		: integer := <value;
--
-- Declare functions and procedure
--
-- function <function_name>  (signal <signal_name> : in <type_declaration>) return <type_declaration>;
-- procedure <procedure_name> (<type_declaration> <constant_name>	: in <type_declaration>);
--

end TsotnePackage;

package body TsotnePackage is

---- Example 1
--  function <function_name>  (signal <signal_name> : in <type_declaration>  ) return <type_declaration> is
--    variable <variable_name>     : <type_declaration>;
--  begin
--    <variable_name> := <signal_name> xor <signal_name>;
--    return <variable_name>; 
--  end <function_name>;

---- Example 2
--  function <function_name>  (signal <signal_name> : in <type_declaration>;
--                         signal <signal_name>   : in <type_declaration>  ) return <type_declaration> is
--  begin
--    if (<signal_name> = '1') then
--      return <signal_name>;
--    else
--      return 'Z';
--    end if;
--  end <function_name>;

---- Procedure Example
--  procedure <procedure_name>  (<type_declaration> <constant_name>  : in <type_declaration>) is
--    
--  begin
--    
--  end <procedure_name>;


--  function <function_name>  (signal <signal_name> : in <type_declaration>;
--                         signal <signal_name>   : in <type_declaration>  ) return <type_declaration> is
--  begin
--    if (<signal_name> = '1') then
--      return <signal_name>;
--    else
--      return 'Z';
--    end if;
--  end <function_name>;

end TsotnePackage;
