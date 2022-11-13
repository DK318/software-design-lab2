module Client
  ( NewsFeedSearch
  , newsFeedSearch
  ) where

import Data.Time.Clock.POSIX (POSIXTime)
import Data.Typeable (Proxy (..))
import Servant.API (Get, JSON, QueryParam', Required, Strict, type (:>))
import Servant.Client.Core (RunClient, clientIn)
import Types (TotalCount)
import Util (toUnixTime)

type NewsFeedSearch = "method"
  :> "newsfeed.search"
  :> QueryParam' '[Required, Strict] "access_token" String
  :> QueryParam' '[Required, Strict] "q" String
  :> QueryParam' '[Required, Strict] "start_time" String
  :> QueryParam' '[Required, Strict] "end_time" String
  :> QueryParam' '[Required, Strict] "v" String
  :> Get '[JSON] TotalCount

newsFeedSearch' :: (RunClient m) => String -> String -> String -> String -> String -> m TotalCount
newsFeedSearch' = clientIn (Proxy @NewsFeedSearch) Proxy

newsFeedSearch :: (RunClient m) => String -> String -> POSIXTime -> POSIXTime -> m TotalCount
newsFeedSearch token query startTime endTime =
  newsFeedSearch'
    token
    query
    do show $ toUnixTime startTime
    do show $ toUnixTime endTime
    "5.131"
