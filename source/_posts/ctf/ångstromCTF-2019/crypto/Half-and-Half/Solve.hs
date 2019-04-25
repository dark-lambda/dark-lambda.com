import Data.Bits
import Data.Char

solve :: Char -> Int -> Char
solve c t = chr ((ord c) `xor` t)

xs :: [(Char, Int)]
xs = [ ('t', 0x15)
     , ('a', 0x02)
     , ('s', 0x07)
     , ('t', 0x12)
     , ('e', 0x1e)
     , ('s', 0x10)
     , ('_', ord '0')
     , ('g', 0x01)
     , ('o', ord '\t')
     , ('o', ord '\n')
     , ('d', 0x01)
     , ('}', ord '"')
     ]