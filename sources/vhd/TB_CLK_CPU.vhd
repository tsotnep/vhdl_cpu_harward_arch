--***************************************************************************************************
 --*	Author: Tsotne Putkaradze, tsotnep@gmail.com
 --*	Professor: Peeter Ellervee
 --*	Lab Assitant: Siavoosh Payandeh Azad, Muhammad Adeel Tajammul
 --*	University: Tallinn Technical University, subject: IAY0340
 --*	Board: Nexys 2, Nexys 3
 --*	Manual of Board nexys 2: http://www.pld.ttu.ee/~alsu/DE_Nexys2.pdf
 --*	Manual of Board nexys 3: http://www.pld.ttu.ee/~alsu/DE_Nexys3.pdf
 --*	Description of Software:
 --*		Harvard architecture based CPU - not used i think.
 --*
 --***************************************************************************************************/
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY TB_CLK_CPU IS
END TB_CLK_CPU;
 
ARCHITECTURE behavior OF TB_CLK_CPU IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Control
    PORT(
         output : OUT  std_logic_vector(7 downto 0);
         OUTLeft3bit : OUT  std_logic_vector(2 downto 0);
         rst : IN  std_logic;
         realCLK : IN  std_logic;
         clkBtn : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal rst : std_logic := '1';
   signal realCLK : std_logic := '0';
   signal clkBtn : std_logic := '0';

 	--Outputs
   signal output : std_logic_vector(7 downto 0);
   signal OUTLeft3bit : std_logic_vector(2 downto 0);

   -- Clock period definitions
   constant realCLK_period : time := 10 ns;
   constant clkBtn_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Control PORT MAP (
          output => output,
          OUTLeft3bit => OUTLeft3bit,
          rst => rst,
          realCLK => realCLK,
          clkBtn => clkBtn
        );

      -- insert stimulus here 

      wait;
   end process;

END;
