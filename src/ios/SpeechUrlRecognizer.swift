import Speech

@objc(SpeechUrlRecognizer) 
class SpeechUrlRecognizer : CDVPlugin {
    @objc(urlRecognitionRequest:)
    func urlRecognitionRequest(command: CDVInvokedUrlCommand) {
        
        guard let audio = command.argument(at: 0) as? String else {
            sendResult(result: CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Error: Provided value for audioURL is not valid"), callbackId: command.callbackId);
            return;
        }
        let audioURL = URL.init(string: audio);
        guard audioURL != nil else {
            sendResult(result: CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Error: Provided URL \(audio) is not a valid url"), callbackId: command.callbackId);
            return;
        }
        
        
        guard let showPartialResults = command.argument(at: 1, withDefault: false) as? Bool else {
            sendResult(result: CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Error: Provided value for showPartialResults is not valid"), callbackId: command.callbackId);
            return;
        }

        
        guard let locale = command.argument(at: 2, withDefault: "en-US") as? String else {
            sendResult(result: CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Error: Provided value for locale is not valid"), callbackId: command.callbackId);
            return;
        }
        
        let supportedLocales = SFSpeechRecognizer.supportedLocales().compactMap { l in
            return l.identifier;
        };
        guard supportedLocales.contains(locale) else {
            sendResult(result: CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Error: Provided Locale \(locale) is not supported"), callbackId: command.callbackId);
            return;
        }

        let recognizer = SFSpeechRecognizer(locale: Locale.init(identifier: locale))
        let request = SFSpeechURLRecognitionRequest(url: audioURL!)

        request.shouldReportPartialResults = showPartialResults;

        if (recognizer?.isAvailable)! {

            recognizer?.recognitionTask(with: request) { [self] result, error in
                guard error == nil else {
                    sendResult(result: CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: error?.localizedDescription ?? error.debugDescription), callbackId: command.callbackId);
                    return;
                }
                
                guard let result = result else {
                    sendResult(result: CDVPluginResult(status: CDVCommandStatus_OK, messageAs: ""), callbackId: command.callbackId);
                    return;
                }
                
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: result.bestTranscription.formattedString)!;
                
                let isFinal = !result.isFinal;
                pluginResult.setKeepCallbackAs(isFinal);
                
                self.sendResult(result: pluginResult, callbackId: command.callbackId);
            }
        }
        else {
            sendResult(result: CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Speech Recognizer Unavailable"), callbackId: command.callbackId);
        }
    }
    
    @objc(getSupportedLocales:)
    func getSupportedLocales(command: CDVInvokedUrlCommand) {
        let locales = SFSpeechRecognizer.supportedLocales().compactMap { l in
            return l.identifier;
        }
        sendResult(result: CDVPluginResult(status: CDVCommandStatus_OK, messageAs: locales), callbackId: command.callbackId);
    }
    
    @objc(isAvailable:)
    func isAvailable(command: CDVInvokedUrlCommand) {
        let recognizer = SFSpeechRecognizer();
        let isAvailable = recognizer?.isAvailable ?? false;
        sendResult(result: CDVPluginResult(status: CDVCommandStatus_OK, messageAs: isAvailable), callbackId: command.callbackId);
    }
    
    @objc(checkPermission:)
    func checkPermission(command: CDVInvokedUrlCommand) {
        let permission = SFSpeechRecognizer.authorizationStatus().rawValue;
        sendResult(result: CDVPluginResult(status: CDVCommandStatus_OK, messageAs: permission), callbackId: command.callbackId);
    }
    
    @objc(requestPermission:)
    func requestPermission(command: CDVInvokedUrlCommand) {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            let permission = SFSpeechRecognizer.authorizationStatus().rawValue;
            self.sendResult(result: CDVPluginResult(status: CDVCommandStatus_OK, messageAs: permission), callbackId: command.callbackId);
        }
    }
    
    func sendResult(result: CDVPluginResult, callbackId: String) {
        self.commandDelegate!.send(result, callbackId: callbackId);
    }
}
