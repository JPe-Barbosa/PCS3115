-- Code your design here

entity JogoDaVelha is
    port (
    a1 , a2 , a3 : in bit_vector (1 downto 0);
    b1 , b2 , b3 : in bit_vector (1 downto 0);
    c1 , c2 , c3 : in bit_vector (1 downto 0);
    z : out bit_vector (1 downto 0)
    ) ;
    end JogoDaVelha ;
    
    architecture teste of JogoDaVelha is 
     signal X,Y: bit;
    begin
      X <=  '1' when 
              (a3 = "10" and b2 = "10" and c1 = "10") or 
              (a3 = "10" and b3 = "10" and c3 = "10") or
              (a3 = "10" and a2 = "10" and a1 = "10") or
              (b3 = "10" and b2 = "10" and b1 = "10") or
              (c3 = "10" and b2 = "10" and a1 = "10") or
              (c3 = "10" and c2 = "10" and c1 = "10") or
              (a2 = "10" and b2 = "10" and c2 = "10") or
              (a1 = "10" and b1 = "10" and c1 = "10") else
            '0';
      
       Y <=  '1' when 
              (a3 = "01" and b2 = "01" and c1 = "01") or 
              (a3 = "01" and b3 = "01" and c3 = "01") or
              (a3 = "01" and a2 = "01" and a1 = "01") or
              (b3 = "01" and b2 = "01" and b1 = "01") or
              (c3 = "01" and b2 = "01" and a1 = "01") or
              (c3 = "01" and c2 = "01" and c1 = "01") or
              (a2 = "01" and b2 = "01" and c2 = "01") or
              (a1 = "01" and b1 = "01" and c1 = "01") else
            '0';
      
       z <= "11" when (X = '1' and Y ='1') else 
            "10" when (X = '1') else
            "01" when (Y = '1') else 
            "00";
        
    end teste;