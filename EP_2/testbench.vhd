LIBRARY ieee;
USE ieee.numeric_bit.ALL;

ENTITY testbench IS
END ENTITY;

ARCHITECTURE tb OF testbench IS

      -- Component to be tested
      COMPONENT StartTrekAssault IS
            PORT (
                  clock, reset : IN BIT; -- sinais de controle globais 
                  damage : IN bit_vector(7 DOWNTO 0); -- Entrada de dados: dano
                  shield : OUT bit_vector(7 DOWNTO 0); -- Saída: shield atual
                  health : OUT bit_vector(7 DOWNTO 0); -- Saída: health atual
                  turn : OUT bit_vector(4 DOWNTO 0); -- Saída: rodada atual
                  WL : OUT bit_vector(1 DOWNTO 0) -- Saída: vitória e/ou derrota
            );
      END COMPONENT;

      -- Declaration of signals
      SIGNAL clk_in, rst_in : BIT := '0';
      SIGNAL damage_in : bit_vector(7 DOWNTO 0);
      SIGNAL shield_out : bit_vector(7 DOWNTO 0);
      SIGNAL health_out : bit_vector(7 DOWNTO 0);
      SIGNAL turn_out : bit_vector(4 DOWNTO 0);
      SIGNAL WL_out : bit_vector(1 DOWNTO 0);
      CONSTANT clockPeriod : TIME := 1 ns; -- clock period
      SIGNAL keep_simulating : BIT := '0'; -- ao colocar em '0': interrompe simulação

BEGIN
      -- Clock generator: clock runs while 'keep_simulating', with given
      -- period. When keep_simulating = '0', clock stops and so do the event
      -- simulation
      clk_in <= (NOT clk_in) AND keep_simulating AFTER clockPeriod/2;

      -- Connect DUT (Device Under Test)
      dut : StartTrekAssault
      PORT MAP(
            clk_in, rst_in,
            damage_in,
            shield_out,
            health_out,
            turn_out,
            WL_out
      );
      stimulus : PROCESS IS
            ---------------- Como são vários testes, vamos fazer um record array --------------
            TYPE pattern_type IS RECORD
                  --  The inputs of the circuit.
                  reset : BIT;
                  damage : bit_vector(7 DOWNTO 0);
                  --  The expected outputs of the circuit.
                  shield : bit_vector(7 DOWNTO 0);
                  health : bit_vector(7 DOWNTO 0);
                  turn : bit_vector(4 DOWNTO 0);
                  WL : bit_vector(1 DOWNTO 0);
            END RECORD;
            --  The patterns to apply.
            TYPE pattern_array IS ARRAY (NATURAL RANGE <>) OF pattern_type;
            CONSTANT patterns : pattern_array :=
            (
            ('1', bit_vector(to_unsigned(20, damage_in'length)),
            bit_vector(to_unsigned(0, shield_out'length)),
            bit_vector(to_unsigned(0, health_out'length)),
            bit_vector(to_unsigned(0, turn_out'length)),
            "00"),
            ('1', bit_vector(to_unsigned(20, damage_in'length)), -- 1
            bit_vector(to_unsigned(0, shield_out'length)),
            bit_vector(to_unsigned(0, health_out'length)),
            bit_vector(to_unsigned(0, turn_out'length)),
            "00"),
            ('1', bit_vector(to_unsigned(20, damage_in'length)), -- 2
            bit_vector(to_unsigned(0, shield_out'length)),
            bit_vector(to_unsigned(0, health_out'length)),
            bit_vector(to_unsigned(0, turn_out'length)),
            "00"),
            ('1', bit_vector(to_unsigned(20, damage_in'length)), -- 3
            bit_vector(to_unsigned(0, shield_out'length)),
            bit_vector(to_unsigned(0, health_out'length)),
            bit_vector(to_unsigned(0, turn_out'length)),
            "00"),
            ('0', bit_vector(to_unsigned(0, damage_in'length)), -- 4
            bit_vector(to_unsigned(255, shield_out'length)),
            bit_vector(to_unsigned(255, health_out'length)),
            bit_vector(to_unsigned(1, turn_out'length)),
            "00"),
            ('0', bit_vector(to_unsigned(31, damage_in'length)), -- 5
            bit_vector(to_unsigned(255, shield_out'length)),
            bit_vector(to_unsigned(255, health_out'length)),
            bit_vector(to_unsigned(2, turn_out'length)),
            "00"),
            ('0', bit_vector(to_unsigned(55, damage_in'length)), -- 6
            bit_vector(to_unsigned(216, shield_out'length)),
            bit_vector(to_unsigned(255, health_out'length)),
            bit_vector(to_unsigned(3, turn_out'length)),
            "00"),
            ('0', bit_vector(to_unsigned(16, damage_in'length)), -- 7
            bit_vector(to_unsigned(216, shield_out'length)),
            bit_vector(to_unsigned(255, health_out'length)),
            bit_vector(to_unsigned(4, turn_out'length)),
            "00"),
            ('0', bit_vector(to_unsigned(0, damage_in'length)), -- 8
            bit_vector(to_unsigned(232, shield_out'length)),
            bit_vector(to_unsigned(255, health_out'length)),
            bit_vector(to_unsigned(5, turn_out'length)),
            "00"),
            ('0', bit_vector(to_unsigned(120, damage_in'length)), -- 9
            bit_vector(to_unsigned(128, shield_out'length)),
            bit_vector(to_unsigned(255, health_out'length)),
            bit_vector(to_unsigned(6, turn_out'length)),
            "00"),
            ('0', bit_vector(to_unsigned(17, damage_in'length)), -- 10
            bit_vector(to_unsigned(127, shield_out'length)),
            bit_vector(to_unsigned(255, health_out'length)),
            bit_vector(to_unsigned(7, turn_out'length)),
            "00"),
            ('0', bit_vector(to_unsigned(0, damage_in'length)), -- 10
            bit_vector(to_unsigned(129, shield_out'length)),
            bit_vector(to_unsigned(255, health_out'length)),
            bit_vector(to_unsigned(8, turn_out'length)),
            "00"),
            ('0', bit_vector(to_unsigned(231, damage_in'length)), -- 11
            bit_vector(to_unsigned(0, shield_out'length)),
            bit_vector(to_unsigned(155, health_out'length)),
            bit_vector(to_unsigned(9, turn_out'length)),
            "00"),
            ('0', bit_vector(to_unsigned(1, damage_in'length)), -- 12
            bit_vector(to_unsigned(1, shield_out'length)),
            bit_vector(to_unsigned(155, health_out'length)),
            bit_vector(to_unsigned(10, turn_out'length)),
            "00"),
            ('0', bit_vector(to_unsigned(4, damage_in'length)), -- 13
            bit_vector(to_unsigned(0, shield_out'length)),
            bit_vector(to_unsigned(154, health_out'length)),
            bit_vector(to_unsigned(11, turn_out'length)),
            "00"),
            ('0', bit_vector(to_unsigned(200, damage_in'length)), -- 14
            bit_vector(to_unsigned(0, shield_out'length)),
            bit_vector(to_unsigned(0, health_out'length)),
            bit_vector(to_unsigned(12, turn_out'length)),
            "00"),
            ('0', bit_vector(to_unsigned(100, damage_in'length)), -- 15
            bit_vector(to_unsigned(0, shield_out'length)),
            bit_vector(to_unsigned(0, health_out'length)),
            bit_vector(to_unsigned(12, turn_out'length)),
            "10"),
            ('0', bit_vector(to_unsigned(100, damage_in'length)), -- 16
            bit_vector(to_unsigned(0, shield_out'length)),
            bit_vector(to_unsigned(0, health_out'length)),
            bit_vector(to_unsigned(12, turn_out'length)),
            "10"),
            ('0', bit_vector(to_unsigned(100, damage_in'length)), -- 17
            bit_vector(to_unsigned(0, shield_out'length)),
            bit_vector(to_unsigned(0, health_out'length)),
            bit_vector(to_unsigned(12, turn_out'length)),
            "10"),
            ('0', bit_vector(to_unsigned(100, damage_in'length)), -- 18
            bit_vector(to_unsigned(0, shield_out'length)),
            bit_vector(to_unsigned(0, health_out'length)),
            bit_vector(to_unsigned(12, turn_out'length)),
            "10"),
            ('0', bit_vector(to_unsigned(0, damage_in'length)), -- 19
            bit_vector(to_unsigned(0, shield_out'length)),
            bit_vector(to_unsigned(0, health_out'length)),
            bit_vector(to_unsigned(12, turn_out'length)),
            "10"),
            ('1', bit_vector(to_unsigned(20, damage_in'length)), -- 20
            bit_vector(to_unsigned(0, shield_out'length)),
            bit_vector(to_unsigned(0, health_out'length)),
            bit_vector(to_unsigned(0, turn_out'length)),
            "00"),
            ('1', bit_vector(to_unsigned(20, damage_in'length)), -- 21
            bit_vector(to_unsigned(0, shield_out'length)),
            bit_vector(to_unsigned(0, health_out'length)),
            bit_vector(to_unsigned(0, turn_out'length)),
            "00"),
            ('1', bit_vector(to_unsigned(20, damage_in'length)), -- 22
            bit_vector(to_unsigned(0, shield_out'length)),
            bit_vector(to_unsigned(0, health_out'length)),
            bit_vector(to_unsigned(0, turn_out'length)),
            "00"),
            ('1', bit_vector(to_unsigned(20, damage_in'length)), -- 23
            bit_vector(to_unsigned(0, shield_out'length)),
            bit_vector(to_unsigned(0, health_out'length)),
            bit_vector(to_unsigned(0, turn_out'length)),
            "00"),
            ('0', bit_vector(to_unsigned(0, damage_in'length)), -- 24
            bit_vector(to_unsigned(255, shield_out'length)),
            bit_vector(to_unsigned(255, health_out'length)),
            bit_vector(to_unsigned(1, turn_out'length)),
            "00"),
            ('0', bit_vector(to_unsigned(31, damage_in'length)), -- 25
            bit_vector(to_unsigned(255, shield_out'length)),
            bit_vector(to_unsigned(255, health_out'length)),
            bit_vector(to_unsigned(2, turn_out'length)),
            "00"),
            ('0', bit_vector(to_unsigned(55, damage_in'length)), -- 26
            bit_vector(to_unsigned(216, shield_out'length)),
            bit_vector(to_unsigned(255, health_out'length)),
            bit_vector(to_unsigned(3, turn_out'length)),
            "00"),
            ('0', bit_vector(to_unsigned(16, damage_in'length)), -- 27
            bit_vector(to_unsigned(216, shield_out'length)),
            bit_vector(to_unsigned(255, health_out'length)),
            bit_vector(to_unsigned(4, turn_out'length)),
            "00"),
            ('0', bit_vector(to_unsigned(0, damage_in'length)), -- 28
            bit_vector(to_unsigned(232, shield_out'length)),
            bit_vector(to_unsigned(255, health_out'length)),
            bit_vector(to_unsigned(5, turn_out'length)),
            "00"),
            ('0', bit_vector(to_unsigned(120, damage_in'length)), -- 29
            bit_vector(to_unsigned(128, shield_out'length)),
            bit_vector(to_unsigned(255, health_out'length)),
            bit_vector(to_unsigned(6, turn_out'length)),
            "00"),
            ('0', bit_vector(to_unsigned(17, damage_in'length)), -- 30
            bit_vector(to_unsigned(127, shield_out'length)),
            bit_vector(to_unsigned(255, health_out'length)),
            bit_vector(to_unsigned(7, turn_out'length)),
            "00"),
            ('0', bit_vector(to_unsigned(0, damage_in'length)), -- Reset inicial
            bit_vector(to_unsigned(129, shield_out'length)),
            bit_vector(to_unsigned(255, health_out'length)),
            bit_vector(to_unsigned(8, turn_out'length)),
            "00"),
            ('0', bit_vector(to_unsigned(231, damage_in'length)), -- Reset inicial
            bit_vector(to_unsigned(0, shield_out'length)),
            bit_vector(to_unsigned(155, health_out'length)),
            bit_vector(to_unsigned(9, turn_out'length)),
            "00"),
            ('0', bit_vector(to_unsigned(1, damage_in'length)), -- Reset inicial
            bit_vector(to_unsigned(1, shield_out'length)),
            bit_vector(to_unsigned(155, health_out'length)),
            bit_vector(to_unsigned(10, turn_out'length)),
            "00"),
            ('0', bit_vector(to_unsigned(4, damage_in'length)), -- Reset inicial
            bit_vector(to_unsigned(0, shield_out'length)),
            bit_vector(to_unsigned(154, health_out'length)),
            bit_vector(to_unsigned(11, turn_out'length)),
            "00"),
            ('0', bit_vector(to_unsigned(200, damage_in'length)), -- Reset inicial
            bit_vector(to_unsigned(0, shield_out'length)),
            bit_vector(to_unsigned(0, health_out'length)),
            bit_vector(to_unsigned(12, turn_out'length)),
            "00"),
            ('0', bit_vector(to_unsigned(100, damage_in'length)), -- Reset inicial
            bit_vector(to_unsigned(0, shield_out'length)),
            bit_vector(to_unsigned(0, health_out'length)),
            bit_vector(to_unsigned(12, turn_out'length)),
            "10"),
            ('0', bit_vector(to_unsigned(100, damage_in'length)), -- Reset inicial
            bit_vector(to_unsigned(0, shield_out'length)),
            bit_vector(to_unsigned(0, health_out'length)),
            bit_vector(to_unsigned(12, turn_out'length)),
            "10"),
            ('0', bit_vector(to_unsigned(100, damage_in'length)), -- Reset inicial
            bit_vector(to_unsigned(0, shield_out'length)),
            bit_vector(to_unsigned(0, health_out'length)),
            bit_vector(to_unsigned(12, turn_out'length)),
            "10"),
            ('0', bit_vector(to_unsigned(100, damage_in'length)), -- Reset inicial
            bit_vector(to_unsigned(0, shield_out'length)),
            bit_vector(to_unsigned(0, health_out'length)),
            bit_vector(to_unsigned(12, turn_out'length)),
            "10"),
            ('0', bit_vector(to_unsigned(0, damage_in'length)), -- Reset inicial
            bit_vector(to_unsigned(0, shield_out'length)),
            bit_vector(to_unsigned(0, health_out'length)),
            bit_vector(to_unsigned(12, turn_out'length)),
            "10"),
            ('1', bit_vector(to_unsigned(20, damage_in'length)),
            bit_vector(to_unsigned(0, shield_out'length)),
            bit_vector(to_unsigned(0, health_out'length)),
            bit_vector(to_unsigned(0, turn_out'length)),
            "00"),
                    ('1', bit_vector(to_unsigned(20,damage_in'length)),                -- Reset inicial
              bit_vector(to_unsigned(0,shield_out'length)), 
              bit_vector(to_unsigned(0,health_out'length)), 
              bit_vector(to_unsigned(0,turn_out'length)), 
              "00"), 
        ('0', bit_vector(to_unsigned(0,damage_in'length)),                -- Reset inicial
              bit_vector(to_unsigned(255,shield_out'length)), 
              bit_vector(to_unsigned(255,health_out'length)), 
              bit_vector(to_unsigned(1,turn_out'length)), 
              "00"), 
        ('0', bit_vector(to_unsigned(31,damage_in'length)),                -- Reset inicial
              bit_vector(to_unsigned(255,shield_out'length)), 
              bit_vector(to_unsigned(255,health_out'length)), 
              bit_vector(to_unsigned(2,turn_out'length)), 
              "00"), 
        ('0', bit_vector(to_unsigned(35,damage_in'length)),                -- Reset inicial
              bit_vector(to_unsigned(236,shield_out'length)), 
              bit_vector(to_unsigned(255,health_out'length)), 
              bit_vector(to_unsigned(3,turn_out'length)), 
              "00"), 
        ('0', bit_vector(to_unsigned(6,damage_in'length)),                -- Reset inicial
              bit_vector(to_unsigned(246,shield_out'length)), 
              bit_vector(to_unsigned(255,health_out'length)), 
              bit_vector(to_unsigned(4,turn_out'length)), 
              "00"), 
        ('0', bit_vector(to_unsigned(1,damage_in'length)),                -- Reset inicial
              bit_vector(to_unsigned(255,shield_out'length)), 
              bit_vector(to_unsigned(255,health_out'length)), 
              bit_vector(to_unsigned(5,turn_out'length)), 
              "00"), 
        ('0', bit_vector(to_unsigned(17,damage_in'length)),                -- Reset inicial
              bit_vector(to_unsigned(254,shield_out'length)), 
              bit_vector(to_unsigned(255,health_out'length)), 
              bit_vector(to_unsigned(6,turn_out'length)), 
              "00"), 
        ('0', bit_vector(to_unsigned(216,damage_in'length)),                -- Reset inicial
              bit_vector(to_unsigned(54,shield_out'length)), 
              bit_vector(to_unsigned(255,health_out'length)), 
              bit_vector(to_unsigned(7,turn_out'length)), 
              "00"), 
        ('0', bit_vector(to_unsigned(2,damage_in'length)),                -- Reset inicial
              bit_vector(to_unsigned(54,shield_out'length)), 
              bit_vector(to_unsigned(255,health_out'length)), 
              bit_vector(to_unsigned(8,turn_out'length)), 
              "00"), 
        ('0', bit_vector(to_unsigned(156,damage_in'length)),                -- Reset inicial
              bit_vector(to_unsigned(0,shield_out'length)), 
              bit_vector(to_unsigned(155,health_out'length)), 
              bit_vector(to_unsigned(9,turn_out'length)), 
              "00"), 
        ('0', bit_vector(to_unsigned(0,damage_in'length)),                -- Reset inicial
              bit_vector(to_unsigned(2,shield_out'length)), 
              bit_vector(to_unsigned(155,health_out'length)), 
              bit_vector(to_unsigned(10,turn_out'length)), 
              "00"), 
        ('0', bit_vector(to_unsigned(59,damage_in'length)),                -- Reset inicial
              bit_vector(to_unsigned(0,shield_out'length)), 
              bit_vector(to_unsigned(100,health_out'length)), 
              bit_vector(to_unsigned(11,turn_out'length)), 
              "00"), 
        ('0', bit_vector(to_unsigned(1,damage_in'length)),                -- Reset inicial
              bit_vector(to_unsigned(1,shield_out'length)), 
              bit_vector(to_unsigned(100,health_out'length)), 
              bit_vector(to_unsigned(12,turn_out'length)), 
              "00"), 
        ('0', bit_vector(to_unsigned(3,damage_in'length)),                -- Reset inicial
              bit_vector(to_unsigned(0,shield_out'length)), 
              bit_vector(to_unsigned(100,health_out'length)), 
              bit_vector(to_unsigned(13,turn_out'length)), 
              "00"), 
        ('0', bit_vector(to_unsigned(82,damage_in'length)),                -- Reset inicial
              bit_vector(to_unsigned(0,shield_out'length)), 
              bit_vector(to_unsigned(20,health_out'length)), 
              bit_vector(to_unsigned(14,turn_out'length)), 
              "00"), 
        ('0', bit_vector(to_unsigned(12,damage_in'length)),                -- Reset inicial
              bit_vector(to_unsigned(0,shield_out'length)), 
              bit_vector(to_unsigned(10,health_out'length)), 
              bit_vector(to_unsigned(15,turn_out'length)), 
              "00"), 
        ('0', bit_vector(to_unsigned(12,damage_in'length)),                -- Reset inicial
              bit_vector(to_unsigned(0,shield_out'length)), 
              bit_vector(to_unsigned(0,health_out'length)), 
              bit_vector(to_unsigned(16,turn_out'length)), 
              "00"), 
        ('0', bit_vector(to_unsigned(12,damage_in'length)),                -- Reset inicial
              bit_vector(to_unsigned(0,shield_out'length)), 
              bit_vector(to_unsigned(0,health_out'length)), 
              bit_vector(to_unsigned(16,turn_out'length)), 
              "11"),
              
            ('1', bit_vector(to_unsigned(20, damage_in'length)),
            bit_vector(to_unsigned(0, shield_out'length)),
            bit_vector(to_unsigned(0, health_out'length)),
            bit_vector(to_unsigned(0, turn_out'length)),
            "00"),
            
            ('1', bit_vector(to_unsigned(20, damage_in'length)),
            bit_vector(to_unsigned(0, shield_out'length)),
            bit_vector(to_unsigned(0, health_out'length)),
            bit_vector(to_unsigned(0, turn_out'length)),
            "00"),
            
        ('1', bit_vector(to_unsigned(20,damage_in'length)),                -- Reset inicial
              bit_vector(to_unsigned(0,shield_out'length)), 
              bit_vector(to_unsigned(0,health_out'length)), 
              bit_vector(to_unsigned(0,turn_out'length)), 
              "00"), 
        ('0', bit_vector(to_unsigned(0,damage_in'length)),                -- Reset inicial
              bit_vector(to_unsigned(255,shield_out'length)), 
              bit_vector(to_unsigned(255,health_out'length)), 
              bit_vector(to_unsigned(1,turn_out'length)), 
              "00"), 
        ('0', bit_vector(to_unsigned(0,damage_in'length)),                -- Reset inicial
              bit_vector(to_unsigned(255,shield_out'length)), 
              bit_vector(to_unsigned(255,health_out'length)), 
              bit_vector(to_unsigned(2,turn_out'length)), 
              "00"), 
        ('0', bit_vector(to_unsigned(0,damage_in'length)),                -- Reset inicial
              bit_vector(to_unsigned(255,shield_out'length)), 
              bit_vector(to_unsigned(255,health_out'length)), 
              bit_vector(to_unsigned(3,turn_out'length)), 
              "00"), 
        ('0', bit_vector(to_unsigned(0,damage_in'length)),                -- Reset inicial
              bit_vector(to_unsigned(255,shield_out'length)), 
              bit_vector(to_unsigned(255,health_out'length)), 
              bit_vector(to_unsigned(4,turn_out'length)), 
              "00"), 
        ('0', bit_vector(to_unsigned(0,damage_in'length)),                -- Reset inicial
              bit_vector(to_unsigned(255,shield_out'length)), 
              bit_vector(to_unsigned(255,health_out'length)), 
              bit_vector(to_unsigned(5,turn_out'length)), 
              "00"), 
        ('0', bit_vector(to_unsigned(0,damage_in'length)),                -- Reset inicial
              bit_vector(to_unsigned(255,shield_out'length)), 
              bit_vector(to_unsigned(255,health_out'length)), 
              bit_vector(to_unsigned(6,turn_out'length)), 
              "00"), 
        ('0', bit_vector(to_unsigned(0,damage_in'length)),                -- Reset inicial
              bit_vector(to_unsigned(255,shield_out'length)), 
              bit_vector(to_unsigned(255,health_out'length)), 
              bit_vector(to_unsigned(7,turn_out'length)), 
              "00"), 
        ('0', bit_vector(to_unsigned(0,damage_in'length)),                -- Reset inicial
              bit_vector(to_unsigned(255,shield_out'length)), 
              bit_vector(to_unsigned(255,health_out'length)), 
              bit_vector(to_unsigned(8,turn_out'length)), 
              "00"), 
        ('0', bit_vector(to_unsigned(0,damage_in'length)),                -- Reset inicial
              bit_vector(to_unsigned(255,shield_out'length)), 
              bit_vector(to_unsigned(255,health_out'length)), 
              bit_vector(to_unsigned(9,turn_out'length)), 
              "00"), 
        ('0', bit_vector(to_unsigned(0,damage_in'length)),                -- Reset inicial
              bit_vector(to_unsigned(255,shield_out'length)), 
              bit_vector(to_unsigned(255,health_out'length)), 
              bit_vector(to_unsigned(10,turn_out'length)), 
              "00"), 
        ('0', bit_vector(to_unsigned(0,damage_in'length)),                -- Reset inicial
              bit_vector(to_unsigned(255,shield_out'length)), 
              bit_vector(to_unsigned(255,health_out'length)), 
              bit_vector(to_unsigned(11,turn_out'length)), 
              "00"), 
        ('0', bit_vector(to_unsigned(0,damage_in'length)),                -- Reset inicial
              bit_vector(to_unsigned(255,shield_out'length)), 
              bit_vector(to_unsigned(255,health_out'length)), 
              bit_vector(to_unsigned(12,turn_out'length)), 
              "00"), 
        ('0', bit_vector(to_unsigned(0,damage_in'length)),                -- Reset inicial
              bit_vector(to_unsigned(255,shield_out'length)), 
              bit_vector(to_unsigned(255,health_out'length)), 
              bit_vector(to_unsigned(13,turn_out'length)), 
              "00"), 
        ('0', bit_vector(to_unsigned(0,damage_in'length)),                -- Reset inicial
              bit_vector(to_unsigned(255,shield_out'length)), 
              bit_vector(to_unsigned(255,health_out'length)), 
              bit_vector(to_unsigned(14,turn_out'length)), 
              "00"), 
        ('0', bit_vector(to_unsigned(0,damage_in'length)),                -- Reset inicial
              bit_vector(to_unsigned(255,shield_out'length)), 
              bit_vector(to_unsigned(255,health_out'length)), 
              bit_vector(to_unsigned(15,turn_out'length)), 
              "00"), 
        ('0', bit_vector(to_unsigned(0,damage_in'length)),                -- Reset inicial
              bit_vector(to_unsigned(255,shield_out'length)), 
              bit_vector(to_unsigned(255,health_out'length)), 
              bit_vector(to_unsigned(16,turn_out'length)), 
              "00"), 
        ('0', bit_vector(to_unsigned(0,damage_in'length)),                -- Reset inicial
              bit_vector(to_unsigned(255,shield_out'length)), 
              bit_vector(to_unsigned(255,health_out'length)), 
              bit_vector(to_unsigned(16,turn_out'length)), 
              "01")

            );

      BEGIN

            ASSERT false REPORT "Simulation start" SEVERITY note;
            keep_simulating <= '1';
            --  Verifica cada pattern
            FOR k IN patterns'RANGE LOOP
                  --  Fornece as entradas
                  rst_in <= patterns(k).reset;
                  damage_in <= patterns(k).damage;

                  --  Espera até a atualização da UC
                  WAIT UNTIL rising_edge(clk_in);

                  --  Espera até a atualização da FD
                  WAIT UNTIL falling_edge(clk_in);
                  WAIT FOR clockPeriod/4;

                  --  Verifica as saídas.
                  ASSERT (shield_out = patterns(k).shield)
                  REPORT "Teste " & INTEGER'image(k) & " > "
                        & "Shield: " & INTEGER'image(to_integer(unsigned(shield_out))) & " (obtido), "
                        & INTEGER'image(to_integer(unsigned(patterns(k).shield))) & " (esperado); "
                        SEVERITY error;
                  --  Verifica as saídas.
                  ASSERT (health_out = patterns(k).health)
                  REPORT "Teste " & INTEGER'image(k) & " > "
                        & "Health: " & INTEGER'image(to_integer(unsigned(health_out))) & " (obtido), "
                        & INTEGER'image(to_integer(unsigned(patterns(k).health))) & " (esperado); "
                        SEVERITY error;
                  --  Verifica as saídas.
                  ASSERT (turn_out = patterns(k).turn)
                  REPORT "Teste " & INTEGER'image(k) & " > "
                        & "Turn: " & INTEGER'image(to_integer(unsigned(turn_out))) & " (obtido), "
                        & INTEGER'image(to_integer(unsigned(patterns(k).turn))) & " (esperado); "
                        SEVERITY error;
                  --  Verifica as saídas.
                  ASSERT (WL_out = patterns(k).WL)
                  REPORT "Teste " & INTEGER'image(k) & " > "
                        & "WL: " & INTEGER'image(to_integer(unsigned(WL_out))) & " (obtido), "
                        & INTEGER'image(to_integer(unsigned(patterns(k).WL))) & " (esperado); "
                        SEVERITY error;
            END LOOP;
            ASSERT false REPORT "Simulation end" SEVERITY note;
            keep_simulating <= '0';

            WAIT; -- end of simulation
      END PROCESS;

END ARCHITECTURE;