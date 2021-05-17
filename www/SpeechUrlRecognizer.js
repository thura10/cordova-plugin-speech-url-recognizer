var exec = require('cordova/exec');
var PLUGIN_NAME = "SFSpeechRecognizerPlugin";

exports.getSupportedLocales = function(onSuccess, onError) {
    exec(onSuccess, onError, PLUGIN_NAME, "getSupportedLocales", []);
}

exports.checkPermission = function(onSuccess, onError) {
    exec(onSuccess, onError, PLUGIN_NAME, "checkPermission", []);
}

exports.requestPermission = function(onSuccess, onError) {
    exec(onSuccess, onError, PLUGIN_NAME, "requestPermission", []);
}

exports.urlRecognitionRequest = function(arg0, arg1, onSuccess, onError) {
    exec(onSuccess, onError, PLUGIN_NAME, "urlRecognitionRequest", [arg0, arg1]);
};