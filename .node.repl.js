const { styleText } = require("node:util");
const repl = require("node:repl");

let v8version = "";
if (process.versions.v8) {
  v8version = ` (v8 ${process.versions.v8})`
}
console.log(`Node.js ${process.version}${v8version}`)

const replServer = repl.start({ prompt: styleText("yellow", "node  ") });
