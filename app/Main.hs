module Main
  ( main
  ) where

import Data.Text qualified as T
import Data.Time.Clock.POSIX (getPOSIXTime)
import Network.HTTP.Client (newManager)
import Network.HTTP.Conduit (tlsManagerSettings)
import Options.Applicative
  (Parser, ParserInfo, auto, execParser, fullDesc, header, help, helper, info, long, metavar,
  option, progDesc, strOption, (<**>))
import Servant.Client (Scheme (Http), mkClientEnv, runClientM)
import Servant.Client.Core (BaseUrl (..))
import StatsCollecting (getStats)
import Toml qualified

getApiKey :: IO String
getApiKey = T.unpack <$> Toml.decodeFile (Toml.text "apiKey") "config.toml"

data Options = Options
  { oQuery :: String
  , oNumberOfHours :: Integer
  }

pOptions :: Parser Options
pOptions = Options
  <$> strOption
        ( mconcat
            [ long "query"
            , metavar "QUERY"
            , help "Substring to find"
            ]
        )
  <*> option auto
        ( mconcat
            [ long "numberOfHours"
            , metavar "NUMBER OF HOURS"
            , help "Range of hours starting from now"
            ]
        )

main :: IO ()
main = go =<< execParser optsParser
  where
    optsParser :: ParserInfo Options
    optsParser = info (pOptions <**> helper)
      ( mconcat
          [ fullDesc
          , progDesc "Prints statistic for some QUERY in NUMBER OF HOURS"
          , header "Software design lab 2"
          ]
      )

    go :: Options -> IO ()
    go Options{..} = do
      manager <- newManager tlsManagerSettings

      let url = BaseUrl
            { baseUrlScheme = Http
            , baseUrlHost = "api.vk.com"
            , baseUrlPort = 80
            , baseUrlPath = ""
            }

      let clientEnv = mkClientEnv manager url

      now <- getPOSIXTime
      apiKey <- getApiKey

      runClientM (getStats apiKey oQuery now oNumberOfHours) clientEnv >>= \case
        Left err -> do
          putStrLn "Some error happened:"
          print err
        Right res -> print res
