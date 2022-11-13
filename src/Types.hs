module Types
  ( TotalCount (..)
  ) where

import Data.Aeson (FromJSON, ToJSON, parseJSON, withObject, (.:))
import Data.Aeson.QQ (aesonQQ)
import Data.Aeson.Types (toJSON)

newtype TotalCount = TotalCount { unTotalCount :: Integer }
  deriving newtype (Show, Eq, Ord)

instance FromJSON TotalCount where
  parseJSON = withObject "response" \o -> do
    totalCount <- o .: "response" >>= flip (.:) "total_count"
    pure $ TotalCount totalCount

instance ToJSON TotalCount where
  toJSON (TotalCount cnt) =
    [aesonQQ|
      {
        "response": { "total_count": #{cnt} }
      }
    |]
