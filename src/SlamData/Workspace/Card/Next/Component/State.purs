{-
Copyright 2016 SlamData, Inc.

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

module SlamData.Workspace.Card.Next.Component.State where

import Data.Lens (Lens', lens)

import Halogen as H

import SlamData.Monad (Slam)
import SlamData.Workspace.Card.Next.Component.Query (Query)
import SlamData.Workspace.Card.Next.Component.ChildSlot as CS
import SlamData.Workspace.Card.Port (Port)

type StateP =
  H.ParentState State CS.ChildState Query CS.ChildQuery Slam CS.ChildSlot

type State =
  { input ∷ Port
  , presentAddCardGuide ∷ Boolean
  }

initialState ∷ Port → State
initialState input =
    { input
    , presentAddCardGuide: false
    }

_input ∷ ∀ a r. Lens' { input ∷ a | r } a
_input = lens _.input (_ { input = _ })

_presentAddCardGuide ∷ ∀ a r. Lens' { presentAddCardGuide ∷ a | r } a
_presentAddCardGuide = lens _.presentAddCardGuide (_ { presentAddCardGuide = _ })
