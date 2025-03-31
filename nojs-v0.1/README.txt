🧱 NO JS CLI - v0.1

Write structure with meaning — generate HTML without JavaScript.
This is a minimal, fast, and safe CLI built in Zig.

📦 Included files:
- nojs.exe         ← The CLI binary (Windows)
- hello.nojs       ← Sample .nojs input file
- README.txt       ← This guide

🧪 How to Use (Windows CLI):

1. Open your terminal (PowerShell or CMD)
2. Navigate to this folder
3. Run the following command:

   nojs.exe build hello.nojs

4. Output:
   A file named `output/hello.html` will be created.

🌐 Sample Output (HTML):

<div><h1>Welcome, Yuki</h1></div>

📝 Sample Syntax (hello.nojs):

page "home" {
  state.username = "Yuki"

  div {
    h1 { text "Welcome, {username}" }
  }
}

🧠 Features:
- Zero JavaScript
- State → Placeholder expansion (`{username}`)
- Meaning-driven markup syntax
- Built in Zig (safe, fast, no dependencies)

💬 Feedback / GitHub:
https://github.com/jetscript-lang/No-JS
