entity hamming is
    port (
    entrada : in bit_vector (13 downto 1 ) ;
    dados : out bit_vector (8 downto 0)
    ) ;
    end hamming ;
    
    architecture ham of hamming is
        signal pos : BIT_VECTOR(3 downto 0);
    begin
    pos(0) <= entrada(1) xor entrada(3) xor entrada(5) xor entrada(7) xor entrada(9) xor entrada(11) xor entrada(13);
    pos(1) <= entrada(2) xor entrada(3) xor entrada(6) xor entrada(7) xor entrada(10) xor entrada(11);
    pos(2) <= entrada(4) xor entrada(5) xor entrada(6) xor entrada(7) xor entrada(12) xor entrada(13);
    pos(3) <= entrada(8) xor entrada(9) xor entrada(10) xor entrada(11) xor entrada(12) xor entrada(13);
    
    dados(0) <= entrada(3) when pos /= "0011" else (not entrada(3));
    dados(1) <= entrada(5) when pos /= "0101" else (not entrada(5));
    dados(2) <= entrada(6) when pos /= "0110" else (not entrada(6));
    dados(3) <= entrada(7) when pos /= "0111" else (not entrada(7));
    dados(4) <= entrada(9) when pos /= "1001" else (not entrada(9));
    dados(5) <= entrada(10) when pos /= "1010" else (not entrada(10));
    dados(6) <= entrada(11) when pos /= "1011" else (not entrada(11));
    dados(7) <= entrada(12) when pos /= "1100" else (not entrada(12));
    dados(8) <= entrada(13) when pos /= "1101" else (not entrada(13));
    
    
    end ham;