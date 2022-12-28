#!/usr/bin/env node

const fs = require("fs");
const path = require("path");

if (process.argv.length !== 4) {
  console.error("4 arguments are required");
  process.exit(1);
}

const srcdir = path.dirname(__dirname);

const pkg = JSON.parse(
  fs.readFileSync(path.join(srcdir, "package.json"), "utf8")
);
pkg.version = process.argv[3];
pkg.main = "./output/styling.cjs";
pkg.exports = {
  ".": {
    import: "./output/styling.mjs",
    require: "./output/styling.cjs"
  }
};
delete pkg.private;
fs.writeFileSync(
  process.argv[2],
  JSON.stringify(pkg, null, 2)
);
