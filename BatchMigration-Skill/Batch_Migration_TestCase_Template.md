# Batch Migration Test Case Template

## 1. Test Information

| Item | Value |
|---|---|
| Batch Name | |
| Legacy Version | |
| New Version | |
| Test Environment | |
| Test Date | |
| Tester | |
| Reviewer | |
| Test Data | |
| Related Requirement | |

---

# 2. Business Compatibility Tests

## TC-BIZ-001 Normal Processing

**Purpose:** Verify that normal business processing produces the same result.

**Precondition**
- Legacy and New environments use equivalent input.
- Required DB/file/external systems are available.

**Input**
- Input file:
- Parameters:
- DB initial state:

**Execution**
1. Execute Legacy Batch.
2. Capture DB/output/result.
3. Reset test data.
4. Execute New Batch.
5. Compare results.

**Expected Result**
- Business DB results are equivalent.
- Output is equivalent.
- Calculated values are equivalent.
- Business status is equivalent.
- No unexpected difference exists.

**Actual Result**

**Evidence**

**Result:** PASS / FAIL

---

## TC-BIZ-002 Boundary Data

**Purpose:** Verify boundary conditions remain unchanged.

**Test Data**
- minimum value
- maximum value
- zero
- null
- empty
- boundary date
- maximum record count

**Expected Result**
- Legacy and New produce equivalent business results.

**Result:** PASS / FAIL

---

## TC-BIZ-003 Business Validation Error

**Purpose:** Verify business validation behavior is preserved.

**Input**

**Expected**
- Same validation condition
- Same business error classification
- Same business result/status

**Result:** PASS / FAIL

---

## TC-BIZ-004 Database Result Comparison

**Purpose:** Compare business DB changes.

### INSERT

| Table | Legacy | New | Result |
|---|---|---|---|
| | | | |

### UPDATE

| Table | Legacy | New | Result |
|---|---|---|---|
| | | | |

### DELETE

| Table | Legacy | New | Result |
|---|---|---|---|
| | | | |

**Result:** PASS / FAIL

---

## TC-BIZ-005 Transaction Boundary

**Purpose:** Verify transaction behavior remains compatible.

Verify:

- transaction start
- transaction end
- commit point
- rollback point
- isolation level
- lock behavior

**Expected Result**

No unapproved transaction behavior change.

**Result:** PASS / FAIL

---

# 3. System Control Tests

## TC-SYS-001 Normal Startup

**Purpose:** Verify standard startup.

**Steps**
1. Start Batch through the new launcher.
2. Check execution ID.
3. Check execution status.
4. Check log.

**Expected**
- Batch starts successfully.
- Execution status is registered.
- Standard log is created.

**Result:** PASS / FAIL

---

## TC-SYS-002 Duplicate Execution

**Purpose:** Verify duplicate execution prevention.

**Steps**
1. Start Batch.
2. Start the same Batch again while the first execution is active.

**Expected**
- Second execution is rejected according to the new standard.
- First execution is not affected.
- Appropriate log/alert/exit code is generated.

**Result:** PASS / FAIL

---

## TC-SYS-003 Graceful Stop

**Purpose:** Verify controlled shutdown.

**Steps**
1. Start Batch.
2. Issue standard stop command.
3. Observe processing.
4. Check final status.

**Expected**
- Stop request is recognized.
- Batch terminates according to the defined graceful-stop policy.
- Resources are released.
- Final status is correct.

**Result:** PASS / FAIL

---

## TC-SYS-004 Forced Stop

**Purpose:** Verify forced termination policy.

**Expected**
- Forced termination occurs only according to the approved policy.
- Final status is recorded.
- Recovery procedure is applicable.

**Result:** PASS / FAIL

---

## TC-SYS-005 Invalid Parameter

**Purpose:** Verify parameter validation.

**Input**
- invalid parameter

**Expected**
- Batch does not enter business processing.
- Standard error is recorded.
- Correct exit code is returned.
- Alert behavior follows standard.

**Result:** PASS / FAIL

---

## TC-SYS-006 Timeout

**Purpose:** Verify timeout control.

**Steps**
1. Start Batch.
2. Cause processing to exceed the configured timeout.
3. Observe timeout handling.

**Expected**
- Timeout is detected.
- Batch status becomes TIMEOUT or the approved equivalent.
- Resources are released.
- Correct alert/exit code is generated.

**Result:** PASS / FAIL

---

## TC-SYS-007 Retry

**Purpose:** Verify retry policy for retryable system errors.

**Steps**
1. Cause a retryable system failure.
2. Observe retry.
3. Repeat until success or retry limit.

**Expected**
- Only approved errors are retried.
- Retry count is correct.
- Delay/backoff is correct.
- No unintended duplicate business processing occurs.
- Final result is correct.

**Result:** PASS / FAIL

---

## TC-SYS-008 Retry Exhaustion

**Purpose:** Verify behavior after retry limit is reached.

**Expected**
- Retry stops at configured limit.
- Batch ends with the standard failure status.
- Alert is generated.
- Correct exit code is returned.

**Result:** PASS / FAIL

---

## TC-SYS-009 DB System Failure

**Purpose:** Verify DB connectivity/system failure handling.

**Expected**
- System error is correctly classified.
- Approved retry behavior occurs.
- No unintended business data corruption occurs.
- Final status/log/alert are correct.

**Result:** PASS / FAIL

---

## TC-SYS-010 File System Failure

**Purpose:** Verify file I/O failure handling.

**Expected**
- System error is classified correctly.
- Retry/abort behavior follows the new standard.
- Resources are released.
- Final status is correct.

**Result:** PASS / FAIL

---

## TC-SYS-011 Unexpected Exception

**Purpose:** Verify unexpected exception handling.

**Expected**
- Exception is captured.
- Batch terminates safely.
- Error is logged.
- Alert is generated where required.
- Correct exit code is returned.

**Result:** PASS / FAIL

---

## TC-SYS-012 Restart / Recovery

**Purpose:** Verify restart behavior.

**Precondition**
- Batch has failed or stopped at a defined point.

**Steps**
1. Execute Batch.
2. Stop/fail it.
3. Execute recovery/restart procedure.
4. Compare business result.

**Expected**
- Restart follows the approved restart policy.
- No unintended duplicate business processing occurs.
- Final business result is equivalent to the approved legacy behavior.

**Result:** PASS / FAIL

---

# 4. Comparison Test

## TC-CMP-001 Legacy vs New Full Comparison

### Input

| Item | Legacy | New |
|---|---|---|
| Input file | | |
| Parameters | | |
| DB initial state | | |

### Output

| Item | Legacy | New | Difference |
|---|---|---|---|
| INSERT | | | |
| UPDATE | | | |
| DELETE | | | |
| Output file | | | |
| Status | | | |
| Calculated value | | | |

### Control Behavior

| Item | Legacy | New | Intentional? |
|---|---|---|---|
| Startup | | | |
| Stop | | | |
| Lock | | | |
| Retry | | | |
| Timeout | | | |
| Logging | | | |
| Exit code | | | |
| Alert | | | |

**Business Difference:** None / Describe

**Control Difference:** Expected / Unexpected

**Result:** PASS / FAIL

---

# 5. Test Summary

| Category | Total | Pass | Fail | N/A |
|---|---:|---:|---:|---:|
| Business Compatibility | | | | |
| System Control | | | | |
| Error Handling | | | | |
| Recovery | | | | |
| Full Comparison | | | | |

## Final Assessment

- [ ] Business behavior preserved
- [ ] System control conforms to new standard
- [ ] No unexplained difference
- [ ] All failures resolved or formally accepted
- [ ] Test evidence archived

**Final Result:** PASS / CONDITIONAL PASS / FAIL

**Reviewer Comment:**

