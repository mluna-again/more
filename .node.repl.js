const { styleText } = require("node:util");
const repl = require("repl");
const replServer = repl.start({ prompt: styleText("yellow", "node  ") });
