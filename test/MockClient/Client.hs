module MockClient.Client
  ( mockClient
  ) where

import Control.Monad.Free (Free (..))
import Data.Aeson (encode)
import Data.Bifunctor (second)
import Data.Foldable (toList)
import Data.Function ((&))
import Data.Functor ((<&>))
import Data.Map ((!))
import Data.Map qualified as M
import Data.Maybe (fromJust)
import Data.Sequence qualified as Seq
import Data.Text qualified as T
import FakeDatabase.Database (queryDatabase)
import Network.HTTP.Types (hContentType, http20, ok200, queryToQueryText)
import Servant.Client.Core (ClientError, RequestF (requestQueryString), ResponseF (..))
import Servant.Client.Free (ClientF (..))
import Types (TotalCount (TotalCount))

mockClient :: Free ClientF a -> IO (Either ClientError a)
mockClient = \case
  Pure res -> pure $ Right res
  Free (Throw err) -> pure $ Left err
  Free (RunRequest req cont) -> do
    let query = req
          & requestQueryString
          & toList
          & queryToQueryText
          <&> second (T.replace "%23" "#" . fromJust)
          & M.fromList

    let startTime = T.unpack $ query ! "start_time"
    let endTime = T.unpack $ query ! "end_time"
    let q = T.unpack $ query ! "q"
    let result = TotalCount $ queryDatabase startTime endTime q

    let response = Response
          { responseStatusCode = ok200
          , responseHeaders = Seq.singleton (hContentType, "application/json")
          , responseHttpVersion = http20
          , responseBody = encode result
          }

    mockClient (cont response)
