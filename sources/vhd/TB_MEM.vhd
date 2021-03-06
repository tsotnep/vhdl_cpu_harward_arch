--***************************************************************************************************
 --*	Author: Tsotne Putkaradze, tsotnep@gmail.com
 --*	Professor: Peeter Ellervee
 --*	Lab Assitant: Siavoosh Payandeh Azad, Muhammad Adeel Tajammul
 --*	University: Tallinn Technical University, subject: IAY0340
 --*	Board: Nexys 2, Nexys 3
 --*	Manual of Board nexys 2: http://www.pld.ttu.ee/~alsu/DE_Nexys2.pdf
 --*	Manual of Board nexys 3: http://www.pld.ttu.ee/~alsu/DE_Nexys3.pdf
 --*	Description of Software:
 --*		Harvard architecture based CPU - testbench for memory
 --*
 --***************************************************************************************************/
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE std.textio.all;
use ieee.std_logic_textio.all;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_arith.all;

ENTITY TB_mem IS
END TB_mem;
 
ARCHITECTURE behavior OF TB_mem IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT mem
    PORT(
         M_FrD_RW : IN  std_logic;
         M_FrD_Address : IN  std_logic_vector(7 downto 0);
         M_FrD_data : IN  std_logic_vector(7 downto 0);
         M_ToD_data : OUT  std_logic_vector(7 downto 0);
         rst : IN  std_logic;
         clk : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal M_FrD_RW : std_logic := '0';
   signal M_FrD_Address : std_logic_vector(7 downto 0) := (others => '0');
   signal M_FrD_data : std_logic_vector(7 downto 0) := (others => '0');
   signal rst : std_logic := '0';
   signal clk : std_logic := '0';

 	--Outputs
   signal M_ToD_data : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
	shared variable count : integer :=0;

		
BEGIN
	-- Instantiate the Unit Under Test (UUT)
   uut: mem PORT MAP (
          M_FrD_RW => M_FrD_RW,
          M_FrD_Address => M_FrD_Address,
          M_FrD_data => M_FrD_data,
          M_ToD_data => M_ToD_data,
          rst => rst,
          clk => clk
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
	
	
	process -- INPUT
		
		file OutputFile: text;
		file InputFile: text;
		variable LINEVARIABLE: line;
		variable wholeline : std_logic_vector (17 downto 0);
		variable count2 : integer := 0;
		begin
		wait for 105 ns;
			file_open(InputFile,		"Input_File.txt", read_mode);
			while not endfile (InputFile) 
			loop
				count := count + 1;
				readline (InputFile, LINEVARIABLE);
				read (LINEVARIABLE, wholeline); 
				
				rst 				<= wholeline (17);
				M_FrD_RW 		<= wholeline (16);
				M_FrD_Address 	<= wholeline (15 downto 8);
				M_FrD_data 		<= wholeline (7 downto 0);
				
				wait for 10 ns;
			end loop;
			file_open(OutputFile,	"Output_File.txt", write_mode);
			M_FrD_Address <= "00000000";
			
			while count > 0 
			loop
				count2 := count2 + 1;
				count := count - 1;
				M_FrD_Address <= CONV_STD_LOGIC_VECTOR(count2,8);
				
				write(LINEVARIABLE, M_ToD_data);
				writeline(OutputFile, LINEVARIABLE);
				
				wait for 10 ns;
			end loop;
	END process;
--------TB---------
-------------------
--rst		RW 	Addr 		Data
--1		0 		00000000 00000000
--0		1 		00000010 01111110
--0		1 		00000011 01100110
--0		0 		00000010 00001111
--
-- 

END;
