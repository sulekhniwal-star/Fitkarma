## Description of Changes
<!-- Provide a brief description of the changes introduced in this pull request -->

## Checklist
- [ ] Code builds cleanly and static analysis passes (`flutter analyze`)
- [ ] Unit & widget tests updated and passing (`flutter test`)
- [ ] Environment variables verified for dev/staging/prod via `--dart-define`

### 🩺 Clinical Copy Change Checklist (§P10-M Compliance Boundary)
- [ ] Verified copy changes in §P10-I (Prescription Verification), §P10-H (Medication Tracker), or §P10-J (Doctor Sharing Portal) retain mandatory medical disclaimers.
- [ ] Confirmed no clinical diagnosis, treatment claims, or unvalidated medical advice is rendered to the user without physician disclaimer.
- [ ] Ran `dart run scripts/clinical_copy_linter.dart` and verified 0 compliance violations.
- [ ] Passcode-protected PDF export remains default for Doctor Sharing Portal (§P10-J).
