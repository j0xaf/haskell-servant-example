{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE LambdaCase #-}
module Server where

import Data.Function((&))
import Servant
import GHC.Generics
import Data.Aeson (FromJSON, ToJSON)
import Network.Wai.Handler.Warp (defaultSettings, setPort, runSettings, setBeforeMainLoop)
import System.IO
import Data.Text (Text)

type ItemApi = 
    "item" :> Get '[JSON] [Item] :<|>
    "item" :> Capture "itemId" Integer :> Get '[JSON] Item

data Item = Item {
    itemId :: Integer,
    itemText :: Text
  } deriving (Eq, Show, Generic)

instance FromJSON Item
instance ToJSON Item

itemApi :: Proxy ItemApi
itemApi = Proxy

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

server :: Server ItemApi
server = 
    getItems :<|>
    getItemById

getItems :: Handler [Item]
getItems = return [exampleItem]
    
getItemById :: Integer -> Handler Item
getItemById =  \case
    0 -> return exampleItem
    _ -> throwError err404

exampleItem :: Item
exampleItem = Item 0 "exampleItem"
