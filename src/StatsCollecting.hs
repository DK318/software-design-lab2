module StatsCollecting
  ( StatsPerHour (..)
  , getStats
  ) where

import Client (newsFeedSearch)
import Control.Monad (forM)
import Data.Time.Clock.POSIX (POSIXTime)
import Servant.Client.Core (RunClient)
import Types (TotalCount (unTotalCount))

newtype StatsPerHour = StatsPerHour { unStatsPerHour :: [Integer] }
  deriving newtype (Eq, Ord)

instance Show StatsPerHour where
  show (StatsPerHour cnts) =
    unlines $ zipWith (\num cnt -> show @Integer num <> ": " <> show cnt) [1..] (tail cnts)

getStats :: (RunClient m) => String -> String -> POSIXTime -> Integer -> m StatsPerHour
getStats token query now hours = StatsPerHour
  <$> forM [0..hours] \hour -> do
        let endTime = now - 60 * 60 * fromIntegral (hour + 1)
        let startTime = endTime - 60 * 60 * fromIntegral hour
        unTotalCount <$> newsFeedSearch token query startTime endTime
