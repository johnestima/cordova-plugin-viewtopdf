var exec = require('cordova/exec');

exports.greet = function(arg0, success, error) {
    exec(success, error, "viewtopdf", "topdf", [name]); 
};
