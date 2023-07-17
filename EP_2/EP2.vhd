library ieee;
use ieee.numeric_bit.all;

entity StartTrekAssault is
  port (
  clock, reset: in bit; -- sinais de controle globais
  damage: in bit_vector(7 downto 0); -- Entrada de dados: dano
  shield: out bit_vector(7 downto 0); -- Saída: shield atual
  health: out bit_vector(7 downto 0); -- Saída: health atual
  turn: out bit_vector(4 downto 0); -- Saída: rodada atual
  WL: out bit_vector(1 downto 0) -- Saída: vitória e/ou derrota
  );
end entity;

architecture structural of StartTrekAssault is

  component StartTrekAssault_FD
    port(
      clock: in bit; -- sinais de controle globais
        damage: in bit_vector(7 downto 0); -- Entrada de dados: dano
        damage_32, turn_16,shield_128, health_0: out bit; -- sinais para a unidade de controle 
        turn_fd: out bit_vector(4 downto 0); -- sinal de saida global
        reset_shield, set_shield, enable_shield: in bit; -- sinais da unidade de controle para o registrador shield
        reset_health, set_health, enable_health: in bit; -- sinais da unidade de controle para o registrador health
        show_result: in bit; --sinal da unidade de controle para mostrar o resultado
        regen_state_2: in bit; -- sinal da unidade de controle que informa o estado do regen
        reset_turn, enable_turn: in bit;
        wl: out bit_vector(1 downto 0);
        shield: out bit_vector(7 downto 0); -- Saída: shield atual
        health: out bit_vector(7 downto 0) -- Saída: health atual
    );
  end component;

  component StartTrekAssault_UC is
    port (
      clock, reset: in bit; -- sinais de controle globais
      damage_32, turn_16,shield_128, health_0: in bit; -- sinais do fluxo de dados 
      reset_shield, set_shield, enable_shield: out bit; -- sinais para o fluxo de dados para o registrador shield
      reset_health, set_health, enable_health: out bit; -- sinais para o fluxo de dados para o registrador health
      regen_state_2: out bit; -- sinal para a unidade de controle informando o estado de regen
      show_result: out bit; -- sinal para o fluxo de dados para o encerramento e envio do resultado
      reset_turn, enable_turn: out bit -- sinais para o fluxo de dados para o registrador turn
    );
    end component;

  --signals
  signal s_damage_32, s_turn_16, s_shield_128, s_health_0: bit;
  signal s_reset_shield, s_set_shield, s_enable_shield, s_reset_health, s_set_health, 
         s_enable_health, s_regen_state_2, s_show_result, s_reset_turn, s_enable_turn: bit;

  signal s_clock_n:      bit;
  begin

    s_clock_n <= not clock;
    FluxoDeDados: StartTrekAssault_FD port map(
      clock => s_clock_n,
      damage => damage,
      damage_32 => s_damage_32,
      turn_16 => s_turn_16,
      shield_128 => s_shield_128,
      health_0 => s_health_0,
      turn_fd => turn,
      reset_shield => s_reset_shield,
      set_shield => s_set_shield,
      enable_shield => s_enable_shield,
      reset_health => s_reset_health,
      set_health => s_set_health,
      enable_health => s_enable_health,
      show_result => s_show_result,
      regen_state_2 => s_regen_state_2,
      reset_turn => s_reset_turn,
      enable_turn => s_enable_turn,
      wl => WL,
      shield => shield,
      health => health
    );

    UnidadeDeControle: StartTrekAssault_UC port map(
      clock => clock,
      reset => reset,
      damage_32 => s_damage_32,
      turn_16 => s_turn_16,
      shield_128 => s_shield_128,
      health_0 => s_health_0,
      reset_shield=> s_reset_shield,
      set_shield => s_set_shield,
      enable_shield => s_enable_shield,
      reset_health => s_reset_health,
      set_health => s_set_health, 
      enable_health => s_enable_health,
      regen_state_2 => s_regen_state_2,
      show_result => s_show_result,
      reset_turn => s_reset_turn, 
      enable_turn => s_enable_turn 
    );
  end architecture;
-------------------------------------------------------------------------------------------------------------
-------------------------------------   REGISTRADORES    ----------------------------------------------------
-------------------------------------------------------------------------------------------------------------


-- Registrador de 8 bits capaz de somar seu conteúdo à entrada. Satura-se em 0-255
library ieee;
use ieee.numeric_bit.all;

entity adderSaturated8 is
  port (
    clock, set, reset: in bit;					-- Controle global: clock, set e reset (síncrono)
	enableAdd: 	  in bit;						-- Se 1, conteúdo do registrador é somado a parallel_add (síncrono)
    parallel_add: in  bit_vector(8 downto 0);   -- Entrada a ser somada (inteiro COM sinal): -256 a +255
    parallel_out: out bit_vector(7 downto 0)	-- Conteúdo do registrador: 8 bits, representando 0 a 255
  );
end entity;

architecture arch of adderSaturated8 is
  signal internal: signed(9 downto 0); -- 10 bits com sinal: captura valores entre -512 e 511 na soma
  signal extIn: signed(9 downto 0); -- entrada convertida para 10 bits
  signal preOut: bit_vector(9 downto 0);  -- pré-saida: internal convertido para bit_vector
begin
  extIn <= signed(parallel_add(8) & parallel_add); -- extensão de sinal
  
  process(clock, reset)
  begin
    if (rising_edge(clock)) then
      if set = '1' then						  -- set síncrono
         internal <= (9|8 => '0', others=>'1'); -- Carrega 255 no registrador
	  elsif reset = '1' then				 -- reset síncrono
		 internal <= (others=>'0'); 		 -- Carrega 0s no registrador
	  elsif enableAdd = '1' then			 -- add síncrono
         -- Resultado fica na faixa entre -256 (se parallel_add = -256 e internal = 0) 
         -- e 510 (se parallel_add = 255 e internal = 255)
         if    (internal + extIn < 0)   then internal <= "0000000000"; -- negativo: satura em 0
         elsif (internal + extIn > 255) then internal <= "0011111111"; -- positivo 255+: satura em 255
         else                                internal <= internal + extIn; -- entre 0 e 255
         end if; 
      end if;
    end if;
  end process;
  
  preOut <= bit_vector(internal);
  parallel_out <= preOut(7 downto 0);
end architecture;

---------------------------------------------------------------------
library ieee;
use ieee.numeric_bit.all;

-- Registrador de 8 bits capaz de subtrair a entrada de seu conteúdo. Satura-se em 0
entity decrementerSaturated8 is
  port (
    clock, set, reset: in bit;					-- Controle global: clock, set e reset (síncrono)
	enableSub: 	  in bit;						-- Se 1, conteúdo do registrador é subtraído de parallel_sub (síncrono)
    parallel_sub: in  bit_vector(7 downto 0);   -- Entrada a ser substraida (inteiro SEM sinal): 0 a 255
    parallel_out: out bit_vector(7 downto 0)	-- Conteúdo do registrador: 8 bits, representando 0 a 255
  );
end entity;

architecture arch of decrementerSaturated8 is
  signal internal: signed(8 downto 0); -- 9 bits com sinal: captura valores entre -256 e 255 na substração
  signal convertedIn: signed(8 downto 0); -- entrada convertida para 9 bits
  signal preOut: bit_vector(8 downto 0);  -- pré-saida: internal convertido para bit_vector
begin
  convertedIn <= signed('0' & parallel_sub); -- extensão de sinal: número positivo
  
  process(clock, reset)
  begin
    if (rising_edge(clock)) then
      if set = '1' then						  -- set síncrono
         internal <= (8 => '0', others=>'1'); -- Carrega 255 no registrador
	  elsif reset = '1' then				  -- reset síncrono
		 internal <= (others=>'0'); 		  -- Carrega 0s no registrador
	  elsif enableSub = '1' then			  -- sub síncrono
         internal <= internal - convertedIn;
      end if;
    end if;
  end process;
  
  preOut <= bit_vector(internal);
  parallel_out <= "00000000" when preOut(8) = '1' else --valores negativos: saturar em 0
  				  preout(7 downto 0);
end architecture;
-------------------------------------------------------------------------------------------------------------
-------------------------------------   FLUXO DE DADOS   ----------------------------------------------------
-------------------------------------------------------------------------------------------------------------
library ieee;
use ieee.numeric_bit.all;

entity StartTrekAssault_FD is
  port (
    clock: in bit; -- sinais de controle globais
    damage: in bit_vector(7 downto 0); -- Entrada de dados: dano
    damage_32, turn_16,shield_128, health_0: out bit; -- sinais para a unidade de controle 
    turn_fd: out bit_vector(4 downto 0); -- sinal de saida global
    reset_shield, set_shield, enable_shield: in bit; -- sinais da unidade de controle para o registrador shield
    reset_health, set_health, enable_health: in bit; -- sinais da unidade de controle para o registrador health
    show_result: in bit; --sinal da unidade de controle para mostrar o resultado
    regen_state_2: in bit; -- sinal da unidade de controle que informa o estado do regen
    reset_turn, enable_turn: in bit; -- sinais da unidade de controle para o registrador turn
    wl: out bit_vector(1 downto 0);
    shield: out bit_vector(7 downto 0); -- Saída: shield atual
    health: out bit_vector(7 downto 0) -- Saída: health atual
  );
end entity;
architecture structural of StartTrekAssault_FD is

  -- portando os registradores para dentro do fluxo de dados
  component adderSaturated8 is 
    port (
      clock, set, reset: in bit;					-- Controle global: clock, set e reset (síncrono)
      enableAdd: 	  in bit;						-- Se 1, conteúdo do registrador é somado a parallel_add (síncrono)
      parallel_add: in  bit_vector(8 downto 0);   -- Entrada a ser somada (inteiro COM sinal): -256 a +255
      parallel_out: out bit_vector(7 downto 0)
    );
  end component;

  component decrementerSaturated8 is
    port(
      clock, set, reset: in bit;					-- Controle global: clock, set e reset (síncrono)
       enableSub: 	  in bit;						-- Se 1, conteúdo do registrador é subtraído de parallel_sub (síncrono)
       parallel_sub: in  bit_vector(7 downto 0);   -- Entrada a ser substraida (inteiro SEM sinal): 0 a 255
       parallel_out: out bit_vector(7 downto 0)	-- Conteúdo do registrador: 8 bits, representando 0 a 255
    );
  end component;

    -- sinais do fluxo de dados
    signal s_health, s_shield, s_damage, s_damage_update, s_health_decrement, s_health_update: signed(8 downto 0); -- sinais para calculos
    signal bitvector_damage_update: bit_vector(8 downto 0);
    signal s_health_update_10bit,s_health_10bit,s_damage_10bit,s_shield_10bit, s_recovery_10bit: signed(9 downto 0);
    signal us_health, us_shield, us_damage, us_damage_update,bitvector_health_update: bit_vector(7 downto 0);
    signal turn_8bit: bit_vector (7 downto 0); -- sinal do turno que sera convertido para 5 bits
    signal s_recovery: signed(8 downto 0); -- sinal que representa o recovery de 16 ou 2


begin
  -- criando os registradores 
  reg_shield: adderSaturated8 port map(
    clock => clock,
    set => set_shield,
    reset => reset_shield,
    enableAdd => enable_shield,
    parallel_add => bitvector_damage_update,
    parallel_out => us_shield
  );

  reg_health: decrementerSaturated8 port map(
    clock => clock,
    set => set_health,
    reset => reset_health,
    enableSub => enable_health,
    parallel_sub => bitvector_health_update,
    parallel_out => us_health
  );

  reg_turn: adderSaturated8 port map(
    clock => clock,
    set => '0',
    reset => reset_turn,
    enableAdd => enable_turn,
    parallel_add => "000000001",
    parallel_out => turn_8bit
  );
  
  -- criando versões com sinais de health, shild e damage onde todas começam positivas
  s_health <=  signed('0' & us_health) ;
  s_shield <= signed('0' & us_shield);
  s_damage <= signed('0' & damage);

  s_health_10bit <= signed(s_health(8)& '0' & s_health(7 downto 0));
  s_shield_10bit <= signed(s_shield(8) & '0' & s_shield(7 downto 0));
  s_recovery_10bit <= signed(s_recovery(8) & '0' & s_recovery(7 downto 0));
  s_damage_10bit <= signed(s_damage(8) & '0' & s_damage(7 downto 0));

  -- fazendo um cast para a entrada paralela
  bitvector_damage_update <= bit_vector(s_damage_update);
  bitvector_health_update <= bit_vector(s_health_update(7 downto 0));

proc:process(clock)
    begin
        
            --if regen_state_2 = '1' then
            --  s_recovery <= "000000010"; else
            --  if us_shield < "10000000" then
            --    s_recovery <="000000010";
            --  else
            --    s_recovery <="000010000";
            --  end if;
            --end if;
            

            if s_recovery_10bit  + s_shield_10bit - s_damage_10bit  > "0000000000"   then s_health_update <= "000000000"; 
                                                        else s_health_update <= s_damage - s_recovery - s_shield;
            end if;
            
            s_damage_update <= s_recovery - s_damage;
            
            --if damage > "00100000"  then damage_32 <= '1'; 
            --                        else damage_32 <= '0';
            --end if;
            --if turn_8bit >= "00010000"  then turn_16 <= '1';
            --                            else turn_16 <= '0';
            --end if;
            --if s_shield < "010000000"   then shield_128 <= '1';
            --                            else shield_128 <= '0';
            --end if;
            --if  s_health + s_shield + s_recovery - s_damage < 0  then health_0 <= '1';
            --                                                    else health_0 <= '0';
            --end if;
            
        
            if show_result = '1' then
                if us_health = "00000000" then
                    if turn_8bit >= "00010000"  then wl <= "11";
                                                else wl <= "10";
                    end if;
                else
                    wl <= "01";
                end if;
            else
                  wl <= "00";
            end if;

       
end process proc;

  s_recovery <= "000000010" when regen_state_2 = '1' or us_shield < "10000000" else 
                "000010000" when regen_state_2 = '0' ; --seleciona a recuperação adequada
  --s_damage_update <= s_damage - s_recovery; -- 16 = 32 -16
  --s_health_decrement <= s_damage_update - s_shield; -- 12 = 16 - 4
  --s_health_update <= "000000000" when s_health_decrement < "000000000" else s_health_decrement; -- 12 > 0 . update = 12

  damage_32 <= '1' when damage > "00100000" else '0';
  turn_16 <= '1' when turn_8bit >= "00010000" else '0';
  shield_128 <= '1' when s_shield < "010000000" else '0'; 
  health_0 <= '1' when us_health = "00000000" else '0';

  --wl <= "11" when show_result = '1' and us_health = "00000000" and turn_8bit >= "00010000" else
   --     "10" when show_result = '1' and us_health = "00000000" and turn_8bit < "00010000" else
   --     "01" when show_result = '1' and us_health > "00000000";
  
  -- ligando os sinais de saida
  turn_fd <= turn_8bit(4 downto 0);
  shield <= us_shield;
  health <= us_health;

end architecture;
-------------------------------------------------------------------------------------------------------------
-------------------------------------   UNIDADE DE CONTROLE   -----------------------------------------------
-------------------------------------------------------------------------------------------------------------  
entity StartTrekAssault_UC is
  port (
      clock, reset: in bit; -- sinais de controle globais
      damage_32, turn_16,shield_128, health_0: in bit; -- sinais do fluxo de dados 
      reset_shield, set_shield, enable_shield: out bit; -- sinais para o fluxo de dados para o registrador shield
      reset_health, set_health, enable_health: out bit; -- sinais para o fluxo de dados para o registrador health
      regen_state_2: out bit; -- sinal para a unidade de controle informando o estado de regen
      show_result: out bit; -- sinal para o fluxo de dados para o encerramento e envio do resultado
      reset_turn, enable_turn: out bit -- sinais para o fluxo de dados para o registrador turn
);
end entity;

architecture fsm of StartTrekAssault_UC is
  type state_t  is (start, unshaken, recovery_16, recovery_2, result);
  signal next_state, current_state: state_t;
begin
  fsm: process(clock, reset)
  begin
    if reset = '1' then
      current_state <= start;
    elsif (clock'event and clock='1') then
      current_state <= next_state;
    end if;
  end process;

-- Logica de proximo estado
next_state <= 
  unshaken when ((current_state = start ) or (current_state = unshaken and damage_32 = '0')) and turn_16 = '0' else
  recovery_16 when ((current_state = unshaken and damage_32 = '1') or (current_state = recovery_16 and shield_128 = '0' )) and turn_16 = '0' else
  recovery_2 when ((current_state = recovery_16 and shield_128 = '1') or (current_state = recovery_2)) and turn_16 = '0' and health_0 = '0'else
  result when turn_16 = '1' or ((current_state = recovery_2) and (health_0 = '1')) or current_state = result else
  start;

-- Decodifica o estado para gerar sinais de controle
reset_shield <= '1' when current_state = start else '0';
reset_health <= '1' when current_state = start else '0';
reset_turn <= '1' when current_state = start else '0';
set_shield <= '1' when current_state = unshaken else '0';
set_health <= '1' when current_state = unshaken else '0';
enable_shield <= '1' when current_state = recovery_16 or current_state = recovery_2 else '0';
enable_turn <= '1' when current_state = unshaken or current_state = recovery_16 or current_state = recovery_2 else '0';
enable_health <= '1' when current_state = recovery_16 or current_state = recovery_2 else '0';
regen_state_2 <= '1' when current_state = recovery_2 else '0';

show_result <= '1' when current_state = result else '0';

end architecture;