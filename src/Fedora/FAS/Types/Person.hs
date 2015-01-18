{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE FunctionalDependencies #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
module Fedora.FAS.Types.Person where

import Control.Applicative
import Control.Lens
import Control.Monad (mzero)
import Data.Aeson
import Fedora.FAS.Types.Pages
import Fedora.FAS.Types.UTCTimeFAS

data Person = Person {
    _username     :: String
  , _status       :: Integer
  , _idNumber     :: Integer
  , _avatar       :: Maybe String
  , _fullname     :: String
  , _creationDate :: UTCTimeFAS
  , _ircNick      :: Maybe String
  , _email        :: String
  } deriving (Eq, Ord, Show)

instance FromJSON Person where
  parseJSON (Object v) = Person
                         <$> v .:  "Username"
                         <*> v .:  "Status"
                         <*> v .:  "PeopleId"
                         <*> v .:? "Avatar"
                         <*> v .:  "Fullname"
                         <*> v .:  "CreationDate"
                         <*> v .:? "Ircnick"
                         <*> v .:  "Email"
  parseJSON _          = mzero

makeLenses ''Person

data PersonResponse = PersonResponse {
    personResponseStartTimestamp :: UTCTimeFAS
  , personResponseEndTimestamp   :: UTCTimeFAS
  , personResponsePeople         :: Person
  } deriving (Eq, Ord, Show)

instance FromJSON PersonResponse where
  parseJSON (Object v) = PersonResponse
                         <$> v .:  "StartTimeStamp"
                         <*> v .:  "EndTimeStamp"
                         <*> v .:  "People"
  parseJSON _          = mzero

makeFields ''PersonResponse

data PeopleResponse = PeopleResponse {
    poepleResponseStartTimestamp :: UTCTimeFAS
  , peopleResponseEndTimestamp   :: UTCTimeFAS
  , peopleResponsePages          :: Pages
  , peopleResponsePeople         :: [Person]
  } deriving (Eq, Ord, Show)

instance FromJSON PeopleResponse where
  parseJSON (Object v) = PeopleResponse
                         <$> v .:  "StartTimeStamp"
                         <*> v .:  "EndTimeStamp"
                         <*> v .:  "Pages"
                         <*> v .:  "People"
  parseJSON _          = mzero

makeFields ''PeopleResponse
