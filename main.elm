import Html exposing (Html, input, button, div, text)
import Html.Attributes exposing (..)
import Html.App as Html
import Html.Events exposing (onClick)
import Audio
import Task
import String

main =
  Html.program { init = init, view = view, update = update, subscriptions = subscriptions }



-- MODEL

type alias Model = 
  { playing: Bool,
    freq: Float
  }

type alias AudioGenerator = Float -> Model -> Float

init : (Model, Cmd Msg)
init =
    let 
      model = Model False 440
    in
      (model, (updateAudioModel model))


-- UPDATE

type Msg = Play | NoOp | AudioSucceed Int | AudioError Int | UpdateFrequency Float

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Play ->
       let 
          playing = not model.playing
        in
          ({ model | playing = playing }, if not playing then stopCmd else (playCmd generateAudio))
    NoOp ->
      (model, Cmd.none)
    AudioSucceed a ->
      (model, Cmd.none)
    AudioError a ->
      (model, Cmd.none)
    UpdateFrequency freq ->
      let
        newModel = {model | freq = freq}
      in
        (newModel, updateAudioModel newModel)


-- AUDIO GENERATION

sine sample freq =
  sin ((2 * pi * freq * sample) / 44100)

saw sample freq =
  let
    x = sample / (44100 / freq)
  in
    2.0 * (x - (toFloat (floor x) + 0.5))

square sample freq =
  let
    periodSamples = (44100 / freq)
    x = sample / (44100 / freq)
  in
    if (floor sample) % (floor periodSamples) < ((floor periodSamples) // 2) then
      1.0
    else
      -1.0

generateAudio sample model =
  let
    x = 50 * (square sample 10)
  in
    sine sample (model.freq + x)

playCmd : AudioGenerator -> Cmd Msg
playCmd generator =
  Task.perform AudioError AudioSucceed (Audio.startAudio generator)


stopCmd : Cmd Msg
stopCmd =
  Task.perform AudioError AudioSucceed (Audio.stopAudio)


updateAudioModel : Model -> Cmd Msg
updateAudioModel model = 
  Task.perform AudioError AudioSucceed (Audio.updateModel model)

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none


-- VIEW

viewSlider : Float -> Html Msg
viewSlider freq =
  div []
    [ input
      [ type' "range"
      , Html.Attributes.min "440"
      , Html.Attributes.max "600"
      , Html.Events.onInput <| String.toFloat >> Result.withDefault 0.0 >> UpdateFrequency
      , value (toString freq)
      ] []
    ]

view : Model -> Html Msg
view model =
  let
    buttonLabel = 
        if model.playing then
          "Pause"
        else
          "Play"
  in
    div []
      [ button [ onClick Play ] [ text buttonLabel ]
      , div [] [ text (toString model.freq) ],
      viewSlider model.freq
      ]