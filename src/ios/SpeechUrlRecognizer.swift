import Speech

@objc(SpeechUrlRecognizer) class SpeechUrlRecognizer : CDVPlugin {
    @objc(urlRecognitionRequest:)
    func urlRecognitionRequest(command: CDVInvokedUrlCommand) {
        
        let audio = command.argument(at: 0);
        let audioURL = URL.init(string: audio as! String);
        
        let locale = command.argument(at: 1, withDefault: "en-US");
        let supportedLocales = SFSpeechRecognizer.supportedLocales();
        
        let isLocaleSupported = supportedLocales.contains { l in
            if (l.identifier == locale as! String) {
                return true;
            }
            else {
                return false;
            }
        }
        
        guard isLocaleSupported else {
            sendResult(result: CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Error: Provided Locale \(locale as! String) is not supported"), callbackId: command.callbackId);
            return;
        }
        
        guard audioURL != nil else {
            sendResult(result: CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Error: Provided URL \(audio ?? "") is not a valid url"), callbackId: command.callbackId);
            return;
        }

        let recognizer = SFSpeechRecognizer(locale: Locale.init(identifier: locale as! String))
        let request = SFSpeechURLRecognitionRequest(url: audioURL!)

        request.shouldReportPartialResults = false;

        if (recognizer?.isAvailable)! {

            recognizer?.recognitionTask(with: request) { [self] result, error in
                guard error == nil else {
                    sendResult(result: CDVPluginResult(status: CDVCommandStatus_OK, messageAs: error?.localizedDescription ?? error.debugDescription), callbackId: command.callbackId);
                    return;
                }
                
                guard let result = result else {
                    sendResult(result: CDVPluginResult(status: CDVCommandStatus_OK, messageAs: ""), callbackId: command.callbackId);
                    return;
                }
                
                sendResult(result: CDVPluginResult(status: CDVCommandStatus_OK, messageAs: result.bestTranscription.formattedString), callbackId: command.callbackId);
            }
        }
        else {
            sendResult(result: CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Speech Recognizer Unavailable"), callbackId: command.callbackId);
        }
    }
    
    @objc(getSupportedLocales:)
    func getSupportedLocales(command: CDVInvokedUrlCommand) {
        let locales = SFSpeechRecognizer.supportedLocales();
        sendResult(result: CDVPluginResult(status: CDVCommandStatus_OK, messageAs: Array(locales)), callbackId: command.callbackId);
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
