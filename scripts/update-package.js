#!/usr/bin/env node

const fs = require("fs");
const path = require("path");

if (process.argv.length !== 3) {
  console.error("A third argument is required");
  process.exit(1);
}

const srcdir = path.dirname(__dirname);

const pkg = JSON.parse(
  fs.readFileSync(path.join(srcdir, "package.json"), "utf8")
);
pkg.version = process.argv[2];
fs.writeFileSync(
  path.join(srcdir, "package.json"),
  JSON.stringify(pkg, null, 2)
);
