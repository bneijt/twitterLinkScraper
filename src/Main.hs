module Main where

import qualified Network.Curl as Curl
import qualified Text.JSON as Json
import Text.Regex.Posix (getAllTextMatches, (=~))
import Data.List.Split (splitOn)
import Data.IORef

-- This url will work if you run doc/serve.py
twitterStreamingAPIStatusUrl :: String
-- twitterStreamingAPIStatusUrl = "http://stream.twitter.com/1/statuses/sample.json"
twitterStreamingAPIStatusUrl = "http://localhost:8080/"
username :: String
username = ""
password :: String
password = ""
{-
username = ""
password = ""
-}

perWordOfStatus :: String -> IO()
perWordOfStatus ('#':t) = putStrLn t
perWordOfStatus _ = putStr ""

urlRegex :: String
urlRegex = "http://[a-zA-Z0-9.-_]+\\.[a-zA-Z]{2,3}(/[a-zA-Z0-9.-_/:#$?]*)?"

printUrlsFrom :: String -> IO()
printUrlsFrom value = mapM_ putStrLn $ getAllTextMatches (value =~ urlRegex)

parseTwitterStatus :: String -> IO()
parseTwitterStatus line = do
      case Json.decode line :: Json.Result Json.JSValue of
        Json.Ok (Json.JSObject twitterMessage) -> printUrlsFrom $ getTextField twitterMessage
        Json.Error msg -> putStrLn ("Error:  " ++ msg ++ "\n" ++ (take 200 line))

getTextField :: Json.JSObject Json.JSValue -> String
getTextField a = case Json.valFromObj "text" a of
    Json.Ok b -> b
    Json.Error _ -> ""

collectLine :: (IORef String) -> String -> IO()
collectLine buffer newInput = do
    bufferValue <- readIORef buffer
    let newBufferValue = bufferValue ++ newInput
    if any ('\n' ==) newBufferValue
        then do
            let bufferedLines = splitOn "\n" newBufferValue
            mapM_ parseTwitterStatus $ init bufferedLines
            writeIORef buffer $ last bufferedLines
        else
            writeIORef buffer $ newBufferValue


twitterReader :: IO()
twitterReader = do
    buffer <- newIORef ""
    h <- Curl.initialize
    Curl.setopts h
        [ Curl.CurlFailOnError   $ True
        , Curl.CurlURL           $ twitterStreamingAPIStatusUrl
        , Curl.CurlUserPwd       $ username ++ ":" ++ password
        , Curl.CurlHttpAuth      $ [Curl.HttpAuthAny]
        , Curl.CurlWriteFunction $ Curl.callbackWriter (collectLine buffer)]
    returnCode <- Curl.perform h
    putStrLn $ show returnCode


main :: IO ()
main = twitterReader




