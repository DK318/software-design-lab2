import Client (NewsFeedSearch)
import Control.Concurrent.Async (withAsync)
import Control.Monad.Reader (runReader)
import Data.Typeable (Proxy (Proxy))
import FakeDatabase.Test (spec_Database_tests)
import MockClient.Test (spec_mock_client_test)
import Network.HTTP.Client (newManager)
import Network.HTTP.Conduit (tlsManagerSettings)
import Network.Wai.Handler.Warp (run)
import Servant.Client (mkClientEnv)
import Servant.Server (serve)
import StubServer.Server (connectionUrl, port, stubServer)
import StubServer.Test (spec_stub_server_tests)
import Test.Tasty (defaultMain, testGroup)

main :: IO ()
main = do
  withAsync
    do run port $ serve (Proxy @NewsFeedSearch) stubServer
    do
      \_ -> do
        manager <- newManager tlsManagerSettings
        let clientEnv = mkClientEnv manager connectionUrl

        let allTests = testGroup "All tests"
              [ spec_Database_tests
              , runReader spec_stub_server_tests clientEnv
              , spec_mock_client_test
              ]

        defaultMain allTests
