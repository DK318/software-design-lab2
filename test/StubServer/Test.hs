module StubServer.Test
  ( spec_stub_server_tests
  ) where

import Client (newsFeedSearch)
import Control.Monad.Reader (MonadReader (ask), Reader)
import Servant.Client (ClientEnv, runClientM)
import StatsCollecting (StatsPerHour (StatsPerHour), getStats)
import Test.HUnit (Assertion, assertFailure, (@?=))
import Test.Tasty (TestTree, testGroup)
import Test.Tasty.HUnit (testCase)
import Types (TotalCount (TotalCount))
import Util (hour)

spec_stub_server_tests :: Reader ClientEnv TestTree
spec_stub_server_tests = ask >>= \clientEnv -> pure $ testGroup "Stub server tests"
  [ testGroup "newsFeedSearch tests"
      let
        assertNewsFeedSearch :: String -> Integer -> Integer -> Integer -> Assertion
        assertNewsFeedSearch hashtag startTime endTime expected = do
          runClientM
            do newsFeedSearch "fake_token" hashtag (fromIntegral $ startTime * hour) (fromIntegral $ endTime * hour)
            clientEnv >>= \case
              Left err -> assertFailure (show err)
              Right result -> result @?= TotalCount expected
      in
      [ testCase "Count bar hashtags" do
          assertNewsFeedSearch "#bar" 0 24 5

      , testCase "No hashtags" do
          assertNewsFeedSearch "#DontExist" 0 24 0

      , testCase "#test hashtag" do
          assertNewsFeedSearch "#test" 3 6 1
      ]

  , testGroup "getStats tests"
      let
        assertGetStats :: String -> Integer -> Integer -> [Integer] -> Assertion
        assertGetStats hashtag startTime hours expected = do
          runClientM (getStats "fake_token" hashtag (fromIntegral $ startTime * hour) hours) clientEnv >>= \case
            Left err -> assertFailure (show err)
            Right result -> result @?= StatsPerHour expected
      in
      [ testCase "bar statistics for 12 hours" do
          assertGetStats "#bar" 12 12 [0, 0, 0, 2, 3, 3, 4, 3, 3, 2, 2, 1, 0]

      , testCase "Count not existing tag" do
          assertGetStats "#DontExist" 6 6 [0, 0, 0, 0, 0, 0, 0]

      , testCase "Count #test hashtag" do
          assertGetStats "#test" 6 3 [0, 1, 2, 2]
      ]
  ]
