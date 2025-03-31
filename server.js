const express = require("express");
const fs = require("fs");
const { exec } = require("child_process");
const path = require("path");

const app = express();
const PORT = 3000;

app.use(express.static("public"));
app.use(express.json());

app.post("/build", (req, res) => {
  const code = req.body.code;

  // Save .nojs input
  fs.writeFileSync("tmp/input.nojs", code);

  // Run `nojs build tmp/input.nojs`
  exec("zig-out\\bin\\nojs.exe build tmp/input.nojs", (err, stdout, stderr) => {
    if (err) {
      return res.status(500).send(`Build error: ${stderr}`);
    }

    // Read generated HTML
    const htmlPath = path.resolve("output/build.html");
    if (!fs.existsSync(htmlPath)) {
      return res.status(500).send("No HTML output generated.");
    }

    const html = fs.readFileSync(htmlPath, "utf-8");
    res.send(html);
  });
});

app.listen(PORT, () => {
  console.log(`✨ NO JS Playground running at http://localhost:${PORT}`);
});
