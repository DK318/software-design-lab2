module FakeDatabase.Test
  ( spec_Database_tests
  ) where

import FakeDatabase.Database (queryDatabase)
import Test.Tasty (TestTree, testGroup)
import Test.Tasty.HUnit (Assertion, testCase, (@?=))
import Util (hoursToUnixString)

databaseAssert :: Integer -> Integer -> String -> Integer -> Assertion
databaseAssert startTime endTime hashtag expectedCnt = do
  let startTimeStr = hoursToUnixString startTime
  let endTimeStr = hoursToUnixString endTime
  queryDatabase startTimeStr endTimeStr hashtag @?= expectedCnt

spec_Database_tests :: TestTree
spec_Database_tests = testGroup "Fake database tests"
  [ testCase "Count bar hashtags" do
      databaseAssert 0 24 "#bar" 5

  , testCase "No hashtags" do
      databaseAssert 0 24 "#DontExist" 0

  , testCase "#test hashtag" do
      databaseAssert 3 6 "#test" 1
  ]
