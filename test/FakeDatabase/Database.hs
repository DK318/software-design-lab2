module FakeDatabase.Database
  ( Database
  , queryDatabase
  ) where

import Data.Function ((&))
import Data.Set (Set)
import Data.Set qualified as S
import Util (hour)

type Database = Set (Integer, String)

database :: Database
database = S.fromList
  [ (0, "#bar")
  , (1, "#pizza")
  , (2, "#bar")
  , (hour, "#test")
  , (hour + 1, "#hashtag")
  , (2 * hour, "#test")
  , (3 * hour, "#bar")
  , (3 * hour + 1, "#test")
  , (3 * hour + 2, "#hashtag")
  , (4 * hour, "#pizza")
  , (5 * hour, "#bar")
  , (5 * hour + 1, "#bar")
  , (6 * hour + 1, "#wow")
  ]

queryDatabase :: String -> String -> String -> Integer
queryDatabase (read -> startTime) (read -> endTime) query =
  S.size result
    & fromIntegral
  where
    (result, _) = database
      & S.partition \(timestamp, hashtag) ->
        startTime <= timestamp && timestamp <= endTime && hashtag == query
