module Input.Notebook (updateState) where

import Data.Maybe (maybe)
import Data.Array (filter, modifyAt, (!!))
import Model.Path (getName, updateName)
import Model.Notebook
import Optic.Core ((..), (<>~), (%~), (+~))
import Optic.Setter (mapped, over)
import qualified App.Notebook.Ace as NA

updateState :: State -> Input -> State

updateState state (Dropdown i) =
  let visSet = maybe true not (_.visible <$> state.dropdowns !! i) in
  state # dropdowns %~
  (modifyAt i (\x -> x{visible = visSet})) <<<  (_{visible = false} <$>)

updateState state CloseDropdowns =
  state{addingCell = false} # dropdowns %~ (_{visible = false} <$>)

updateState state (SetTimeout mbTm) =
  state{timeout = mbTm}

updateState state (SetPath path) =
  state{path = path, name = getName path}

updateState state (SetName name) =
  state{path = updateName name state.path}

updateState state (SetItems items) =
  state{items = items}

updateState state (SetLoaded loaded) =
  state{loaded = loaded}

updateState state (SetError error) =
  state{error = error}

updateState state (SetEditable editable) =
  state{editable = editable}

updateState state (SetModalError error) =
  state{modalError = error}

updateState state (SetAddingCell adding) =
  state{addingCell = adding}

updateState state (AddCell cellType) =
  state # (nextCellId +~ 1)..addCell cellType

updateState state (ToggleEditorCell cellId) =
  state # notebook..notebookCells..mapped %~ toggleEditor cellId

updateState state (TrashCell cellId) =
  state # notebook..notebookCells %~ filter (not <<< isCell cellId)

updateState state (AceInput (NA.TextCopied _)) =
  state

toggleEditor :: CellId -> Cell -> Cell
toggleEditor ci c@(Cell o) | isCell ci c = Cell $ o { hiddenEditor = not o.hiddenEditor }
toggleEditor _ c = c

isCell :: CellId -> Cell -> Boolean
isCell ci (Cell { cellId = ci' }) = ci == ci'

addCell :: CellType -> State -> State
addCell cellType state =
  state # notebook..notebookCells <>~ [ newCell (show state.nextCellId) cellType ]
