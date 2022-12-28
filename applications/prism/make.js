#!/usr/bin/env node

const fs = require('fs');
const styles = require(process.argv[2]);
const theme = JSON.stringify(styles.prism[process.argv[3]], null, 2);
fs.writeFileSync(process.argv[4], theme);
