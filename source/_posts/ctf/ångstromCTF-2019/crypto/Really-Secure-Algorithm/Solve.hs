import Crypto.PubKey.RSA
import Crypto.Number.ModArithmetic
import Crypto.Number.Serialize

import Data.Text
import Data.Text.Encoding

solve :: Integer -> Integer -> Integer -> Integer -> Text
solve p q e c = toDisplay $ expSafe c d n
  where
    n = p * q
    d = case generateWith (p,q) 0 e of
      Nothing -> error "generateWith error"
      Just (_pubKey, privateKey) -> private_d privateKey

toDisplay :: Integer -> Text
toDisplay = decodeUtf8 . i2osp