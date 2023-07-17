entity tips_tb is
    end tips_tb;
    
    architecture tips_arch of tips_tb is
        component Ajuda is
            port (dica, jogador : in bit;
                  a1, a2, a3    : in bit_vector (1 downto 0);
                  b1, b2, b3    : in bit_vector (1 downto 0);
                  c1, c2, c3    : in bit_vector(1 downto 0);
                  La1, La2, La3 : out bit;
                  Lb1, Lb2, Lb3 : out bit;
                  Lc1, Lc2, Lc3 : out bit);
        end component;
    
        signal dica_in, jogador_in, La1_out, La2_out, La3_out, Lb1_out, Lb2_out, Lb3_out, Lc1_out, Lc2_out, Lc3_out : bit; 
        signal a1_in, a2_in, a3_in, b1_in, b2_in, b3_in, c1_in, c2_in, c3_in : bit_vector(1 downto 0);
    
        begin
            DUT: Ajuda port map(dica_in, jogador_in, a1_in, a2_in, a3_in, b1_in, b2_in, b3_in, c1_in, c2_in, c3_in, La1_out, La2_out, La3_out, Lb1_out, Lb2_out, Lb3_out, Lc1_out, Lc2_out, Lc3_out);
    
            process
            begin
                dica_in <= '1'; jogador_in <= '1';
                a3_in <= "01"; b3_in <= "00"; c3_in <= "01";
                a2_in <= "10"; b2_in <= "01"; c2_in <= "00";
                a1_in <= "10"; b1_in <= "10"; c1_in <= "00";
                wait for 1 ns;
                assert(Lc1_out='1') report "Nao acendeu o Led Lc1" severity error;
                assert(La1_out='0' and La2_out='0' and La3_out='0' and Lb1_out='0' and Lb2_out='0' and Lb3_out='0' and Lc2_out='0' and Lc3_out='0') report "Acendeu algum LED alem do Lc1" severity error;
    
                dica_in <= '1'; jogador_in <= '0';
                a3_in <= "01"; b3_in <= "00"; c3_in <= "01";
                a2_in <= "10"; b2_in <= "01"; c2_in <= "00";
                a1_in <= "10"; b1_in <= "10"; c1_in <= "00";
                wait for 1 ns;
                assert(Lc1_out='1') report "Nao acendeu o Led Lc1" severity error;
                assert(Lb3_out='1') report "Nao acendeu o Led Lb3" severity error;
                assert(La1_out='0' and La2_out='0' and La3_out='0' and Lb1_out='0' and Lb2_out='0' and Lc2_out='0' and Lc3_out='0') report "Acendeu algum LED alem do Lc1 e do Lb3" severity error;
    
                dica_in <= '0'; jogador_in <= '0';
                a3_in <= "01"; b3_in <= "00"; c3_in <= "01";
                a2_in <= "10"; b2_in <= "01"; c2_in <= "00";
                a1_in <= "10"; b1_in <= "10"; c1_in <= "00";
                wait for 1 ns;
                assert(La1_out='0' and La2_out='0' and La3_out='0' and Lb1_out='0' and Lb2_out='0' and Lb3_out='0' and Lc1_out='0' and Lc2_out='0' and Lc3_out='0') report "Acendeu algum LED sem pedir dica (jogada do bolinha)" severity error;
    
                dica_in <= '0'; jogador_in <= '1';
                a3_in <= "01"; b3_in <= "00"; c3_in <= "01";
                a2_in <= "10"; b2_in <= "01"; c2_in <= "00";
                a1_in <= "10"; b1_in <= "10"; c1_in <= "00";
                wait for 1 ns;
                assert(La1_out='0' and La2_out='0' and La3_out='0' and Lb1_out='0' and Lb2_out='0' and Lb3_out='0' and Lc1_out='0' and Lc2_out='0' and Lc3_out='0') report "Acendeu algum LED sem pedir dica (jogada do X)" severity error;
                
                assert false report "Teste finalizado" severity note;
                wait;
            end process;
    end tips_arch;