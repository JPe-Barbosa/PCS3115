-- testbench for JogoDaVelha

entity testbench is

    end testbench;
    
    architecture tb of testbench is
    
    component JogoDaVelha is 
    port (
    a1 , a2 , a3 : in bit_vector (1 downto 0 );
    b1 , b2 , b3 : in bit_vector (1 downto 0 );
    c1 , c2 , c3 : in bit_vector (1 downto 0 );
    z : out bit_vector (1 downto 0)
    ) ;
    end component;
    
    signal a1_i , a2_i , a3_i, b1_i , b2_i , b3_i, c1_i , c2_i , c3_i, z_o: bit_vector (1 downto 0);
    
    begin 
        -- Connect DUT
        DUT: JogoDaVelha port map (a1_i , a2_i , a3_i, b1_i , b2_i , b3_i, c1_i , c2_i , c3_i, z_o);
        
        process
        begin
            assert false report "Test start." severity note;
            
            a1_i <= "01" ;
            a2_i <= "01" ;
            a3_i <= "01" ;
            b1_i <= "01" ;
            b2_i <= "01" ;
            b3_i <= "01" ;
            c1_i <= "01" ;
            c2_i <= "01" ;
            c3_i <= "01" ;
            
            wait for 1 ns;
            assert z_o /= "01" report " 'o' victory ok" severity note;
            assert z_o = "01" report " 'o' victory error, z = " & to_string(z_o) severity error;
    
            
            a1_i <= "10" ;
            a2_i <= "10" ;
            a3_i <= "10" ;
            b1_i <= "10" ;
            b2_i <= "10" ;
            b3_i <= "10" ;
            c1_i <= "10" ;
            c2_i <= "10" ;
            c3_i <= "10" ;
            
            wait for 1 ns;
            assert z_o /= "10" report "'x' victory ok" severity note;
            assert z_o = "10" report " 'x' victory error, z = " & to_string(z_o) severity error;
    
            
            a1_i <= "01" ;
            a2_i <= "01" ;
            a3_i <= "01" ;
            b1_i <= "10" ;
            b2_i <= "10" ;
            b3_i <= "10" ;
            c1_i <= "01" ;
            c2_i <= "01" ;
            c3_i <= "01" ;
            
            wait for 1 ns;
            assert z_o /= "11" report " more than 1 winer ok" severity note;
            assert z_o = "11" report " more than 1 winer error, z = " & to_string(z_o) severity error;
    
            
            a1_i <= "00" ;
            a2_i <= "00" ;
            a3_i <= "00" ;
            b1_i <= "10" ;
            b2_i <= "00" ;
            b3_i <= "00" ;
            c1_i <= "00" ;
            c2_i <= "00" ;
            c3_i <= "10" ;
            
            wait for 1 ns;
            assert z_o /= "00" report " on going ok" severity note;
            assert z_o = "00" report " on going error, z = " & to_string(z_o)  severity error;
    
            
            assert false report "Test done." severity note;
            wait;
      end process;
    end tb;