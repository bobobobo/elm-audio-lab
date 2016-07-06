var _bobobobo$elm_audio_lab$Native_Audio = function() {

var _audioGenerator, _model = null, _audioContext, _sampleNumber = 0, _processingNode;

function updateModel(model){

    return _elm_lang$core$Native_Scheduler.nativeBinding(function(callback)
    {
        _model = model;
        callback(_elm_lang$core$Native_Scheduler.succeed(1));
    });
}

function startAudio(audioGenerator){

    return _elm_lang$core$Native_Scheduler.nativeBinding(function(callback)
    {
        _audioGenerator = audioGenerator;
        try {
          window.AudioContext = window.AudioContext || window.webkitAudioContext;
          _audioContext = new AudioContext();
        } catch(e) {
          alert("Web Audio API is not supported in this browser");
        }

        var bufferSize = 4096;
        _processingNode = _audioContext.createScriptProcessor(bufferSize, 1, 1);
        console.log(_audioContext.sampleRate);
        _processingNode.onaudioprocess = function(e) {
          var output = e.outputBuffer.getChannelData(0);
          for (var i = 0; i < bufferSize; i++) {
            if(_model){
                var sample = _audioGenerator(_sampleNumber)(_model);
                output[i] = sample;
            }
            _sampleNumber++;
          }

        }
        _processingNode.connect(_audioContext.destination);

        callback(_elm_lang$core$Native_Scheduler.succeed(1));
    });
}


var stopAudio = _elm_lang$core$Native_Scheduler.nativeBinding(function(callback){
        _processingNode.disconnect();
        callback(_elm_lang$core$Native_Scheduler.succeed(1));
    });


return {
    startAudio: startAudio,
    stopAudio: stopAudio,
    updateModel: updateModel
};

}();
