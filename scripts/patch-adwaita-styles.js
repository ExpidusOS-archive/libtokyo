#!/usr/bin/env node

const fs = require("fs");

if (process.argv.length !== 4) {
  console.error("4 arguments are required");
  process.exit(1);
}

fs.writeFileSync(
  process.argv[3],
  fs
    .readFileSync(process.argv[2], "utf-8")
    .split("\n")
    .filter((str) => !str.startsWith("@define-color"))
    .map((str) => {
      for (const match of str.matchAll(/@([a-zA-Z_]+)/g)) {
        if (match.index == 0) continue;
        str = str.replace(match[0], `gtkcolor(${match[1]})`);
      }
      return str
        .split("alpha(")
        .join("gtkalpha(")
        .split("mix(")
        .join("gtkmix(");
    })
    .join("\n")
);
