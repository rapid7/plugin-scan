function R7BTest(oname, url, timeout) {
	this.oname     = oname;
	this.base_url  = url;
	this.timeout   = timeout;
	this.results   = {};
	this.progress  = {};
	this.callbacks = {}
	this.log_container = null;

	this.runTest = function(testName, uid, cb) {
		var t   = this.tuid(testName, uid);
		var url = this.base_url + "r7bhook.js?t=" + testName + '&' + 'u=' + uid + 'o=' + oname;

		var sob = document.createElement("script");
		sob.setAttribute("language", "javascript");
		sob.setAttribute("src", url);

		if (cb) {
			this.callbacks[t] = function(action, result){ cb(testName, uid, action, result); }
		}

		document.body.appendChild(sob);

		setTimeout(oname + ".handleTimeout('" + testName +"', '" + uid + "')", this.timeout)
		this.log("RunTest: " + testName + " - " + uid);
	}

	this.handleTimeout = function(testName, uid) {
		var t = this.tuid(testName, uid);
		if (this.results[t]) return;
		this.log("TestTimeout: " + testName + " - " + uid);
		this.results[t] = { status : "unknown", timeout : true };
		if (this.callbacks[t]) {
			var cb = this.callbacks[t];
			cb( "timeout", this.results[t] );
		}
		return true;
	}

	this.reportResult = function(testName, uid, result) {
		var t = this.tuid(testName, uid);
		if (this.results[t]) return;
		this.log("reportTest: " + testName + " - " + uid + " - " + result.status);
		this.results[t] = result;
		if (this.callbacks[t]) {
			var cb = this.callbacks[t];
			cb( "result", this.results[t] );
		}
		return true;
	}

	this.reportProgress = function(testName, uid, percent) {
		var t = this.tuid(testName, uid);
		this.log("reportProgress: " + testName + " - " + uid + " - " + percent.toString());
		this.progress[t] = percent;
		if (this.callbacks[t]) {
			var cb = this.callbacks[t];
			cb( "progress", percent );
		}
		return true;
	}

	this.log = function(msg) {
		if (! this.log_container) return false;

		var o = document.getElementById(this.log_container);
		if (! o) return false;

		var p = document.createElement("p");
		p.innerHTML = msg;
		o.appendChild(p);
		return true;
	}

	this.flush = function() {
		this.results  = {};
		this.progress = {};
	}

	this.getResult = function(testName, uid) {
		return this.results[ this.tuid(testName, uid) ];
	}

	this.tuid = function(testName, uid) {
		var t = testName + ":" + uid;
		return t;
	}

	return this;
}

