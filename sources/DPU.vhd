--***************************************************************************************************
 --*	Author: Tsotne Putkaradze, tsotnep@gmail.com
 --*	Professor: Peeter Ellervee
 --*	Lab Assitant: Siavoosh Payandeh Azad, Muhammad Adeel Tajammul
 --*	University: Tallinn Technical University, subject: IAY0340
 --*	Board: Nexys 2, Nexys 3
 --*	Manual of Board nexys 2: http://www.pld.ttu.ee/~alsu/DE_Nexys2.pdf
 --*	Manual of Board nexys 3: http://www.pld.ttu.ee/~alsu/DE_Nexys3.pdf
 --*	Description of Software:
 --*		Harvard architecture based CPU - data path
 --*
 --* 	copyright: you can use anything from here, you can also add some manual
 --***************************************************************************************************/
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;
use IEEE.STD_LOGIC_ARITH.ALL;

entity DPU is
	port(
		D_FrC_Data       : in  STD_LOGIC_VECTOR(7 downto 0);
		D_FrM_Data       : in  STD_LOGIC_VECTOR(7 downto 0);
		D_FrC_Command    : in  STD_LOGIC_VECTOR(4 downto 0);
		D_FrC_MuxConData : in  STD_LOGIC_VECTOR(1 downto 0);
		D_FrC_Address    : in  STD_LOGIC_VECTOR(7 downto 0);
		D_FrC_RW         : in  STD_LOGIC;
		D_ToC_FlagZ      : out STD_LOGIC;
		D_ToC_FlagOV     : out STD_LOGIC;
		D_ToM_RW         : out STD_LOGIC;
		D_ToM_Data       : out STD_LOGIC_VECTOR(7 downto 0);
		D_ToM_Address    : out STD_LOGIC_VECTOR(7 downto 0);
		rst              : in  STD_LOGIC;
		clk              : in  STD_LOGIC
	);
end DPU;

architecture Behavioral of DPU is
	-- INPUTS FROM CONTROL UNIT
	signal MemData, ConData : STD_LOGIC_VECTOR(7 downto 0);
	signal OP               : STD_LOGIC_VECTOR(4 downto 0);
	signal MuxConData       : STD_LOGIC_VECTOR(1 downto 0);
	-- LOCAL SIGNALS
	signal ACC, ans, B    	: STD_LOGIC_VECTOR(7 downto 0) := "00000000";
	signal OV_en, OV_isov, 
			Z_isz, OV_cl, 
			Z_cl,OV_fl, Z_fl 	: STD_LOGIC	:= '0';

begin
	-- OUTPUTS - passing by
	D_ToM_RW      <= D_FrC_RW;
	D_ToM_Address <= D_FrC_Address;

	-- INPUTS FROM CONTROL UNIT
	ConData    <= D_FrC_Data;
	MemData    <= D_FrM_Data;
	OP         <= D_FrC_Command;
	MuxConData <= D_FrC_MuxConData;
	
	-- FlAG THINGS 
	OV_isov      <= ((NOT ans(7)) AND ACC(7) AND B(7)) OR (ans(7) AND (NOT ACC(7)) AND (NOT B(7)));
	Z_isz        <= NOT (ans(0) OR ans(1) OR ans(2) OR ans(3) OR ans(4) OR ans(5) OR ans(6) OR ans(7));
	D_ToC_FlagOV <= OV_fl;
	D_ToC_FlagZ  <= Z_fl;

	--============= ACC&FLAGS_REG =========--
	ACCU : process(clk, rst, ans)
	begin
		if rst = '1' then
			ACC <= "00000000";
		else
			if rising_edge(clk) then
				D_ToM_Data <= ans;
				ACC        <= ans;
				OV_fl      <= (OV_fl OR (OV_isov and OV_en)) AND (not OV_cl);
				Z_fl       <= (Z_fl OR Z_isz) AND (not Z_cl);
			end if;
		end if;
	end process;

	--============= B_MUX ================--
	MUX_B : process(MemData, ConData, MuxConData, ACC)
	begin
		case MuxConData is
			When "00"   => B <= ConData;
			when "01"   => B <= MemData;
			when "10"   => B <= "00000001";
			when others => B <= ACC;
		end case;
	end process;
	--============= ALU ================--
	PROC_ALU : process(OP, B, ACC)
	begin
		OV_en <= '0';
		Z_cl  <= '0';
		OV_cl <= '0';
		case OP is
			WHEN "10010" => ans <= ACC; Z_cl <= '1'; --clear Zero
			WHEN "10011" => ans <= ACC; OV_cl <= '1'; --clear Overflow
			WHEN "01011" => ans <= B;   --BYPASSING B				
			WHEN "10001" => ans <= "00000000"; --CLEAR ACC
			WHEN "01100" => ans <= NOT ACC + '1'; --NEGATION
			WHEN "00001" => ans <= ACC + B; OV_en <= '1'; --add, addam, inca
			WHEN "00011" => ans <= ACC - B; OV_en <= '1'; --sub, subam, deca
			WHEN "01111" => ans <= ACC(7) & ACC(5 downto 0) & '0'; --arithm shift left
			WHEN "10000" => ans <= ACC(7) & '0' & ACC(6 downto 1); --arithm shift right
			WHEN "01110" => ans <= ACC(6 downto 0) & '0'; --logic shift left
			WHEN "01101" => ans <= '0' & ACC(7 downto 1); --logic shift right
			WHEN "00111" => ans <= ACC AND B; --AND
			WHEN "01000" => ans <= ACC OR B; -- OR
			WHEN "01001" => ans <= ACC XOR B; -- XOR
			WHEN "01010" => ans <= NOT ACC; -- NOT
			WHEN OTHERS => ans  <= ACC; -- NOP
		END CASE;
	end process;

end Behavioral;

