module Main where

import Server
import Network.Wai.Handler.Warp (defaultSettings, setPort, runSettings, setBeforeMainLoop)
import System.IO
import Data.Function((&))
import Network.Wai (Application)
import Servant (serve)

main :: IO ()
main = run

--
-- * App
-- 

run :: IO ()
run = do
    let port = 3000
        settings = 
            defaultSettings
            & setPort port
            & setBeforeMainLoop (hPutStrLn stderr ("listening on port " ++ show port))
    runSettings settings =<< mkApp

mkApp :: IO Application
mkApp = return $ serve itemApi server
