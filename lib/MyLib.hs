module MyLib
  ( Tube (..),
    process,
    recv,
  )
where

import Data.ByteString
import GHC.IO.Handle
import Network.Connection
import System.Process

data Tube = Conn Connection | Proc (Maybe Handle, Maybe Handle, Maybe Handle, ProcessHandle)

process :: [String] -> IO Tube
process (path : args) = do
  (hin, hout, herr, ph) <- createProcess (proc path args) {std_out = CreatePipe}
  return $ Proc (hin, hout, herr, ph)

recv :: Tube -> Int -> IO ByteString
recv (Conn con) number = connectionGet con number
recv (Proc (_, hout, _, _)) number = case hout of
  Nothing -> error "Could not get stdout handle from process"
  Just hout' -> hGet hout' number
