module Todo.Todo (component) where
  
import Prelude

import Data.Maybe (Maybe(..))
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP

type State = 
  { 
    input :: String
  , todos :: Array Todos 
  }

type Todos = 
  {
    todo :: String
  , completed :: Boolean
  } 


data Action a = 
    AddTodo a
  | UpdateInput a


initialState :: forall i. i -> State 
initialState _ = { 
                   input : ""
                 , todos : [] 
                 }

component :: forall q i o m. H.Component HH.HTML q i o m
component =
  H.mkComponent
    { initialState
    , render
    , eval: H.mkEval $ H.defaultEval { handleAction = handleAction }
    }

handleAction ∷ forall o m. (Action String) -> H.HalogenM State (Action String) () o m Unit
handleAction = case _ of
  UpdateInput (str) -> 
    H.modify_ \st -> st { input = str }
  AddTodo (str) ->
    H.modify_ \st -> st { 
                        todos = (st.todos) <> ([
                          { 
                            todo : str 
                          , completed : false 
                          }
                        ]) 
                        , input = ""
                      }

render :: forall m. State -> H.ComponentHTML (Action String) () m 
render state = HH.div_ 
  [
    HH.div_ [ HH.text state.input ]
  , HH.div_ [ HH.text $ show $ state ]
  , HH.input [
      HP.value state.input
    , HP.type_ HP.InputText
    , HE.onValueInput $ Just <<< UpdateInput 
    ] 
  , HH.button [ 
                HE.onClick $ (\ _ -> (Just <<< AddTodo) state.input)
              ] []
  ]
