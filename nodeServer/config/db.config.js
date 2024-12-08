'use strict';
import sqlite3 from 'sqlite3';
sqlite3.verbose();

export const db = new sqlite3.Database('./data.db', (err) => {
  if (err) {
    //console.error('Error opening database:', err);
  } else {
    //console.log('Connected to the SQLite database.');
  }
});

export const executeTransaction = async (queries) => {
  console.log('executeTransaction : ', queries);
  return new Promise((resolve, reject) => {
    db.serialize(() => {
      db.run('BEGIN TRANSACTION');
      try {
        for (const query of queries) {
          db.run(query);
        }
        db.run('COMMIT');
        resolve();
      } catch (error) {
        db.run('ROLLBACK');
        reject(error);
      }
    });
  });
};

//db.close();

export default db;
