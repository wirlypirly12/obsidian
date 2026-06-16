# Obsidian
> **Runtime Roblox development tooling. Stealthy and fast.**

Obsidian is a Luau script designed for **Roblox runtime use**, giving you powerful code generation and nil checking.

```lua
loadstring(game:HttpGet("https://github.com/wirlypirly12/obsidian/releases/download/Preview/Obsidian.wax.luau"))()
```

---

## Features

### ⚡ Code Generation from Remotes
Obsidian generates clean Luau code directly from RemoteEvents and RemoteFunctions.

### 🔍 Trailing Nil Detection
One issue I noticed with every similar project is that code generation fails to account for nils hidden inside parameters. Hidden nils are commonly used by developers to detect exploiters firing a remote without enough context, triggering an anti-cheat detection. Obsidian handles these correctly.

### 🕶️ Extremely Stealthy
Obsidian is built to be invisible to the things that matter. Rather than hooking the global metatable, Obsidian opts to spoof the metatable of the specific **Instance** it's targeting. This causes generic hook detections to miss Obsidian entirely.

---

## Roadmap

Obsidian is still missing a number of functional and quality-of-life features. Here's what I plan to implement in the near future:

- Log all forms of client→server communication and vice versa
- Add more detail to the log window (calling function, calling script, etc.)
- User interface overhaul — the current interface is bland and due for a complete redesign, though functionality comes first
- Spoofing of parameters and return types
- Actor support

---

## Why

Obsidian was built to provide complete control over the environment while staying simple and practical. The issue most modern similar projects face is a lack of security and quality-of-life features for developers looking for something specific. Obsidian aims to fill that gap.

---

## License

MIT
