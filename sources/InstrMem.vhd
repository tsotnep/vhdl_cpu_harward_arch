library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.all;

entity InstrMem is
   Port ( 
		I_FrC_Instr_address : in  STD_LOGIC_VECTOR (7 downto 0);
      I_ToC_16data : OUT  STD_LOGIC_VECTOR (15 downto 0);
		clk : in STD_LOGIC
	);
end InstrMem;	

architecture Behavioral of InstrMem is
	type Instr_mem is array ( 0 to 255) of std_logic_vector(15 downto 0);
	constant my_InstMem : Instr_mem := (
	"0000000000000000", --NOP	 0 ACC  	((Instr N:3))
	"0000000100110011", --ADD	 1 ACC  	((Instr N:1))
	"0001001000000000", --CLRZ	 0 ACC  	((Instr N:3))
	"0000000100110011", --ADD	 1 ACC  	((Instr N:1))
	"0000000100110011", --ADD	 1 ACC  	((Instr N:1))
	"0000000100110011", --ADD	 1 ACC  	((Instr N:1))
	"0001001100000000", --CLRO	 0 ACC  	((Instr N:3))
	"0000000100110011", --ADD	 1 ACC  	((Instr N:1))
	"0000000100110011", --ADD	 1 ACC  	((Instr N:1))
	"0000000100110011", --ADD	 1 ACC  	((Instr N:1))
	"0000000100110011", --ADD	 1 ACC  	((Instr N:1))
--	"0001010000000011", --JMP	 1 ACC

--	"0001001100000000", --CLRO	 0 ACC  	((Instr N:3))
--	"0000000100110011", --ADD	 1 ACC  	((Instr N:1))
--	"0001001000000000", --CLRZ	 0 ACC  	((Instr N:3))
--	"0000010000000010", --SUB	 3 ACC  	((Instr N:1))
--	"0000000000000000", --NOP	 0 ACC  	((Instr N:3))
--	"0000000100110011", --ADD	 1 ACC  	((Instr N:1))
--	"0000000100110011", --ADD	 1 ACC  	((Instr N:1))
--	"0000000000000000", --NOP	 0 ACC  	((Instr N:3))
--	"0001001100000000", --CLRO	 0 ACC  	((Instr N:3))
--	"0001001000000000", --CLRZ	 0 ACC  	((Instr N:3))
	others => "0001111100000000" -- HALT
	);
begin
process (clk) 
begin
	if rising_edge(clk) then
		I_ToC_16data <= my_InstMem(CONV_INTEGER(I_FrC_Instr_address));
	end if;
end process;
end Behavioral;

