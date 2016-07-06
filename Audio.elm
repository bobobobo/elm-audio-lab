module Audio exposing ( startAudio, stopAudio, updateModel )
{-| A module for accessing the Web Audio API via Elm.

@docs addOne, testStuff


-}
import Native.Audio


{-| Start audio generation. 
-}
startAudio : generator -> Platform.Task x a
startAudio value =
    Native.Audio.startAudio value


{-| Stop audio generation.
-}
stopAudio : Platform.Task x a
stopAudio =
    Native.Audio.stopAudio

{-| Update model used for audio generation.
-}
updateModel : m -> Platform.Task x a
updateModel model =
    Native.Audio.updateModel model