module Affine (encryption) where

import Crypto.Number.Basic
import Control.Monad
import Data.Char

type Key = (Int, Int) -- 暗号鍵 a, b のペア

encryption :: Key -> Char -> Char
encryption (a,b) c
  | c `elem` ['A'..'Z'] || c `elem` ['a'..'z'] = substD base e
  | otherwise = c
  where
    e = (a*x + b) `mod` m
    m = 26
    x = substE c
    base = if isUpper c then 'A' else 'a'

decryption :: Key -> Char -> Char
decryption (a,b) c
  | c `elem` ['A'..'Z'] || c `elem` ['a'..'z'] = substD base e
  | otherwise = c
  where
    e = fromIntegral invA * (x-b) `mod` m
    m = 26
    x = substE c
    (invA, _y, _v) = gcde (toInteger a) (toInteger m)
    base = if isUpper c then 'A' else 'a'

substE :: Char -> Int
substE c = fromEnum c - fromEnum base
  where
    base = if isUpper c then 'A' else 'a'

substD :: Char -> Int-> Char
substD base i = toEnum (i + fromEnum base)

crack :: Int -> String -> IO ()
crack a crypted = forM_ [0..25] $ \i -> do
  putStr $ show i <> ": "
  putStrLn $ map (decryption (a, i)) crypted