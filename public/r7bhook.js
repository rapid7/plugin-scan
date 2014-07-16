// Normally pulled from t / u / v query string
var r7b_testName = "plugins";
var r7b_uid      = "ua12345";
var r7b_o        = eval("r7bmain");

// Specific variables for this test run
var pct = 0;

function simulateTest() {
	if (pct >= 100) {
		var results = { status : "success", results : { addon1 : { status : "vulnerable", detail : "version 1.0.0 is vulnerable" } } };
		r7b_o.reportResult(r7b_testName, r7b_uid, results);
		return;
	}

	pct = pct + 10;
	r7b_o.reportProgress(r7b_testName, r7b_uid, pct)
	setTimeout("simulateTest()", 200);
}

setTimeout("simulateTest()", 200);
