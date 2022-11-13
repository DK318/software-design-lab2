module Util
  ( hour
  , hoursToUnixString
  ) where

hour :: Integer
hour = 60 * 60

hoursToUnixString :: Integer -> String
hoursToUnixString n = show $ n * hour
