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
    R.map(line => `${tag}${line}`),
    R.split("\n"),
    R.trim,
  )(lines);
  for (const line of lls) {
    console.log(line);
  }
};

const filepath = process.argv[2];
if (!fs.existsSync(filepath)) {
  console.log(`${filepath} do not exists.`);
  process.exit();
}
const tasks = YAML.parse(fs.readFileSync(filepath).toString());

const tagMaxLen = R.compose(
  R.apply(Math.max),
  R.map(R.length),
  R.pluck("tag"),
)(tasks);

const sep = " | ".gray

/* eslint-disable fp/no-loops */
/* eslint-disable no-restricted-syntax */
for (const [idx, task] of tasks.entries()) {
  task.display = colorFn[idx](task.tag.padEnd(tagMaxLen, " ")) + sep;
  task.state = "pending";
}

const findTask = tag => R.find(R.propEq(tag, "tag"), tasks);

const isRunnable = (task) => {
  if (task.state !== "pending") {
    return false;
  }
  const allCompleted = R.all(
    (afterTag) => findTask(afterTag).state === "completed"
  )(task.after || [])
  if (!allCompleted) {
    return false;
  }
  return true;
};

const runAllRunnable = () => {
  R.map(
    async (task) => {
      if (!isRunnable(task)) {
        return false;
      }
      task.state = "running";
      await spawnP(task.cmd.replaceAll("\n", ""), {}, (lines) => {
        printLines(task.display, lines);
      })
      task.state = "completed";
      printLines(task.display, "- completed -".gray);
      runAllRunnable();
    }
  )(tasks);
};

runAllRunnable();
