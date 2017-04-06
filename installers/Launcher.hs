module Launcher where

import qualified Data.List       as L
import           Data.Monoid     ((<>))
import           System.FilePath (pathSeparator)

-- OS dependent configuration
data Launcher = Launcher
    { nodePath      :: String
    , nodeLogPath   :: String
    , walletPath    :: String
    , installerPath :: String
    , runtimePath   :: String
    }

launcherArgs :: Launcher -> String
launcherArgs launcher = unwords $
  [ "--node", quote (nodePath launcher)
  , "--node-log-path", quote (nodeLogPath launcher)
  , "--wallet", quote (walletPath launcher)
  , "--updater ", quote (installerPath launcher)
  , "--node-timeout 5"
  , (" -n " ++ (L.intercalate " -n " nodeArgs))
  ]
    where
      nodeArgs = [
        "--listen", "127.0.0.1:12100",
        "--report-server", "http://35.157.192.243:8080",
        "--log-config", "log-config-prod.yaml",
        "--update-latest-path", quote (installerPath launcher),
        "--keyfile", quote (runtimePath launcher <> "Secrets" <> (pathSeparator : "secret.key")),
        "--logs-prefix", quote (runtimePath launcher <> "Logs"),
        "--db-path", quote (runtimePath launcher <> "DB-0.2"),
        "--wallet-db-path", quote (runtimePath launcher <> "Wallet-0.2"),
        "--peers-file", "ip-dht-mappings",
        "--system-start", "1491409300",
        "--wallet"
        ]

quote :: String -> String
quote p = "\"" <> p <> "\""