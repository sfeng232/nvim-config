#!/usr/bin/env node

// sudo npm install -g ramda colors yaml
// NODE_PATH=$(npm root -g) .devbase/bin/multi.js

const {spawn} = require("child_process");
const R = require("ramda");
const colors = require("colors");
const fs = require("fs");
const YAML = require("yaml");

colors.enable()

const colorFn = [
  colors.brightRed,
  colors.brightGreen,
  colors.brightYellow,
  colors.brightBlue,
  colors.brightMagenta,
  colors.brightCyan,
  colors.brightWhite,
  colors.red,
  colors.green,
  colors.yellow,
  colors.blue,
  colors.magenta,
  colors.cyan,
  colors.white,
  colors.gray,
  colors.grey,
];

const spawnP = (cli, options, fn) =>
  new Promise((resolve, reject) => {
    const proc = spawn("bash", ["-c", cli]);

    proc.stdout.on('data', (data) => {
      fn(`${data}`);
    });

    proc.stderr.on('data', (data) => {
      fn(`${data}`);
    });

    proc.on('close', (code) => {
      resolve(code);
    });
  });

/* eslint-disable fp/no-loops */
/* eslint-disable no-restricted-syntax */
/* eslint-disable guard-for-in */
const printLines = (tag, lines) => {
  const lls = R.compose(
    R.map(line => `${tag}| ${line}`),
    R.split("\n"),
    R.trim,
  )(lines);
  for (const line of lls) {
    console.log(line);
  }
};

const tasks = YAML.parse(fs.readFileSync(process.argv[2]).toString());

const fn1 = async () => {
  const ps = R.addIndex(R.map)(
    (task, idx) => {
      const tag = colorFn[idx](task.tag);
      return spawnP(task.cmd.replaceAll("\n", ""), {}, (lines) => {
        printLines(tag, lines);
      })
    }
  )(tasks);
  await Promise.all(ps);
};
fn1().then(() => console.log("multi.js ended successfully"));

// vi: ft=javascript
