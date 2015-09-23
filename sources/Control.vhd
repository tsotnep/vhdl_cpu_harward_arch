library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use work.TsotnePackage.ALL;

-- synthesised for and works for NEXYS 3 FPGA (SPARTAN 6)
-- on 4 SevenSegment i am writing ACC (converting it to BCD and then converting each part of BCD to 8-bit)
-- on LEDS 6,7 is displayed OVERFLOW
-- On LEDS 4,5 is displayed ZERO (p.s. from the beginning ACC is 0, so..)
-- on LEDS 0,1,2,3, is displayed states, if Fetch LEDS(0)+, if Decode LEDS(1)+..
-- clock is on Button -> BTNR (pin-> D9), if pressed clk goes from '0' to '1', and vice versa
-- rst is on Button -> BTNL (pin-> C4), if pressed then should CLOCK to execute reset

-- ADDED Functions:
-- JMPIFX - if ACC = OPERAND, skips next instruction

-- TODO:
-- implement PUSH, POP, JMPREL, RRC, RLC, JMPREL, LOADPC, SAVEPC

-- issues(general):
-- on 4 SevenSegment display, i cant write negative numbers, YET
-- no other issue, everything is almost perfect (c) TsotneP

entity Control is
	PORT(
		LEDS        : out STD_LOGIC_VECTOR(7 downto 0);
		OUTLeft3bit : out STD_LOGIC_VECTOR(2 downto 0);
		AN          : out STD_LOGIC_VECTOR(3 downto 0);
		SS          : out STD_LOGIC_VECTOR(7 downto 0);
		rst         : in  STD_LOGIC;
		realCLK     : in  STD_LOGIC;
		clkBtn      : in  STD_LOGIC
	);
end Control;

architecture Behavioral of Control is
	-- Seven Segment
	component SevSeg is
		port(
			an  : out STD_LOGIC_VECTOR(3 downto 0);
			ss  : out STD_LOGIC_VECTOR(7 downto 0);
			StLed : out STD_LOGIC_VECTOR(3 downto 0);
			state : in  STATES;
			data  : in  STD_LOGIC_VECTOR(7 downto 0);
			rst : in  STD_LOGIC;
			clk : in  STD_LOGIC
		);
	end component;
	-- MANUAL CLOCK DEBOUNCER
	component clkDeb is
		Port(
			clkBtn  : in  STD_LOGIC;
			realCLK : in  STD_LOGIC;
			rst     : in  STD_LOGIC;
			clk_SS  : out STD_LOGIC;
			clk     : out STD_LOGIC
		);
	end component;
	-- CONTROL UNIT INSTANTIATION
	component InstrMem is
		Port(
			I_FrC_Instr_address : in  STD_LOGIC_VECTOR(7 downto 0);
			I_ToC_16data        : OUT STD_LOGIC_VECTOR(15 downto 0);
			clk                 : in  STD_LOGIC
		);
	end component;

	--DATA PATH UNIT INSTANTIATION
	component DPU is
		port(
			D_FrC_Data       : in  STD_LOGIC_VECTOR(7 downto 0);
			D_FrM_Data       : in  STD_LOGIC_VECTOR(7 downto 0);
			D_FrC_Command    : in  STD_LOGIC_VECTOR(4 downto 0);
			D_FrC_MuxConData : in  STD_LOGIC_VECTOR(1 downto 0);
			--			itsSP					: in STD_LOGIC;
			D_FrC_RW         : in  STD_LOGIC; -- to mem
			D_FrC_Address    : in  STD_LOGIC_VECTOR(7 downto 0); -- to mem

			D_ToC_FlagZ      : out STD_LOGIC;
			D_ToC_FlagOV     : out STD_LOGIC;

			D_ToM_Data       : out STD_LOGIC_VECTOR(7 downto 0);
			D_ToM_Address    : out STD_LOGIC_VECTOR(7 downto 0);
			D_ToM_RW         : out STD_LOGIC;

			rst              : in  STD_LOGIC;
			clk              : in  STD_LOGIC
		);
	end component;

	-- MEMORY INSTANTIATION
	component mem is
		-- SIGNALS
		Port(
			M_FrD_RW      : in  STD_LOGIC;
			M_FrD_Address : in  STD_LOGIC_VECTOR(7 downto 0);
			M_FrD_data    : in  STD_LOGIC_VECTOR(7 downto 0);
			M_ToD_data    : out STD_LOGIC_VECTOR(7 downto 0);
			rst           : in  STD_LOGIC;
			clk           : in  STD_LOGIC
		);
	end component;

	--===================== SIGNAL DECLARATION=========================--
	Signal State                       : STATES;
	Signal Instr                       : Instruction;
	signal addToPC                     : integer                       := 1;
	signal SP                          : STD_LOGIC_VECTOR(7 downto 0)  := (others => '1');
	signal C_16data, C_FrI_16data      : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
	signal C_ToD_Command, C_FrI_OpCode : STD_LOGIC_VECTOR(4 downto 0)  := (others => '0');
	signal C_FrI_Left3bit              : STD_LOGIC_VECTOR(2 downto 0)  := (others => '0');
	signal C_ToD_MuxConData            : STD_LOGIC_VECTOR(1 downto 0)  := (others => '0');
	signal clk, clk_SS, C_ToD_RW, 
		FlagZ, FlagOV, MED_RWDM, 
		C_FrD_FlagZ, C_FrD_FlagOV 		  : std_logic                     := '0';
	signal MED_AddressDM, PC, 
		MED_Data_M_To_D, 
		C_ToI_Instr_address,
		C_FrI_8Data, C_FrD_Data, 
		C_ToD_address, C_ToD_Data 		  : STD_LOGIC_VECTOR(7 downto 0)  := (others => '0');
begin

	OUTLeft3bit <= C_FrI_Left3bit;
	FlagOV      <= C_FrD_FlagOV;
	FlagZ       <= C_FrD_FlagZ;
	LEDS(7 downto 6)      <= FlagOV & FlagOV ;
	LEDS(5 downto 4)      <= FlagZ & FlagZ;
	S_S : SevSeg port map(
			-- OUT_PUTS
			an  => AN,
			ss  => SS,
			StLed => LEDS(3 downto 0),
			-- IN_PUTS
			state => State,
			data	=> C_FrD_Data,
			rst => rst,
			clk => clk_SS
		);
	C_D : clkDeb port map(
			-- IN_PUTS
			realCLK => realCLK,
			clkBtn  => clkBtn,
			rst     => rst,
			-- OUT_PUTS
			clk_SS  => clk_SS,
			clk     => clk
		);
	I_M : InstrMem port map(
			-- OUT_PUTS
			I_ToC_16data        => C_FrI_16data,
			-- IN_PUTS
			I_FrC_Instr_address => C_ToI_Instr_address,
			clk                 => realclk
		);

	D_P : DPU port map(
			-- OUT_PUTS
			D_ToM_Address    => MED_AddressDM,
			D_ToM_Data       => C_FrD_Data,
			D_ToC_FlagOV     => C_FrD_FlagOV,
			D_ToC_FlagZ      => C_FrD_FlagZ,
			D_ToM_RW         => MED_RWDM,
			--			itsSP					=> itsSP,

			-- IN_PUTS
			D_FrC_address    => C_ToD_address,
			D_FrC_MuxConData => C_ToD_MuxConData,
			D_FrC_RW         => C_ToD_RW,
			D_FrC_Data       => C_ToD_Data,
			D_FrC_Command    => C_ToD_Command,
			D_FrM_Data       => MED_Data_M_To_D,
			rst              => rst,
			clk              => clk
		);

	M_R : mem port map(
			-- OUT_PUTS
			M_ToD_data    => MED_Data_M_To_D,
			-- IN_PUTS
			M_FrD_RW      => MED_RWDM,
			M_FrD_Address => MED_AddressDM,
			M_FrD_data    => C_FrD_Data,
			rst           => rst,
			clk           => realclk
		);

	--	 --:::::::::::::::::::COMMAND DECODER:::::::::::::::::::
	process(C_FrI_OpCode)
	begin
		--	if rising_edge(clk) then
		case C_FrI_OpCode is
			when "00000" => Instr <= NOP;
			when "00001" => Instr <= ADD;
			when "00010" => Instr <= INCA;
			when "00011" => Instr <= ADDAM;
			when "00100" => Instr <= SUB;
			when "00101" => Instr <= DECA;
			when "00110" => Instr <= SUBAM;
			when "00111" => Instr <= MYAND;
			when "01000" => Instr <= MYOR;
			when "01001" => Instr <= MYXOR;
			when "01010" => Instr <= MYNOT;
			when "01011" => Instr <= BypassB;
			when "01100" => Instr <= NEG;
			when "01101" => Instr <= LSR;
			when "01110" => Instr <= LSL;
			when "01111" => Instr <= ASL;
			when "10000" => Instr <= ASR;
			when "10001" => Instr <= CLRA;
			when "10010" => Instr <= CLRZ;
			when "10011" => Instr <= CLRO;
			when "10100" => Instr <= JMP;
			when "10101" => Instr <= JMPZ;
			when "10110" => Instr <= JMPO;
			when "10111" => Instr <= LOAD;
			when "11000" => Instr <= STORE;
			when "11001" => Instr <= JMPIFX; --11001
			when "11010" => Instr <= PUSH;
			when "11011" => Instr <= POP;
			when "11100" => Instr <= NOP;
			when "11101" => Instr <= NOP;
			when "11110" => Instr <= NOP;
			when others  => Instr <= HALT; --11111
		end case;
	--end if;
	end process;

	--	 --:::::::::::::::::::STATE FSM:::::::::::::::::::
	process(clk, rst)
	BEGIN
		if rst = '1' then
			State <= Fetch;
			PC		<= "00000000";
			SP    <= "11111111";
		elsif rising_edge(clk) then
			CASE State is
				when Fetch => State <= Decode;
					C_ToD_RW         <= '0';
					C_ToD_Data       <= "00000000";
					C_ToD_address    <= "00000000";
					C_ToD_Command    <= "00000"; --NOP;
					C_ToD_MuxConData <= "00";

				when Decode => State <= Execution;
					C_FrI_OpCode     <= C_FrI_16data(12 downto 8);
					C_FrI_Left3bit   <= C_FrI_16data(15 downto 13);
					C_FrI_8Data      <= C_FrI_16data(7 downto 0);
					C_ToD_RW         <= '0';
					C_ToD_Data       <= "00000000";
					C_ToD_address    <= "00000000";
					C_ToD_Command    <= "00000"; --NOP;
					C_ToD_MuxConData <= "00";

				when Execution => State <= Fetch;
					C_ToI_Instr_address <= CONV_STD_LOGIC_VECTOR((CONV_INTEGER(PC) + 1), 8);
					PC                  <= CONV_STD_LOGIC_VECTOR((CONV_INTEGER(PC) + 1), 8);
					case Instr is
						when PUSH =>
							C_ToD_RW         <= '1';
							C_ToD_Data       <= C_FrI_8Data;
							C_ToD_address    <= SP;
							C_ToD_Command    <= "01011"; --BypassB;
							C_ToD_MuxConData <= "00";
							SP               <= SP - 1;

						when POP =>
							C_ToD_RW         <= '0';
							C_ToD_Data       <= C_FrI_8Data; --does not matter cuz its from mem
							C_ToD_address    <= SP + 1;
							C_ToD_Command    <= "01011"; --BypassB;
							C_ToD_MuxConData <= "01";
							SP               <= SP + 1;

						when HALT =>
							state <= StateHalt;
						when ADD =>
							C_ToD_RW         <= '0';
							C_ToD_Data       <= C_FrI_8Data;
							C_ToD_address    <= "00000000";
							C_ToD_Command    <= "00001"; --ADD;
							C_ToD_MuxConData <= "00";

						when INCA =>
							C_ToD_RW         <= '0';
							C_ToD_Data       <= "00000000";
							C_ToD_address    <= "00000000";
							C_ToD_Command    <= "00101"; --INCr;
							C_ToD_MuxConData <= "10";

						when ADDAM =>
							C_ToD_RW         <= '0';
							C_ToD_Data       <= "00000000";
							C_ToD_address    <= C_FrI_8Data;
							C_ToD_Command    <= "00001"; --ADD;
							C_ToD_MuxConData <= "01";

						when SUB =>
							C_ToD_RW         <= '0';
							C_ToD_Data       <= C_FrI_8Data;
							C_ToD_address    <= "00000000";
							C_ToD_Command    <= "00011"; --ADD;
							C_ToD_MuxConData <= "00";

						when DECA =>
							C_ToD_RW         <= '0';
							C_ToD_Data       <= "00000000";
							C_ToD_address    <= "00000000";
							C_ToD_Command    <= "00011"; --ADD;
							C_ToD_MuxConData <= "11";

						when SUBAM =>
							C_ToD_RW         <= '0';
							C_ToD_Data       <= "00000000";
							C_ToD_address    <= C_FrI_8Data;
							C_ToD_Command    <= "00011"; --ADD;
							C_ToD_MuxConData <= "01";

						when MYAND =>
							C_ToD_RW         <= '0';
							C_ToD_Data       <= C_FrI_8Data;
							C_ToD_address    <= "00000000";
							C_ToD_Command    <= "00111"; --MYAND;
							C_ToD_MuxConData <= "00";

						when MYOR =>
							C_ToD_RW         <= '0';
							C_ToD_Data       <= C_FrI_8Data;
							C_ToD_address    <= "00000000";
							C_ToD_Command    <= "01000"; --MYOR;
							C_ToD_MuxConData <= "00";

						when MYXOR =>
							C_ToD_RW         <= '0';
							C_ToD_Data       <= C_FrI_8Data;
							C_ToD_address    <= "00000000";
							C_ToD_Command    <= "01001"; --MYXOR;
							C_ToD_MuxConData <= "00";

						when MYNOT =>
							C_ToD_RW         <= '0';
							C_ToD_Data       <= C_FrI_8Data;
							C_ToD_address    <= "00000000";
							C_ToD_Command    <= "01010"; --MYNOT;
							C_ToD_MuxConData <= "00";

						when BypassB =>
							C_ToD_RW         <= '0';
							C_ToD_Data       <= C_FrI_8Data;
							C_ToD_address    <= "00000000";
							C_ToD_Command    <= "01011"; --BypassB;
							C_ToD_MuxConData <= "00";

						when NEG =>
							C_ToD_RW         <= '0';
							C_ToD_Data       <= "00000000";
							C_ToD_address    <= "00000000";
							C_ToD_Command    <= "01100"; --NEG;
							C_ToD_MuxConData <= "00";

						when LSR =>
							C_ToD_RW         <= '0';
							C_ToD_Data       <= "00000000";
							C_ToD_address    <= "00000000";
							C_ToD_Command    <= "01101"; --LSR;
							C_ToD_MuxConData <= "00";

						when LSL =>
							C_ToD_RW         <= '0';
							C_ToD_Data       <= "00000000";
							C_ToD_address    <= "00000000";
							C_ToD_Command    <= "01110"; --LSL;
							C_ToD_MuxConData <= "00";

						when ASL =>
							C_ToD_RW         <= '0';
							C_ToD_Data       <= "00000000";
							C_ToD_address    <= "00000000";
							C_ToD_Command    <= "01111"; --ASL;
							C_ToD_MuxConData <= "00";

						when ASR =>
							C_ToD_RW         <= '0';
							C_ToD_Data       <= "00000000";
							C_ToD_address    <= "00000000";
							C_ToD_Command    <= "10000"; --ASR;
							C_ToD_MuxConData <= "00";

						when CLRA =>
							C_ToD_RW         <= '0';
							C_ToD_Data       <= "00000000";
							C_ToD_address    <= "00000000";
							C_ToD_Command    <= "10001"; --CLRA;
							C_ToD_MuxConData <= "00";

						when CLRZ =>
							C_ToD_RW         <= '0';
							C_ToD_Data       <= "00000000";
							C_ToD_address    <= "00000000";
							C_ToD_Command    <= "10010"; --CLRZ;
							C_ToD_MuxConData <= "00";

						when CLRO =>
							C_ToD_RW         <= '0';
							C_ToD_Data       <= "00000000";
							C_ToD_address    <= "00000000";
							C_ToD_Command    <= "10011"; --CLRO;
							C_ToD_MuxConData <= "00";

						when JMP =>
							C_ToI_Instr_address <= C_FrI_8Data;
							PC                  <= C_FrI_8Data;
							C_ToD_RW            <= '0';
							C_ToD_Data          <= "00000000";
							C_ToD_address       <= "00000000";
							C_ToD_Command       <= "00000"; --NOP;
							C_ToD_MuxConData    <= "00";

						when JMPIFX =>
							if C_FrD_Data /= C_FrI_8Data then
								PC                  <= CONV_STD_LOGIC_VECTOR((CONV_INTEGER(PC) + 2), 8);
								C_ToI_Instr_address <= CONV_STD_LOGIC_VECTOR((CONV_INTEGER(PC) + 2), 8);
								State               <= fetch;
							end if;
							C_ToD_RW         <= '0';
							C_ToD_Data       <= "00000000";
							C_ToD_address    <= "00000000";
							C_ToD_Command    <= "00000"; --NOP;
							C_ToD_MuxConData <= "00";

						when JMPZ =>
							if FlagZ = '1' then
								PC                  <= C_FrI_8Data;
								C_ToI_Instr_address <= C_FrI_8Data;
								State               <= fetch;
							end if;
							C_ToD_RW         <= '0';
							C_ToD_Data       <= "00000000";
							C_ToD_address    <= "00000000";
							C_ToD_Command    <= "00000"; --NOP;
							C_ToD_MuxConData <= "00";

						when JMPO =>
							if FlagOV = '1' then
								PC                  <= C_FrI_8Data;
								C_ToI_Instr_address <= C_FrI_8Data;
								State               <= fetch;
							end if;
							C_ToD_RW         <= '0';
							C_ToD_Data       <= "00000000";
							C_ToD_address    <= "00000000";
							C_ToD_Command    <= "00000"; --NOP;
							C_ToD_MuxConData <= "00";

						when LOAD =>
							C_ToD_RW         <= '0';
							C_ToD_Data       <= "00000000";
							C_ToD_address    <= C_FrI_8Data;
							C_ToD_Command    <= "01011"; --bypass B(mem)
							C_ToD_MuxConData <= "01";

						when STORE =>
							C_ToD_RW         <= '1';
							C_ToD_Data       <= "00000000";
							C_ToD_address    <= C_FrI_8Data;
							C_ToD_Command    <= "00000"; --NOP;
							C_ToD_MuxConData <= "00";

						when NOP =>
							C_ToD_RW         <= '0';
							C_ToD_Data       <= "00000000";
							C_ToD_address    <= "00000000";
							C_ToD_Command    <= "00000"; --NOP;
							C_ToD_MuxConData <= "11";

						when others =>
							C_ToD_RW         <= '0';
							C_ToD_Data       <= "00000000";
							C_ToD_address    <= "00000000";
							C_ToD_Command    <= "00000"; --NOP;
							C_ToD_MuxConData <= "00";
					end case;

				when StateHalt =>
					state <= StateHalt;
			END CASE;
		end if;
	END process;

end Behavioral;