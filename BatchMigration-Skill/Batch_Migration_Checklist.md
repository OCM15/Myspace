# Batch Migration Checklist

## A. Planning

- [ ] Batch name identified
- [ ] Business owner identified
- [ ] Technical owner identified
- [ ] Scheduler identified
- [ ] Current production version identified
- [ ] Migration target framework identified
- [ ] Migration scope agreed
- [ ] Out-of-scope items documented

## B. Legacy Inventory

- [ ] Entry point identified
- [ ] Startup command documented
- [ ] Stop procedure documented
- [ ] Parameters documented
- [ ] Configuration documented
- [ ] Environment variables documented
- [ ] Lock mechanism documented
- [ ] Duplicate execution behavior documented
- [ ] Timeout behavior documented
- [ ] Retry behavior documented
- [ ] Exit codes documented
- [ ] Log behavior documented
- [ ] Alert behavior documented
- [ ] Restart/recovery procedure documented

## C. Business Behavior

- [ ] Input files documented
- [ ] Input parameters documented
- [ ] Business validations documented
- [ ] Business branching documented
- [ ] Business calculations documented
- [ ] DB tables documented
- [ ] SQL documented
- [ ] Transaction boundaries documented
- [ ] Commit timing documented
- [ ] Rollback timing documented
- [ ] Output files documented
- [ ] Output DB records documented
- [ ] External calls documented
- [ ] Business error behavior documented

## D. Classification

- [ ] Control logic identified
- [ ] Business logic identified
- [ ] Shared logic identified
- [ ] Unknown logic identified
- [ ] Unknown logic reviewed
- [ ] Legacy → New mapping created

## E. New Control Layer

- [ ] Standard launcher implemented
- [ ] Parameter validation implemented
- [ ] Execution ID implemented
- [ ] Duplicate execution prevention implemented
- [ ] Lock management implemented
- [ ] Timeout management implemented
- [ ] Retry management implemented
- [ ] Error classification implemented
- [ ] Standard logging implemented
- [ ] Monitoring implemented
- [ ] Alert integration implemented
- [ ] Exit code standardized
- [ ] Graceful stop implemented
- [ ] Forced termination policy documented
- [ ] Restart/recovery policy documented

## F. Business Preservation

- [ ] Business service unchanged or explicitly reviewed
- [ ] Business rules unchanged
- [ ] Calculations unchanged
- [ ] SQL semantics unchanged
- [ ] Transaction boundaries unchanged
- [ ] Commit behavior unchanged
- [ ] Rollback behavior unchanged
- [ ] Input semantics unchanged
- [ ] Output semantics unchanged
- [ ] External interface semantics unchanged
- [ ] Business error behavior unchanged

## G. Test Preparation

- [ ] Test data prepared
- [ ] Normal case prepared
- [ ] Boundary cases prepared
- [ ] Business error cases prepared
- [ ] System error cases prepared
- [ ] DB failure case prepared
- [ ] File failure case prepared
- [ ] Timeout case prepared
- [ ] Retry case prepared
- [ ] Duplicate execution case prepared
- [ ] Stop case prepared
- [ ] Restart/recovery case prepared
- [ ] Invalid parameter case prepared

## H. Business Compatibility Test

- [ ] Same input used for legacy and new
- [ ] DB result compared
- [ ] INSERT compared
- [ ] UPDATE compared
- [ ] DELETE compared
- [ ] Calculated values compared
- [ ] Status transitions compared
- [ ] Output files compared
- [ ] Business error result compared

## I. System Control Test

- [ ] Startup
- [ ] Normal completion
- [ ] Graceful stop
- [ ] Forced stop
- [ ] Duplicate startup
- [ ] Invalid parameter
- [ ] Timeout
- [ ] Retry
- [ ] Retry exhaustion
- [ ] DB failure
- [ ] File failure
- [ ] Unexpected exception
- [ ] Exit code
- [ ] Log
- [ ] Alert
- [ ] Recovery

## J. Review

- [ ] Code review complete
- [ ] Business owner review complete
- [ ] Technical review complete
- [ ] Test evidence attached
- [ ] Differences documented
- [ ] All intentional differences approved
- [ ] No unexplained business differences
- [ ] Production rollback procedure prepared

## K. Release

- [ ] Deployment package verified
- [ ] Scheduler configuration verified
- [ ] Production parameters verified
- [ ] Monitoring verified
- [ ] Alert verified
- [ ] Start/stop procedure documented
- [ ] Operations team informed
- [ ] Rollback procedure tested/verified
- [ ] Go-live approval obtained
