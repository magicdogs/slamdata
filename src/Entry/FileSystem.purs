{-
Copyright 2015 SlamData, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
-}

module Entry.FileSystem where

import Prelude

import Control.Monad.Aff (runAff, forkAff, Aff())
import Control.Monad.Eff (Eff())
import Control.Monad.Eff.Exception (throwException)
import Control.UI.Browser (setTitle)

import Data.Functor.Coproduct (left)
import Data.Functor.Eff (liftEff)

import Halogen.Component (installedState)
import Halogen.Driver (runUI)
import Halogen.Query (action)
import Halogen.Util (appendToBody, onLoad)

import DOM (DOM())

import FileSystem (comp, initialState, Query(..))
import FileSystem.Effects (FileSystemEffects())
import FileSystem.Routing (routeSignal)

setSlamDataTitle :: forall e. String -> Aff (dom :: DOM|e) Unit
setSlamDataTitle version =
  liftEff $ setTitle $ "SlamData " <> version

main :: Eff FileSystemEffects Unit
main = runAff throwException (const (pure unit)) do
  halogen <- runUI comp (installedState initialState)
  onLoad (appendToBody halogen.node)
  forkAff do
    let version = Config.Version.slamDataVersion
    setSlamDataTitle version
    halogen.driver (left $ action $ SetVersion version)
  forkAff $ routeSignal halogen.driver
