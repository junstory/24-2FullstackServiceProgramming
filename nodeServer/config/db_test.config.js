'use strict';
import sqlite3 from 'sqlite3';
sqlite3.verbose();

export const test_db = new sqlite3.Database('./data_test.db', (err) => {
  if (err) {
    //console.error('Error opening database:', err);
  } else {
    //console.log('Connected to the SQLite test database.');
  }
});

//db.close();

export default test_db;
