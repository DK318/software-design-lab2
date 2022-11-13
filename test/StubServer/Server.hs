module StubServer.Server
  ( stubServer
  , port
  , connectionUrl
  ) where

import Client (NewsFeedSearch)
import FakeDatabase.Database (queryDatabase)
import Servant.Client (BaseUrl (..), Scheme (Http))
import Servant.Server (Handler, Server)
import Types (TotalCount (TotalCount))

stubServer :: Server NewsFeedSearch
stubServer = getTotalCount
  where
    getTotalCount :: String -> String -> String -> String -> String -> Handler TotalCount
    getTotalCount _ hashtag startTime endTime _ =
      pure . TotalCount $ queryDatabase startTime endTime hashtag

port :: Int
port = 8081

connectionUrl :: BaseUrl
connectionUrl = BaseUrl
  { baseUrlScheme = Http
  , baseUrlHost = "localhost"
  , baseUrlPort = port
  , baseUrlPath = ""
  }
