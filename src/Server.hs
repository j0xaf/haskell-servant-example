module Server(server, itemApi) where

import Servant
import GHC.Generics
import Data.Aeson (FromJSON, ToJSON)
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
