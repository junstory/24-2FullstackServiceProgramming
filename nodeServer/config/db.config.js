'use strict';
import sqlite3 from 'sqlite3';
sqlite3.verbose();
const db = new sqlite3.Database('./data.db');

db.serialize(()=> {
    db.run("CREATE TABLE IF NOT EXISTS users (id INTEGER PRIMARY KEY, name TEXT, isActive INTEGER)");

    const stmt = db.prepare("INSERT INTO users (name, isActive) VALUES (?, ?)");
    stmt.run("Kim",1);
    stmt.run("Park", 0);
    stmt.finalize(); //stmt더이상 사용 불가. 자원 정리

    db.each("SELECT id, name, isActive FROM users WHERE isActive = 1", (err, row) =>{
        if (err) return console.err(err);
        console.log(`${row.id} : ${row.name} (isActive: ${row.isActive})`)
    })
});

db.close();