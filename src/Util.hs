module Util
  ( toUnixTime
  ) where

import Data.Time.Clock.POSIX (POSIXTime)

toUnixTime :: POSIXTime -> Integer
toUnixTime = truncate
