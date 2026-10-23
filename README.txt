Bumper Chances & Jantari — Firestore Historical Import

Files:
  results_2015_2026.json: 4,293 date documents, 2015-01-01 to 2026-10-02
  upload_results.js: safe create-only Firestore Admin SDK import
  historical_schedule_exceptions.csv: raw bundled values inconsistent with declared monthly schedule

1. Back up the Firestore 'results' collection first.
2. Use a trusted local computer with Node.js installed.
3. From Firebase Console > Project Settings > Service Accounts, generate a service-account JSON.
   KEEP IT PRIVATE, outside your project. Never send the credential to ChatGPT or GitHub.
4. Run: npm install firebase-admin
5. Dry run: node upload_results.js --credential C:/private/firebase-key.json
6. Check firestore_import_comparison.json and the project ID, especially conflicting records.
7. Import: node upload_results.js --credential C:/private/firebase-key.json --apply

The importer uses document IDs YYYY-MM-DD, matches app's existing 'results' structure,
creates only missing documents, never overwrites live results, and does not delete anything.
Firestore Admin SDK has elevated privileges and bypasses Security Rules: only execute locally.

This file does NOT modify historical_data.dart or any Bumper calculation rules.


Generating 3,072 bit RSA key pair and self-signed certificate (SHA256withRSA) with a validity of 10,000 days
        for: CN=Ravi Gautam, OU=Individual, O=Individual, L=New Delhi, ST=Delhi, C=IN
[Storing C:\Users\ravik\bumper-upload-key-final.jks] - Jantri123!@#
