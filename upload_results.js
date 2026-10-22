/** Firestore admin-only historical results import.
 * Setup: npm install firebase-admin
 * Dry run: node upload_results.js --credential /SECURE/PATH/service-account.json
 * Write new documents only: node upload_results.js --credential /SECURE/PATH/service-account.json --apply
 * Existing documents are NEVER overwritten by this script.
 * Protect service-account JSON: never commit, upload, or share the key.
 */
const fs = require('fs');
const path = require('path');
const admin = require('firebase-admin');
const args = process.argv.slice(2);
const flag = (name) => args.includes(name);
const value = (name) => { const i=args.indexOf(name); return i < 0 ? null : args[i+1]; };
async function main() {
  const credentialPath = value('--credential');
  if (!credentialPath) throw Error('Provide --credential /private/path/service-account.json');
  const input = value('--input') || path.join(__dirname, 'results_2015_2026.json');
  const payload = JSON.parse(fs.readFileSync(input, 'utf8'));
  if (payload.format !== 'bumper-jantari-date-documents-v1') throw Error('Unexpected import file format');
  const entries = Object.entries(payload.results);
  if (!entries.length) throw Error('Empty import');
  const allowedFields = ['Disawar','Faridabad','Ghaziabad','Gali'];
  for (const [id, record] of entries) {
    if (!/^\d{4}-\d{2}-\d{2}$/.test(id) || Number.isNaN(Date.parse(id))) throw Error(`Bad date: ${id}`);
    if (Object.keys(record).sort().join('|') !== [...allowedFields].sort().join('|')) throw Error(`Wrong fields: ${id}`);
    for (const x of Object.values(record)) if (x !== null && !/^\d{2}$/.test(x)) throw Error(`Bad number: ${id} ${x}`);
  }
  const serviceAccount = JSON.parse(fs.readFileSync(credentialPath,'utf8'));
  admin.initializeApp({credential: admin.credential.cert(serviceAccount)});
  const db = admin.firestore();
  console.log(`Firebase project: ${serviceAccount.project_id}; ${entries.length} historical dates; apply=${flag('--apply')}`);
  let exists=0, newDocs=0, differences=0; const problems=[]; const pending=[];
  for (let i=0; i<entries.length; i+=200) {
    const segment=entries.slice(i,i+200);
    const refs=segment.map(([id])=>db.collection('results').doc(id));
    const snapshots=await db.getAll(...refs);
    snapshots.forEach((snap,j)=>{
      const [id,record]=segment[j];
      if (snap.exists) {
        exists++;
        const saved=snap.data() || {};
        const changed=allowedFields.filter(f=>saved[f]!==undefined && saved[f]!==record[f]);
        if(changed.length) { differences++; problems.push({date:id, fields:changed, firestore:changed.map(f=>saved[f]),import:changed.map(f=>record[f])}); }
      } else { newDocs++; pending.push([refs[j],record]); }
    });
    process.stdout.write(`\rChecked ${Math.min(i+200,entries.length)}/${entries.length}`);
  }
  console.log(`\nExisting docs=${exists}, new docs=${newDocs}, conflicting existing docs=${differences}`);
  const report=path.join(__dirname, 'firestore_import_comparison.json');
  fs.writeFileSync(report,JSON.stringify({project_id:serviceAccount.project_id,exists,newDocs,differences,problems},null,2));
  console.log('Comparison report:',report);
  if(!flag('--apply')) { console.log('DRY RUN only. Re-run with --apply to create missing documents.'); return; }
  if (differences>0) console.warn('WARNING: existing conflicting documents will be left unchanged.');
  // Firestore Admin SDK bypasses Security Rules: run only on trusted computer.
  let created=0, skipped=0;
  for(const [ref,record] of pending) {
    try { await ref.create(record); created++; }
    catch(e) { if(e.code===6 || e.code==='already-exists') skipped++; else throw e; }
  }
  console.log(`Created=${created}, concurrent existing/skipped=${skipped}. Existing records untouched.`);
}
main().catch(e=>{console.error(e);process.exitCode=1});
