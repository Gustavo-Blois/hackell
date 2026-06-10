module Main where

import qualified Data.Text as T
import qualified Data.Text.Encoding as TEnc
import MyLib

main :: IO ()
main = do
  p <- process ["ls", "-la", "/"]
  r <- recv p 100
  putStrLn $ T.unpack $ TEnc.decodeUtf8 $ r
