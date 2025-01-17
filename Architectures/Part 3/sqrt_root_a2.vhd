LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.numeric_std.ALL;

ENTITY square_root IS
generic (
		n           : integer := 16
		);
port (
		clk, reset, start    : 	in  	std_logic 			            ;
      	A    		        : 	in 		std_logic_vector(2*n-1 downto 0);

        result              :   out 	std_logic_vector(n-1 downto 0);
		finished		    :	out		std_logic
		);
END square_root;

architecture a1 of square_root is
    type statetype is (IDLE, INIT, COMP, DONE);
    signal state : statetype;
    signal D     : unsigned(2*n-1 downto 0);

    begin
        process(clk,reset)        
        variable cnt               : integer;
        variable R,Z               : unsigned (n+1 downto 0);

        begin
            if(reset = '0') then -- reset is active low 
                state <= IDLE;
                finished <= '0';
            elsif(clk'event and clk='1') then
                case state is
                    
                    when IDLE =>
                        if(start = '1') then
                            state <= INIT;
                        end if;

                    when INIT =>
                        cnt := n;    
                        D <= unsigned(A);
                        R := (others => '0');
                        Z := (others => '0');
                        state <= COMP;
                    
                    when COMP =>
                            if (cnt = 0) then
                                state <= DONE;
                            else 
                                if (R(n+1)='0') then
                                    R := resize(R*4,R'length) + resize(D(2*n-1 downto 2*n-2), R'length) - resize(4*Z+1,R'length);
                                else
                                    R := resize(R*4,R'length) + resize(D(2*n-1 downto 2*n-2), R'length) + resize(4*Z+3,R'length);
                                end if;
                                if (R(n+1)='0') then
                                    Z := resize(Z*2+1,Z'length);
                                else
                                    Z := resize(Z*2,Z'length);
                                end if;
                                D   <= resize(D*4, D'length);
                                cnt := cnt -1;
                            end if;

                    when DONE =>
                        finished <= '1';
                        result <= std_logic_vector(Z(n-1 downto 0));
                        if(start = '0') then
                            state <= IDLE;
                            finished <= '0';
                        end if;
                    end case;
                end if;
        end process;
end architecture a1;
    