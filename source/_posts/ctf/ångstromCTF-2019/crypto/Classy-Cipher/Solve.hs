import Data.Char

solve :: Char -> Char -> Int
solve plain encrypted = head [ n | n <- [0..0xff], shift n plain == encrypted]

shift :: Int -> Char -> Char
shift k c = chr ((ord c + k) `mod` 0xff)