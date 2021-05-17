var exec = require('cordova/exec');
var PLUGIN_NAME = "SpeechUrlRecognizer";

exports.getSupportedLocales = function(onSuccess, onError) {
    exec(onSuccess, onError, PLUGIN_NAME, "getSupportedLocales", []);
};

exports.isAvailable = function(onSuccess, onError) {
    exec(onSuccess, onError, PLUGIN_NAME, "isAvailable", []);
};

exports.checkPermission = function(onSuccess, onError) {
    exec(onSuccess, onError, PLUGIN_NAME, "checkPermission", []);
};

exports.requestPermission = function(onSuccess, onError) {
    exec(onSuccess, onError, PLUGIN_NAME, "requestPermission", []);
};

exports.urlRecognitionRequest = function(onSuccess, onError, audioURL, showPartialResults, locale) {
    exec(onSuccess, onError, PLUGIN_NAME, "urlRecognitionRequest", [audioURL, showPartialResults, locale]);
};